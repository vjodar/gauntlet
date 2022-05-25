BossRoom={}

function BossRoom:load()
    self.boss=nil --holds the boss instance

    self.sprites={
        lava=love.graphics.newImage('assets/maps/boss_lava.png'),
        floor=love.graphics.newImage('assets/maps/boss_floor.png'),
    }
    self.floorW,self.floorH=self.sprites.floor:getWidth(),self.sprites.floor:getHeight()

    self.lavaColliders={ --colliders for lava surrounding the floor
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

    self.tornadoTimer=10 --start 10s in to spawn first torando soon
end

function BossRoom:update()
    self:updateLava() --damage and knockback player when touching lava

    self.tornadoTimer=self.tornadoTimer+dt 
    if self.tornadoTimer>=20 then --spawn tornados every 30s
        self.tornadoTimer=0
        self:spawnFlameTonados()
    end
end

function BossRoom:draw()
    love.graphics.draw(self.sprites.lava,0,0)
    love.graphics.draw(self.sprites.floor,224,160)
end

function BossRoom:updateLava()
    for i,c in pairs(self.lavaColliders) do
        if not self.lavaAttackOnCooldown[i]
        and c:enter('player')
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