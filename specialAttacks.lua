SpecialAttacks={}

function SpecialAttacks:load()
    self.spriteSheets={
        tornado_segment_1=love.graphics.newImage('assets/specials/tornado_segment_1.png'),
        tornado_segment_2=love.graphics.newImage('assets/specials/tornado_segment_2.png'),
        tornado_segment_3=love.graphics.newImage('assets/specials/tornado_segment_3.png'),
        tornado_segment_4=love.graphics.newImage('assets/specials/tornado_segment_4.png'),
        tornado_segment_5=love.graphics.newImage('assets/specials/tornado_segment_5.png'),
        tornado_segment_6=love.graphics.newImage('assets/specials/tornado_segment_6.png'),
        tornado_segment_7=love.graphics.newImage('assets/specials/tornado_segment_7.png'),
        tornado_segment_8=love.graphics.newImage('assets/specials/tornado_segment_8.png'),
        flame_tornado_segment_1=love.graphics.newImage('assets/specials/flame_tornado_segment_1.png'),
        flame_tornado_segment_2=love.graphics.newImage('assets/specials/flame_tornado_segment_2.png'),
        flame_tornado_segment_3=love.graphics.newImage('assets/specials/flame_tornado_segment_3.png'),
        flame_tornado_segment_4=love.graphics.newImage('assets/specials/flame_tornado_segment_4.png'),
        flame_tornado_segment_5=love.graphics.newImage('assets/specials/flame_tornado_segment_5.png'),
        flame_tornado_segment_6=love.graphics.newImage('assets/specials/flame_tornado_segment_6.png'),
        flame_tornado_segment_7=love.graphics.newImage('assets/specials/flame_tornado_segment_7.png'),
        flame_tornado_segment_8=love.graphics.newImage('assets/specials/flame_tornado_segment_8.png'),

        fireInsignia=love.graphics.newImage('assets/specials/fire_insignia.png'),
        flame=love.graphics.newImage('assets/specials/flame_particle.png'),
        fireball=love.graphics.newImage('assets/specials/fireball_particle.png'),
        flamePillar=love.graphics.newImage('assets/specials/flame_pillar_particle.png'),

        fissure_trail_1=love.graphics.newImage('assets/specials/fissure_trail_1.png'),
        fissure_trail_2=love.graphics.newImage('assets/specials/fissure_trail_2.png'),
        fissure_trail_3=love.graphics.newImage('assets/specials/fissure_trail_3.png'),
        fissure_trail_4=love.graphics.newImage('assets/specials/fissure_trail_4.png'),
        fissure_trail_5=love.graphics.newImage('assets/specials/fissure_trail_5.png'),
        fissure_trail_6=love.graphics.newImage('assets/specials/fissure_trail_6.png'),
    }

    self.grids={
        tornado_segment_1=anim8.newGrid(
            6,5,self.spriteSheets.tornado_segment_1:getWidth(),
            self.spriteSheets.tornado_segment_1:getHeight()
        ),
        tornado_segment_2=anim8.newGrid(
            7,6,self.spriteSheets.tornado_segment_2:getWidth(),
            self.spriteSheets.tornado_segment_2:getHeight()
        ),
        tornado_segment_3=anim8.newGrid(
            9,8,self.spriteSheets.tornado_segment_3:getWidth(),
            self.spriteSheets.tornado_segment_3:getHeight()
        ),
        tornado_segment_4=anim8.newGrid(
            11,9,self.spriteSheets.tornado_segment_4:getWidth(),
            self.spriteSheets.tornado_segment_4:getHeight()
        ),
        tornado_segment_5=anim8.newGrid(
            14,10,self.spriteSheets.tornado_segment_5:getWidth(),
            self.spriteSheets.tornado_segment_5:getHeight()
        ),
        tornado_segment_6=anim8.newGrid(
            17,11,self.spriteSheets.tornado_segment_6:getWidth(),
            self.spriteSheets.tornado_segment_6:getHeight()
        ),
        tornado_segment_7=anim8.newGrid(
            21,13,self.spriteSheets.tornado_segment_7:getWidth(),
            self.spriteSheets.tornado_segment_7:getHeight()
        ),
        tornado_segment_8=anim8.newGrid(
            29,14,self.spriteSheets.tornado_segment_8:getWidth(),
            self.spriteSheets.tornado_segment_8:getHeight()
        ),
        fissure_trail_1=anim8.newGrid(
            7,self.spriteSheets.fissure_trail_1:getHeight(),
            self.spriteSheets.fissure_trail_1:getWidth(),
            self.spriteSheets.fissure_trail_1:getHeight()
        ),
        fissure_trail_2=anim8.newGrid(
            7,self.spriteSheets.fissure_trail_2:getHeight(),
            self.spriteSheets.fissure_trail_2:getWidth(),
            self.spriteSheets.fissure_trail_2:getHeight()
        ),
        fissure_trail_3=anim8.newGrid(
            10,self.spriteSheets.fissure_trail_3:getHeight(),
            self.spriteSheets.fissure_trail_3:getWidth(),
            self.spriteSheets.fissure_trail_3:getHeight()
        ),
        fissure_trail_4=anim8.newGrid(
            10,self.spriteSheets.fissure_trail_4:getHeight(),
            self.spriteSheets.fissure_trail_4:getWidth(),
            self.spriteSheets.fissure_trail_4:getHeight()
        ),
        fissure_trail_5=anim8.newGrid(
            11,self.spriteSheets.fissure_trail_5:getHeight(),
            self.spriteSheets.fissure_trail_5:getWidth(),
            self.spriteSheets.fissure_trail_5:getHeight()
        ),
        fissure_trail_6=anim8.newGrid(
            11,self.spriteSheets.fissure_trail_6:getHeight(),
            self.spriteSheets.fissure_trail_6:getWidth(),
            self.spriteSheets.fissure_trail_6:getHeight()
        ),
    }

    self.animations={
        tornado_segment_1=anim8.newAnimation(self.grids.tornado_segment_1('1-6',1), 0.03),
        tornado_segment_2=anim8.newAnimation(self.grids.tornado_segment_2('1-10',1), 0.02),
        tornado_segment_3=anim8.newAnimation(self.grids.tornado_segment_3('1-11',1), 0.02),
        tornado_segment_4=anim8.newAnimation(self.grids.tornado_segment_4('1-12',1), 0.02),
        tornado_segment_5=anim8.newAnimation(self.grids.tornado_segment_5('1-12',1), 0.02),
        tornado_segment_6=anim8.newAnimation(self.grids.tornado_segment_6('1-11',1), 0.02),
        tornado_segment_7=anim8.newAnimation(self.grids.tornado_segment_7('1-8',1), 0.04),
        tornado_segment_8=anim8.newAnimation(self.grids.tornado_segment_8('1-14',1), 0.04),
    }

    self.particleSystems={}
    --particle system for FireCircle
    self.particleSystems.flames=love.graphics.newParticleSystem(self.spriteSheets.flame,200)
    self.particleSystems.flames:setParticleLifetime(0.5,1)
    self.particleSystems.flames:setEmissionArea('normal',3,2)
    self.particleSystems.flames:setLinearAcceleration(-30,0,30,-130)    
    self.particleSystems.flames:setRotation(0,0.5*math.pi)
    self.particleSystems.flames:setSizes(0.5,2,0.5,2,0.5,0.1)
    self.particleSystems.flames:setColors(
        1,1,1,0.5,
        (250/255),(203/255),(62/255),0.5,
        (238/255),(142/255),(46/255),0.6,
        (218/255),(78/255),(56/255),0.6,
        (218/255),(78/255),(56/255),0.7,
        (34/255),(34/255),(34/255),1
    ) 
    --particle system for Fireball
    self.particleSystems.fireball=love.graphics.newParticleSystem(self.spriteSheets.fireball,1000)
    self.particleSystems.fireball:setParticleLifetime(0.1,0.4)
    self.particleSystems.fireball:setSpeed(10,20)
    self.particleSystems.fireball:setEmissionArea('ellipse',5,5,0,true)
    self.particleSystems.fireball:setSpin(50)
    self.particleSystems.fireball:setRotation(0,0.5*math.pi)
    self.particleSystems.fireball:setColors(
        1,1,1,1,
        (250/255),(203/255),(62/255),1,
        (238/255),(142/255),(46/255),1,
        (218/255),(78/255),(56/255),1,
        (218/255),(78/255),(56/255),1,
        (34/255),(34/255),(34/255),1
    )
    --particle system for disabling Fireball (disables protection magics on hit)
    self.particleSystems.disablingFireball=self.particleSystems.fireball:clone()
    self.particleSystems.disablingFireball:setColors(
        1,1,1,1,
        (247/255),(134/255),(151/255),1,
        (220/255),(74/255),(123/255),1,
        (159/255),(41/255),(78/255),1,
        (95/255),(45/255),(86/255),1,
        (95/255),(45/255),(86/255),1,
        (34/255),(34/255),(34/255),1
    )
    --particle system for flame tornado
    self.particleSystems.flamePillar=love.graphics.newParticleSystem(self.spriteSheets.flamePillar,4000)
    self.particleSystems.flamePillar:setParticleLifetime(1.8,2.2)
    self.particleSystems.flamePillar:setRadialAcceleration(-2000)
    self.particleSystems.flamePillar:setLinearAcceleration(-40,-2000,40,-2000)
    self.particleSystems.flamePillar:setLinearDamping(1)
    self.particleSystems.flamePillar:setSpeed(-100,100)
    self.particleSystems.flamePillar:setSpin(15)
    self.particleSystems.flamePillar:setEmissionArea('borderellipse',4,3,0,true)
    -- self.particleSystems.flamePillar:setSizes(0.7,1,1,1)
    self.particleSystems.flamePillar:setColors(
        1,1,1,0.6,
        (255/255),(204/255),(104/255),1,
        (250/255),(203/255),(62/255),1,
        (238/255),(142/255),(46/255),0.8,
        (238/255),(142/255),(46/255),0.6,
        (218/255),(78/255),(56/255),0.6,
        (218/255),(78/255),(56/255),0.4,
        (34/255),(34/255),(34/255),0.2
    )
