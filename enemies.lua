Enemies={}

function Enemies:load()
    self.spriteSheets={} --stores spriteSheets of enemies
    self.spriteSheets.orcT1=love.graphics.newImage('assets/orc_t1.png')
    self.spriteSheets.demonT1=love.graphics.newImage('assets/demon_t1.png')
    self.spriteSheets.skeletonT1=love.graphics.newImage('assets/skeleton_t1.png')
    self.spriteSheets.orcT2=love.graphics.newImage('assets/orc_t2.png')
    self.spriteSheets.demonT2=love.graphics.newImage('assets/demon_t2.png')
    self.spriteSheets.mageT2=love.graphics.newImage('assets/mage_t2.png')
    self.spriteSheets.orcT3=love.graphics.newImage('assets/orc_t3.png')
    self.spriteSheets.demonT3=love.graphics.newImage('assets/demon_t3.png')
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

        --insert enemy into entitiesTable
        table.insert(Entities.entitiesTable,self) 
    end

    function enemy:update() 
        --update vectors
        self.xPos, self.yPos=self.collider:getPosition()
        self.xVel, self.yVel=self.collider:getLinearVelocity()

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
        if self.state.moving==true then 
            self.currentAnim=self.animations.moving 
        else 
            self.currentAnim=self.animations.idle
        end

        self.currentAnim:draw(self.spriteSheet,self.xPos,self.yPos,nil,1,1,8,14)
    end

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

        --insert enemy into entitiesTable
        table.insert(Entities.entitiesTable,self) 
    end

    function enemy:update() 
        --update vectors
        self.xPos, self.yPos=self.collider:getPosition()
        self.xVel, self.yVel=self.collider:getLinearVelocity()

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
        if self.state.moving==true then 
            self.currentAnim=self.animations.moving 
        else 
            self.currentAnim=self.animations.idle
        end

        self.currentAnim:draw(self.spriteSheet,self.xPos,self.yPos,nil,1,1,8,14)
    end

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

        --insert enemy into entitiesTable
        table.insert(Entities.entitiesTable,self) 
    end

    function enemy:update() 
        --update vectors
        self.xPos, self.yPos=self.collider:getPosition()
        self.xVel, self.yVel=self.collider:getLinearVelocity()

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
        if self.state.moving==true then 
            self.currentAnim=self.animations.moving 
        else 
            self.currentAnim=self.animations.idle
        end

        self.currentAnim:draw(self.spriteSheet,self.xPos,self.yPos,nil,1,1,8,14)
    end

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

        --insert enemy into entitiesTable
        table.insert(Entities.entitiesTable,self) 
    end

    function enemy:update() 
        --update vectors
        self.xPos, self.yPos=self.collider:getPosition()
        self.xVel, self.yVel=self.collider:getLinearVelocity()

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
        if self.state.moving==true then 
            self.currentAnim=self.animations.moving 
        else 
            self.currentAnim=self.animations.idle
        end

        self.currentAnim:draw(self.spriteSheet,self.xPos,self.yPos,nil,1,1,9,15)
    end

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

        --insert enemy into entitiesTable
        table.insert(Entities.entitiesTable,self) 
    end

    function enemy:update() 
        --update vectors
        self.xPos, self.yPos=self.collider:getPosition()
        self.xVel, self.yVel=self.collider:getLinearVelocity()

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
        if self.state.moving==true then 
            self.currentAnim=self.animations.moving 
        else 
            self.currentAnim=self.animations.idle
        end

        self.currentAnim:draw(self.spriteSheet,self.xPos,self.yPos,nil,1,1,8,21)
    end

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

        --insert enemy into entitiesTable
        table.insert(Entities.entitiesTable,self) 
    end

    function enemy:update() 
        --update vectors
        self.xPos, self.yPos=self.collider:getPosition()
        self.xVel, self.yVel=self.collider:getLinearVelocity()

        --update animation
        self.currentAnim:update(dt)
    end

    function enemy:draw()
        self.shadow:draw(self.xPos,self.yPos) --draw shadow
        if self.state.moving==true then 
            self.currentAnim=self.animations.moving 
        else 
            self.currentAnim=self.animations.idle
        end

        self.currentAnim:draw(self.spriteSheet,self.xPos,self.yPos,nil,1,1,7,22)
    end

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

        --insert enemy into entitiesTable
        table.insert(Entities.entitiesTable,self) 
    end

    function enemy:update() 
        --update vectors
        self.xPos, self.yPos=self.collider:getPosition()
        self.xVel, self.yVel=self.collider:getLinearVelocity()

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
        if self.state.moving==true then 
            self.currentAnim=self.animations.moving 
        else 
            self.currentAnim=self.animations.idle
        end

        self.currentAnim:draw(self.spriteSheet,self.xPos,self.yPos,nil,1,1,16,29)
    end

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

        --insert enemy into entitiesTable
        table.insert(Entities.entitiesTable,self) 
    end

    function enemy:update() 
        --update vectors
        self.xPos, self.yPos=self.collider:getPosition()
        self.xVel, self.yVel=self.collider:getLinearVelocity()

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
        if self.state.moving==true then 
            self.currentAnim=self.animations.moving 
        else 
            self.currentAnim=self.animations.idle
        end

        self.currentAnim:draw(self.spriteSheet,self.xPos,self.yPos,nil,1,1,16,29)
    end

    enemy:load() --initialize enemy
end

--takes a spawn area and fills it with a random number of random T1 enemies
function Enemies:fillRoomT1(spawnZone)
    for i=1,3 do 
        --spawn 3 random T1 enemies inside the spawn zone
        self.enemySpawner.t1[love.math.random(3)](
            love.math.random(spawnZone.x1,spawnZone.x2),
            love.math.random(spawnZone.y1,spawnZone.y2)
        )
    end
end

--takes a spawn area and fills it with a random number of random T2 enemies
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
