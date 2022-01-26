Enemies={}

function Enemies:load()
    self.enemiesTable={} --stores enemies
end

function Enemies:update()
    for k, enemy in pairs(self.enemiesTable) do 
        enemy:update()
    end
end

function Enemies:draw()
    for k, enemy in pairs(self.enemiesTable) do 
        enemy:draw()
    end
end

function Enemies:add_orc_t1(_x,_y)
    local enemy={} --create enemy instance
    function enemy:load() 
        --setip physics collider
        self.collider=world:newRectangleCollider(_x,_y,9,9)
        self.xPos, self.yPos = _x, _y
        self.xVel, self.yVel = 0,0
        self.collider:setLinearDamping(20)
        self.collider:setFixedRotation(true) --collider won't spin

        --sprites and animations
        self.spriteSheet=love.graphics.newImage('assets/orc_t1.png')
        self.grid=anim8.newGrid(16,16,self.spriteSheet:getWidth(),self.spriteSheet:getHeight())
        self.animations={} --animations table
        self.animations.idle=anim8.newAnimation(self.grid('1-4',1), 0.1)
        self.animations.moving=anim8.newAnimation(self.grid('5-8',1), 0.1)
        self.currentAnim=self.animations.idle 

        --enemy's current state metatable
        self.state={}
        self.state.facing='right'
        self.state.moving=false

        table.insert(Enemies.enemiesTable,self) --insert enemy into enemiesTable
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
        if self.state.moving==true then 
            self.currentAnim=self.animations.moving 
        else 
            self.currentAnim=self.animations.idle
        end

        self.currentAnim:draw(self.spriteSheet,self.xPos,self.yPos,nil,1,1,8,10)
    end

    enemy:load() --initialize enemy
end

function Enemies:add_demon_t1(_x,_y)
    local enemy={} --create enemy instance
    function enemy:load() 
        --setip physics collider
        self.collider=world:newRectangleCollider(_x,_y,9,9)
        self.xPos, self.yPos = _x, _y
        self.xVel, self.yVel = 0,0
        self.collider:setLinearDamping(20)
        self.collider:setFixedRotation(true) --collider won't spin

        --sprites and animations
        self.spriteSheet=love.graphics.newImage('assets/demon_t1.png')
        self.grid=anim8.newGrid(16,16,self.spriteSheet:getWidth(),self.spriteSheet:getHeight())
        self.animations={} --animations table
        self.animations.idle=anim8.newAnimation(self.grid('1-4',1), 0.1)
        self.animations.moving=anim8.newAnimation(self.grid('5-8',1), 0.1)
        self.currentAnim=self.animations.idle 

        --enemy's current state metatable
        self.state={}
        self.state.facing='right'
        self.state.moving=false

        table.insert(Enemies.enemiesTable,self) --insert enemy into enemiesTable
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
        if self.state.moving==true then 
            self.currentAnim=self.animations.moving 
        else 
            self.currentAnim=self.animations.idle
        end

        self.currentAnim:draw(self.spriteSheet,self.xPos,self.yPos,nil,1,1,8,10)
    end

    enemy:load() --initialize enemy
end

function Enemies:add_skeleton_t1(_x,_y)
    local enemy={} --create enemy instance
    function enemy:load() 
        --setip physics collider
        self.collider=world:newRectangleCollider(_x,_y,9,14)
        self.xPos, self.yPos = _x, _y
        self.xVel, self.yVel = 0,0
        self.collider:setLinearDamping(20)
        self.collider:setFixedRotation(true) --collider won't spin

        --sprites and animations
        self.spriteSheet=love.graphics.newImage('assets/skeleton_t1.png')
        self.grid=anim8.newGrid(16,16,self.spriteSheet:getWidth(),self.spriteSheet:getHeight())
        self.animations={} --animations table
        self.animations.idle=anim8.newAnimation(self.grid('1-4',1), 0.1)
        self.animations.moving=anim8.newAnimation(self.grid('5-8',1), 0.1)
        self.currentAnim=self.animations.idle 

        --enemy's current state metatable
        self.state={}
        self.state.facing='right'
        self.state.moving=false

        table.insert(Enemies.enemiesTable,self) --insert enemy into enemiesTable
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
        if self.state.moving==true then 
            self.currentAnim=self.animations.moving 
        else 
            self.currentAnim=self.animations.idle
        end

        self.currentAnim:draw(self.spriteSheet,self.xPos,self.yPos,nil,1,1,8,8)
    end

    enemy:load() --initialize enemy
