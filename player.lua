Player={}

function Player:load()
    --setup player's physics collider and position, velocity vectors
    self.collider=world:newRectangleCollider(600,100,12,5)
    self.xPos, self.yPos=self.collider:getPosition()
    self.xVel, self.yVel=self.collider:getLinearVelocity()
    self.collider:setLinearDamping(20) --apply increased 'friction'
    self.collider:setFixedRotation(true) --collider won't spin/rotate
    self.collider:setCollisionClass('player')
    self.collider:setObject(self) --attach collider to this object
    self.moveSpeed=40

    --sprites and animations
    self.spriteSheet=love.graphics.newImage('assets/armor_full_t3.png')
    self.grid=anim8.newGrid(16,22,self.spriteSheet:getWidth(),self.spriteSheet:getHeight())
    self.animations={} --anmations table
    self.animations.idle=anim8.newAnimation(self.grid('1-4',1), 0.1)
    self.animations.moving=anim8.newAnimation(self.grid('5-8',1), 0.1)
    self.currentAnim=self.animations.idle    

    --'metatable' containing info of the player's current state
    self.state={}
    self.state.facing='right'
    self.state.moving=false

    table.insert(Entities.entitiesTable,self)
end

function Player:update()
    --update position and velocity vectors
    self.xPos, self.yPos=self.collider:getPosition()
    self.xVel, self.yVel=self.collider:getLinearVelocity()

    --Only accept inputs when currently on top of state stack
    if acceptInput then 
        self:move() --movement
        self:query()
    end

    --update animations
    self.currentAnim:update(dt)
end

function Player:draw()
    local scaleX=1 --used to flip sprite when facing left
    if self.state.facing=='left' then scaleX=-1 end

    --update current animation based on self.state
    if self.state.moving==true then 
        self.currentAnim=self.animations.moving 
    else --defaults to idle animation
        self.currentAnim=self.animations.idle
    end
    
    --draw the appropriate current animation
    self.currentAnim:draw(self.spriteSheet,self.xPos,self.yPos,nil,scaleX,1,8,19)
end

function Player:move()
    self.state.moving=false --default to idle

    if love.keyboard.isDown('left') then 
        self.xVel=self.xVel-self.moveSpeed
        self.state.facing='left'
        self.state.moving=true
    end
    if love.keyboard.isDown('right') then 
        self.xVel=self.xVel+self.moveSpeed 
        self.state.facing='right'
        self.state.moving=true
    end
    if love.keyboard.isDown('up') then 
        self.yVel=self.yVel-self.moveSpeed
        self.state.moving=true
    end
    if love.keyboard.isDown('down') then 
        self.yVel=self.yVel+self.moveSpeed 
        self.state.moving=true
    end

    --apply updated velocities to collider
    self.collider:setLinearVelocity(self.xVel,self.yVel)
end

--Query the world for any nearby resource nodes. If there is one nearby,
--begin harvesting it's resource by calling the node's harvestResource function
function Player:query()
    if love.keyboard.isDown('x') then 
        local nodeColliders=world:queryRectangleArea(self.xPos-8,self.yPos-5,16,10,{'resourceNode'})
        if #nodeColliders>0 then --found a resource node
            --gets the resourceNode object attached to the collider
            local nearbyNode=nodeColliders[1]:getObject()

            --face player toward that node
            if nearbyNode.xPos<self.xPos then self.state.facing='left' 
            else self.state.facing='right' end
            --harvest the node

        end 
    end
end