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

    self.sharedEnemyFunctions={} --functions shared by all enemies

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
        --if player is still targeting enemy at this point, stop targeting it
        if Player.combatData.currentEnemy==_enemy then 
            Player.combatData.currentEnemy=nil 
        end 
        _enemy.collider:destroy() --destroy collider
        return false --return false to remove entity from game
    end
end

--holds spawn functions for each tier of enemy
Enemies.enemySpawner={t1={}, t2={}, t3={}}

Enemies.enemySpawner.t1[1]=function(_x,_y) --spawn orc_t1
    local enemy={} --create enemy instance
    function enemy:load() 
        --setup physics collider
        self.collider=world:newRectangleCollider(_x,_y,9,5)
        self.xPos, self.yPos = _x, _y
        self.xVel, self.yVel = 0,0
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
        self.state.moving=false
        self.state.isTargetted=false --true when player is targeting this enemy

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

        self:updateHealth() --update healthbar

        if self.state.willDie then return self:die() end

        if math.abs(self.xVel)<10 and math.abs(self.yVel)<10 then 
            self.state.moving=false 
            self.currentAnim=self.animations.idle
        else 
            self.state.moving=true 
            self.currentAnim=self.animations.moving 
        end

        --update animation
        self.currentAnim:update(dt)
    end

    function enemy:draw()
        self.shadow:draw(self.xPos,self.yPos) --draw shadow
        self.currentAnim:draw(self.spriteSheet,self.xPos,self.yPos,nil,1,1,8,14)
    end

    function enemy:drawUIelements() --called by UI
        if self.state.isTargetted then --draw health when targetted
            love.graphics.draw(self.health.sprite,self.xPos-6,self.yPos-16)
            --draw remaining health
            love.graphics.setColor(self.health.RGB.red,self.health.RGB.green,self.health.RGB.blue)
            love.graphics.rectangle(
                'fill',self.xPos-5,self.yPos-15,
                self.health.currentShown*0.5,1)
            love.graphics.setColor(1,1,1)
        end
    end

    enemy.updateHealth=Enemies.sharedEnemyFunctions.updateHealthFunction
    enemy.takeDamage=Enemies.sharedEnemyFunctions.takeDamage
    enemy.die=Enemies.sharedEnemyFunctions.die 

    enemy:load() --initialize enemy
end

Enemies.enemySpawner.t1[2]=function(_x,_y) --spawn demon_t1
    local enemy={} --create enemy instance
    function enemy:load() 
        --setup physics collider
        self.collider=world:newRectangleCollider(_x,_y,9,5)
        self.xPos, self.yPos = _x, _y
        self.xVel, self.yVel = 0,0
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
        self.state.moving=false
        self.state.isTargetted=false --true when player is targeting this enemy

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

        self:updateHealth() --update healthbar

        if self.state.willDie then return self:die() end

        if math.abs(self.xVel)<10 and math.abs(self.yVel)<10 then 
            self.state.moving=false 
            self.currentAnim=self.animations.idle
        else 
            self.state.moving=true 
            self.currentAnim=self.animations.moving 
        end

        --update animation
        self.currentAnim:update(dt)
    end

    function enemy:draw()
        self.shadow:draw(self.xPos,self.yPos) --draw shadow
        self.currentAnim:draw(self.spriteSheet,self.xPos,self.yPos,nil,1,1,8,14)
    end

    function enemy:drawUIelements() --called by UI
        if self.state.isTargetted then --draw health when targetted
            love.graphics.draw(self.health.sprite,self.xPos-6,self.yPos-16)
            --draw remaining health
            love.graphics.setColor(self.health.RGB.red,self.health.RGB.green,self.health.RGB.blue)
            love.graphics.rectangle(
                'fill',self.xPos-5,self.yPos-15,
                self.health.currentShown*0.5,1)
            love.graphics.setColor(1,1,1)
        end
    end

    enemy.updateHealth=Enemies.sharedEnemyFunctions.updateHealthFunction
    enemy.takeDamage=Enemies.sharedEnemyFunctions.takeDamage
    enemy.die=Enemies.sharedEnemyFunctions.die 

    enemy:load() --initialize enemy
end

