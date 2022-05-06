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

        fireInsignia=love.graphics.newImage('assets/specials/fire_insignia.png'),
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

        self.collider=world:newBSGRectangleCollider(_xPos,_yPos,12,5,3)
        self.collider:setFixedRotation(true)
        self.collider:setFriction(0)
        self.collider:setRestitution(0)
        self.collider:setLinearDamping(20)
        self.collider:setMass(0.1)
        self.collider:setCollisionClass('tornado')
        self.collider:setObject(self)
        self.xPos,self.yPos=self.collider:getPosition()
        self.moveSpeed=100
        self.angle=_angle
        self.attackOnCooldown=false
        self.willDie=false
        
        self.moveToPlayer=false --travel along initial angle, after 2s, move to player
        TimerState:after(2,function() self.moveToPlayer=true end)

        --after some time from spawning, destroy tornado
        TimerState:after(
            love.math.random(10,20), --lifespan is 10-20s
            function() self.willDie=true end
        )

        self.shadow=Shadows:newShadow('tornado')

        table.insert(Entities.entitiesTable,self)
    end

    function tornado:update()
        self.xPos,self.yPos=self.collider:getPosition()
        for i,anim in pairs(self.animations) do anim:update(dt) end
        for i,o in pairs(self.oscillations) do
            self.oscillations[i]=self.oscillations[i]+dt*8
        end

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

        if not self.willDie then 
            --update angle to player after initial travel time
            if self.moveToPlayer then 
                self.angle=math.atan2(
                    (Player.yPos-self.yPos),(Player.xPos-self.xPos)
                )
            end

            --damage and knockback player
            if not self.attackOnCooldown 
                --manually check for 'stay' collision, since collider:stay() doesn't work
                and self.collider:isTouching(Player.collider:getBody())
            then
                local angleToPlayer=math.atan2(
                    (Player.yPos-self.yPos),(Player.xPos-self.xPos)
                )
                self.attackOnCooldown=true 
                TimerState:after(0.5,function() self.attackOnCooldown=false end)
                Player:takeDamage('melee','pure',self.moveSpeed*0.5,angleToPlayer,20)
            end

            if Player.health.current==0 then self.willDie=true end
        end

        if self.willDie then 
            --use timers to remove each segment gradually from bottom to top
            for i=1,8 do 
                TimerState:after(i*0.2,function() self.animations['s'..i]=nil end)
            end
            --slow down speed over time
            self.moveSpeed=self.moveSpeed-45*dt

            --once all segments are removed, remove the tornado itself from game
            if self.animations.s8==nil then 
                self.collider:destroy()
                return false 
            end
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

        table.insert(Dungeon.floorObjects,self) --add to dungeon's floor effects
    end

    function insignia:update()
        --reveal by increasing alpha, capped at 0.7
        if self.alpha<0.7 then self.alpha=self.alpha+dt*0.5 end
    end

    function insignia:draw()
        love.graphics.setColor(1,1,1,self.alpha)
        love.graphics.draw(self.sprite,self.xPos-23.5,self.yPos-16)
        love.graphics.setColor(1,1,1,1)
    end

    insignia:load()

    -- local flames={}

    -- function flames:load()

    --     table.insert(Entities.entitiesTable,self)
    -- end

    -- function flames:update()

    -- end

    -- function flames:draw()

    -- end

    -- flames:load()
end