end 

--spawns a tornado at a given set of coordinates and an initial travel angle
function SpecialAttacks:spawnTornado(_xPos,_yPos,_angle)
    local tornado={}

    function tornado:load()
        self.spriteSheets={
            s1=SpecialAttacks.spriteSheets.tornado_segment_1,
            s2=SpecialAttacks.spriteSheets.tornado_segment_2,
            s3=SpecialAttacks.spriteSheets.tornado_segment_3,
            s4=SpecialAttacks.spriteSheets.tornado_segment_4,
            s5=SpecialAttacks.spriteSheets.tornado_segment_5,
            s6=SpecialAttacks.spriteSheets.tornado_segment_6,
            s7=SpecialAttacks.spriteSheets.tornado_segment_7,
            s8=SpecialAttacks.spriteSheets.tornado_segment_8,
        }

        self.animations={
            s1=SpecialAttacks.animations.tornado_segment_1:clone(),
            s2=SpecialAttacks.animations.tornado_segment_2:clone(),
            s3=SpecialAttacks.animations.tornado_segment_3:clone(),
            s4=SpecialAttacks.animations.tornado_segment_4:clone(),
            s5=SpecialAttacks.animations.tornado_segment_5:clone(),
            s6=SpecialAttacks.animations.tornado_segment_6:clone(),
            s7=SpecialAttacks.animations.tornado_segment_7:clone(),
            s8=SpecialAttacks.animations.tornado_segment_8:clone(),
        }

        self.offsets={
            s1={x=-3,y=-4},
            s2={x=-3,y=-8},
            s3={x=-4,y=-12},
            s4={x=-5,y=-17},
            s5={x=-6,y=-22},
            s6={x=-7,y=-28},
            s7={x=-9,y=-32},
            s8={x=-12,y=-38},
        }

        self.oscillations={
            s1=0.25*8,
            s2=0.25*7,
            s3=0.25*6,
            s4=0.25*5,
            s5=0.25*4,
            s6=0.25*3,
            s7=0.25*2,
            s8=0.25*1,
        }

        self.collider=world:newBSGRectangleCollider(_xPos,_yPos,12,5,3) --physical collider
        --need to use another collider for detecting collisions with the player
        --because the player has fixtures that extend out and can be sensors.
        --if only the physical collider was used, tornados will be able to damage
        --the player through vertical walls.
        self.damageCollider=world:newRectangleCollider(_xPos,_yPos,2,5) --damaging collider
        self.damageCollider:setSensor(true )
        self.collider:setFixedRotation(true)
        self.collider:setFriction(0)
        self.collider:setRestitution(0)
        self.collider:setLinearDamping(20)
        self.collider:setMass(0.1)
        self.collider:setCollisionClass('tornado')
        self.collider:setObject(self)
        self.xPos,self.yPos=self.collider:getPosition()
        self.moveSpeed=100
        self.knockback=50
        self.damage=20
        self.angle=_angle
        self.attackOnCooldown=false
        self.willDie=false
        
        self.moveToPlayer=false --travel along initial angle, after 2s, move to player
        TimerState:after(2,function() self.moveToPlayer=true end)

        --after some time from spawning, destroy tornado
        TimerState:after(
            love.math.random(10,20), --lifespan is 10-20s
            function() 
                self:removeSegments()
                self.willDie=true 
            end
        )

        self.shadow=Shadows:newShadow('tornado')

        self.sfx={
            tornado=Sounds.tornado()
        }

        table.insert(Entities.entitiesTable,self)
    end

    function tornado:update()
        self.xPos,self.yPos=self.collider:getPosition()
        for i,anim in pairs(self.animations) do anim:update(dt) end
        for i,o in pairs(self.oscillations) do
            self.oscillations[i]=self.oscillations[i]+dt*8
        end

        local pitch=love.math.random(4,8)*0.1
        self.sfx.tornado:play(pitch)

        --apply force to move the tornado in a circle to match it's sprite oscillation
        self.collider:applyForce(
            3*math.cos(self.oscillations.s1+math.pi*0.25)*self.moveSpeed*0.2,
            2*math.sin(self.oscillations.s1+math.pi*0.25)*self.moveSpeed*0.2
        )

        --travel in the direction of angle
        self.collider:applyForce(
            math.cos(self.angle)*self.moveSpeed,
            math.sin(self.angle)*self.moveSpeed
        )

        --move damage collider to physical collider location
        self.damageCollider:setPosition(self.collider:getPosition())

        if self.willDie then 
            --slow down speed over time
            self.moveSpeed=self.moveSpeed-45*dt

            --once all segments are removed, remove the tornado itself from game
            if self.animations.s8==nil then 
                self.collider:destroy()
                self.damageCollider:destroy()
                return false 
            end
            return
        end

        --update angle to player after initial travel time
        if self.moveToPlayer then 
            self.angle=math.atan2(
                (Player.yPos-self.yPos),(Player.xPos-self.xPos)
            )
        end

        --damage and knockback player
        if not self.attackOnCooldown 
            --using the damageCollider which is smaller because otherwise
            --the tornado will detect collisions with the fixtures that
            --extend beyond the player's hitbox.
            and self.damageCollider:isTouching(Player.collider:getBody())
        then
            local angleToPlayer=math.atan2(
                (Player.yPos-self.yPos),(Player.xPos-self.xPos)
            )
            self.attackOnCooldown=true 
            TimerState:after(0.5,function() self.attackOnCooldown=false end)
            Player:takeDamage('melee','pure',self.knockback,angleToPlayer,self.damage)
        end

        if Player.health.current==0 then 
            self:removeSegments()
            self.willDie=true 
        end
    end

    function tornado:draw()
        self.shadow:draw(self.xPos,self.yPos)
        for i,segment in pairs(self.animations) do
            segment:draw(
                self.spriteSheets[i],
                self.xPos+self.offsets[i].x+3*math.cos(self.oscillations[i]),
                self.yPos+self.offsets[i].y+2*math.sin(self.oscillations[i])
            )
        end
    end

    function tornado:removeSegments() 
        for i=1,8 do --use timers to remove each segment gradually from bottom to top
            TimerState:after(i*0.2,function() self.animations['s'..i]=nil end)
        end
    end

    tornado:load()
