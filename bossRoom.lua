BossRoom={}

function BossRoom:load()
    self.boss=nil --holds the boss instance

    --spritesheets and animations
    self.sprites={
        lava=love.graphics.newImage('assets/maps/boss_lava.png'),
        floor=love.graphics.newImage('assets/maps/boss_floor.png'),
        floorTile=love.graphics.newImage('assets/maps/boss_floor_tile.png')
    }
    self.floorW,self.floorH=self.sprites.floor:getWidth(),self.sprites.floor:getHeight()
    self.grids={
        floorTile=anim8.newGrid(
            16,16,self.sprites.floorTile:getWidth(),
            self.sprites.floorTile:getHeight()
        )
    }

     --colliders for lava surrounding the floor
    self.lavaColliders={
        top=world:newRectangleCollider(224,160-32,self.floorW,32),
        bot=world:newRectangleCollider(224,160+self.floorH,self.floorW,32),
        left=world:newRectangleCollider(224-32,160,32,self.floorH),
        right=world:newRectangleCollider(224+self.floorW,160,32,self.floorH)
    }
    for i,c in pairs(self.lavaColliders) do 
        c:setCollisionClass('lava')
        c:setType('static')
    end
    self.lavaColliderKnockbackAngles={top=0.5*math.pi,bot=-0.5*math.pi,left=0,right=math.pi}
    self.lavaAttackOnCooldown={top=false,bot=false,left=false,right=false}

    self.floorTiles=self:generateFloorTiles()   
    
    self.tornadoTimer=10 --start 10s in to spawn first torando soon
    self.floorTileTimer=28
end

function BossRoom:update()
    self:updateFloorTiles() --update floorTiles' animations
    self:updateLava() --damage and knockback player when touching lava

    self.tornadoTimer=self.tornadoTimer+dt 
    if self.tornadoTimer>=20 then --spawn tornados every 20s
        self.tornadoTimer=0
        self:spawnFlameTonados()
    end

    self.floorTileTimer=self.floorTileTimer+dt
    if self.floorTileTimer>=30 then 
        self.floorTileTimer=0 
        self:activateFloorTiles()
    end
end

function BossRoom:draw()
    love.graphics.draw(self.sprites.lava,0,0)
    love.graphics.draw(self.sprites.floor,224,160)
    self:drawFloorTiles()
end

--generates the floor tile objects. Floor tiles have an x,y (absolute) position 
--and an animation. Tiles are stored in a 2D array which represent their
--relative position on the 'board'.
function BossRoom:generateFloorTiles()
    local floorTiles={}
    for x=1,25 do
        floorTiles[x]={}
        for y=1,19 do
            floorTiles[x][y]={
                xPos=224+16*(x-1),
                yPos=160+16*(y-1),
                animations={} --holds all animations
            }
            floorTiles[x][y].animations.seep=anim8.newAnimation( --lava seeps through cracks
                self.grids.floorTile('1-4',1),0.15,
                function() floorTiles[x][y].animations.seep:pauseAtEnd() end
            )
            floorTiles[x][y].animations.fill=anim8.newAnimation( --lava fills tile
                self.grids.floorTile('5-10',1),0.15,
                function() floorTiles[x][y].animations.fill:pauseAtEnd() end
            )
            floorTiles[x][y].animations.receed=anim8.newAnimation( --lava receeds from tile
                self.grids.floorTile('10-1',1),0.15,
                function() floorTiles[x][y].animations.receed:pauseAtEnd() end
            )
            floorTiles[x][y].animations.seep:pauseAtStart()
            floorTiles[x][y].animations.fill:pauseAtStart()
            floorTiles[x][y].animations.receed:pauseAtStart()
            floorTiles[x][y].animations.currentAnim=floorTiles[x][y].animations.seep            
        end
    end
    return floorTiles
end

function BossRoom:updateFloorTiles() --update all floor tiles
    for x=1,#self.floorTiles do 
        for y,tile in pairs(self.floorTiles[x]) do 
            tile.animations.currentAnim:update(dt) 
        end
    end
end

function BossRoom:drawFloorTiles() --draw all floor tiles
    for x=1,#self.floorTiles do 
        for y,tile in pairs(self.floorTiles[x]) do 
            tile.animations.currentAnim:draw(
                self.sprites.floorTile,tile.xPos,tile.yPos
            )            
        end
    end
end

function BossRoom:updateLava()
    for i,c in pairs(self.lavaColliders) do
        if not self.lavaAttackOnCooldown[i]
        and c:isTouching(Player.collider:getBody())
        then
            local angle=self.lavaColliderKnockbackAngles[i]           
            Player:takeDamage('melee','pure',25*(Player.collider:getMass()/0.1),angle,5)
            self.lavaAttackOnCooldown[i]=true
            TimerState:after(0.1,function() self.lavaAttackOnCooldown[i]=false end) 
        end
    end
end

function BossRoom:spawnFlameTonados()
    if self.boss==nil then return end --if no boss, return
    if self.boss.health.current==0 then return end --if boss is dead, return
    if Player.health.current==0 then return end --is player is dead, return

    local numTornados=0
    local corners={'topLeft','topRight','botLeft','botRight'}
    local positions={
        topLeft={x=192,y=128},
        topRight={x=624,y=128},
        botLeft={x=192,y=464},
        botRight={x=624,y=464}
    }
    local angles={
        topLeft=math.atan2(1,1),
        topRight=math.atan2(1,-1),
        botLeft=math.atan2(-1,1),
        botRight=math.atan2(-1,-1)
    }

    --amount of tornados increase as boss loses thirds of max health
    if self.boss.health.current<=self.boss.health.max*0.33 then numTornados=4
    elseif self.boss.health.current<=self.boss.health.max*0.66 then numTornados=3
    else numTornados=2
    end

    for i=1,numTornados do 
        --pick a corner to spawn in, then remove that corner from the selection
        --so that the next tornado can't choose the same corner.
        local i=love.math.random(#corners)
        local selectedCorner=corners[i]
        table.remove(corners,i)

        SpecialAttacks:spawnFlameTornado( --spawn tornado at the selected corner 
            positions[selectedCorner].x,
            positions[selectedCorner].y,
            angles[selectedCorner]
        )
    end
end

function BossRoom:activateFloorTiles()
    for x=1,#self.floorTiles do 
        for y,tile in pairs(self.floorTiles[x]) do 
            tile.animations.seep:pauseAtStart()
            tile.animations.fill:pauseAtStart()
            tile.animations.receed:pauseAtStart()
            TimerState:after(3,function() 
                tile.animations.currentAnim=tile.animations.fill
                tile.animations.currentAnim:resume()
            end)
            TimerState:after(6,function() 
                tile.animations.currentAnim=tile.animations.receed
                tile.animations.currentAnim:resume()
            end)
            tile.animations.currentAnim=tile.animations.seep
            tile.animations.currentAnim:resume()
        end
    end
end