end

function Enemies:add_orc_t2(_x,_y)
    local enemy={} --create enemy instance
    function enemy:load() 
        --setip physics collider
        self.collider=world:newRectangleCollider(_x,_y,10,15)
        self.xPos, self.yPos = _x, _y
        self.xVel, self.yVel = 0,0
        self.collider:setLinearDamping(20)
        self.collider:setFixedRotation(true) --collider won't spin

        --sprites and animations
        self.spriteSheet=love.graphics.newImage('assets/orc_t2.png')
        self.grid=anim8.newGrid(16,17,self.spriteSheet:getWidth(),self.spriteSheet:getHeight())
        self.animations={} --animations table
        self.animations.idle=anim8.newAnimation(self.grid('1-4',1), 0.1)
        self.animations.moving=anim8.newAnimation(self.grid('5-8',1), 0.1)
        self.currentAnim=self.animations.idle 

        --enemy's current state metatable
        self.state={}
        self.state.facing='right'
        self.state.moving=false

        table.insert(Enemies.enemiesTable,self) --insert enemy into enemiesTable
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
        if self.state.moving==true then 
            self.currentAnim=self.animations.moving 
        else 
            self.currentAnim=self.animations.idle
        end

        self.currentAnim:draw(self.spriteSheet,self.xPos,self.yPos,nil,1,1,9,9)
    end

    enemy:load() --initialize enemy
end

function Enemies:add_demon_t2(_x,_y)
    local enemy={} --create enemy instance
    function enemy:load() 
        --setip physics collider
        self.collider=world:newRectangleCollider(_x,_y,10,17)
        self.xPos, self.yPos = _x, _y
        self.xVel, self.yVel = 0,0
        self.collider:setLinearDamping(20)
        self.collider:setFixedRotation(true) --collider won't spin

        --sprites and animations
        self.spriteSheet=love.graphics.newImage('assets/demon_t2.png')
        self.grid=anim8.newGrid(16,23,self.spriteSheet:getWidth(),self.spriteSheet:getHeight())
        self.animations={} --animations table
        self.animations.idle=anim8.newAnimation(self.grid('1-4',1), 0.1)
        self.animations.moving=anim8.newAnimation(self.grid('5-8',1), 0.1)
        self.currentAnim=self.animations.idle 

        --enemy's current state metatable
        self.state={}
        self.state.facing='right'
        self.state.moving=false

        table.insert(Enemies.enemiesTable,self) --insert enemy into enemiesTable
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
        if self.state.moving==true then 
            self.currentAnim=self.animations.moving 
        else 
            self.currentAnim=self.animations.idle
        end

        self.currentAnim:draw(self.spriteSheet,self.xPos,self.yPos,nil,1,1,7,13)
    end

    enemy:load() --initialize enemy
end