end

--spawns a circle of damaging flames after revealing an insignia on the floor,
--showing where the flames will spawn.
function SpecialAttacks:spawnFireCircle(_xPos,_yPos)
    local insignia={}

    function insignia:load()
        self.xPos,self.yPos=_xPos,_yPos
        self.sprite=SpecialAttacks.spriteSheets.fireInsignia
        self.alpha=0
        self.lifespan=love.math.random(5,10)
        self.collider=world:newBSGRectangleCollider(
            self.xPos-23.5,self.yPos-16,47,32,10
        )
        self.collider:setSensor(true)
        self.attackOnCooldown=true
        self.damage=5
        self.knockback=10
        self.flamesSpawned=false 

        TimerState:after(1,function() --spawn flames after 1s
            self:spawnFlames()
            self.attackOnCooldown=false 
            self.flamesSpawned=true
        end) 

        self.sfx={
            spawn=Sounds.fire_cicle(),
            flames=Sounds.flames()
        }
        local pitch=love.math.random(9,11)*0.1
        self.sfx.spawn:play(pitch)

        table.insert(Dungeon.floorObjects,self) --add to dungeon's floor effects
    end

    function insignia:update()
        --reveal by increasing alpha
        if self.alpha<1 then self.alpha=self.alpha+dt end

        if self.flamesSpawned then 
            local pitch=love.math.random(8,12)*0.1
            self.sfx.flames:play(pitch)
        end

        if not self.attackOnCooldown
        and self.collider:isTouching(Player.collider:getBody())
        then 
            local angle=2*math.pi*love.math.random()-math.pi -- -pi to +pi range
            Player:takeDamage('melee','pure',self.knockback,angle,self.damage)
            self.attackOnCooldown=true
            TimerState:after(0.1,function() self.attackOnCooldown=false end)
        end

        self.lifespan=self.lifespan-dt
        if self.lifespan<=0 then 
            for i,obj in pairs(Dungeon.floorObjects) do 
                if obj==self then table.remove(Dungeon.floorObjects,i) end 
            end
            self.collider:destroy()
        end
    end

    function insignia:draw()
        love.graphics.setColor(1,1,1,self.alpha)
        love.graphics.draw(self.sprite,self.xPos-23.5,self.yPos-16)
        love.graphics.setColor(1,1,1,1)
    end

    function insignia:spawnFlames()
        local flamesTable={} --holds all individual flames
        local function loadFlame()
            local flame={} --an individual flame collider/particle system
        
            function flame:load()
                self.xPos,self.yPos=_xPos,_yPos
                self.lifespan=insignia.lifespan

                self.collider=world:newBSGRectangleCollider(
                    self.xPos-4.5,self.yPos-4,
                    9,8,4
                )
                self.collider:setFixedRotation(true)
                self.collider:setCollisionClass('flame')
                self.collider:setLinearDamping(1)

                self.particles=SpecialAttacks.particleSystems.flames:clone()
                self.particles:start()
                self.particleEmissionRate=1/60 --will emit every 1/60s
                self.particleEmissionTimer=0

                self.particles:emit(10)
        
                table.insert(Entities.entitiesTable,self)
                table.insert(flamesTable,self)
            end
        
            function flame:update()
                self.xPos,self.yPos=self.collider:getPosition()
                self.particles:update(dt)
                self.particleEmissionTimer=self.particleEmissionTimer+dt
                if self.particleEmissionTimer>=self.particleEmissionRate then 
                    self.particleEmissionTimer=0
                    self.particles:emit(2) --emit every ~1/60s
                end

                self.lifespan=self.lifespan-dt 
                if self.lifespan<=0 then
                    --once lifespan is 0, stop particle system.
                    --when no particles remain, destory collider and delete flame
                    self.particles:stop(0) 
                    if self.particles:getCount()==0 then 
                        self.collider:destroy()
                        return false 
                    end
                end 
            end
        
            function flame:draw()
                love.graphics.draw(self.particles,self.xPos,self.yPos)
            end

            flame:load()
        end

        for i=1,17 do loadFlame() end --spawn in 10 flames
        for i=1,#flamesTable-1 do --spread out flames in a circle to cover insignia
            local angle=(i-1)*0.25*math.pi
            local force=1.2
            if i>8 then force=0.6 end
            flamesTable[i].collider:applyLinearImpulse(
                --x impulse is greater than y impulse to match ellipse of insignia
                math.cos(angle)*force*1.4,math.sin(angle)*force*0.9
            )
        end
    end    

    insignia:load() 