Enemies.enemySpawner.t1[3]=function(_x,_y) --spawn skeleton_t1
    local enemy={} --create enemy instance
    function enemy:load() 
        --setup physics collider
        self.collider=world:newRectangleCollider(_x,_y,9,5)
        self.xPos, self.yPos = _x, _y
        self.xVel, self.yVel = 0,0
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
        self.state.moving=false
        self.state.isTargetted=false --true when player is targeting this enemy

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

        self:updateHealth() --update healthbar

        if self.state.willDie then return self:die() end

        if math.abs(self.xVel)<10 and math.abs(self.yVel)<10 then 
            self.state.moving=false 
            self.currentAnim=self.animations.idle
        else 
            self.state.moving=true 
            self.currentAnim=self.animations.moving 
        end

        --update animation
        self.currentAnim:update(dt)
    end

    function enemy:draw()
        self.shadow:draw(self.xPos,self.yPos) --draw shadow
        self.currentAnim:draw(self.spriteSheet,self.xPos,self.yPos,nil,1,1,8,14)
    end

    function enemy:drawUIelements() --called by UI
        if self.state.isTargetted then --draw health when targetted
            love.graphics.draw(self.health.sprite,self.xPos-6.5,self.yPos-22)
            --draw remaining health
            love.graphics.setColor(self.health.RGB.red,self.health.RGB.green,self.health.RGB.blue)
            love.graphics.rectangle(
                'fill',self.xPos-5.5,self.yPos-21,
                self.health.currentShown*0.5,1)
            love.graphics.setColor(1,1,1)
        end
    end

    enemy.updateHealth=Enemies.sharedEnemyFunctions.updateHealthFunction
    enemy.takeDamage=Enemies.sharedEnemyFunctions.takeDamage
    enemy.die=Enemies.sharedEnemyFunctions.die 

    enemy:load() --initialize enemy
end

Enemies.enemySpawner.t2[1]=function(_x,_y) --spawn orc_t2
    local enemy={} --create enemy instance
    function enemy:load() 
        --setup physics collider
        self.collider=world:newRectangleCollider(_x,_y,10,6)
        self.xPos, self.yPos = _x, _y
        self.xVel, self.yVel = 0,0
        self.name='orc_t2'
        self.collider:setLinearDamping(20)
        self.collider:setFixedRotation(true) --collider won't spin
        self.collider:setCollisionClass('enemy')
        self.collider:setObject(self) --attach collider to this object

        --sprites and animations
        self.spriteSheet=Enemies.spriteSheets.orcT2
        self.grid=anim8.newGrid(16,17,self.spriteSheet:getWidth(),self.spriteSheet:getHeight())
        self.animations={} --animations table
        self.animations.idle=anim8.newAnimation(self.grid('1-4',1), 0.1)
        self.animations.moving=anim8.newAnimation(self.grid('5-8',1), 0.1)
        self.currentAnim=self.animations.idle 
        self.currentAnim:gotoFrame(love.math.random(1,4)) --start at random frame
        self.shadow=Shadows:newShadow('small') --shadow

        --enemy's current state metatable
        self.state={}
        self.state.facing='right'
        self.state.moving=false
        self.state.isTargetted=false --true when player is targeting this enemy

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

        self:updateHealth() --update healthbar

        if self.state.willDie then return self:die() end

        if math.abs(self.xVel)<10 and math.abs(self.yVel)<10 then 
            self.state.moving=false 
            self.currentAnim=self.animations.idle
        else 
            self.state.moving=true 
            self.currentAnim=self.animations.moving 
        end

        --update animation
        self.currentAnim:update(dt)
    end

    function enemy:draw()
        self.shadow:draw(self.xPos,self.yPos) --draw shadow
        self.currentAnim:draw(self.spriteSheet,self.xPos,self.yPos,nil,1,1,9,15)
    end

    function enemy:drawUIelements() --called by UI
        if self.state.isTargetted then --draw health when targetted
            love.graphics.draw(self.health.sprite,self.xPos-13,self.yPos-20)
            --draw remaining health
            love.graphics.setColor(self.health.RGB.red,self.health.RGB.green,self.health.RGB.blue)
            love.graphics.rectangle(
                'fill',self.xPos-12,self.yPos-19,
                self.health.currentShown*0.5,1)
            love.graphics.setColor(1,1,1)
        end
    end

    enemy.updateHealth=Enemies.sharedEnemyFunctions.updateHealthFunction
    enemy.takeDamage=Enemies.sharedEnemyFunctions.takeDamage
    enemy.die=Enemies.sharedEnemyFunctions.die 

    enemy:load() --initialize enemy
end

