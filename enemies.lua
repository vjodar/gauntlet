Enemies={}

function Enemies:load()
    self.spriteSheets={} --stores spriteSheets of enemies
    self.spriteSheets.orcT1=love.graphics.newImage('assets/enemies/orc_t1.png')
    self.spriteSheets.demonT1=love.graphics.newImage('assets/enemies/demon_t1.png')
    self.spriteSheets.skeletonT1=love.graphics.newImage('assets/enemies/skeleton_t1.png')
    self.spriteSheets.orcT2=love.graphics.newImage('assets/enemies/orc_t2.png')
    self.spriteSheets.demonT2=love.graphics.newImage('assets/enemies/demon_t2.png')
    self.spriteSheets.mageT2=love.graphics.newImage('assets/enemies/mage_t2.png')
    self.spriteSheets.orcT3=love.graphics.newImage('assets/enemies/orc_t3.png')
    self.spriteSheets.demonT3=love.graphics.newImage('assets/enemies/demon_t3.png')
    self.spriteSheets.boss=love.graphics.newImage('assets/enemies/boss.png')

    self.healthbars={
        t1=love.graphics.newImage('assets/enemies/healthbar_t1.png'),
        t2=love.graphics.newImage('assets/enemies/healthbar_t2.png'),
        t3=love.graphics.newImage('assets/enemies/healthbar_t3.png'),
        t4=love.graphics.newImage('assets/enemies/healthbar_t4.png'),
    }

    self.healthRGB={red=218/255,green=78/255,blue=56/255} --for drawing remaining health of enemy

    self.sharedEnemyFunctions={} --common enemy functions

    self.sharedEnemyFunctions.updateHealthFunction=function(_enemy) --smoothly updates healthbar
        if _enemy.health.current<_enemy.health.currentShown then 
            _enemy.health.timer=_enemy.health.timer+dt 
            if _enemy.health.timer>_enemy.health.moveRate then 
                _enemy.health.currentShown=_enemy.health.currentShown-1
                _enemy.health.timer=0
            end
            --once healthbar is depleted visually, enemy will die
            if _enemy.health.currentShown==0 then _enemy.state.willDie=true end 
        end
    end

    --enemy takes some damage depending on the
    self.sharedEnemyFunctions.takeDamage=function(
        _enemy,_attackType,_damageType,_knockback,_angle,_val
    ) 
        local modifiedDamage=_val 
        --reduce damage by the enemy's damage resistance. Orcs resist physical
        --damage while demons resist magical damage (though not tier 1 enemies).
        if _damageType=='magical' then 
            if _enemy.name=='demon_t2' then 
                modifiedDamage=modifiedDamage-5
            elseif _enemy.name=='demon_t3' then 
                modifiedDamage=modifiedDamage-10
            end
        elseif _damageType=='physical' then 
            if _enemy.name=='orc_t2' then 
                modifiedDamage=modifiedDamage-5
            elseif _enemy.name=='orc_t3' then 
                modifiedDamage=modifiedDamage-10
            end
        end

        modifiedDamage=love.math.random( --roll between +/-10% of damage
            math.floor(modifiedDamage*0.9),math.ceil(modifiedDamage*1.1)
        )
        modifiedDamage=math.max(modifiedDamage,1) --can't hit lower than 1
        _enemy.dialog:damage(modifiedDamage,_damageType)

        _enemy.health.current=math.max(_enemy.health.current-modifiedDamage,0) --can't be lower than 0

        --apply knockback
        _enemy.collider:applyLinearImpulse(
            math.cos(_angle)*_knockback,math.sin(_angle)*_knockback
        )
    end

    self.sharedEnemyFunctions.die=function(_enemy)         
        _enemy:dropLoot() --drop loot

        --if player is still targeting enemy at this point, stop targeting it
        if Player.combatData.currentEnemy==_enemy then 
            Player.combatData.currentEnemy=nil 
        end 
        _enemy.collider:destroy() --destroy collider
        return false --return false to remove entity from game
    end

    self.sharedEnemyFunctions.dropLoot_t1=function(_enemy) 
        for i=love.math.random(3),3 do --drop up to 3 shards
            Items:spawn_item(_enemy.xPos,_enemy.yPos,'arcane_shards')
        end
        if love.math.random(3)==1 then --1/3 chance to spawn a broken bow or staff
            if Dungeon.nextBrokenItem==1 then 
                Items:spawn_item(_enemy.xPos,_enemy.yPos,'broken_bow') 
                Dungeon.nextBrokenItem=2
            elseif Dungeon.nextBrokenItem==2 then 
                Items:spawn_item(_enemy.xPos,_enemy.yPos,'broken_staff') 
                Dungeon.nextBrokenItem=1
            end
        end
        -- if love.math.random(3)==1 then --1/3 chance to spawn a fish or mushroom
        --     if love.math.random(2)==1 then 
        --         Items:spawn_item(_enemy.xPos,_enemy.yPos,'fish_raw')
        --     else
        --         Items:spawn_item(_enemy.xPos,_enemy.yPos,'fungi_mushroom')
        --     end
        -- end
    end

    self.sharedEnemyFunctions.dropLoot_t2=function(_enemy) 
        for i=love.math.random(5),10 do --drop 5 to 10 shards
            Items:spawn_item(_enemy.xPos,_enemy.yPos,'arcane_shards')
        end
        if love.math.random(2)==1 then --1/2 chance to spawn a broken bow or staff
            if Dungeon.nextBrokenItem==1 then 
                Items:spawn_item(_enemy.xPos,_enemy.yPos,'broken_bow') 
                Dungeon.nextBrokenItem=2
            elseif Dungeon.nextBrokenItem==2 then 
                Items:spawn_item(_enemy.xPos,_enemy.yPos,'broken_staff') 
                Dungeon.nextBrokenItem=1
            end
        end
        if love.math.random(3)==1 then --1/3 chance to spawn 2 fish or mushroom
            if love.math.random(2)==1 then 
                for i=1,2 do Items:spawn_item(_enemy.xPos,_enemy.yPos,'fish_raw') end
            else         
                for i=1,2 do Items:spawn_item(_enemy.xPos,_enemy.yPos,'fungi_mushroom') end  
            end      
        end
        --additional role for mages to compensate for being the only t2 enemy in the room
        if _enemy.name=='mage_t2' then
            if love.math.random(3)==1 then
                if love.math.random(2)==1 then 
                    for i=1,2 do Items:spawn_item(_enemy.xPos,_enemy.yPos,'fish_raw') end
                else         
                    for i=1,2 do Items:spawn_item(_enemy.xPos,_enemy.yPos,'fungi_mushroom') end
                end      
            end
        end
    end

    self.sharedEnemyFunctions.dropLoot_t3=function(_enemy) 
        for i=love.math.random(5),10 do --drop 5 to 10 shards
            Items:spawn_item(_enemy.xPos,_enemy.yPos,'arcane_shards')
        end        
        if Dungeon.nextBrokenItem==1 then --always spawn broken bow or staff
            Items:spawn_item(_enemy.xPos,_enemy.yPos,'broken_bow') 
            Dungeon.nextBrokenItem=2
        elseif Dungeon.nextBrokenItem==2 then 
            Items:spawn_item(_enemy.xPos,_enemy.yPos,'broken_staff') 
            Dungeon.nextBrokenItem=1
        end        
        if _enemy.name=='demon_t3' then --spawn appropriate t3 weapon component
            Items:spawn_item(_enemy.xPos,_enemy.yPos,'arcane_orb')
        elseif _enemy.name=='orc_t3' then 
            Items:spawn_item(_enemy.xPos,_enemy.yPos,'arcane_bowstring')
        end
        if love.math.random(2)==1 then --1/2 chance to spawn 3 fish or mushrooms
            if love.math.random(2)==1 then 
                for i=1,3 do Items:spawn_item(_enemy.xPos,_enemy.yPos,'fish_raw') end
            else
                for i=1,3 do Items:spawn_item(_enemy.xPos,_enemy.yPos,'fungi_mushroom') end
            end
        end
    end

    self.sharedEnemyFunctions.move=function(_enemy) --move enemy toward its target
        --set defalt state values
        _enemy.state.idle=true 
        _enemy.state.moving=false 

        if _enemy.state.moveTarget.x<_enemy.xPos-_enemy.halfWidth --target is to the left 
        or _enemy.state.moveTarget.x>_enemy.xPos+_enemy.halfWidth --target is to the right
        or _enemy.state.moveTarget.y<_enemy.yPos-_enemy.halfHeight --target is above
        or _enemy.state.moveTarget.y>_enemy.yPos+_enemy.halfHeight --target is below
        then 
            local angle=math.atan2( --calculate angle to target
                (_enemy.state.moveTarget.y-_enemy.yPos),
                (_enemy.state.moveTarget.x-_enemy.xPos)
            )

            --update where they're facing
            if _enemy.state.moveTarget.x>_enemy.xPos then _enemy.state.facing='right'                
            else _enemy.state.facing='left' end

            --calculate velocity components using angle (vectors are normalized)
            _enemy.xVel=math.cos(angle)*_enemy.state.moveSpeed
            _enemy.yVel=math.sin(angle)*_enemy.state.moveSpeed

            --update their state
            _enemy.state.idle=false 
            _enemy.state.moving=true
        end

        if _enemy.state.moving then 
            _enemy.currentAnim=_enemy.animations.moving
            _enemy.state.movingTimer=_enemy.state.movingTimer+dt 
        elseif _enemy.state.idle then 
            _enemy.currentAnim=_enemy.animations.idle
            _enemy.state.reachedMoveTarget=true
            _enemy.state.movingTimer=0 --reset movingTimer
        end 

        --if enemy takes over 5s to move to target, it's probably stuck; find new target
        if _enemy.state.movingTimer>5 then
            _enemy.state.reachedMoveTarget=true 
            _enemy.state.movingTimer=0
        end
    
        --apply movement forces to collider
        _enemy.collider:applyForce(_enemy.xVel,_enemy.yVel)
    end    

    self.sharedEnemyFunctions.approachTarget=function(_enemy)
        _enemy.state.moveTarget.x=Player.xPos 
        _enemy.state.moveTarget.y=Player.yPos
        _enemy:move()
    end

    self.sharedEnemyFunctions.setNewMoveTarget=function(_enemy) --sets a new moveTarget
        local xPos,yPos=_enemy.xPos,_enemy.yPos
        local w,h=_enemy.halfWidth,_enemy.halfHeight
        local possibleTargets={} --all 8 directions
        local validTargets={} --only possibleTargets with no obstructions
        local distance=20+love.math.random(100) --choose how far to move (20-100px)
        local distanceDiag=math.floor(distance*0.66)

        possibleTargets.above={
            center={x1=xPos,y1=yPos,x2=xPos,y2=yPos-distance},
            sideA={x1=xPos-w,y1=yPos,x2=xPos-w,y2=yPos-distance},
            sideB={x1=xPos+w,y1=yPos,x2=xPos+w,y2=yPos-distance},
        }        
        possibleTargets.below={
            center={x1=xPos,y1=yPos,x2=xPos,y2=yPos+distance},
            sideA={x1=xPos-w,y1=yPos,x2=xPos-w,y2=yPos+distance},
            sideB={x1=xPos+w,y1=yPos,x2=xPos+w,y2=yPos+distance},
        }        
        possibleTargets.left={
            center={x1=xPos,y1=yPos,x2=xPos-distance,y2=yPos},
            sideA={x1=xPos,y1=yPos-h,x2=xPos-distance,y2=yPos-h},
            sideB={x1=xPos,y1=yPos+h,x2=xPos-distance,y2=yPos+h},
        }
        possibleTargets.right={
            center={x1=xPos,y1=yPos,x2=xPos+distance,y2=yPos},
            sideA={x1=xPos,y1=yPos-h,x2=xPos+distance,y2=yPos-h},
            sideB={x1=xPos,y1=yPos+h,x2=xPos+distance,y2=yPos+h},
        }
        possibleTargets.upperLeft={
            center={x1=xPos,y1=yPos,x2=xPos-distanceDiag,y2=yPos-distanceDiag},
            sideA={x1=xPos+w,y1=yPos-h,x2=xPos+w-distanceDiag,y2=yPos-h-distanceDiag},
            sideB={x1=xPos-w,y1=yPos+h,x2=xPos-w-distanceDiag,y2=yPos+h-distanceDiag},
        }
        possibleTargets.upperRight={
            center={x1=xPos,y1=yPos,x2=xPos+distanceDiag,y2=yPos-distanceDiag},
            sideA={x1=xPos-w,y1=yPos-h,x2=xPos-w+distanceDiag,y2=yPos-h-distanceDiag},
            sideB={x1=xPos+w,y1=yPos+h,x2=xPos+w+distanceDiag,y2=yPos+h-distanceDiag},
        }
        possibleTargets.lowerLeft={
            center={x1=xPos,y1=yPos,x2=xPos-distanceDiag,y2=yPos+distanceDiag},
            sideA={x1=xPos-w,y1=yPos-h,x2=xPos-w-distanceDiag,y2=yPos-h+distanceDiag},
            sideB={x1=xPos+w,y1=yPos+h,x2=xPos+w-distanceDiag,y2=yPos+h+distanceDiag},
        }
        possibleTargets.lowerRight={
            center={x1=xPos,y1=yPos,x2=xPos+distanceDiag,y2=yPos+distanceDiag},
            sideA={x1=xPos+w,y1=yPos-h,x2=xPos+w+distanceDiag,y2=yPos-h+distanceDiag},
            sideB={x1=xPos-w,y1=yPos+h,x2=xPos-w+distanceDiag,y2=yPos+h+distanceDiag},
        }

        --for each possible target, query two lines between it and the player (two
        --lines on either side to compensate for the height and width of enemy). If
        --neither line intersects a solid collider, add target to validTargets table
        for i,target in pairs(possibleTargets) do 
            if #world:queryLine(
                target.sideA.x1,target.sideA.y1,target.sideA.x2,target.sideA.y2,
                {
                    'outerWall','innerWall','doorBarrier','craftingNode',
                    'resourceNode','depletedNode','doorButton','lava'
                }
            )==0 
            and #world:queryLine(
                target.sideB.x1,target.sideB.y1,target.sideB.x2,target.sideB.y2,
                {
                    'outerWall','innerWall','doorBarrier','craftingNode',
                    'resourceNode','depletedNode','doorButton','lava'
                }
            )==0 
            then --no obstructions, add target's center line to validTargets
                table.insert(validTargets,target.center)
            end
        end

        --randomly select a valid target 
        if #validTargets>0 then 
            local selectedTarget=validTargets[love.math.random(#validTargets)]
            _enemy.state.moveTarget.x=selectedTarget.x2
            _enemy.state.moveTarget.y=selectedTarget.y2
        else 
            --no valid targets, try again after another nextMoveTargetTimer cycle
            _enemy.state.moveTarget.x=_enemy.xPos
            _enemy.state.moveTarget.y=_enemy.yPos 
        end
    end

    self.sharedEnemyFunctions.wanderingAI=function(_enemy)
        --if enemy hasn't yet reached moveTarget
        if _enemy.state.reachedMoveTarget==false then 
            --move toward moveTarget, also updates state and animations
            _enemy:move()
        else 
            --if enemy reached move target already, countdown to next target
            _enemy.state.nextMoveTargetTimer=_enemy.state.nextMoveTargetTimer-dt 
        end

        --after appropriate amount of idle time, get a new wander target
        if _enemy.state.reachedMoveTarget and _enemy.state.nextMoveTargetTimer<0 then
            _enemy:setNewMoveTarget()
            _enemy.state.reachedMoveTarget=false 
            --reset timer until acquiring next target (1-3s)
            _enemy.state.nextMoveTargetTimer=1+love.math.random()*2
        end
    end

    --checks if player is within Line of Sight and in range of enemy,
    --update enemy states accordingly.
    self.sharedEnemyFunctions.checkTargetPosition=function(_enemy)              
        if #world:queryLine( --check if player is within LOS
            _enemy.xPos,_enemy.yPos,Player.xPos,Player.yPos,
            {'outerWall','innerWall','craftingNode'}
            )==0 
        then 
            if _enemy.state.inCombat==true 
                or (math.abs(_enemy.xPos-Player.xPos)<_enemy.state.attackRange.x 
                and math.abs(_enemy.yPos-Player.yPos)<_enemy.state.attackRange.y)
            then 
                --player is within attack range or enemy is currently attacking
                _enemy.state.inCombat=true --enter combat
                _enemy.state.approachingTarget=false 

            elseif _enemy.state.isTargetted
                or (math.abs(_enemy.xPos-Player.xPos)<_enemy.state.aggroRange.x 
                and math.abs(_enemy.yPos-Player.yPos)<_enemy.state.aggroRange.y)
            then
                --player is out of attack range, but within aggression range, 
                --or enemy is already being attacked by the player, approach
                _enemy.state.approachingTarget=true 
                _enemy:approachTarget()
            end

        else --player is out of LOS and isn't currently attacking, stop combat            
            if _enemy.state.inCombat==true then
            --if enemy was previously fighting the player and LOS was broken, 
            --set moveTarget to last known position of player to try and find them
                _enemy.state.inCombat=false 
                _enemy.state.moveTarget.x=Player.xPos
                _enemy.state.moveTarget.y=Player.yPos
            end
            if _enemy.state.approachingTarget==true then 
            --if enemy was previously approaching the player and LOS was broken, 
            --set moveTarget to last known position of player to try and find them 
                _enemy.state.approachingTarget=false
                _enemy.state.moveTarget.x=Player.xPos
                _enemy.state.moveTarget.y=Player.yPos
            end
            _enemy.currentAnim=_enemy.animations.idle
            _enemy.animations.combat:pauseAtStart()
        end
    end

    self.sharedEnemyFunctions.enterCombatRanged=function(_enemy) --combat for ranged enemies
        if _enemy.xPos<Player.xPos then _enemy.state.facing='right'
        else _enemy.state.facing='left' end 
        if not _enemy.state.attackOnCooldown then
            _enemy.currentAnim=_enemy.animations.combat 
            --put attack on cooldown for 1.35s
            _enemy.state.attackOnCooldown=true
            TimerState:after(1.35,function() 
                _enemy.state.attackOnCooldown=false
            end)
    
            _enemy.animations.combat:resume()
        end
    end

    self.sharedEnemyFunctions.enterCombatMelee=function(_enemy) --combat for melee enemies
        if _enemy.xPos<Player.xPos then _enemy.state.facing='right'
        else _enemy.state.facing='left' end 
        if not _enemy.state.attackOnCooldown then
            _enemy.currentAnim=_enemy.animations.combat 

            local angle=math.atan2( --calculate launch angle
                (Player.yPos-_enemy.yPos), --y distance component
                (Player.xPos-_enemy.xPos)  --x distance component
            )
            _enemy.collider:applyLinearImpulse( --lunge toward player
                math.cos(angle)*_enemy.state.moveSpeed,
                math.sin(angle)*_enemy.state.moveSpeed
            )

            --put attack on cooldown for 1.35s
            _enemy.state.attackOnCooldown=true
            TimerState:after(1.35,function() 
                _enemy.state.attackOnCooldown=false
                _enemy.state.dealtDamageThisAttack=false
            end)
    
            _enemy.animations.combat:resume()
        else 
            --if attack is still on cooldown, continue approaching target
            _enemy.state.inCombat=false 
            _enemy.state.approachingTarget=true
        end
        if _enemy.collider:isTouching(Player.collider:getBody()) then 
            --if player hasn't already been hit this attack cycle
            if _enemy.state.dealtDamageThisAttack==false then 
                _enemy.state.dealtDamageThisAttack=true
                --damage player
                Player:takeDamage(                    
                    'melee','physical',_enemy.state.knockback,
                    math.atan2((Player.yPos-_enemy.yPos),(Player.xPos-_enemy.xPos)),
                    _enemy.state.meleeDamage
                )
            end
        end
    end
end

--holds spawn functions for each tier of enemy
Enemies.enemySpawner={t1={}, t2={}, t3={}, t4={}}

Enemies.enemySpawner.t1[1]=function(_x,_y) --spawn orc_t1
    local enemy={} --create enemy instance
    function enemy:load() 
        --setup physics collider
        self.collider=world:newBSGRectangleCollider(_x,_y,9,5,3)
        self.xPos, self.yPos = _x, _y
        self.xVel, self.yVel = 0,0
        self.halfWidth,self.halfHeight=4.5,2.5
        self.name='orc_t1'
        self.collider:setLinearDamping(10)
        self.collider:setFixedRotation(true) --collider won't spin
        self.collider:setCollisionClass('enemy')
        self.collider:setBullet(true)
        self.collider:setRestitution(0.1)
        self.collider:setFriction(0)
        self.collider:setMass(0.06)
        self.collider:setObject(self) --attach collider to this object

        --sprites and animations
        self.spriteSheet=Enemies.spriteSheets.orcT1
        self.grid=anim8.newGrid(16,16,self.spriteSheet:getWidth(),self.spriteSheet:getHeight())
        self.animations={} --animations table
        self.animations.idle=anim8.newAnimation(self.grid('1-4',1), 0.1)
        self.animations.moving=anim8.newAnimation(self.grid('5-8',1), 0.1)
        self.animations.combat=anim8.newAnimation(
            self.grid(6,1), 0.675,
            function() --onLoop
                self.animations.combat:pauseAtStart()
                self.currentAnim=self.animations.idle
                self.state.inCombat=false 
            end
        )
        self.currentAnim=self.animations.idle 
        self.currentAnim:gotoFrame(love.math.random(1,4)) --start at random frame
        self.shadow=Shadows:newShadow('tiny') --shadow
        self.dialog=Dialog:newDialogSystem() --dialog system

        --enemy's current state metatable
        self.state={}
        self.state.facing='right'
        self.state.scaleX=1 --used to flip horizontally
        self.state.moving=false
        self.state.idle=true 
        self.state.inCombat=false 
        self.state.isTargetted=false --true when player is targeting this enemy
        self.state.willDie=false --true when enemy should die
        self.state.moveSpeed=30
        self.state.moveTarget={x=self.xPos,y=self.yPos} --where to move to
        self.state.nextMoveTargetTimer=1+love.math.random()*2 --sec until new target
        self.state.reachedMoveTarget=false --true as soon as enemy reaches target
        self.state.movingTimer=0 --tracks how long enemy has been moving toward target
        self.state.attackRange={x=30,y=22.5}
        self.state.aggroRange={x=150,y=112}
        --true when enemy has damaged player. This is to prevent the player colliding
        --again after already being hit by the enemy's attack
        self.state.dealtDamageThisAttack=false 
        self.state.meleeDamage=5
        self.state.knockback=30

        --wait 1s before setting a moveTarget to allow enemy to be pushed out of other
        --colliders it may have spawned in
        TimerState:after(1,function() self.state.moveTarget={x=self.xPos,y=self.yPos} end)

        self.health={
            sprite=Enemies.healthbars.t1,
            max=20,
            current=20, --actual current health
            RGB=Enemies.healthRGB,
            currentShown=20, --what will actually be drawn
            timer=0, --used to smoothly tween shown health
            moveRate=0.005, --increase/decrease every 0.02s
        }

        --insert enemy into entitiesTable
        table.insert(Entities.entitiesTable,self) 
    end

    function enemy:update() 
        self.dialog:update() --update dialog

        --update vectors
        self.xPos, self.yPos=self.collider:getPosition()
        self.xVel, self.yVel=self.collider:getLinearVelocity()

        --update animation
        self.currentAnim:update(dt)

        if self.state.facing=='right' then 
            self.state.scaleX=1 else self.state.scaleX=-1
        end

        self:updateHealth() --update healthbar

        if self.state.willDie then return self:die() end

        if Player.health.current==0 then self:wanderingAI() return end

        --check if player is in range and LOS of enemy, update state accordingly
        self:checkTargetPosition() 

        if self.state.inCombat then 
            self:enterCombatMelee()            
        elseif self.state.approachingTarget then 
            self:approachTarget()
        else 
            self:wanderingAI()
        end
    end

    function enemy:draw()
        self.shadow:draw(self.xPos,self.yPos) --draw shadow
        self.currentAnim:draw(
            self.spriteSheet,self.xPos,self.yPos,nil,self.state.scaleX,1,8,14)

    end

    function enemy:drawUIelements() --called by UI
        if self.state.isTargetted then --draw health when targetted
            love.graphics.draw(self.health.sprite,self.xPos-6,self.yPos-16)
            --draw remaining health
            love.graphics.setColor(self.health.RGB.red,self.health.RGB.green,self.health.RGB.blue)
            love.graphics.rectangle(
                'fill',self.xPos-5,self.yPos-15,
                self.health.currentShown*0.5,2)
            love.graphics.setColor(1,1,1)
        end
        self.dialog:draw(self.xPos-4,self.yPos-8)
    end

    enemy.updateHealth=Enemies.sharedEnemyFunctions.updateHealthFunction
    enemy.takeDamage=Enemies.sharedEnemyFunctions.takeDamage
    enemy.dropLoot=Enemies.sharedEnemyFunctions.dropLoot_t1
    enemy.die=Enemies.sharedEnemyFunctions.die
    enemy.move=Enemies.sharedEnemyFunctions.move 
    enemy.setNewMoveTarget=Enemies.sharedEnemyFunctions.setNewMoveTarget 
    enemy.wanderingAI=Enemies.sharedEnemyFunctions.wanderingAI 
    enemy.enterCombatMelee=Enemies.sharedEnemyFunctions.enterCombatMelee
    enemy.approachTarget=Enemies.sharedEnemyFunctions.approachTarget
    enemy.checkTargetPosition=Enemies.sharedEnemyFunctions.checkTargetPosition

    enemy:load() --initialize enemy
end

Enemies.enemySpawner.t1[2]=function(_x,_y) --spawn demon_t1
    local enemy={} --create enemy instance
    function enemy:load() 
        --setup physics collider
        self.collider=world:newBSGRectangleCollider(_x,_y,9,5,3)
        self.xPos, self.yPos = _x, _y
        self.xVel, self.yVel = 0,0
        self.halfWidth,self.halfHeight=4.5,2.5
        self.name='demon_t1'
        self.collider:setLinearDamping(10)
        self.collider:setFixedRotation(true) --collider won't spin
        self.collider:setCollisionClass('enemy')
        self.collider:setBullet(true) --won't phase through player
        self.collider:setRestitution(0.1)
        self.collider:setFriction(0)
        self.collider:setMass(0.06)
        self.collider:setObject(self) --attach collider to this object

        --sprites and animations
        self.spriteSheet=Enemies.spriteSheets.demonT1
        self.grid=anim8.newGrid(16,16,self.spriteSheet:getWidth(),self.spriteSheet:getHeight())
        self.animations={} --animations table
        self.animations.idle=anim8.newAnimation(self.grid('1-4',1), 0.1)
        self.animations.moving=anim8.newAnimation(self.grid('5-8',1), 0.1)
        self.animations.combat=anim8.newAnimation(
            self.grid(6,1), 0.675,
            function() --onLoop
                self.animations.combat:pauseAtStart()
                self.currentAnim=self.animations.idle
                self.state.inCombat=false 
            end
        )
        self.currentAnim=self.animations.idle 
        self.currentAnim:gotoFrame(love.math.random(1,4)) --start at random frame
        self.shadow=Shadows:newShadow('tiny') --shadow
        self.dialog=Dialog:newDialogSystem() --dialog system

        --enemy's current state metatable
        self.state={}
        self.state.facing='right'
        self.state.scaleX=1 --used to flip horizontally
        self.state.moving=false
        self.state.idle=true 
        self.state.inCombat=false 
        self.state.isTargetted=false --true when player is targeting this enemy
        self.state.willDie=false --true when enemy should die
        self.state.moveSpeed=30
        self.state.moveTarget={x=self.xPos,y=self.yPos} --where to move to
        self.state.nextMoveTargetTimer=1+love.math.random()*2 --sec until new target
        self.state.reachedMoveTarget=false --true as soon as enemy reaches target
        self.state.movingTimer=0 --tracks how long enemy has been moving toward target
        self.state.attackRange={x=30,y=22.5}
        self.state.aggroRange={x=150,y=112}
        --true when enemy has damaged player. This is to prevent the player colliding
        --again after already being hit by the enemy's attack
        self.state.dealtDamageThisAttack=false 
        self.state.meleeDamage=5
        self.state.knockback=30

        --wait 1s before setting a moveTarget to allow enemy to be pushed out of other
        --colliders it may have spawned in
        TimerState:after(1,function() self.state.moveTarget={x=self.xPos,y=self.yPos} end)
        self.health={
            sprite=Enemies.healthbars.t1,
            max=20,
            current=20, --actual current health
            RGB=Enemies.healthRGB,
            currentShown=20, --what will actually be drawn
            timer=0, --used to smoothly tween shown health
            moveRate=0.005, --increase/decrease every 0.02s
        }

        --insert enemy into entitiesTable
        table.insert(Entities.entitiesTable,self) 
    end

    function enemy:update() 
        self.dialog:update() --update dialog

        --update vectors
        self.xPos, self.yPos=self.collider:getPosition()
        self.xVel, self.yVel=self.collider:getLinearVelocity()

        --update animation
        self.currentAnim:update(dt)

        if self.state.facing=='right' then 
            self.state.scaleX=1 else self.state.scaleX=-1
        end

        self:updateHealth() --update healthbar

        if self.state.willDie then return self:die() end

        if Player.health.current==0 then self:wanderingAI() return end

        --check if player is in range and LOS of enemy, update state accordingly
        self:checkTargetPosition() 

        if self.state.inCombat then 
            self:enterCombatMelee()            
        elseif self.state.approachingTarget then 
            self:approachTarget()
        else 
            self:wanderingAI()
        end
    end

    function enemy:draw()
        self.shadow:draw(self.xPos,self.yPos) --draw shadow
        self.currentAnim:draw(
            self.spriteSheet,self.xPos,self.yPos,nil,self.state.scaleX,1,8,14
        )
    end

    function enemy:drawUIelements() --called by UI
        if self.state.isTargetted then --draw health when targetted
            love.graphics.draw(self.health.sprite,self.xPos-6,self.yPos-16)
            --draw remaining health
            love.graphics.setColor(self.health.RGB.red,self.health.RGB.green,self.health.RGB.blue)
            love.graphics.rectangle(
                'fill',self.xPos-5,self.yPos-15,
                self.health.currentShown*0.5,2)
            love.graphics.setColor(1,1,1)
        end
        self.dialog:draw(self.xPos-4,self.yPos-8)
    end

    enemy.updateHealth=Enemies.sharedEnemyFunctions.updateHealthFunction
    enemy.takeDamage=Enemies.sharedEnemyFunctions.takeDamage
    enemy.dropLoot=Enemies.sharedEnemyFunctions.dropLoot_t1
    enemy.die=Enemies.sharedEnemyFunctions.die 
    enemy.move=Enemies.sharedEnemyFunctions.move 
    enemy.setNewMoveTarget=Enemies.sharedEnemyFunctions.setNewMoveTarget 
    enemy.wanderingAI=Enemies.sharedEnemyFunctions.wanderingAI 
    enemy.enterCombatMelee=Enemies.sharedEnemyFunctions.enterCombatMelee
    enemy.approachTarget=Enemies.sharedEnemyFunctions.approachTarget
    enemy.checkTargetPosition=Enemies.sharedEnemyFunctions.checkTargetPosition

    enemy:load() --initialize enemy
end

Enemies.enemySpawner.t1[3]=function(_x,_y) --spawn skeleton_t1
    local enemy={} --create enemy instance
    function enemy:load() 
        --setup physics collider
        self.collider=world:newBSGRectangleCollider(_x,_y,9,5,3)
        self.xPos, self.yPos = _x, _y
        self.xVel, self.yVel = 0,0
        self.halfWidth,self.halfHeight=4.5,2.5
        self.name='skeleton_t1'
        self.collider:setLinearDamping(10)
        self.collider:setFixedRotation(true) --collider won't spin
        self.collider:setCollisionClass('enemy')
        self.collider:setBullet(true) --wont phase through player
        self.collider:setRestitution(0.1)
        self.collider:setFriction(0)
        self.collider:setMass(0.06)
        self.collider:setObject(self) --attach collider to this object

        --sprites and animations
        self.spriteSheet=Enemies.spriteSheets.skeletonT1
        self.grid=anim8.newGrid(16,16,self.spriteSheet:getWidth(),self.spriteSheet:getHeight())
        self.animations={} --animations table
        self.animations.idle=anim8.newAnimation(self.grid('1-4',1), 0.1)
        self.animations.moving=anim8.newAnimation(self.grid('5-8',1), 0.1)
        self.animations.combat=anim8.newAnimation(
            self.grid(5,1), 0.675,
            function() --onLoop
                self.animations.combat:pauseAtStart()
                self.currentAnim=self.animations.idle
                self.state.inCombat=false 
            end
        )
        self.currentAnim=self.animations.idle 
        self.currentAnim:gotoFrame(love.math.random(1,4)) --start at random frame
        self.shadow=Shadows:newShadow('small') --shadow
        self.dialog=Dialog:newDialogSystem() --dialog system

        --enemy's current state metatable
        self.state={}
        self.state.facing='right'
        self.state.scaleX=1 --used to flip horizontally
        self.state.moving=false
        self.state.idle=true 
        self.state.inCombat=false 
        self.state.isTargetted=false --true when player is targeting this enemy
        self.state.willDie=false --true when enemy should die
        self.state.moveSpeed=30
        self.state.moveTarget={x=self.xPos,y=self.yPos} --where to move to
        self.state.nextMoveTargetTimer=1+love.math.random()*2 --sec until new target
        self.state.reachedMoveTarget=false --true as soon as enemy reaches target
        self.state.movingTimer=0 --tracks how long enemy has been moving toward target
        self.state.attackRange={x=30,y=22.5}
        self.state.aggroRange={x=150,y=112}
        --true when enemy has damaged player. This is to prevent the player colliding
        --again after already being hit by the enemy's attack
        self.state.dealtDamageThisAttack=false 
        self.state.meleeDamage=5
        self.state.knockback=30

        --wait 1s before setting a moveTarget to allow enemy to be pushed out of other
        --colliders it may have spawned in
        TimerState:after(1,function() self.state.moveTarget={x=self.xPos,y=self.yPos} end)

        self.health={
            sprite=Enemies.healthbars.t1,
            max=20,
            current=20, --actual current health
            RGB=Enemies.healthRGB,
            currentShown=20, --what will actually be drawn
            timer=0, --used to smoothly tween shown health
            moveRate=0.005, --increase/decrease every 0.02s
        }

        --insert enemy into entitiesTable
        table.insert(Entities.entitiesTable,self) 
    end

    function enemy:update() 
        self.dialog:update() --update dialog

        --update vectors
        self.xPos, self.yPos=self.collider:getPosition()
        self.xVel, self.yVel=self.collider:getLinearVelocity()

        --update animation
        self.currentAnim:update(dt)

        if self.state.facing=='right' then 
            self.state.scaleX=1 else self.state.scaleX=-1
        end

        self:updateHealth() --update healthbar

        if self.state.willDie then return self:die() end

        if Player.health.current==0 then self:wanderingAI() return end

        --check if player is in range and LOS of enemy, update state accordingly
        self:checkTargetPosition() 

        if self.state.inCombat then 
            self:enterCombatMelee()            
        elseif self.state.approachingTarget then 
            self:approachTarget()
        else 
            self:wanderingAI()
        end
    end

    function enemy:draw()
        self.shadow:draw(self.xPos,self.yPos) --draw shadow
        self.currentAnim:draw(
            self.spriteSheet,self.xPos,self.yPos,nil,self.state.scaleX,1,8,14
        )
    end

    function enemy:drawUIelements() --called by UI
        if self.state.isTargetted then --draw health when targetted
            love.graphics.draw(self.health.sprite,self.xPos-6.5,self.yPos-22)
            --draw remaining health
            love.graphics.setColor(self.health.RGB.red,self.health.RGB.green,self.health.RGB.blue)
            love.graphics.rectangle(
                'fill',self.xPos-5.5,self.yPos-21,
                self.health.currentShown*0.5,2)
            love.graphics.setColor(1,1,1)
        end
        self.dialog:draw(self.xPos-4,self.yPos-8)
    end

    enemy.updateHealth=Enemies.sharedEnemyFunctions.updateHealthFunction
    enemy.takeDamage=Enemies.sharedEnemyFunctions.takeDamage
    enemy.dropLoot=Enemies.sharedEnemyFunctions.dropLoot_t1
    enemy.die=Enemies.sharedEnemyFunctions.die 
    enemy.move=Enemies.sharedEnemyFunctions.move 
    enemy.setNewMoveTarget=Enemies.sharedEnemyFunctions.setNewMoveTarget 
    enemy.wanderingAI=Enemies.sharedEnemyFunctions.wanderingAI 
    enemy.enterCombatMelee=Enemies.sharedEnemyFunctions.enterCombatMelee
    enemy.approachTarget=Enemies.sharedEnemyFunctions.approachTarget
    enemy.checkTargetPosition=Enemies.sharedEnemyFunctions.checkTargetPosition

    enemy:load() --initialize enemy
end

Enemies.enemySpawner.t2[1]=function(_x,_y) --spawn orc_t2
    local enemy={} --create enemy instance
    function enemy:load() 
        --setup physics collider
        self.collider=world:newBSGRectangleCollider(_x,_y,10,6,3)
        self.xPos, self.yPos = _x, _y
        self.xVel, self.yVel = 0,0
        self.halfWidth,self.halfHeight=5,3
        self.name='orc_t2'
        self.collider:setLinearDamping(20)
        self.collider:setFriction(0)
        self.collider:setFixedRotation(true) --collider won't spin
        self.collider:setCollisionClass('enemy')
        self.collider:setObject(self) --attach collider to this object

        --sprites and animations
        self.spriteSheet=Enemies.spriteSheets.orcT2
        self.grid=anim8.newGrid(27,17,self.spriteSheet:getWidth(),self.spriteSheet:getHeight())
        self.animations={} --animations table
        self.animations.idle=anim8.newAnimation(self.grid('1-4',1), 0.1)
        self.animations.moving=anim8.newAnimation(self.grid('5-8',1), 0.1)
        self.animations.combat=anim8.newAnimation(
            self.grid('9-17',1), 0.075,
            function() --onLoop
                Projectiles:launch(
                    self.xPos+1*self.state.scaleX,self.yPos,self.name,Player
                )
                self.animations.combat:pauseAtStart()
                self.currentAnim=self.animations.idle
                self.state.inCombat=false 
            end
        )
        self.currentAnim=self.animations.idle 
        self.currentAnim:gotoFrame(love.math.random(1,4)) --start at random frame
        self.shadow=Shadows:newShadow('small') --shadow
        self.dialog=Dialog:newDialogSystem() --dialog system

        --enemy's current state metatable
        self.state={}
        self.state.facing='right'
        self.state.scaleX=1 --used to flip horizontally
        self.state.moving=false
        self.state.idle=true 
        self.state.inCombat=false 
        self.state.approachingTarget=false 
        self.state.isTargetted=false --true when player is targeting this enemy
        self.state.willDie=false --true when enemy should die
        self.state.moveSpeed=60
        self.state.moveTarget={x=self.xPos,y=self.yPos} --where to move to
        self.state.nextMoveTargetTimer=1+love.math.random()*2 --sec until new target
        self.state.reachedMoveTarget=false --true as soon as enemy reaches target
        self.state.movingTimer=0 --tracks how long enemy has been moving toward target
        self.state.attackOnCooldown=false
        self.state.attackRange={x=75,y=55} --range enemy can attack from
        self.state.aggroRange={x=150,y=112} --range enemy will become aggressive

        --wait 1s before setting a moveTarget to allow enemy to be pushed out of other
        --colliders it may have spawned in
        TimerState:after(1,function() self.state.moveTarget={x=self.xPos,y=self.yPos} end)

        self.health={
            sprite=Enemies.healthbars.t2,
            max=50,
            current=50, --actual current health
            RGB=Enemies.healthRGB,
            currentShown=50, --what will actually be drawn
            timer=0, --used to smoothly tween shown health
            moveRate=0.005, --increase/decrease every 0.02s
        }

        --insert enemy into entitiesTable
        table.insert(Entities.entitiesTable,self) 
    end

    function enemy:update() 
        self.dialog:update() --update dialog

        --update vectors
        self.xPos, self.yPos=self.collider:getPosition()
        self.xVel, self.yVel=self.collider:getLinearVelocity()

        --update animation
        self.currentAnim:update(dt)

        if self.state.facing=='right' then 
            self.state.scaleX=1 else self.state.scaleX=-1
        end

        self:updateHealth() --update healthbar

        if self.state.willDie then return self:die() end

        if Player.health.current==0 then self:wanderingAI() return end

        --check if player is in range and LOS of enemy, update state accordingly
        self:checkTargetPosition() 

        if self.state.inCombat then 
            self:enterCombatRanged()
        elseif self.state.approachingTarget then 
            self:approachTarget()
        else 
            self:wanderingAI()
        end
    end

    function enemy:draw()
        self.shadow:draw(self.xPos,self.yPos) --draw shadow
        self.currentAnim:draw(
            self.spriteSheet,self.xPos,self.yPos,nil,self.state.scaleX,1,14.5,15
        )
    end

    function enemy:drawUIelements() --called by UI
        if self.state.isTargetted then --draw health when targetted
            love.graphics.draw(self.health.sprite,self.xPos-13,self.yPos-20)
            --draw remaining health
            love.graphics.setColor(self.health.RGB.red,self.health.RGB.green,self.health.RGB.blue)
            love.graphics.rectangle(
                'fill',self.xPos-12,self.yPos-19,
                self.health.currentShown*0.5,2)
            love.graphics.setColor(1,1,1)
        end
        self.dialog:draw(self.xPos-4,self.yPos-8)
    end

    enemy.updateHealth=Enemies.sharedEnemyFunctions.updateHealthFunction
    enemy.takeDamage=Enemies.sharedEnemyFunctions.takeDamage
    enemy.dropLoot=Enemies.sharedEnemyFunctions.dropLoot_t2
    enemy.die=Enemies.sharedEnemyFunctions.die 
    enemy.move=Enemies.sharedEnemyFunctions.move 
    enemy.setNewMoveTarget=Enemies.sharedEnemyFunctions.setNewMoveTarget 
    enemy.wanderingAI=Enemies.sharedEnemyFunctions.wanderingAI 
    enemy.enterCombatRanged=Enemies.sharedEnemyFunctions.enterCombatRanged
    enemy.approachTarget=Enemies.sharedEnemyFunctions.approachTarget
    enemy.checkTargetPosition=Enemies.sharedEnemyFunctions.checkTargetPosition

    enemy:load() --initialize enemy
end

Enemies.enemySpawner.t2[2]=function(_x,_y) --spawn demon_t2
    local enemy={} --create enemy instance
    function enemy:load() 
        --setup physics collider
        self.collider=world:newBSGRectangleCollider(_x,_y,11,6,3)
        self.xPos, self.yPos = _x, _y
        self.xVel, self.yVel = 0,0
        self.halfWidth,self.halfHeight=5.5,3
        self.name='demon_t2'
        self.collider:setLinearDamping(10)
        self.collider:setFriction(0)
        self.collider:setFixedRotation(true) --collider won't spin
        self.collider:setCollisionClass('enemy')
        self.collider:setBullet(true) --won't phase through player
        self.collider:setRestitution(0.1) 
        self.collider:setMass(0.06)
        self.collider:setObject(self) --attach collider to this object

        --sprites and animations
        self.spriteSheet=Enemies.spriteSheets.demonT2
        self.grid=anim8.newGrid(16,23,self.spriteSheet:getWidth(),self.spriteSheet:getHeight())
        self.animations={} --animations table
        self.animations.idle=anim8.newAnimation(self.grid('1-4',1), 0.1)
        self.animations.moving=anim8.newAnimation(self.grid('5-8',1), 0.1)
        self.animations.combat=anim8.newAnimation(
            self.grid('9-17',1), 0.075,
            function() --onLoop
                self.animations.combat:pauseAtStart()
                self.currentAnim=self.animations.idle
                self.state.inCombat=false 
            end
        )
        self.currentAnim=self.animations.idle 
        self.currentAnim:gotoFrame(love.math.random(1,4)) --start at random frame
        self.shadow=Shadows:newShadow('small') --shadow
        self.dialog=Dialog:newDialogSystem() --dialog system

        --enemy's current state metatable
        self.state={}
        self.state.facing='right'
        self.state.scaleX=1 --used to flip horizontally
        self.state.moving=false
        self.state.idle=true 
        self.state.inCombat=false 
        self.state.approachingTarget=false 
        self.state.isTargetted=false --true when player is targeting this enemy
        self.state.willDie=false --true when enemy should die
        self.state.moveSpeed=35
        self.state.moveTarget={x=self.xPos,y=self.yPos} --where to move to
        self.state.nextMoveTargetTimer=1+love.math.random()*2 --sec until new target
        self.state.reachedMoveTarget=false --true as soon as enemy reaches target
        self.state.movingTimer=0 --tracks how long enemy has been moving toward target
        self.state.attackRange={x=40,y=30}
        self.state.aggroRange={x=150,y=112}
        --true when enemy has damaged player. This is to prevent the player colliding
        --again after already being hit by the enemy's attack
        self.state.dealtDamageThisAttack=false 
        self.state.meleeDamage=15
        self.state.knockback=45

        --wait 1s before setting a moveTarget to allow enemy to be pushed out of other
        --colliders it may have spawned in
        TimerState:after(1,function() self.state.moveTarget={x=self.xPos,y=self.yPos} end)

        self.health={
            sprite=Enemies.healthbars.t2,
            max=50,
            current=50, --actual current health
            RGB=Enemies.healthRGB,
            currentShown=50, --what will actually be drawn
            timer=0, --used to smoothly tween shown health
            moveRate=0.005, --increase/decrease every 0.02s
        }

        --insert enemy into entitiesTable
        table.insert(Entities.entitiesTable,self) 
    end

    function enemy:update() 
        self.dialog:update() --update dialog

        --update vectors
        self.xPos, self.yPos=self.collider:getPosition()
        self.xVel, self.yVel=self.collider:getLinearVelocity()

        --update animation
        self.currentAnim:update(dt)

        if self.state.facing=='right' then 
            self.state.scaleX=1 else self.state.scaleX=-1
        end

        self:updateHealth() --update healthbar

        if self.state.willDie then return self:die() end

        if Player.health.current==0 then self:wanderingAI() return end

        --check if player is in range and LOS of enemy, update state accordingly
        self:checkTargetPosition() 

        if self.state.inCombat then 
            self:enterCombatMelee()            
        elseif self.state.approachingTarget then 
            self:approachTarget()
        else 
            self:wanderingAI()
        end
    end

    function enemy:draw()
        self.shadow:draw(self.xPos,self.yPos) --draw shadow
        self.currentAnim:draw(
            self.spriteSheet,self.xPos,self.yPos,nil,self.state.scaleX,1,8,21
        )
    end

    function enemy:drawUIelements() --called by UI
        if self.state.isTargetted then --draw health when targetted
            love.graphics.draw(self.health.sprite,self.xPos-13,self.yPos-25)
            --draw remaining health
            love.graphics.setColor(self.health.RGB.red,self.health.RGB.green,self.health.RGB.blue)
            love.graphics.rectangle(
                'fill',self.xPos-12,self.yPos-24,
                self.health.currentShown*0.5,2)
            love.graphics.setColor(1,1,1)
        end
        self.dialog:draw(self.xPos-4,self.yPos-12)
    end

    enemy.updateHealth=Enemies.sharedEnemyFunctions.updateHealthFunction
    enemy.takeDamage=Enemies.sharedEnemyFunctions.takeDamage
    enemy.dropLoot=Enemies.sharedEnemyFunctions.dropLoot_t2
    enemy.die=Enemies.sharedEnemyFunctions.die 
    enemy.move=Enemies.sharedEnemyFunctions.move 
    enemy.setNewMoveTarget=Enemies.sharedEnemyFunctions.setNewMoveTarget 
    enemy.wanderingAI=Enemies.sharedEnemyFunctions.wanderingAI 
    enemy.enterCombatMelee=Enemies.sharedEnemyFunctions.enterCombatMelee
    enemy.approachTarget=Enemies.sharedEnemyFunctions.approachTarget
    enemy.checkTargetPosition=Enemies.sharedEnemyFunctions.checkTargetPosition

    enemy:load() --initialize enemy
end

Enemies.enemySpawner.t2[3]=function(_x,_y) --spawn mage_t2
    local enemy={} --create enemy instance
    function enemy:load() 
        --setup physics collider
        self.collider=world:newBSGRectangleCollider(_x,_y,12,6,3)
        self.xPos, self.yPos = _x, _y
        self.xVel, self.yVel = 0,0
        self.halfWidth,self.halfHeight=6,3
        self.name='mage_t2'
        self.collider:setLinearDamping(20)
        self.collider:setFriction(0)
        self.collider:setFixedRotation(true) --collider won't spin
        self.collider:setCollisionClass('enemy')
        self.collider:setObject(self) --attach collider to this object

        --sprites and animations
        --Mage idle/moving animations are the same
        self.spriteSheet=Enemies.spriteSheets.mageT2
        self.grid=anim8.newGrid(16,24,self.spriteSheet:getWidth(),self.spriteSheet:getHeight())
        self.animations={} --animations table
        self.animations.moving=anim8.newAnimation(self.grid('1-4',1), 0.1)
        self.animations.idle=anim8.newAnimation(self.grid('1-4',1), 0.1)
        self.animations.combat=anim8.newAnimation(
            self.grid('5-13',1), 0.075,
            function() --onLoop
                Projectiles:launch(
                    self.xPos+1*self.state.scaleX,self.yPos,self.name,Player
                )
                self.animations.combat:pauseAtStart()
                self.currentAnim=self.animations.idle --return to idle between attacks
                self.state.inCombat=false 
            end
        )
        self.currentAnim=self.animations.idle 
        self.currentAnim:gotoFrame(love.math.random(1,4)) --start at random frame
        self.shadow=Shadows:newShadow('medium') --shadow
        self.dialog=Dialog:newDialogSystem() --dialog system

        --enemy's current state metatable
        self.state={}
        self.state.facing='right'
        self.state.scaleX=1 --used to flip horizontally
        self.state.moving=false
        self.state.idle=true 
        self.state.inCombat=false 
        self.state.approachingTarget=false 
        self.state.isTargetted=false --true when player is targeting this enemy
        self.state.willDie=false --true when enemy should die
        self.state.moveSpeed=50
        self.state.moveTarget={x=self.xPos,y=self.yPos} --where to move to
        self.state.nextMoveTargetTimer=1+love.math.random()*2 --sec until new target
        self.state.reachedMoveTarget=false --true as soon as enemy reaches target
        self.state.movingTimer=0 --tracks how long enemy has been moving toward target
        self.state.attackOnCooldown=false 
        self.state.attackRange={x=150,y=112}
        self.state.aggroRange={x=200,y=150}

        --wait 1s before setting a moveTarget to allow enemy to be pushed out of other
        --colliders it may have spawned in
        TimerState:after(1,function() self.state.moveTarget={x=self.xPos,y=self.yPos} end)

        self.health={
            sprite=Enemies.healthbars.t2,
            max=50,
            current=50, --actual current health
            RGB=Enemies.healthRGB,
            currentShown=50, --what will actually be drawn
            timer=0, --used to smoothly tween shown health
            moveRate=0.005, --increase/decrease every 0.02s
        }

        --insert enemy into entitiesTable
        table.insert(Entities.entitiesTable,self) 
    end

    function enemy:update() 
        self.dialog:update() --update dialog

        --update vectors
        self.xPos, self.yPos=self.collider:getPosition()
        self.xVel, self.yVel=self.collider:getLinearVelocity()

        --update animation
        self.currentAnim:update(dt)

        if self.state.facing=='right' then 
            self.state.scaleX=1 else self.state.scaleX=-1
        end

        self:updateHealth() --update healthbar

        if self.state.willDie then return self:die() end

        if Player.health.current==0 then self:wanderingAI() return end

        --check if player is in range and LOS of enemy, update state accordingly
        self:checkTargetPosition() 

        if self.state.inCombat then 
            self:enterCombatRanged()
        elseif self.state.approachingTarget then 
            self:approachTarget()
        else 
            self:wanderingAI()
        end
    end

    function enemy:draw()
        self.shadow:draw(self.xPos,self.yPos) --draw shadow
        self.currentAnim:draw(
            self.spriteSheet,self.xPos,self.yPos,nil,self.state.scaleX,1,7,22
        )
    end

    function enemy:drawUIelements() --called by UI
        if self.state.isTargetted then --draw health when targetted
            love.graphics.draw(self.health.sprite,self.xPos-13,self.yPos-26)
            --draw remaining health
            love.graphics.setColor(self.health.RGB.red,self.health.RGB.green,self.health.RGB.blue)
            love.graphics.rectangle(
                'fill',self.xPos-12,self.yPos-25,
                self.health.currentShown*0.5,2)
            love.graphics.setColor(1,1,1)
        end
        self.dialog:draw(self.xPos-4,self.yPos-12)
    end

    enemy.updateHealth=Enemies.sharedEnemyFunctions.updateHealthFunction
    enemy.takeDamage=Enemies.sharedEnemyFunctions.takeDamage
    enemy.dropLoot=Enemies.sharedEnemyFunctions.dropLoot_t2
    enemy.die=Enemies.sharedEnemyFunctions.die 
    enemy.move=Enemies.sharedEnemyFunctions.move 
    enemy.setNewMoveTarget=Enemies.sharedEnemyFunctions.setNewMoveTarget 
    enemy.wanderingAI=Enemies.sharedEnemyFunctions.wanderingAI 
    enemy.enterCombatRanged=Enemies.sharedEnemyFunctions.enterCombatRanged
    enemy.approachTarget=Enemies.sharedEnemyFunctions.approachTarget
    enemy.checkTargetPosition=Enemies.sharedEnemyFunctions.checkTargetPosition

    enemy:load() --initialize enemy
end

Enemies.enemySpawner.t3[1]=function(_x,_y) --spawn orc_t3
    local enemy={} --create enemy instance
    function enemy:load() 
        --setup physics collider
        self.collider=world:newBSGRectangleCollider(_x,_y,19,8,3)
        self.xPos, self.yPos = _x, _y
        self.xVel, self.yVel = 0,0
        self.halfWidth=9.5
        self.halfHeight=4
        self.name='orc_t3'
        self.collider:setLinearDamping(20)
        self.collider:setFriction(0)
        self.collider:setFixedRotation(true) --collider won't spin
        self.collider:setCollisionClass('enemy')
        self.collider:setObject(self) --attach collider to this object

        --sprites and animations
        self.spriteSheet=Enemies.spriteSheets.orcT3
        self.grid=anim8.newGrid(44,32,self.spriteSheet:getWidth(),self.spriteSheet:getHeight())
        self.animations={} --animations table
        self.animations.idle=anim8.newAnimation(self.grid('1-4',1), 0.1)
        self.animations.moving=anim8.newAnimation(self.grid('5-8',1), 0.1)
        self.animations.combat=anim8.newAnimation(
            self.grid('9-17',1), 0.075,
            function() --onLoop function
                Projectiles:launch(
                    self.xPos+13*self.state.scaleX,self.yPos,self.name,Player
                )
                self.animations.combat:pauseAtStart()
                self.currentAnim=self.animations.idle --return to idle between attacks
                self.state.inCombat=false
                self.state.basicAttackCounter=self.state.basicAttackCounter+1
                if self.state.basicAttackCounter%3==0 then 
                    self:specialAttack()
                end
            end
        )
        self.currentAnim=self.animations.idle 
        self.currentAnim:gotoFrame(love.math.random(1,4)) --start at random frame
        self.shadow=Shadows:newShadow('large') --shadow
        self.dialog=Dialog:newDialogSystem() --dialog system

        --enemy's current state metatable
        self.state={}
        self.state.facing='right'
        self.state.scaleX=1 --used to flip horizontally
        self.state.moving=false
        self.state.idle=true 
        self.state.inCombat=false 
        self.state.approachingTarget=false
        self.state.isTargetted=false --true when player is targeting this enemy
        self.state.willDie=false --true when enemy should die
        self.state.moveSpeed=150
        self.state.moveTarget={x=self.xPos,y=self.yPos} --where to move to
        self.state.nextMoveTargetTimer=1+love.math.random()*2 --sec until new target
        self.state.reachedMoveTarget=false --true as soon as enemy reaches target
        self.state.movingTimer=0 --tracks how long enemy has been moving toward target
        self.state.attackOnCooldown=false 
        self.state.attackRange={x=300,y=200}
        self.state.aggroRange={x=300,y=200}
        self.state.basicAttackCounter=0 --used to trigger a special attack

        --wait 1s before setting a moveTarget to allow enemy to be pushed out of other
        --colliders it may have spawned in
        TimerState:after(1,function() self.state.moveTarget={x=self.xPos,y=self.yPos} end)

        self.health={
            sprite=Enemies.healthbars.t3,
            max=100,
            current=100, --actual current health
            RGB=Enemies.healthRGB,
            currentShown=100, --what will actually be drawn
            timer=0, --used to smoothly tween shown health
            moveRate=0.005, --increase/decrease every 0.02s
        }

        --insert enemy into entitiesTable
        table.insert(Entities.entitiesTable,self) 
    end

    function enemy:update() 
        self.dialog:update() --update dialog

        --update vectors
        self.xPos, self.yPos=self.collider:getPosition()
        self.xVel, self.yVel=self.collider:getLinearVelocity()

        --update animation
        self.currentAnim:update(dt)

        if self.state.facing=='right' then 
            self.state.scaleX=1 else self.state.scaleX=-1
        end

        self:updateHealth() --update healthbar

        if self.state.willDie then return self:die() end

        if Player.health.current==0 then self:wanderingAI() return end

        --check if player is in range and LOS of enemy, update state accordingly
        self:checkTargetPosition() 

        if self.state.inCombat then 
            self:enterCombatRanged()
        elseif self.state.approachingTarget then 
            self:approachTarget()
        else 
            self:wanderingAI()
        end
    end

    function enemy:draw()
        self.shadow:draw(self.xPos,self.yPos) --draw shadow
        self.currentAnim:draw(
            self.spriteSheet,self.xPos,self.yPos,nil,self.state.scaleX,1,11,29
        )
    end

    function enemy:drawUIelements() --called by UI
        if self.state.isTargetted then --draw health when targetted
            love.graphics.draw(self.health.sprite,self.xPos-25,self.yPos-32)
            --draw remaining health
            love.graphics.setColor(self.health.RGB.red,self.health.RGB.green,self.health.RGB.blue)
            love.graphics.rectangle(
                'fill',self.xPos-24,self.yPos-31,
                self.health.currentShown*0.5,2)
            love.graphics.setColor(1,1,1)
        end
        self.dialog:draw(self.xPos-4,self.yPos-16)
    end

    function enemy:specialAttack() --performs special attack (tornado)
        local angleToPlayer=math.atan2((Player.yPos-self.yPos),(Player.xPos-self.xPos))
        local perpendicular1=angleToPlayer+0.5*math.pi
        local perpendicular2=angleToPlayer-0.5*math.pi
        SpecialAttacks:spawnTornado(self.xPos,self.yPos,perpendicular1)
        TimerState:after(0.4,function() --spawn 2nd tornado after 0.4s
            SpecialAttacks:spawnTornado(self.xPos,self.yPos,perpendicular2)
        end)
    end

    enemy.updateHealth=Enemies.sharedEnemyFunctions.updateHealthFunction
    enemy.takeDamage=Enemies.sharedEnemyFunctions.takeDamage
    enemy.dropLoot=Enemies.sharedEnemyFunctions.dropLoot_t3
    enemy.die=Enemies.sharedEnemyFunctions.die 
    enemy.move=Enemies.sharedEnemyFunctions.move 
    enemy.setNewMoveTarget=Enemies.sharedEnemyFunctions.setNewMoveTarget 
    enemy.wanderingAI=Enemies.sharedEnemyFunctions.wanderingAI 
    enemy.enterCombatRanged=Enemies.sharedEnemyFunctions.enterCombatRanged
    enemy.approachTarget=Enemies.sharedEnemyFunctions.approachTarget
    enemy.checkTargetPosition=Enemies.sharedEnemyFunctions.checkTargetPosition

    enemy:load() --initialize enemy
end

Enemies.enemySpawner.t3[2]=function(_x,_y) --spawn demon_t3
    local enemy={} --create enemy instance
    function enemy:load() 
        --setup physics collider
        self.collider=world:newBSGRectangleCollider(_x,_y,19,8,3)
        self.xPos, self.yPos = _x, _y
        self.xVel, self.yVel = 0,0
        self.halfWidth=9.5
        self.halfHeight=4
        self.name='demon_t3'
        self.collider:setLinearDamping(20)
        self.collider:setFriction(0)
        self.collider:setFixedRotation(true) --collider won't spin
        self.collider:setCollisionClass('enemy')
        self.collider:setObject(self) --attach collider to this object

        --sprites and animations
        self.spriteSheet=Enemies.spriteSheets.demonT3
        self.grid=anim8.newGrid(32,32,self.spriteSheet:getWidth(),self.spriteSheet:getHeight())
        self.animations={} --animations table
        self.animations.idle=anim8.newAnimation(self.grid('1-4',1), 0.1)
        self.animations.moving=anim8.newAnimation(self.grid('5-8',1), 0.1)
        self.animations.combat=anim8.newAnimation(
            self.grid('9-17',1), 0.075,
            function() --onLoop function
                Projectiles:launch(
                    self.xPos+self.state.scaleX-1,self.yPos,self.name,Player
                )
                self.animations.combat:pauseAtStart()
                self.currentAnim=self.animations.idle --return to idle between attacks
                self.state.inCombat=false
                self.state.basicAttackCounter=self.state.basicAttackCounter+1
                if self.state.basicAttackCounter%3==0 then 
                    self:specialAttack()
                end
            end
        )
        self.currentAnim=self.animations.idle 
        self.currentAnim:gotoFrame(love.math.random(1,4)) --start at random frame
        self.shadow=Shadows:newShadow('large') --shadow
        self.dialog=Dialog:newDialogSystem() --dialog system

        --enemy's current state metatable
        self.state={}
        self.state.facing='right'
        self.state.scaleX=1 --used to flip horizontally
        self.state.moving=false
        self.state.idle=true 
        self.state.inCombat=false 
        self.state.approachingTarget=false 
        self.state.isTargetted=false --true when player is targeting this enemy
        self.state.willDie=false --true when enemy should die
        self.state.moveSpeed=150
        self.state.moveTarget={x=self.xPos,y=self.yPos} --where to move to
        self.state.nextMoveTargetTimer=1+love.math.random()*2 --sec until new target
        self.state.reachedMoveTarget=false --true as soon as enemy reaches target
        self.state.movingTimer=0 --tracks how long enemy has been moving toward target
        self.state.attackOnCooldown=false 
        self.state.attackRange={x=300,y=200}
        self.state.aggroRange={x=300,y=200}
        self.state.basicAttackCounter=0 --used to trigger special attacks

        --wait 1s before setting a moveTarget to allow enemy to be pushed out of other
        --colliders it may have spawned in
        TimerState:after(1,function() self.state.moveTarget={x=self.xPos,y=self.yPos} end)

        self.health={
            sprite=Enemies.healthbars.t3,
            max=100,
            current=100, --actual current health
            RGB=Enemies.healthRGB,
            currentShown=100, --what will actually be drawn
            timer=0, --used to smoothly tween shown health
            moveRate=0.005, --how frequent health will decrease
        }

        --insert enemy into entitiesTable
        table.insert(Entities.entitiesTable,self) 
    end

    function enemy:update() 
        self.dialog:update() --update dialog

        --update vectors
        self.xPos, self.yPos=self.collider:getPosition()
        self.xVel, self.yVel=self.collider:getLinearVelocity()

        --update animation
        self.currentAnim:update(dt)

        if self.state.facing=='right' then 
            self.state.scaleX=1 else self.state.scaleX=-1
        end

        self:updateHealth() --update healthbar

        if self.state.willDie then return self:die() end

        if Player.health.current==0 then self:wanderingAI() return end

        --check if player is in range and LOS of enemy, update state accordingly
        self:checkTargetPosition() 

        if self.state.inCombat then 
            self:enterCombatRanged()
        elseif self.state.approachingTarget then 
            self:approachTarget()
        else 
            self:wanderingAI()
        end
    end

    function enemy:draw()
        self.shadow:draw(self.xPos,self.yPos) --draw shadow
        self.currentAnim:draw(
            self.spriteSheet,self.xPos,self.yPos,nil,self.state.scaleX,1,16,32
        )
    end

    function enemy:drawUIelements() --called by UI
        if self.state.isTargetted then --draw health when targetted
            love.graphics.draw(self.health.sprite,self.xPos-25,self.yPos-32)
            --draw remaining health
            love.graphics.setColor(self.health.RGB.red,self.health.RGB.green,self.health.RGB.blue)
            love.graphics.rectangle(
                'fill',self.xPos-24,self.yPos-31,
                self.health.currentShown*0.5,2)
            love.graphics.setColor(1,1,1)
        end
        self.dialog:draw(self.xPos-4,self.yPos-16)
    end

    --spawns a fire insignia on the ground beneath the demon, then twice beneath
    --the player. Once the insignia fades in, flames spawn to engulf the area above
    --the insignia which rapidly damage and knockback the player.
    function enemy:specialAttack()
        SpecialAttacks:spawnFireCircle(self.xPos,self.yPos)
        TimerState:after(0.75,function() 
            SpecialAttacks:spawnFireCircle(Player.xPos,Player.yPos)
        end)
        TimerState:after(1.5,function() 
            SpecialAttacks:spawnFireCircle(Player.xPos,Player.yPos)
        end)
    end

    enemy.updateHealth=Enemies.sharedEnemyFunctions.updateHealthFunction
    enemy.takeDamage=Enemies.sharedEnemyFunctions.takeDamage    
    enemy.dropLoot=Enemies.sharedEnemyFunctions.dropLoot_t3
    enemy.die=Enemies.sharedEnemyFunctions.die 
    enemy.move=Enemies.sharedEnemyFunctions.move
    enemy.setNewMoveTarget=Enemies.sharedEnemyFunctions.setNewMoveTarget
    enemy.wanderingAI=Enemies.sharedEnemyFunctions.wanderingAI
    enemy.enterCombatRanged=Enemies.sharedEnemyFunctions.enterCombatRanged
    enemy.approachTarget=Enemies.sharedEnemyFunctions.approachTarget
    enemy.checkTargetPosition=Enemies.sharedEnemyFunctions.checkTargetPosition

    enemy:load() --initialize enemy
end

Enemies.enemySpawner.t4[1]=function(_x,_y) --spawn boss
    local enemy={} --create enemy instance
    function enemy:load() 
        --setup physics collider
        self.collider=world:newBSGRectangleCollider(_x,_y,37,10,5)
        self.xPos, self.yPos = _x, _y
        self.xVel, self.yVel = 0,0
        self.halfWidth=18.5
        self.halfHeight=5
        self.name='boss'
        self.collider:setLinearDamping(20)
        self.collider:setFriction(0)
        self.collider:setFixedRotation(true) --collider won't spin
        self.collider:setCollisionClass('enemy')
        self.collider:setObject(self) --attach collider to this object

        --sprites and animations
        self.spriteSheet=Enemies.spriteSheets.boss
        self.grid=anim8.newGrid(70,55,self.spriteSheet:getWidth(),self.spriteSheet:getHeight())
        self.animations={} --animations table
        self.animations.idle=anim8.newAnimation(self.grid('1-6',1), 0.1)
        self.animations.moving=anim8.newAnimation(self.grid('1-6',2), 0.1)
        self.animations.combat={current=nil,physical=nil,magical=nil}
        self.animations.combat.physical=anim8.newAnimation(
            self.grid('1-8',3), 0.125,
            function() --onLoop function                
                self.state.attackOnCooldown=true
                TimerState:after(self.state.physicalCooldownTime,function() 
                    self.state.attackOnCooldown=false 
                    self.state.hasAttacked=false 
                end)
                self.animations.combat.current:pauseAtStart()
                self.currentAnim=self.animations.idle --return to idle between attacks
                self.state.basicAttackCounter=self.state.basicAttackCounter+1
                if self.state.basicAttackCounter==4 then --switch attacks
                    self.state.basicAttackCounter=0
                    self.state.currentAttack='magical'
                    self.animations.combat.current=self.animations.combat.magical
                    --choose an attack number to launch a disablingFireball.
                    --effectively ~57% to launch on a given magic attack cycle
                    self.state.disablingFireballAttackNum=love.math.random(7)-1
                end
            end
        )
        self.animations.combat.magical=anim8.newAnimation(
            self.grid('1-16',4), 0.1,
            function() --onLoop function                
                self.state.attackOnCooldown=true
                TimerState:after(self.state.magicalCooldownTime,function() 
                    self.state.attackOnCooldown=false 
                    self.state.hasAttacked=false 
                end)
                self.animations.combat.current:pauseAtStart()
                self.currentAnim=self.animations.idle --return to idle between attacks
                self.state.basicAttackCounter=self.state.basicAttackCounter+1
                if self.state.basicAttackCounter==4 then --switch attacks
                    self.state.basicAttackCounter=0
                    self.state.currentAttack='physical'
                    self.animations.combat.current=self.animations.combat.physical
                end
            end
        )
        self.currentAnim=self.animations.idle 
        self.currentAnim:gotoFrame(love.math.random(1,4)) --start at random frame
        self.shadow=Shadows:newShadow('boss') --shadow
        self.dialog=Dialog:newDialogSystem() --dialog system

        --enemy's current state metatable
        self.state={}
        self.state.wait=true --wait for transitions/animations before starting AI
        self.state.facing='right'
        self.state.scaleX=1 --used to flip horizontally
        self.state.moving=false
        self.state.idle=true 
        self.state.hasAttacked=false --used to perform a single attack at a time
        self.state.isTargetted=false --true when player is targeting this enemy
        self.state.physicalCooldownTime=1.35 --1.35s between physical attacks
        self.state.magicalCooldownTime=0.75 --0.755s between magical attacks
        self.state.willDie=false --true when enemy should die
        self.state.moveSpeed=500
        self.state.moveTarget={x=self.xPos,y=self.yPos} --where to move to
        self.state.nextMoveTargetTimer=1+love.math.random()*2 --sec until new target
        self.state.reachedMoveTarget=false --true as soon as enemy reaches target
        self.state.movingTimer=0 --tracks how long enemy has been moving toward target
        self.state.attackOnCooldown=true 
        self.state.basicAttackCounter=0        
        --choose an attack number to launch a disablingFireball.
        --effectively ~57% to launch on a given magic attack cycle
        self.state.disablingFireballAttackNum=love.math.random(7)-1
        self.state.attacksTaken=0 --how many attacks has the boss taken
        self.state.protectionActivated=true --currently using protection magics
        self.state.currentProtectionMagic='' --currently protected against

        self.particleSystems={} --all particle systems
        --fireball (used for initial explosion from mouth)
        self.particleSystems.fireball=SpecialAttacks.particleSystems.fireball:clone()
        self.particleSystems.fireball:setSpeed(20,60)        
        self.particleSystems.disablingFireball=SpecialAttacks.particleSystems.disablingFireball:clone()
        self.particleSystems.disablingFireball:setSpeed(20,60)        

        --used to select initial attack and protection type
        local attackStyles={'physical','magical'}
        local chooseStyle=attackStyles[love.math.random(1,2)]

        --create protection magics
        self.protectionMagics=ProtectionMagics:newProtectionMagicSystem(self)
        self.state.currentProtectionMagic=chooseStyle
        self.protectionMagics:activate(self.state.currentProtectionMagic)

        --select attack style opposite of current protection magic
        self.state.currentAttack=chooseStyle
        self.animations.combat.current=self.animations.combat[chooseStyle]

        self.health={
            sprite=Enemies.healthbars.t4,
            max=200,
            current=200, --actual current health
            RGB=Enemies.healthRGB,
            currentShown=200, --what will actually be drawn
            timer=0, --used to smoothly tween shown health
            moveRate=0.005, --how frequent health will decrease
        }

        --testing-----------------------
        TimerState:after(0.5,function() self.state.attackOnCooldown=false end)
        --testing-------------------------

        --insert enemy into entitiesTable
        table.insert(Entities.entitiesTable,self) 

        --also pass boss to BossRoom
        BossRoom.boss=self 
    end

    function enemy:update() 
        self.dialog:update() --update dialog
        --update particle systems
        for i,p in pairs(self.particleSystems) do p:update(dt) end 

        --update vectors
        self.xPos, self.yPos=self.collider:getPosition()
        self.xVel, self.yVel=self.collider:getLinearVelocity()

        --update animation
        self.currentAnim:update(dt)

        if self.state.facing=='right' then 
            self.state.scaleX=1 else self.state.scaleX=-1
        end

        if self.state.wait then return end --wait for transitions/animations before starting AI

        self:updateHealth() --update healthbar

        if self.state.willDie then return self:die() end

        if Player.health.current==0 then self:wanderingAI() return end

        if self.state.attackOnCooldown==false then 
            self.currentAnim=self.animations.combat.current         
            self.currentAnim:resume()

            if self.state.currentAttack=='physical' then self:attackPhysical() 
            elseif self.state.currentAttack=='magical' then self:attackMagical()
            end
            
        elseif self.state.attackOnCooldown then 
            self:approachTarget()
        elseif Player.health.current>0 then
            self:wanderingAI()
        end
    end

    function enemy:draw()
        self.shadow:draw(self.xPos,self.yPos) --draw shadow
        self.currentAnim:draw(
            self.spriteSheet,self.xPos,self.yPos,
            nil,self.state.scaleX,1,33,54
        )
        love.graphics.draw( --draw fireball explosion particles
            self.particleSystems.fireball,
            self.xPos+5*self.state.scaleX,self.yPos-23
        )
    end

    function enemy:drawUIelements() --called by UI
        if self.state.isTargetted then --draw health when targetted
            love.graphics.draw(self.health.sprite,self.xPos-48,self.yPos-56)
            --draw remaining health
            love.graphics.setColor(self.health.RGB.red,self.health.RGB.green,self.health.RGB.blue)
            love.graphics.rectangle(
                'fill',self.xPos-47,self.yPos-55,
                self.health.currentShown*0.5,3)
            love.graphics.setColor(1,1,1)
        end
        self.dialog:draw(self.xPos-4,self.yPos-16)
    end

    function enemy:attackPhysical()
        if self.currentAnim.position>=5 and not self.state.hasAttacked then
            self.state.hasAttacked=true 
            if self.state.scaleX==1 then 
                SpecialAttacks:spawnFissure(self.xPos+25,self.yPos,Player)
            else 
                SpecialAttacks:spawnFissure(self.xPos-35,self.yPos,Player)
            end
        end
    end

    function enemy:attackMagical()
        if self.currentAnim.position>=13 and not self.state.hasAttacked then
            self.state.hasAttacked=true 
            --fireball will be disabling only on even magical attack cycles and
            --only on the selected attack number (chosen after 4th physical attack)
            local isDisabling=self.state.basicAttackCounter==self.state.disablingFireballAttackNum
            SpecialAttacks:launchFireball(
                self.xPos+5*self.state.scaleX,
                self.yPos-3,Player,isDisabling
            )
            if isDisabling then --emit correct color particles for initial explosion
                self.particleSystems.disablingFireball:emit(100)
            else
                self.particleSystems.fireball:emit(100) 
            end
            --apply some recoil to boss
            self.collider:applyLinearImpulse(-60*self.state.scaleX,0)
        else --continue facing player until fireball is launched
            if Player.xPos>self.xPos then 
                self.state.facing='right' else self.state.facing='left'
            end
        end
    end

    function enemy:takeDamage(_attackType,_damageType,_knockback,_angle,_val) 
        local modifiedDamage=_val 
        
        --if successfully protected, damage is 0, return 
        --don't count the attack as a hit for the attacksTaken counter
        if self.state.currentProtectionMagic==_damageType then 
            self.dialog:damage(0,_damageType)
            return
        end

        modifiedDamage=love.math.random( --roll between +/-10% of damage
            math.floor(modifiedDamage*0.9),math.ceil(modifiedDamage*1.1)
        )
        modifiedDamage=math.max(modifiedDamage,1) --can't hit lower than 1
        self.dialog:damage(modifiedDamage,_damageType)

        --apply reduced damage to effectively increase total health (to 1000hp)
        modifiedDamage=modifiedDamage/5
        self.health.current=math.max(self.health.current-modifiedDamage,0)

        --apply knockback
        self.collider:applyLinearImpulse(
            math.cos(_angle)*_knockback,math.sin(_angle)*_knockback
        )

        --change protection magics after taking 5 hits
        self.state.attacksTaken=self.state.attacksTaken+1
        if self.state.attacksTaken==5 then 
            self.state.attacksTaken=0
            self.protectionMagics:deactivate()
            local opposite={physical='magical',magical='physical'}
            self.state.currentProtectionMagic=opposite[self.state.currentProtectionMagic]
            self.protectionMagics:activate(self.state.currentProtectionMagic)
        end
    end

    function enemy:die()
        --if player is still targeting enemy at this point, stop targeting it
        if Player.combatData.currentEnemy==self then 
            Player.combatData.currentEnemy=nil 
        end 

        self.protectionMagics:deactivate() 
        self.collider:destroy()

        --TODO-------------
        --end the game I guess
        BossRoom:endBossBattle()
        --TODO-------------

        return false --return false to remove entity from game
    end

    enemy.updateHealth=Enemies.sharedEnemyFunctions.updateHealthFunction
    enemy.move=Enemies.sharedEnemyFunctions.move
    enemy.setNewMoveTarget=Enemies.sharedEnemyFunctions.setNewMoveTarget
    enemy.wanderingAI=Enemies.sharedEnemyFunctions.wanderingAI
    enemy.approachTarget=Enemies.sharedEnemyFunctions.approachTarget

    enemy:load() --initialize enemy
end

--takes a spawn zone and fills it with a set of 3 random T1 enemies
function Enemies:fillRoomT1(spawnZone)
    for i=1,3 do 
        --spawn 3 random T1 enemies inside the spawn zone
        self.enemySpawner.t1[love.math.random(3)](
            love.math.random(spawnZone.x1,spawnZone.x2),
            love.math.random(spawnZone.y1,spawnZone.y2)
        )
    end
end

--takes a spawn zone and fills it with a set of 3 random T2 enemies
--if a mage spawns, it can only be accompanied by T1 skeleton enemies
--otherwise, T2 demons and orcs will spawn
function Enemies:fillRoomT2(spawnZone)
    local spawnMage=(love.math.random(2)==1) --50% chance to spawn mage
    if spawnMage then 
        --if mages spawn, only T1 skeletons can accompany it
        self.enemySpawner.t2[3]( --spawn the mage
            love.math.random(spawnZone.x1,spawnZone.x2),
            love.math.random(spawnZone.y1,spawnZone.y2)
        )
        self.enemySpawner.t1[3]( --spawn skeleton
            love.math.random(spawnZone.x1,spawnZone.x2),
            love.math.random(spawnZone.y1,spawnZone.y2)
        )
        self.enemySpawner.t1[3]( --spawn another skeleton
            love.math.random(spawnZone.x1,spawnZone.x2),
            love.math.random(spawnZone.y1,spawnZone.y2)
        )
    else
        for i=1,3 do 
            --spawn only tier 2 demons or orcs
            self.enemySpawner.t2[love.math.random(2)](
                love.math.random(spawnZone.x1,spawnZone.x2),
                love.math.random(spawnZone.y1,spawnZone.y2)
            )
        end
    end
end

--takes a spawn zone and fills it with a T3 orc or demon
--uses Dungeon.nextDemiBoss to alternate between spawning the orc or demon
function Enemies:fillRoomT3(spawnZone)
    self.enemySpawner.t3[Dungeon.nextDemiBoss]( --spawn T3 enemy
        love.math.random(spawnZone.x1,spawnZone.x2),
        love.math.random(spawnZone.y1,spawnZone.y2)
    )
    Dungeon.nextDemiBoss=1+(Dungeon.nextDemiBoss%2) --alternate to next demi boss
end
