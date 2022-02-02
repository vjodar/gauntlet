Enemies={}

function Enemies:add_orc_t1(_x,_y)
    local enemy={} --create enemy instance
    function enemy:load() 
        --setup physics collider
        self.collider=world:newRectangleCollider(_x,_y,9,5)
        self.xPos, self.yPos = _x, _y
        self.xVel, self.yVel = 0,0
        self.collider:setLinearDamping(20)
        self.collider:setFixedRotation(true) --collider won't spin
        self.collider:setCollisionClass('enemy')
        self.collider:setObject(self) --attach collider to this object

        --sprites and animations
        self.spriteSheet=love.graphics.newImage('assets/orc_t1.png')
        self.grid=anim8.newGrid(16,16,self.spriteSheet:getWidth(),self.spriteSheet:getHeight())
        self.animations={} --animations table
        self.animations.idle=anim8.newAnimation(self.grid('1-4',1), 0.1)
        self.animations.moving=anim8.newAnimation(self.grid('5-8',1), 0.1)
        self.currentAnim=self.animations.idle 
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
        self.shadow:draw(self.xPos-5,self.yPos-3) --draw shadow
        if self.state.moving==true then 
            self.currentAnim=self.animations.moving 
        else 
            self.currentAnim=self.animations.idle
        end

        self.currentAnim:draw(self.spriteSheet,self.xPos,self.yPos,nil,1,1,8,14)
    end

    enemy:load() --initialize enemy
end

function Enemies:add_demon_t1(_x,_y)
    local enemy={} --create enemy instance
    function enemy:load() 
        --setup physics collider
        self.collider=world:newRectangleCollider(_x,_y,9,5)
        self.xPos, self.yPos = _x, _y
        self.xVel, self.yVel = 0,0
        self.collider:setLinearDamping(20)
        self.collider:setFixedRotation(true) --collider won't spin
        self.collider:setCollisionClass('enemy')
        self.collider:setObject(self) --attach collider to this object

        --sprites and animations
        self.spriteSheet=love.graphics.newImage('assets/demon_t1.png')
        self.grid=anim8.newGrid(16,16,self.spriteSheet:getWidth(),self.spriteSheet:getHeight())
        self.animations={} --animations table
        self.animations.idle=anim8.newAnimation(self.grid('1-4',1), 0.1)
        self.animations.moving=anim8.newAnimation(self.grid('5-8',1), 0.1)
        self.currentAnim=self.animations.idle 
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
        self.shadow:draw(self.xPos-5,self.yPos-3) --draw shadow
        if self.state.moving==true then 
            self.currentAnim=self.animations.moving 
        else 
            self.currentAnim=self.animations.idle
        end

        self.currentAnim:draw(self.spriteSheet,self.xPos,self.yPos,nil,1,1,8,14)
    end

    enemy:load() --initialize enemy
end

function Enemies:add_skeleton_t1(_x,_y)
    local enemy={} --create enemy instance
    function enemy:load() 
        --setup physics collider
        self.collider=world:newRectangleCollider(_x,_y,9,5)
        self.xPos, self.yPos = _x, _y
        self.xVel, self.yVel = 0,0
        self.collider:setLinearDamping(20)
        self.collider:setFixedRotation(true) --collider won't spin
        self.collider:setCollisionClass('enemy')
        self.collider:setObject(self) --attach collider to this object

        --sprites and animations
        self.spriteSheet=love.graphics.newImage('assets/skeleton_t1.png')
        self.grid=anim8.newGrid(16,16,self.spriteSheet:getWidth(),self.spriteSheet:getHeight())
        self.animations={} --animations table
        self.animations.idle=anim8.newAnimation(self.grid('1-4',1), 0.1)
        self.animations.moving=anim8.newAnimation(self.grid('5-8',1), 0.1)
        self.currentAnim=self.animations.idle 
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
        self.shadow:draw(self.xPos-6,self.yPos-3) --draw shadow
        if self.state.moving==true then 
            self.currentAnim=self.animations.moving 
        else 
            self.currentAnim=self.animations.idle
        end

        self.currentAnim:draw(self.spriteSheet,self.xPos,self.yPos,nil,1,1,8,14)
    end

    enemy:load() --initialize enemy
end

function Enemies:add_orc_t2(_x,_y)
    local enemy={} --create enemy instance
    function enemy:load() 
        --setup physics collider
        self.collider=world:newRectangleCollider(_x,_y,10,6)
        self.xPos, self.yPos = _x, _y
        self.xVel, self.yVel = 0,0
        self.collider:setLinearDamping(20)
        self.collider:setFixedRotation(true) --collider won't spin
        self.collider:setCollisionClass('enemy')
        self.collider:setObject(self) --attach collider to this object

        --sprites and animations
        self.spriteSheet=love.graphics.newImage('assets/orc_t2.png')
        self.grid=anim8.newGrid(16,17,self.spriteSheet:getWidth(),self.spriteSheet:getHeight())
        self.animations={} --animations table
        self.animations.idle=anim8.newAnimation(self.grid('1-4',1), 0.1)
        self.animations.moving=anim8.newAnimation(self.grid('5-8',1), 0.1)
        self.currentAnim=self.animations.idle 
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
        self.shadow:draw(self.xPos-6,self.yPos-3) --draw shadow
        if self.state.moving==true then 
            self.currentAnim=self.animations.moving 
        else 
            self.currentAnim=self.animations.idle
        end

        self.currentAnim:draw(self.spriteSheet,self.xPos,self.yPos,nil,1,1,9,15)
    end

    enemy:load() --initialize enemy