Enemies.enemySpawner.t2[2]=function(_x,_y) --spawn demon_t2
    local enemy={} --create enemy instance
    function enemy:load() 
        --setup physics collider
        self.collider=world:newRectangleCollider(_x,_y,11,6)
        self.xPos, self.yPos = _x, _y
        self.xVel, self.yVel = 0,0
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
        self.state.moving=false
        self.state.isTargetted=false --true when player is targeting this enemy

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

        self:updateHealth() --update healthbar

        if self.state.willDie then return self:die() end

        if math.abs(self.xVel)<10 and math.abs(self.yVel)<10 then 
            self.state.moving=false 
            self.currentAnim=self.animations.idle
        else 
            self.state.moving=true 
            self.currentAnim=self.animations.moving 
        end

        --update animation
        self.currentAnim:update(dt)
    end

    function enemy:draw()
        self.shadow:draw(self.xPos,self.yPos) --draw shadow
        self.currentAnim:draw(self.spriteSheet,self.xPos,self.yPos,nil,1,1,8,21)
    end

    function enemy:drawUIelements() --called by UI
        if self.state.isTargetted then --draw health when targetted
            love.graphics.draw(self.health.sprite,self.xPos-13,self.yPos-25)
            --draw remaining health
            love.graphics.setColor(self.health.RGB.red,self.health.RGB.green,self.health.RGB.blue)
            love.graphics.rectangle(
                'fill',self.xPos-12,self.yPos-24,
                self.health.currentShown*0.5,1)
            love.graphics.setColor(1,1,1)
        end
    end

    enemy.updateHealth=Enemies.sharedEnemyFunctions.updateHealthFunction
    enemy.takeDamage=Enemies.sharedEnemyFunctions.takeDamage
    enemy.die=Enemies.sharedEnemyFunctions.die 

    enemy:load() --initialize enemy
end

Enemies.enemySpawner.t2[3]=function(_x,_y) --spawn mage_t2
    local enemy={} --create enemy instance
    function enemy:load() 
        --setup physics collider
        self.collider=world:newRectangleCollider(_x,_y,12,6)
        self.xPos, self.yPos = _x, _y
        self.xVel, self.yVel = 0,0
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
        self.animations.idle=anim8.newAnimation(self.grid('1-4',1), 0.1)
        self.currentAnim=self.animations.idle 
        self.currentAnim:gotoFrame(love.math.random(1,4)) --start at random frame
        self.shadow=Shadows:newShadow('medium') --shadow

        --enemy's current state metatable
        self.state={}
        self.state.facing='right'
        self.state.isTargetted=false --true when player is targeting this enemy

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

        self:updateHealth() --update healthbar

        if self.state.willDie then return self:die() end

        if math.abs(self.xVel)<10 and math.abs(self.yVel)<10 then 
            self.state.moving=false 
        else 
            self.state.moving=true 
        end

        --update animation
        self.currentAnim:update(dt)
    end

    function enemy:draw()
        self.shadow:draw(self.xPos,self.yPos) --draw shadow
        self.currentAnim:draw(self.spriteSheet,self.xPos,self.yPos,nil,1,1,7,22)
    end

    function enemy:drawUIelements() --called by UI
        if self.state.isTargetted then --draw health when targetted
            love.graphics.draw(self.health.sprite,self.xPos-13,self.yPos-22)
            --draw remaining health
            love.graphics.setColor(self.health.RGB.red,self.health.RGB.green,self.health.RGB.blue)
            love.graphics.rectangle(
                'fill',self.xPos-12,self.yPos-21,
                self.health.currentShown*0.5,1)
            love.graphics.setColor(1,1,1)
        end
    end

    enemy.updateHealth=Enemies.sharedEnemyFunctions.updateHealthFunction
    enemy.takeDamage=Enemies.sharedEnemyFunctions.takeDamage
    enemy.die=Enemies.sharedEnemyFunctions.die 

    enemy:load() --initialize enemy
end

