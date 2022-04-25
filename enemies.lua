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

    self.sprites={} --stores all other sprites used by enemies
    self.sprites.healthbars={
        t1=love.graphics.newImage('assets/enemies/healthbar_t1.png'),
        t2=love.graphics.newImage('assets/enemies/healthbar_t2.png'),
        t3=love.graphics.newImage('assets/enemies/healthbar_t3.png'),
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
        end
    end

    self.sharedEnemyFunctions.takeDamage=function(_enemy,_val) --enemy takes some damage
        _enemy.health.current=math.max(_enemy.health.current-_val,0) --can't be lower than 0
        if _enemy.health.current==0 then _enemy.state.willDie=true end 
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
        if love.math.random(3)==1 then --1/3 chance to spawn a fish
            Items:spawn_item(_enemy.xPos,_enemy.yPos,'fish_raw')
        end
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
        if love.math.random(3)==1 then --1/3 chance to spawn 2 fish
            for i=1,2 do Items:spawn_item(_enemy.xPos,_enemy.yPos,'fish_raw') end            
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
        if love.math.random(2)==1 then --1/2 chance to spawn 3 fish
            for i=1,3 do Items:spawn_item(_enemy.xPos,_enemy.yPos,'fish_raw') end         
        end
    end

    self.sharedEnemyFunctions.move=function(_enemy) --move enemy toward its target
        --set defalt state values
        _enemy.state.idle=true 
        _enemy.state.moving=false 
        _enemy.state.movingHorizontally=false 

        if _enemy.state.moveTarget.x<_enemy.xPos-_enemy.halfWidth then --target is to the left
            _enemy.xVel=_enemy.xVel-_enemy.state.moveSpeed*dt
            _enemy.state.facing='left'
            _enemy.state.moving=true
            _enemy.state.movingHorizontally=true
        
        elseif _enemy.state.moveTarget.x>_enemy.xPos+_enemy.halfWidth then --target is to the right
            _enemy.xVel=_enemy.xVel+_enemy.state.moveSpeed*dt 
            _enemy.state.facing='right'
            _enemy.state.moving=true
            _enemy.state.movingHorizontally=true
        end

        if _enemy.state.moveTarget.y<_enemy.yPos-_enemy.halfHeight then --target is above
            --accomodate for diagonal speed
            if _enemy.state.movingHorizontally then 
                _enemy.yVel=_enemy.yVel-_enemy.state.moveSpeedDiag*dt
            else            
                _enemy.yVel=_enemy.yVel-_enemy.state.moveSpeed*dt
            end 
            _enemy.state.moving=true
        
        elseif _enemy.state.moveTarget.y>_enemy.yPos+_enemy.halfHeight then  --target is below
            --accomodate for diagonal speed
            if _enemy.state.movingHorizontally then 
                _enemy.yVel=_enemy.yVel+_enemy.state.moveSpeedDiag*dt
            else            
                _enemy.yVel=_enemy.yVel+_enemy.state.moveSpeed*dt
            end 
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
    
        --apply updated velocities to collider
        _enemy.collider:setLinearVelocity(_enemy.xVel,_enemy.yVel)
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
                    'resourceNode','depletedNode','doorButton','ladder'
                }
            )==0 
            and #world:queryLine(
                target.sideB.x1,target.sideB.y1,target.sideB.x2,target.sideB.y2,
                {
                    'outerWall','innerWall','doorBarrier','craftingNode',
                    'resourceNode','depletedNode','doorButton','ladder'
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
end

--holds spawn functions for each tier of enemy
Enemies.enemySpawner={t1={}, t2={}, t3={}}

Enemies.enemySpawner.t1[1]=function(_x,_y) --spawn orc_t1
    local enemy={} --create enemy instance
    function enemy:load() 
        --setup physics collider
        self.collider=world:newBSGRectangleCollider(_x,_y,9,5,3)
        self.xPos, self.yPos = _x, _y
        self.xVel, self.yVel = 0,0
        self.halfWidth,self.halfHeight=4.5,2.5
        self.name='orc_t1'
        self.collider:setLinearDamping(20)
        self.collider:setFixedRotation(true) --collider won't spin
        self.collider:setCollisionClass('enemy')
        self.collider:setObject(self) --attach collider to this object

        --sprites and animations
        self.spriteSheet=Enemies.spriteSheets.orcT1
        self.grid=anim8.newGrid(16,16,self.spriteSheet:getWidth(),self.spriteSheet:getHeight())
        self.animations={} --animations table
        self.animations.idle=anim8.newAnimation(self.grid('1-4',1), 0.1)
        self.animations.moving=anim8.newAnimation(self.grid('5-8',1), 0.1)
        self.currentAnim=self.animations.idle 
        self.currentAnim:gotoFrame(love.math.random(1,4)) --start at random frame
        self.shadow=Shadows:newShadow('tiny') --shadow

        --enemy's current state metatable
        self.state={}
        self.state.facing='right'
        self.state.scaleX=1 --used to flip horizontally
        self.state.moving=false
        self.state.movingHorizontally=false 
        self.state.idle=true 
        self.state.inCombat=false 
        self.state.isTargetted=false --true when player is targeting this enemy
        self.state.willDie=false --true when enemy should die
        self.state.moveSpeed=900
        self.state.moveSpeedDiag=self.state.moveSpeed*0.61
        self.state.moveTarget={x=self.xPos,y=self.yPos} --where to move to
        self.state.nextMoveTargetTimer=1+love.math.random()*2 --sec until new target
        self.state.reachedMoveTarget=false --true as soon as enemy reaches target
        self.state.movingTimer=0 --tracks how long enemy has been moving toward target

        --wait 1s before setting a moveTarget to allow enemy to be pushed out of other
        --colliders it may have spawned in
        TimerState:after(1,function() self.state.moveTarget={x=self.xPos,y=self.yPos} end)

        self.health={
            sprite=Enemies.sprites.healthbars.t1,
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

        if self.state.inCombat then 
            --combat
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
    end

    enemy.updateHealth=Enemies.sharedEnemyFunctions.updateHealthFunction
    enemy.takeDamage=Enemies.sharedEnemyFunctions.takeDamage
    enemy.dropLoot=Enemies.sharedEnemyFunctions.dropLoot_t1
    enemy.die=Enemies.sharedEnemyFunctions.die
    enemy.move=Enemies.sharedEnemyFunctions.move 
    enemy.setNewMoveTarget=Enemies.sharedEnemyFunctions.setNewMoveTarget 
    enemy.wanderingAI=Enemies.sharedEnemyFunctions.wanderingAI 

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
        self.collider:setLinearDamping(20)
        self.collider:setFixedRotation(true) --collider won't spin
        self.collider:setCollisionClass('enemy')
        self.collider:setObject(self) --attach collider to this object

        --sprites and animations
        self.spriteSheet=Enemies.spriteSheets.demonT1
        self.grid=anim8.newGrid(16,16,self.spriteSheet:getWidth(),self.spriteSheet:getHeight())
        self.animations={} --animations table
        self.animations.idle=anim8.newAnimation(self.grid('1-4',1), 0.1)
        self.animations.moving=anim8.newAnimation(self.grid('5-8',1), 0.1)
        self.currentAnim=self.animations.idle 
        self.currentAnim:gotoFrame(love.math.random(1,4)) --start at random frame
        self.shadow=Shadows:newShadow('tiny') --shadow

        --enemy's current state metatable
        self.state={}
        self.state.facing='right'
        self.state.scaleX=1 --used to flip horizontally
        self.state.moving=false
        self.state.movingHorizontally=false 
        self.state.idle=true 
        self.state.inCombat=false 
        self.state.isTargetted=false --true when player is targeting this enemy
        self.state.willDie=false --true when enemy should die
        self.state.moveSpeed=900
        self.state.moveSpeedDiag=self.state.moveSpeed*0.61
        self.state.moveTarget={x=self.xPos,y=self.yPos} --where to move to
        self.state.nextMoveTargetTimer=1+love.math.random()*2 --sec until new target
        self.state.reachedMoveTarget=false --true as soon as enemy reaches target
        self.state.movingTimer=0 --tracks how long enemy has been moving toward target

        --wait 1s before setting a moveTarget to allow enemy to be pushed out of other
        --colliders it may have spawned in
        TimerState:after(1,function() self.state.moveTarget={x=self.xPos,y=self.yPos} end)
        self.health={
            sprite=Enemies.sprites.healthbars.t1,
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

        if self.state.inCombat then 
            --combat
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
    end

    enemy.updateHealth=Enemies.sharedEnemyFunctions.updateHealthFunction
    enemy.takeDamage=Enemies.sharedEnemyFunctions.takeDamage
    enemy.dropLoot=Enemies.sharedEnemyFunctions.dropLoot_t1
    enemy.die=Enemies.sharedEnemyFunctions.die 
    enemy.move=Enemies.sharedEnemyFunctions.move 
    enemy.setNewMoveTarget=Enemies.sharedEnemyFunctions.setNewMoveTarget 
    enemy.wanderingAI=Enemies.sharedEnemyFunctions.wanderingAI 

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
        self.collider:setLinearDamping(20)
        self.collider:setFixedRotation(true) --collider won't spin
        self.collider:setCollisionClass('enemy')
        self.collider:setObject(self) --attach collider to this object

        --sprites and animations
        self.spriteSheet=Enemies.spriteSheets.skeletonT1
        self.grid=anim8.newGrid(16,16,self.spriteSheet:getWidth(),self.spriteSheet:getHeight())
        self.animations={} --animations table
        self.animations.idle=anim8.newAnimation(self.grid('1-4',1), 0.1)
        self.animations.moving=anim8.newAnimation(self.grid('5-8',1), 0.1)
        self.currentAnim=self.animations.idle 
        self.currentAnim:gotoFrame(love.math.random(1,4)) --start at random frame
        self.shadow=Shadows:newShadow('small') --shadow

        --enemy's current state metatable
        self.state={}
        self.state.facing='right'
        self.state.scaleX=1 --used to flip horizontally
        self.state.moving=false
        self.state.movingHorizontally=false 
        self.state.idle=true 
        self.state.inCombat=false 
        self.state.isTargetted=false --true when player is targeting this enemy
        self.state.willDie=false --true when enemy should die
        self.state.moveSpeed=900
        self.state.moveSpeedDiag=self.state.moveSpeed*0.61
        self.state.moveTarget={x=self.xPos,y=self.yPos} --where to move to
        self.state.nextMoveTargetTimer=1+love.math.random()*2 --sec until new target
        self.state.reachedMoveTarget=false --true as soon as enemy reaches target
        self.state.movingTimer=0 --tracks how long enemy has been moving toward target

        --wait 1s before setting a moveTarget to allow enemy to be pushed out of other
        --colliders it may have spawned in
        TimerState:after(1,function() self.state.moveTarget={x=self.xPos,y=self.yPos} end)

        self.health={
            sprite=Enemies.sprites.healthbars.t1,
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

        if self.state.inCombat then 
            --combat
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
    end

    enemy.updateHealth=Enemies.sharedEnemyFunctions.updateHealthFunction
    enemy.takeDamage=Enemies.sharedEnemyFunctions.takeDamage
    enemy.dropLoot=Enemies.sharedEnemyFunctions.dropLoot_t1
    enemy.die=Enemies.sharedEnemyFunctions.die 
    enemy.move=Enemies.sharedEnemyFunctions.move 
    enemy.setNewMoveTarget=Enemies.sharedEnemyFunctions.setNewMoveTarget 
    enemy.wanderingAI=Enemies.sharedEnemyFunctions.wanderingAI 

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
            end
        )
        self.currentAnim=self.animations.idle 
        self.currentAnim:gotoFrame(love.math.random(1,4)) --start at random frame
        self.shadow=Shadows:newShadow('small') --shadow

        --enemy's current state metatable
        self.state={}
        self.state.facing='right'
        self.state.scaleX=1 --used to flip horizontally
        self.state.moving=false
        self.state.movingHorizontally=false 
        self.state.idle=true 
        self.state.inCombat=false 
        self.state.isTargetted=false --true when player is targeting this enemy
        self.state.willDie=false --true when enemy should die
        self.state.moveSpeed=900
        self.state.moveSpeedDiag=self.state.moveSpeed*0.61
        self.state.moveTarget={x=self.xPos,y=self.yPos} --where to move to
        self.state.nextMoveTargetTimer=1+love.math.random()*2 --sec until new target
        self.state.reachedMoveTarget=false --true as soon as enemy reaches target
        self.state.movingTimer=0 --tracks how long enemy has been moving toward target
        self.state.attackOnCooldown=false

        --wait 1s before setting a moveTarget to allow enemy to be pushed out of other
        --colliders it may have spawned in
        TimerState:after(1,function() self.state.moveTarget={x=self.xPos,y=self.yPos} end)

        self.health={
            sprite=Enemies.sprites.healthbars.t2,
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

        --check if player is within aggro zone and in LOS
        if math.abs(self.xPos-Player.xPos)<200 
        and math.abs(self.yPos-Player.yPos)<150
        and #world:queryLine( 
            self.xPos,self.yPos,Player.xPos,Player.yPos,
            {'outerWall','innerWall','craftingNode'}
            )==0 
        then --if player is in range and LOS is clear, enter combat
            self.state.inCombat=true
        else 
            self.state.inCombat=false
            self.currentAnim=self.animations.idle
            self.animations.combat:pauseAtStart()
        end

        if self.state.inCombat then
            self:enterCombatRanged()
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
    end

    enemy.updateHealth=Enemies.sharedEnemyFunctions.updateHealthFunction
    enemy.takeDamage=Enemies.sharedEnemyFunctions.takeDamage
    enemy.dropLoot=Enemies.sharedEnemyFunctions.dropLoot_t2
    enemy.die=Enemies.sharedEnemyFunctions.die 
    enemy.move=Enemies.sharedEnemyFunctions.move 
    enemy.setNewMoveTarget=Enemies.sharedEnemyFunctions.setNewMoveTarget 
    enemy.wanderingAI=Enemies.sharedEnemyFunctions.wanderingAI 
    enemy.enterCombatRanged=Enemies.sharedEnemyFunctions.enterCombatRanged

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
        self.collider:setLinearDamping(20)
        self.collider:setFixedRotation(true) --collider won't spin
        self.collider:setCollisionClass('enemy')
        self.collider:setObject(self) --attach collider to this object

        --sprites and animations
        self.spriteSheet=Enemies.spriteSheets.demonT2
        self.grid=anim8.newGrid(16,23,self.spriteSheet:getWidth(),self.spriteSheet:getHeight())
        self.animations={} --animations table
        self.animations.idle=anim8.newAnimation(self.grid('1-4',1), 0.1)
        self.animations.moving=anim8.newAnimation(self.grid('5-8',1), 0.1)
        self.currentAnim=self.animations.idle 
        self.currentAnim:gotoFrame(love.math.random(1,4)) --start at random frame
        self.shadow=Shadows:newShadow('small') --shadow

        --enemy's current state metatable
        self.state={}
        self.state.facing='right'
        self.state.scaleX=1 --used to flip horizontally
        self.state.moving=false
        self.state.movingHorizontally=false 
        self.state.idle=true 
        self.state.inCombat=false 
        self.state.isTargetted=false --true when player is targeting this enemy
        self.state.willDie=false --true when enemy should die
        self.state.moveSpeed=900
        self.state.moveSpeedDiag=self.state.moveSpeed*0.61
        self.state.moveTarget={x=self.xPos,y=self.yPos} --where to move to
        self.state.nextMoveTargetTimer=1+love.math.random()*2 --sec until new target
        self.state.reachedMoveTarget=false --true as soon as enemy reaches target
        self.state.movingTimer=0 --tracks how long enemy has been moving toward target

        --wait 1s before setting a moveTarget to allow enemy to be pushed out of other
        --colliders it may have spawned in
        TimerState:after(1,function() self.state.moveTarget={x=self.xPos,y=self.yPos} end)

        self.health={
            sprite=Enemies.sprites.healthbars.t2,
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

        if self.state.inCombat then 
            --combat
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
    end

    enemy.updateHealth=Enemies.sharedEnemyFunctions.updateHealthFunction
    enemy.takeDamage=Enemies.sharedEnemyFunctions.takeDamage
    enemy.dropLoot=Enemies.sharedEnemyFunctions.dropLoot_t2
    enemy.die=Enemies.sharedEnemyFunctions.die 
    enemy.move=Enemies.sharedEnemyFunctions.move 
    enemy.setNewMoveTarget=Enemies.sharedEnemyFunctions.setNewMoveTarget 
    enemy.wanderingAI=Enemies.sharedEnemyFunctions.wanderingAI 

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
            end
        )
        self.currentAnim=self.animations.idle 
        self.currentAnim:gotoFrame(love.math.random(1,4)) --start at random frame
        self.shadow=Shadows:newShadow('medium') --shadow

        --enemy's current state metatable
        self.state={}
        self.state.facing='right'
        self.state.scaleX=1 --used to flip horizontally
        self.state.moving=false
        self.state.movingHorizontally=false 
        self.state.idle=true 
        self.state.inCombat=false 
        self.state.isTargetted=false --true when player is targeting this enemy
        self.state.willDie=false --true when enemy should die
        self.state.moveSpeed=600
        self.state.moveSpeedDiag=self.state.moveSpeed*0.61
        self.state.moveTarget={x=self.xPos,y=self.yPos} --where to move to
        self.state.nextMoveTargetTimer=1+love.math.random()*2 --sec until new target
        self.state.reachedMoveTarget=false --true as soon as enemy reaches target
        self.state.movingTimer=0 --tracks how long enemy has been moving toward target
        self.state.attackOnCooldown=false 

        --wait 1s before setting a moveTarget to allow enemy to be pushed out of other
        --colliders it may have spawned in
        TimerState:after(1,function() self.state.moveTarget={x=self.xPos,y=self.yPos} end)

        self.health={
            sprite=Enemies.sprites.healthbars.t2,
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

        --check if player is within aggro zone and in LOS
        if math.abs(self.xPos-Player.xPos)<200 
        and math.abs(self.yPos-Player.yPos)<150
        and #world:queryLine( 
            self.xPos,self.yPos,Player.xPos,Player.yPos,
            {'outerWall','innerWall','craftingNode'}
            )==0 
        then --if player is in range and LOS is clear, enter combat
            self.state.inCombat=true
        else 
            self.state.inCombat=false
            self.currentAnim=self.animations.idle
            self.animations.combat:pauseAtStart()
        end

        if self.state.inCombat then
            self:enterCombatRanged()
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
            love.graphics.draw(self.health.sprite,self.xPos-13,self.yPos-22)
            --draw remaining health
            love.graphics.setColor(self.health.RGB.red,self.health.RGB.green,self.health.RGB.blue)
            love.graphics.rectangle(
                'fill',self.xPos-12,self.yPos-21,
                self.health.currentShown*0.5,2)
            love.graphics.setColor(1,1,1)
        end
    end

    enemy.updateHealth=Enemies.sharedEnemyFunctions.updateHealthFunction
    enemy.takeDamage=Enemies.sharedEnemyFunctions.takeDamage
    enemy.dropLoot=Enemies.sharedEnemyFunctions.dropLoot_t2
    enemy.die=Enemies.sharedEnemyFunctions.die 
    enemy.move=Enemies.sharedEnemyFunctions.move 
    enemy.setNewMoveTarget=Enemies.sharedEnemyFunctions.setNewMoveTarget 
    enemy.wanderingAI=Enemies.sharedEnemyFunctions.wanderingAI 
    enemy.enterCombatRanged=Enemies.sharedEnemyFunctions.enterCombatRanged

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
            end
        )
        self.currentAnim=self.animations.idle 
        self.currentAnim:gotoFrame(love.math.random(1,4)) --start at random frame
        self.shadow=Shadows:newShadow('large') --shadow

        --enemy's current state metatable
        self.state={}
        self.state.facing='right'
        self.state.scaleX=1 --used to flip horizontally
        self.state.moving=false
        self.state.movingHorizontally=false 
        self.state.idle=true 
        self.state.inCombat=false 
        self.state.isTargetted=false --true when player is targeting this enemy
        self.state.willDie=false --true when enemy should die
        self.state.moveSpeed=400
        self.state.moveSpeedDiag=self.state.moveSpeed*0.61
        self.state.moveTarget={x=self.xPos,y=self.yPos} --where to move to
        self.state.nextMoveTargetTimer=1+love.math.random()*2 --sec until new target
        self.state.reachedMoveTarget=false --true as soon as enemy reaches target
        self.state.movingTimer=0 --tracks how long enemy has been moving toward target
        self.state.attackOnCooldown=false 

        --wait 1s before setting a moveTarget to allow enemy to be pushed out of other
        --colliders it may have spawned in
        TimerState:after(1,function() self.state.moveTarget={x=self.xPos,y=self.yPos} end)

        self.health={
            sprite=Enemies.sprites.healthbars.t3,
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

        --check if player is within aggro zone and in LOS
        if math.abs(self.xPos-Player.xPos)<200 
        and math.abs(self.yPos-Player.yPos)<150
        and #world:queryLine( 
            self.xPos,self.yPos,Player.xPos,Player.yPos,
            {'outerWall','innerWall','craftingNode'}
            )==0 
        then --if player is in range and LOS is clear, enter combat
            self.state.inCombat=true
        else 
            self.state.inCombat=false
            self.currentAnim=self.animations.idle
            self.animations.combat:pauseAtStart()
        end

        if self.state.inCombat then
            self:enterCombatRanged()
        else 
            self:wanderingAI()
        end
    end

    function enemy:draw()
        self.shadow:draw(self.xPos,self.yPos) --draw shadow
        self.currentAnim:draw(
            self.spriteSheet,self.xPos,self.yPos,nil,self.state.scaleX,1,16,29
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
    end

    enemy.updateHealth=Enemies.sharedEnemyFunctions.updateHealthFunction
    enemy.takeDamage=Enemies.sharedEnemyFunctions.takeDamage
    enemy.dropLoot=Enemies.sharedEnemyFunctions.dropLoot_t3
    enemy.die=Enemies.sharedEnemyFunctions.die 
    enemy.move=Enemies.sharedEnemyFunctions.move 
    enemy.setNewMoveTarget=Enemies.sharedEnemyFunctions.setNewMoveTarget 
    enemy.wanderingAI=Enemies.sharedEnemyFunctions.wanderingAI 
    enemy.enterCombatRanged=Enemies.sharedEnemyFunctions.enterCombatRanged

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
            end
        )
        self.currentAnim=self.animations.idle 
        self.currentAnim:gotoFrame(love.math.random(1,4)) --start at random frame
        self.shadow=Shadows:newShadow('large') --shadow

        --enemy's current state metatable
        self.state={}
        self.state.facing='right'
        self.state.scaleX=1 --used to flip horizontally
        self.state.moving=false
        self.state.movingHorizontally=false 
        self.state.idle=true 
        self.state.inCombat=false 
        self.state.isTargetted=false --true when player is targeting this enemy
        self.state.willDie=false --true when enemy should die
        self.state.moveSpeed=400
        self.state.moveSpeedDiag=self.state.moveSpeed*0.61
        self.state.moveTarget={x=self.xPos,y=self.yPos} --where to move to
        self.state.nextMoveTargetTimer=1+love.math.random()*2 --sec until new target
        self.state.reachedMoveTarget=false --true as soon as enemy reaches target
        self.state.movingTimer=0 --tracks how long enemy has been moving toward target
        self.state.attackOnCooldown=false 

        --wait 1s before setting a moveTarget to allow enemy to be pushed out of other
        --colliders it may have spawned in
        TimerState:after(1,function() self.state.moveTarget={x=self.xPos,y=self.yPos} end)

        self.health={
            sprite=Enemies.sprites.healthbars.t3,
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

        --check if player is within aggro zone and in LOS
        if math.abs(self.xPos-Player.xPos)<200 
        and math.abs(self.yPos-Player.yPos)<150
        and #world:queryLine( 
            self.xPos,self.yPos,Player.xPos,Player.yPos,
            {'outerWall','innerWall','craftingNode'}
            )==0 
        then --if player is in range and LOS is clear, enter combat
            self.state.inCombat=true
        else 
            self.state.inCombat=false
            self.currentAnim=self.animations.idle
            self.animations.combat:pauseAtStart()
        end

        if self.state.inCombat then
            self:enterCombatRanged()
        else 
            self:wanderingAI()
        end
    end

    function enemy:draw()
        self.shadow:draw(self.xPos,self.yPos) --draw shadow
        self.currentAnim:draw(
            self.spriteSheet,self.xPos,self.yPos,nil,self.state.scaleX,1,16,29
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
    end

    enemy.updateHealth=Enemies.sharedEnemyFunctions.updateHealthFunction
    enemy.takeDamage=Enemies.sharedEnemyFunctions.takeDamage    
    enemy.dropLoot=Enemies.sharedEnemyFunctions.dropLoot_t3
    enemy.die=Enemies.sharedEnemyFunctions.die 
    enemy.move=Enemies.sharedEnemyFunctions.move
    enemy.setNewMoveTarget=Enemies.sharedEnemyFunctions.setNewMoveTarget
    enemy.wanderingAI=Enemies.sharedEnemyFunctions.wanderingAI
    enemy.enterCombatRanged=Enemies.sharedEnemyFunctions.enterCombatRanged

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
