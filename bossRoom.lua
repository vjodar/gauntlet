BossRoom={}

function BossRoom:load()
    self.boss=nil --holds the boss instance

    --spritesheets and animations
    self.sprites={
        lava=love.graphics.newImage('assets/maps/boss_lava.png'),
        floor=love.graphics.newImage('assets/maps/boss_floor.png'),
        floorTile1=love.graphics.newImage('assets/maps/boss_floor_tile7.png'),
        floorTile2=love.graphics.newImage('assets/maps/boss_floor_tile8.png'),
        floorTile3=love.graphics.newImage('assets/maps/boss_floor_tile9.png'),
        floorTile4=love.graphics.newImage('assets/maps/boss_floor_tile10.png'),
        floorTile5=love.graphics.newImage('assets/maps/boss_floor_tile11.png'),
        floorTile6=love.graphics.newImage('assets/maps/boss_floor_tile12.png'),
        floorTile7=love.graphics.newImage('assets/maps/boss_floor_tile13.png'),
        floorTile8=love.graphics.newImage('assets/maps/boss_floor_tile14.png'),
    }
    self.floorW,self.floorH=self.sprites.floor:getWidth(),self.sprites.floor:getHeight()
    self.grids={
        floorTile=anim8.newGrid(
            16,16,self.sprites.floorTile1:getWidth(),
            self.sprites.floorTile1:getHeight()
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
    self.floorLavaPatterns,self.floorLavaColliderData=self:generateFloorLavaPatterns()    

    self.floorLavaColliders={} --holds the colliders for floor lava
    self.floorLavaAttackOnCooldown=false 
    
    self.tornadoTimer=10 --start 10s in to spawn first torando soon
    self.floorTileTimer=8
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
    if self.floorTileTimer>=10 then 
        self.floorTileTimer=0 
        self:activateFloorTiles()
    end

    for i,lava in pairs(self.floorLavaColliders) do 
        if not self.floorLavaAttackOnCooldown
        and lava:isTouching(Player.collider:getBody()) 
        then 
            self.floorLavaAttackOnCooldown=true 
            TimerState:after(0.1,function() self.floorLavaAttackOnCooldown=false end)
            --choose random angle in 360 degree spread
            local angle=2*math.pi*love.math.random()-math.pi
            Player:takeDamage('melee','pure',10,angle,5)
        end
    end
end

function BossRoom:draw()
    love.graphics.draw(self.sprites.lava,0,0)
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
                spriteNum=love.math.random(1,8), --choose a tile sprite
                xPos=224+16*(x-1),
                yPos=160+16*(y-1),
                animations={} --holds all animations
            }
            floorTiles[x][y].animations.seep=anim8.newAnimation( --lava seeps through cracks
                self.grids.floorTile('1-4',1),0.25,
                function() floorTiles[x][y].animations.seep:pauseAtEnd() end
            )
            floorTiles[x][y].animations.fill=anim8.newAnimation( --lava fills tile
                self.grids.floorTile('5-10',1),0.1,
                function() --after filling, go to rise/fall idle
                    floorTiles[x][y].animations.currentAnim=floorTiles[x][y].animations.fall
                    floorTiles[x][y].animations.fall:resume()
                end
            )
            floorTiles[x][y].animations.receed=anim8.newAnimation( --lava receeds from tile
                self.grids.floorTile('10-1',1),0.1,
                function() floorTiles[x][y].animations.receed:pauseAtEnd() end
            )
            floorTiles[x][y].animations.fall=anim8.newAnimation( --lava idle fall
                self.grids.floorTile('9-7',1),0.1+2*love.math.random(),
                function() --return to fall idle
                    floorTiles[x][y].animations.currentAnim=floorTiles[x][y].animations.rise                    
                end
            )
            floorTiles[x][y].animations.rise=anim8.newAnimation( --lava idle rise
                self.grids.floorTile('8-10',1),0.1+2*love.math.random(),
                function() --return to rise idle
                    floorTiles[x][y].animations.currentAnim=floorTiles[x][y].animations.fall
                end
            )
            floorTiles[x][y].animations.seep:pauseAtStart()
            floorTiles[x][y].animations.fill:pauseAtStart()
            floorTiles[x][y].animations.receed:pauseAtStart()
            floorTiles[x][y].animations.fall:pauseAtStart()

            floorTiles[x][y].animations.currentAnim=floorTiles[x][y].animations.seep     
        end
    end
    return floorTiles
end

--generates floor lava patterns and their collider data. Patterns are tables of 
--coordinates for the floorTiles which will be 'activated' to produce the 
--'damaging floor' attack. Collider data is the x, y, width, and height of all
--colliders that will be created to represent the floor lava damaging areas
function BossRoom:generateFloorLavaPatterns()
    local patterns={}
    local colliderData={}

    local a1={} --1
    for x=5,14 do for y=5,13 do table.insert(a1,{x,y}) end end
    table.insert(patterns,a1)
    local a1_data={}
    table.insert(a1_data,self:createColliderData(5,14,5,13))
    table.insert(colliderData,a1_data)

    local a2={} --2 
    for x=5,14 do for y=7,15 do table.insert(a2,{x,y}) end end
    table.insert(patterns,a2)
    local a2_data={}
    table.insert(a2_data,self:createColliderData(5,14,7,15))
    table.insert(colliderData,a2_data)

    local a3={} --3
    for x=12,21 do for y=5,13 do table.insert(a3,{x,y}) end end
    table.insert(patterns,a3)
    local a3_data={}
    table.insert(a3_data,self:createColliderData(12,21,5,13))
    table.insert(colliderData,a3_data)

    local a4={} --4
    for x=12,21 do for y=7,15 do table.insert(a4,{x,y}) end end
    table.insert(patterns,a4)    
    local a4_data={}
    table.insert(a4_data,self:createColliderData(12,21,7,15))
    table.insert(colliderData,a4_data)

    local b1={} --5
    for x=1,12 do for y=1,10 do table.insert(b1,{x,y}) end end
    table.insert(patterns,b1)
    local b1_data={}
    table.insert(b1_data,self:createColliderData(1,12,1,10))
    table.insert(colliderData,b1_data)
    
    local b2={} --6
    for x=14,25 do for y=1,10 do table.insert(b2,{x,y}) end end
    table.insert(patterns,b2)
    local b2_data={}
    table.insert(b2_data,self:createColliderData(14,25,1,10))
    table.insert(colliderData,b2_data)

    local b3={} --7
    for x=1,12 do for y=10,19 do table.insert(b3,{x,y}) end end
    table.insert(patterns,b3)
    local b3_data={}
    table.insert(b3_data,self:createColliderData(1,12,10,19))
    table.insert(colliderData,b3_data)

    local b4={} --8
    for x=14,25 do for y=10,19 do table.insert(b4,{x,y}) end end
    table.insert(patterns,b4)
    local b4_data={}
    table.insert(b4_data,self:createColliderData(14,25,10,19))
    table.insert(colliderData,b4_data)

    local c1={} --9
    for x=1,6 do for y=1,19 do table.insert(c1,{x,y}) end end 
    for x=20,25 do for y=1,19 do table.insert(c1,{x,y}) end end 
    table.insert(patterns,c1)
    local c1_data={}
    table.insert(c1_data,self:createColliderData(1,6,1,19))
    table.insert(c1_data,self:createColliderData(20,25,1,19))
    table.insert(colliderData,c1_data)

    local c2={} --10
    for x=1,25 do for y=1,4 do table.insert(c2,{x,y}) end end 
    for x=1,25 do for y=16,19 do table.insert(c2,{x,y}) end end 
    table.insert(patterns,c2)
    local c2_data={}
    table.insert(c2_data,self:createColliderData(1,25,1,4))
    table.insert(c2_data,self:createColliderData(1,25,16,19))
    table.insert(colliderData,c2_data)

    local d1={} --11
    for x=1,25 do for y=1,8 do table.insert(d1,{x,y}) end end
    table.insert(patterns,d1)
    local d1_data={}
    table.insert(d1_data,self:createColliderData(1,25,1,8))
    table.insert(colliderData,d1_data)

    local d2={} --12
    for x=1,25 do for y=12,19 do table.insert(d2,{x,y}) end end
    table.insert(patterns,d2)
    local d2_data={}
    table.insert(d2_data,self:createColliderData(1,25,12,19))
    table.insert(colliderData,d2_data)

    local d3={} --13
    for x=1,10 do for y=1,19 do table.insert(d3,{x,y}) end end
    table.insert(patterns,d3)
    local d3_data={}
    table.insert(d3_data,self:createColliderData(1,10,1,19))
    table.insert(colliderData,d3_data)

    local d4={} --14
    for x=16,25 do for y=1,19 do table.insert(d4,{x,y}) end end
    table.insert(patterns,d4)
    local d4_data={}
    table.insert(d4_data,self:createColliderData(16,25,1,19))
    table.insert(colliderData,d4_data)

    local e={} --15
    for x=9,17 do for y=7,13 do table.insert(e,{x,y}) end end
    for x=1,7 do for y=1,5 do table.insert(e,{x,y}) end end
    for x=1,7 do for y=15,19 do table.insert(e,{x,y}) end end
    for x=19,25 do for y=1,5 do table.insert(e,{x,y}) end end
    for x=19,25 do for y=15,19 do table.insert(e,{x,y}) end end
    table.insert(patterns,e)
    local e_data={}
    table.insert(e_data,self:createColliderData(9,17,7,13))
    table.insert(e_data,self:createColliderData(1,7,1,5))
    table.insert(e_data,self:createColliderData(1,7,15,19))
    table.insert(e_data,self:createColliderData(19,25,1,5))
    table.insert(e_data,self:createColliderData(19,25,15,19))
    table.insert(colliderData,e_data)

    local f={} --16
    for x=3,11 do for y=3,8 do table.insert(f,{x,y}) end end
    for x=3,11 do for y=12,17 do table.insert(f,{x,y}) end end
    for x=15,23 do for y=3,8 do table.insert(f,{x,y}) end end
    for x=15,23 do for y=12,17 do table.insert(f,{x,y}) end end
    table.insert(patterns,f)
    local f_data={}
    table.insert(f_data,self:createColliderData(3,11,3,8))
    table.insert(f_data,self:createColliderData(3,11,12,17))
    table.insert(f_data,self:createColliderData(15,23,3,8))
    table.insert(f_data,self:createColliderData(15,23,12,17))
    table.insert(colliderData,f_data)

    local g={} --17
    for x=1,25 do for y=1,4 do table.insert(g,{x,y}) end end
    for x=1,25 do for y=16,19 do table.insert(g,{x,y}) end end
    for x=1,5 do for y=5,15 do table.insert(g,{x,y}) end end
    for x=21,25 do for y=5,15 do table.insert(g,{x,y}) end end
    table.insert(patterns,g)
    local g_data={}
    table.insert(g_data,self:createColliderData(1,25,1,4))
    table.insert(g_data,self:createColliderData(1,25,16,19))
    table.insert(g_data,self:createColliderData(1,5,5,15))
    table.insert(g_data,self:createColliderData(21,25,5,15))
    table.insert(colliderData,g_data)

    return patterns,colliderData
end

--helper function for generateFloorLavaPatterns. Returns a collider data table
--given a start and end (x,y) pair (based on the layout of the boss room).
function BossRoom:createColliderData(_x1,_x2,_y1,_y2)
    return {x=224+16*(_x1-1),y=160+16*(_y1-1),w=(1+_x2-_x1)*16,h=(1+_y2-_y1)*16}
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
                self.sprites['floorTile'..tile.spriteNum],tile.xPos,tile.yPos
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
    if self.boss==nil then return end --no boss, return
    if self.boss.health.current==0 then return end --dead boss, return
    if Player.health.current==0 then return end --dead player, return

    --select a floor lava pattern
    local patternIndex=1
    if self.boss.health.current<=self.boss.health.max/3 then 
        --boss has 1/3hp left, choose a hard lava pattern
        patternIndex=love.math.random(15,17)
    else --boss has over 1/3hp, choose a normal lava pattern
        patternIndex=love.math.random(1,14)
    end
    local selectedPattern=self.floorLavaPatterns[patternIndex]

    --activate the floorTiles at all coordinate pairs in the selected pattern
    for i,coordinate in pairs(selectedPattern) do 
        local tile=self.floorTiles[coordinate[1]][coordinate[2]]
        tile.animations.seep:pauseAtStart()
        tile.animations.fill:pauseAtStart()
        tile.animations.receed:pauseAtStart()
        tile.animations.fall:pauseAtStart()
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

    TimerState:after(3,function() --create colliders upon 'fill' animation
        for i,data in pairs(self.floorLavaColliderData[patternIndex]) do 
            local collider=world:newRectangleCollider(data.x,data.y,data.w,data.h)
            collider:setSensor(true)
            table.insert(self.floorLavaColliders,collider)
        end        
    end)

    TimerState:after(6,function() --destroy colliders upon 'receed' animation
        for i,collider in pairs(self.floorLavaColliders) do 
            collider:destroy()
        end
        self.floorLavaColliders={} --empty floorLavaCollidersTable
    end)
end