end

--boss' basic physical attack
--spawns a collider that travels to a _target, spawning fissure trail pieces while 
--it traveles, creating a fissure. Upon touching target, damage and spawn a fissue end
function SpecialAttacks:spawnFissure(_xPos,_yPos,_target)
    local fissure={}

    function fissure:load()
        self.sprites={
            fissure_trail_1=SpecialAttacks.spriteSheets.fissure_trail_1,
            fissure_trail_2=SpecialAttacks.spriteSheets.fissure_trail_2,
            fissure_trail_3=SpecialAttacks.spriteSheets.fissure_trail_3,
            fissure_trail_4=SpecialAttacks.spriteSheets.fissure_trail_4,
            fissure_trail_5=SpecialAttacks.spriteSheets.fissure_trail_5,
            fissure_trail_6=SpecialAttacks.spriteSheets.fissure_trail_6,
        }
        self.collider=world:newBSGRectangleCollider(_xPos,_yPos,9,8,4)
        self.xPos,self.yPos=self.collider:getPosition()
        self.collider:setLinearDamping(20)
        self.collider:setMass(0.1)
        self.collider:setSensor(true)
        self.target=_target 
        self.damage=45
        self.knockback=120
        self.speed=480
        self.timer=-0.075
        self.angle=0
        self.willDie=false 
        self.hitTarget=false --true when fissure reached and hit its target

        self:spawnCrater1(self.xPos,self.yPos) --create crater in initial impact area

        self.sfx={
            travel=Sounds.fissure_travel()
        }

        table.insert(Entities.entitiesTable,self)
    end

    function fissure:update()
        self.xPos,self.yPos=self.collider:getPosition()
        self.timer=self.timer+dt 

        if not self.hitTarget then             
            --play fissure trail travel sfx
            local pitch=love.math.random(7,13)*0.1
            self.sfx.travel:play(pitch)
        end

        if self.timer>0.025 and not self.hitTarget then --spawn trail every 0.025s
            --spawn two trail pieces along the line of travel but somewhat 
            --staggered (1/4pi and 3/4pi along angle) to create a zigzag trail
            self:spawnTrail(
                self.xPos+3*math.cos(self.angle+0.25*math.pi),
                self.yPos+3*math.sin(self.angle+0.25*math.pi)
            )
            self:spawnTrail(
                self.xPos+3*math.cos(self.angle-0.75*math.pi),
                self.yPos+3*math.sin(self.angle-0.75*math.pi)
            )
            self.timer=0
        end 

        if Player.health.current==0 
        or (BossRoom.boss and BossRoom.boss.health.current==0)
        then 
            self.willDie=true 
        end

        if self.willDie then 
            self.collider:destroy()
            return false 
        end

        --travel toward target
        self.angle=math.atan2((self.target.yPos-self.yPos),(self.target.xPos-self.xPos))
        self.collider:applyForce(
            math.cos(self.angle)*self.speed, math.sin(self.angle)*self.speed            
        )
        
        --when contacting target, damage and set collider to not active, then die
        if not self.hitTarget 
        and self.collider:isTouching(self.target.collider:getBody())
        then 
            self:spawnCrater2(self.xPos,self.yPos,self.angle)
            self.target:takeDamage( --deal physical damage
                'projectile','physical',self.knockback,self.angle,self.damage
            )
            self.target:takeDamage( --deal reduced pure damage (with no knockback)
                'projectile','pure',0,self.angle,self.damage*0.25
            )
            self.hitTarget=true
            self.collider:setActive(false)
            TimerState:after(2,function() self.willDie=true end)
        end
    end

    function fissure:draw() end

    --spawns a random fissure trail piece and adds to entitiesTable
    function fissure:spawnTrail(_xPos,_yPos) 
        local trail={}

        function trail:load()
            self.xPos,self.yPos=_xPos,_yPos
            --choose a random fissure trail sprite/animation
            local trail='fissure_trail_'..love.math.random(1,6)
            self.sprite=fissure.sprites[trail]
            self.animationForward=anim8.newAnimation(
                SpecialAttacks.grids[trail]('1-4',1),0.02,
                function() self.animationForward:pauseAtEnd() end
            )
            self.animationBackward=anim8.newAnimation(
                SpecialAttacks.grids[trail]('4-1',1),0.02,
                function() self.willDie=true end
            )
            self.currentAnim=self.animationForward
            self.lifespan=1.5 --lasts for 1.5s  
            self.willDie=false          

            -- offset sprite to center base
            local w,h=self.currentAnim:getDimensions()
            self.xOffset=-w*0.5
            self.yOffset=-h*0.75

            table.insert(Entities.entitiesTable,self)
        end

        function trail:update()
            self.currentAnim:update(dt)
            self.lifespan=self.lifespan-dt 
            if self.lifespan<=0 then self.currentAnim=self.animationBackward end
            if self.willDie then return false end
        end

        function trail:draw()
            self.currentAnim:draw(
                self.sprite,
                self.xPos+self.xOffset,
                self.yPos+self.yOffset
            )
        end

        trail:load()
    end

    --creates a crater of trail peices at initial area (where boss slams)
    function fissure:spawnCrater1(_xPos,_yPos) 
        self:spawnTrail(_xPos-12,_yPos+1)
        self:spawnTrail(_xPos-8,_yPos-4)
        self:spawnTrail(_xPos,_yPos-6)
        self:spawnTrail(_xPos+8,_yPos-4)
        self:spawnTrail(_xPos+12,_yPos+1)
        self:spawnTrail(_xPos-8,_yPos+4)
        self:spawnTrail(_xPos,_yPos+6)
        self:spawnTrail(_xPos+8,_yPos+4)
        self:spawnTrail(_xPos,_yPos)
    end

    --creates a crater of trail peices at impact area (where player is hit)
    function fissure:spawnCrater2(_xPos,_yPos,_angle)
        self:spawnTrail(_xPos+10*math.cos(_angle),_yPos+8*math.sin(_angle))
        self:spawnTrail(_xPos+8*math.cos(_angle+0.25*math.pi),_yPos+6*math.sin(_angle+0.25*math.pi))
        self:spawnTrail(_xPos+8*math.cos(_angle-0.25*math.pi),_yPos+6*math.sin(_angle-0.25*math.pi))
        self:spawnTrail(_xPos+8*math.cos(_angle+0.5*math.pi),_yPos+6*math.sin(_angle+0.5*math.pi))
        self:spawnTrail(_xPos+8*math.cos(_angle-0.5*math.pi),_yPos+6*math.sin(_angle-0.5*math.pi))
    end

    fissure:load()