function Enemies:add_mage_t2(_x,_y)
    local enemy={} --create enemy instance
    function enemy:load() 
        --setip physics collider
        self.collider=world:newRectangleCollider(_x,_y,12,15)
        self.xPos, self.yPos = _x, _y
        self.xVel, self.yVel = 0,0
        self.collider:setLinearDamping(20)
        self.collider:setFixedRotation(true) --collider won't spin

        --sprites and animations
        --Mage idle/moving animations are the same
        self.spriteSheet=love.graphics.newImage('assets/mage_t2.png')
        self.grid=anim8.newGrid(16,24,self.spriteSheet:getWidth(),self.spriteSheet:getHeight())
        self.animations={} --animations table
        self.animations.idle=anim8.newAnimation(self.grid('1-4',1), 0.1)
        self.currentAnim=self.animations.idle 

        --enemy's current state metatable
        self.state={}
        self.state.facing='right'

        table.insert(Enemies.enemiesTable,self) --insert enemy into enemiesTable
    end

    function enemy:update() 
        --update vectors
        self.xPos, self.yPos=self.collider:getPosition()
        self.xVel, self.yVel=self.collider:getLinearVelocity()

        --update animation
        self.currentAnim:update(dt)
    end

    function enemy:draw()
        if self.state.moving==true then 
            self.currentAnim=self.animations.moving 
        else 
            self.currentAnim=self.animations.idle
        end

        self.currentAnim:draw(self.spriteSheet,self.xPos,self.yPos,nil,1,1,7,15)
    end

    enemy:load() --initialize enemy
end

function Enemies:add_orc_t3(_x,_y)
    local enemy={} --create enemy instance
    function enemy:load() 
        --setip physics collider
        self.collider=world:newRectangleCollider(_x,_y,19,25)
        self.xPos, self.yPos = _x, _y
        self.xVel, self.yVel = 0,0
        self.collider:setLinearDamping(20)
        self.collider:setFixedRotation(true) --collider won't spin

        --sprites and animations
        self.spriteSheet=love.graphics.newImage('assets/orc_t3.png')
        self.grid=anim8.newGrid(32,32,self.spriteSheet:getWidth(),self.spriteSheet:getHeight())
        self.animations={} --animations table
        self.animations.idle=anim8.newAnimation(self.grid('1-4',1), 0.1)
        self.animations.moving=anim8.newAnimation(self.grid('5-8',1), 0.1)
        self.currentAnim=self.animations.idle 

        --enemy's current state metatable
        self.state={}
        self.state.facing='right'
        self.state.moving=false

        table.insert(Enemies.enemiesTable,self) --insert enemy into enemiesTable
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
        if self.state.moving==true then 
            self.currentAnim=self.animations.moving 
        else 
            self.currentAnim=self.animations.idle
        end

        self.currentAnim:draw(self.spriteSheet,self.xPos,self.yPos,nil,1,1,16,18)
    end

    enemy:load() --initialize enemy
end

function Enemies:add_demon_t3(_x,_y)
    local enemy={} --create enemy instance
    function enemy:load() 
        --setip physics collider
        self.collider=world:newRectangleCollider(_x,_y,19,25)
        self.xPos, self.yPos = _x, _y
        self.xVel, self.yVel = 0,0
        self.collider:setLinearDamping(20)
        self.collider:setFixedRotation(true) --collider won't spin

        --sprites and animations
        self.spriteSheet=love.graphics.newImage('assets/demon_t3.png')
        self.grid=anim8.newGrid(32,32,self.spriteSheet:getWidth(),self.spriteSheet:getHeight())
        self.animations={} --animations table
        self.animations.idle=anim8.newAnimation(self.grid('1-4',1), 0.1)
        self.animations.moving=anim8.newAnimation(self.grid('5-8',1), 0.1)
        self.currentAnim=self.animations.idle 

        --enemy's current state metatable
        self.state={}
        self.state.facing='right'
        self.state.moving=false

        table.insert(Enemies.enemiesTable,self) --insert enemy into enemiesTable
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
        if self.state.moving==true then 
            self.currentAnim=self.animations.moving 
        else 
            self.currentAnim=self.animations.idle
        end

        self.currentAnim:draw(self.spriteSheet,self.xPos,self.yPos,nil,1,1,16,18)
    end

    enemy:load() --initialize enemy
end