end

function Enemies:add_demon_t2(_x,_y)
    local enemy={} --create enemy instance
    function enemy:load() 
        --setup physics collider
        self.collider=world:newRectangleCollider(_x,_y,11,6)
        self.xPos, self.yPos = _x, _y
        self.xVel, self.yVel = 0,0
        self.collider:setLinearDamping(20)
        self.collider:setFixedRotation(true) --collider won't spin
        self.collider:setCollisionClass('enemy')
        self.collider:setObject(self) --attach collider to this object

        --sprites and animations
        self.spriteSheet=love.graphics.newImage('assets/demon_t2.png')
        self.grid=anim8.newGrid(16,23,self.spriteSheet:getWidth(),self.spriteSheet:getHeight())
        self.animations={} --animations table
        self.animations.idle=anim8.newAnimation(self.grid('1-4',1), 0.1)
        self.animations.moving=anim8.newAnimation(self.grid('5-8',1), 0.1)
        self.currentAnim=self.animations.idle 
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
        self.shadow:draw(self.xPos-6,self.yPos-3) --draw shadow
        if self.state.moving==true then 
            self.currentAnim=self.animations.moving 
        else 
            self.currentAnim=self.animations.idle
        end

        self.currentAnim:draw(self.spriteSheet,self.xPos,self.yPos,nil,1,1,8,21)
    end

    enemy:load() --initialize enemy
end

function Enemies:add_mage_t2(_x,_y)
    local enemy={} --create enemy instance
    function enemy:load() 
        --setup physics collider
        self.collider=world:newRectangleCollider(_x,_y,12,6)
        self.xPos, self.yPos = _x, _y
        self.xVel, self.yVel = 0,0
        self.collider:setLinearDamping(20)
        self.collider:setFixedRotation(true) --collider won't spin
        self.collider:setCollisionClass('enemy')
        self.collider:setObject(self) --attach collider to this object

        --sprites and animations
        --Mage idle/moving animations are the same
        self.spriteSheet=love.graphics.newImage('assets/mage_t2.png')
        self.grid=anim8.newGrid(16,24,self.spriteSheet:getWidth(),self.spriteSheet:getHeight())
        self.animations={} --animations table
        self.animations.idle=anim8.newAnimation(self.grid('1-4',1), 0.1)
        self.currentAnim=self.animations.idle 
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
        self.shadow:draw(self.xPos-7,self.yPos-3) --draw shadow
        if self.state.moving==true then 
            self.currentAnim=self.animations.moving 
        else 
            self.currentAnim=self.animations.idle
        end

        self.currentAnim:draw(self.spriteSheet,self.xPos,self.yPos,nil,1,1,7,22)
    end

    enemy:load() --initialize enemy
end

function Enemies:add_orc_t3(_x,_y)
    local enemy={} --create enemy instance
    function enemy:load() 
        --setup physics collider
        self.collider=world:newRectangleCollider(_x,_y,19,8)
        self.xPos, self.yPos = _x, _y
        self.xVel, self.yVel = 0,0
        self.collider:setLinearDamping(20)
        self.collider:setFixedRotation(true) --collider won't spin
        self.collider:setCollisionClass('enemy')
        self.collider:setObject(self) --attach collider to this object

        --sprites and animations
        self.spriteSheet=love.graphics.newImage('assets/orc_t3.png')
        self.grid=anim8.newGrid(32,32,self.spriteSheet:getWidth(),self.spriteSheet:getHeight())
        self.animations={} --animations table
        self.animations.idle=anim8.newAnimation(self.grid('1-4',1), 0.1)
        self.animations.moving=anim8.newAnimation(self.grid('5-8',1), 0.1)
        self.currentAnim=self.animations.idle 
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
        self.shadow:draw(self.xPos-11,self.yPos-4) --draw shadow
        if self.state.moving==true then 
            self.currentAnim=self.animations.moving 
        else 
            self.currentAnim=self.animations.idle
        end

        self.currentAnim:draw(self.spriteSheet,self.xPos,self.yPos,nil,1,1,16,29)
    end

    enemy:load() --initialize enemy
end

function Enemies:add_demon_t3(_x,_y)
    local enemy={} --create enemy instance
    function enemy:load() 
        --setup physics collider
        self.collider=world:newRectangleCollider(_x,_y,19,8)
        self.xPos, self.yPos = _x, _y
        self.xVel, self.yVel = 0,0
        self.collider:setLinearDamping(20)
        self.collider:setFixedRotation(true) --collider won't spin
        self.collider:setCollisionClass('enemy')
        self.collider:setObject(self) --attach collider to this object

        --sprites and animations
        self.spriteSheet=love.graphics.newImage('assets/demon_t3.png')
        self.grid=anim8.newGrid(32,32,self.spriteSheet:getWidth(),self.spriteSheet:getHeight())
        self.animations={} --animations table
        self.animations.idle=anim8.newAnimation(self.grid('1-4',1), 0.1)
        self.animations.moving=anim8.newAnimation(self.grid('5-8',1), 0.1)
        self.currentAnim=self.animations.idle 
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
        self.shadow:draw(self.xPos-11,self.yPos-4) --draw shadow
        if self.state.moving==true then 
            self.currentAnim=self.animations.moving 
        else 
            self.currentAnim=self.animations.idle
        end

        self.currentAnim:draw(self.spriteSheet,self.xPos,self.yPos,nil,1,1,16,29)
    end

    enemy:load() --initialize enemy
end