end

--boss' basic magical attack. 
--Launches a fireball that acts as a projectile, but uses particle systems to
--make it look much more detailed and deadlier
function SpecialAttacks:launchFireball(_xPos,_yPos,_target,_disablingBool)
    local fireball={}

    function fireball:load()
        self.collider=world:newBSGRectangleCollider(_xPos,_yPos,14,10,4)
        self.xPos,self.yPos=self.collider:getPosition()
        self.collider:setLinearDamping(20)
        self.collider:setMass(0.1)
        self.collider:setSensor(true)
        self.target=_target 
        self.damage=45
        self.knockback=120
        self.speed=480
        self.timer=0
        self.angle=0
        self.willDie=false 
        self.hitTarget=false --true when fissure reached and hit its target
        self.isDisabling=_disablingBool
        if self.isDisabling then --pink/purple particles
            self.particles=SpecialAttacks.particleSystems.disablingFireball:clone()
        else --yellow/red particles
            self.particles=SpecialAttacks.particleSystems.fireball:clone()
        end
        self.emissionRate=1/60
        self.yOffset=-20
        self.shadow=Shadows:newShadow('fireball')

        --rate at which the sprite will lower to the ground over time.
        --the closer the target, the higher the rate of lowering
        self.lowerRate=-180*(self.yOffset)/(
            ((self.target.xPos-self.xPos)^2+(self.target.yPos-self.yPos)^2)^0.5
        )

        table.insert(Entities.entitiesTable,self)
    end

    function fireball:update()        
        self.particles:update(dt)
        if Player.health.current==0 or BossRoom.boss.health.current==0 then 
            self.willDie=true 
        end
        if self.willDie then --must wait for particle system to be empty before dying
            if self.particles:getCount()==0 then 
                self.collider:destroy()
                return false 
            else return end
        end

        --'lower' sprite by increasing yOffset to -10
        if self.yOffset<-10 then 
            self.yOffset=self.yOffset+self.lowerRate*dt
        end

        self.xPos,self.yPos=self.collider:getPosition()
        self.timer=self.timer+dt

        --travel toward target
        self.angle=math.atan2((self.target.yPos-self.yPos),(self.target.xPos-self.xPos))
        self.collider:applyForce(
            math.cos(self.angle)*self.speed, math.sin(self.angle)*self.speed            
        )

        --every ~1/60s, emit particles
        if self.timer>=self.emissionRate then 
            self.timer=0
            --set particles to accelerate away from angle of travel
            self.particles:setLinearAcceleration(
                500*math.cos(self.angle+math.pi),500*math.sin(self.angle+math.pi),
                1000*math.cos(self.angle+math.pi),1000*math.sin(self.angle+math.pi)
            )
            self.particles:emit(40)
        end
        
        --when contacting target, damage and explode particles
        if self.collider:isTouching(self.target.collider:getBody()) then 
            self.target:takeDamage( --deal magical damage
                'projectile','magical',self.knockback,self.angle,self.damage
            )
            self.target:takeDamage( --deal reduced pure damage (with no knockback)
                'projectile','pure',0,self.angle,self.damage*0.25
            )
            self.particles:setLinearAcceleration(0,0)
            self.particles:setSpeed(20,80)
            self.particles:emit(200)
            if self.isDisabling and self.target.state.protectionActivated then 
                self.target.protectionMagics:deactivate() 
            end 
            self.willDie=true --fireball will die once particle system is empty
        end
    end

    function fireball:draw()
        if not self.willDie then self.shadow:draw(self.xPos,self.yPos) end
        love.graphics.draw(self.particles,self.xPos,self.yPos+self.yOffset)
    end

    fireball:load()