Enemies.enemySpawner.t3[1]=function(_x,_y) --spawn orc_t3
    local enemy={} --create enemy instance
    function enemy:load() 
        --setup physics collider
        self.collider=world:newRectangleCollider(_x,_y,19,8)
        self.xPos, self.yPos = _x, _y
        self.xVel, self.yVel = 0,0
        self.name='orc_t3'
        self.collider:setLinearDamping(20)
        self.collider:setFixedRotation(true) --collider won't spin
        self.collider:setCollisionClass('enemy')
        self.collider:setObject(self) --attach collider to this object

        --sprites and animations
        self.spriteSheet=Enemies.spriteSheets.orcT3
        self.grid=anim8.newGrid(32,32,self.spriteSheet:getWidth(),self.spriteSheet:getHeight())
        self.animations={} --animations table
        self.animations.idle=anim8.newAnimation(self.grid('1-4',1), 0.1)
        self.animations.moving=anim8.newAnimation(self.grid('5-8',1), 0.1)
        self.currentAnim=self.animations.idle 
        self.currentAnim:gotoFrame(love.math.random(1,4)) --start at random frame
        self.shadow=Shadows:newShadow('large') --shadow

        --enemy's current state metatable
        self.state={}
        self.state.facing='right'
        self.state.moving=false
        self.state.isTargetted=false --true when player is targeting this enemy

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

        self:updateHealth() --update healthbar

        if self.state.willDie then return self:die() end

        if math.abs(self.xVel)<10 and math.abs(self.yVel)<10 then 
            self.state.moving=false 
            self.currentAnim=self.animations.idle
        else 
            self.state.moving=true 
            self.currentAnim=self.animations.moving 
        end

        --update animation
        self.currentAnim:update(dt)
    end

    function enemy:draw()
        self.shadow:draw(self.xPos,self.yPos) --draw shadow
        self.currentAnim:draw(self.spriteSheet,self.xPos,self.yPos,nil,1,1,16,29)
    end

    function enemy:drawUIelements() --called by UI
        if self.state.isTargetted then --draw health when targetted
            love.graphics.draw(self.health.sprite,self.xPos-25,self.yPos-32)
            --draw remaining health
            love.graphics.setColor(self.health.RGB.red,self.health.RGB.green,self.health.RGB.blue)
            love.graphics.rectangle(
                'fill',self.xPos-24,self.yPos-31,
                self.health.currentShown*0.5,1)
            love.graphics.setColor(1,1,1)
        end
    end

    enemy.updateHealth=Enemies.sharedEnemyFunctions.updateHealthFunction
    enemy.takeDamage=Enemies.sharedEnemyFunctions.takeDamage
    enemy.die=Enemies.sharedEnemyFunctions.die 

    enemy:load() --initialize enemy
end

Enemies.enemySpawner.t3[2]=function(_x,_y) --spawn demon_t3
    local enemy={} --create enemy instance
    function enemy:load() 
        --setup physics collider
        self.collider=world:newRectangleCollider(_x,_y,19,8)
        self.xPos, self.yPos = _x, _y
        self.xVel, self.yVel = 0,0
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
        self.currentAnim=self.animations.idle 
        self.currentAnim:gotoFrame(love.math.random(1,4)) --start at random frame
        self.shadow=Shadows:newShadow('large') --shadow

        --enemy's current state metatable
        self.state={}
        self.state.facing='right'
        self.state.moving=false
        self.state.isTargetted=false --true when player is targeting this enemy
        self.state.willDie=false --true when enemy should die

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

        self:updateHealth() --update health

        if self.state.willDie then return self:die() end

        if math.abs(self.xVel)<10 and math.abs(self.yVel)<10 then 
            self.state.moving=false 
            self.currentAnim=self.animations.idle
        else 
            self.state.moving=true 
            self.currentAnim=self.animations.moving 
        end

        --update animation
        self.currentAnim:update(dt)
    end

    function enemy:draw()
        self.shadow:draw(self.xPos,self.yPos) --draw shadow
        self.currentAnim:draw(self.spriteSheet,self.xPos,self.yPos,nil,1,1,16,29)
    end

    function enemy:drawUIelements() --called by UI
        if self.state.isTargetted then --draw health when targetted
            love.graphics.draw(self.health.sprite,self.xPos-25,self.yPos-32)
            --draw remaining health
            love.graphics.setColor(self.health.RGB.red,self.health.RGB.green,self.health.RGB.blue)
            love.graphics.rectangle(
                'fill',self.xPos-24,self.yPos-31,
                self.health.currentShown*0.5,1)
            love.graphics.setColor(1,1,1)
        end
    end

    enemy.updateHealth=Enemies.sharedEnemyFunctions.updateHealthFunction
    enemy.takeDamage=Enemies.sharedEnemyFunctions.takeDamage
    enemy.die=Enemies.sharedEnemyFunctions.die 

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