end

--spawns a pillar at a given set of coordinates and an initial travel angle
function SpecialAttacks:spawnFlamePillar(_xPos,_yPos,_angle)
    local pillar={}

    function pillar:load()
        self.particles=SpecialAttacks.particleSystems.flamePillar:clone()

        self.collider=world:newBSGRectangleCollider(_xPos,_yPos,12,5,3)
        self.collider:setFixedRotation(true)
        self.collider:setFriction(0)
        self.collider:setRestitution(0)
        self.collider:setLinearDamping(20)
        self.collider:setMass(0.1)
        self.collider:setSensor(true)
        self.collider:setObject(self)
        self.xPos,self.yPos=self.collider:getPosition()
        self.emissionRate=0.016 --emit particles every ~1/60s
        self.emissionTimer=0 --used to emit particles at the emission rate
        self.angle=_angle
        self.moveSpeed=200
        self.attackOnCooldown=false
        self.damage=20
        self.knockback=50
        self.willDie=false

        --set of verticies used to target a set of points in a star pattern
        --around the player. Start with a random vertex, then continually change
        --targetted vertex to be the vertex across the player.
        self.targetVerticies={ --these verticies form a star
            top='botRight',
            botRight='left',
            left='right',
            right='botLeft',
            botLeft='top'
        }
        self.targetVerticiesCoordinates={ --these coords will be added to Player's
            top={x=0,y=-20},
            botRight={x=20,y=20},
            left={x=-20,y=-5},
            right={x=20,y=-5},
            botLeft={x=-20,y=20}
        }
        local v={'top','botRight','left','right','botLeft'}
        self.currentVertex=v[love.math.random(#v)] --pick random starting vertex
        self.vertexChangeTimer=0
        self.vertexChangeRate=love.math.random()+0.5 --change vertex after 0.5-1.5 sec
        
        self.moveToPlayer=false --travel along initial angle, after 2s, move to player
        TimerState:after(1,function() self.moveToPlayer=true end)

        --after 10-15s from spawning, destroy pillar
        TimerState:after(love.math.random(10,15),function() self:die() end)

        self.shadow=Shadows:newShadow('tornado')

        self.sfx={
            flamePillar=Sounds.flame_pillar()
        }

        table.insert(Entities.entitiesTable,self)
    end

    function pillar:update()
        self.xPos,self.yPos=self.collider:getPosition()
        self.particles:update(dt)

        local pitch=love.math.random(8,12)*0.1
        self.sfx.flamePillar:play(pitch)

        --travel in the direction of angle
        self.collider:applyForce(
            math.cos(self.angle)*self.moveSpeed,
            math.sin(self.angle)*self.moveSpeed
        )

        --emit 10 particles ~60 times per second
        self.emissionTimer=self.emissionTimer+dt 
        if self.emissionTimer>=self.emissionRate then 
            self.emissionTimer=0 --reset timer
            self.particles:emit(10) --emit particles
        end

        --update angle to player after initial travel time
        if self.moveToPlayer then 
            local targetX=Player.xPos+self.targetVerticiesCoordinates[self.currentVertex].x
            local targetY=Player.yPos+self.targetVerticiesCoordinates[self.currentVertex].y
            local xDistance=targetX-self.xPos
            local yDistance=targetY-self.yPos
            self.angle=math.atan2(yDistance,xDistance)
        end

        --change targetted vertex to vertex across player
        self.vertexChangeTimer=self.vertexChangeTimer+dt 
        if self.vertexChangeTimer>=self.vertexChangeRate then 
            self.vertexChangeTimer=0
            self.currentVertex=self.targetVerticies[self.currentVertex]
        end

        --damage and knockback player
        if not self.attackOnCooldown 
        and self.collider:isTouching(Player.collider:getBody())
        then 
            local angleToPlayer=math.atan2(
                (Player.yPos-self.yPos),(Player.xPos-self.xPos)
            )
            self.attackOnCooldown=true 
            TimerState:after(0.5,function() self.attackOnCooldown=false end)
            Player:takeDamage('melee','pure',self.knockback,angleToPlayer,self.damage)
        end

        --if player or boss is dead, flame pillar dies
        if Player.health.current==0 or BossRoom.isBattleOver then self:die() end
    end

    function pillar:draw()
        self.shadow:draw(self.xPos,self.yPos)
        love.graphics.draw(self.particles,self.xPos,self.yPos)
    end

    function pillar:die() --change update to death update
        pillar.update=function()            
            self.xPos,self.yPos=self.collider:getPosition()
            self.particles:update(dt)

            --travel in the direction of angle
            self.collider:applyForce(
                math.cos(self.angle)*self.moveSpeed,
                math.sin(self.angle)*self.moveSpeed
            )

            --slow down speed over time
            self.moveSpeed=self.moveSpeed-45*dt

            --once all particles are destroyed, remove the pillar itself from game
            if self.particles:getCount()==0 then 
                self.collider:destroy()
                return false 
            end
        end
    end

    pillar:load()
end

