Player={}

function Player:load()
    --setup player's physics collider and position, velocity vectors
    self.collider=world:newBSGRectangleCollider(1600,1400,12,5,3)
    self.xPos, self.yPos=self.collider:getPosition()
    self.xVel, self.yVel=self.collider:getLinearVelocity()
    self.collider:setLinearDamping(20) --apply increased 'friction'
    self.collider:setFixedRotation(true) --collider won't spin/rotate
    self.collider:setCollisionClass('player')
    self.collider:setObject(self) --attach collider to this object
    self.moveSpeed=40
    self.moveSpeedDiag=self.moveSpeed*0.61

    --sprites and animations
    self.spriteSheet=love.graphics.newImage('assets/armor_full_t3.png')
    self.grid=anim8.newGrid(16,22,self.spriteSheet:getWidth(),self.spriteSheet:getHeight())
    self.animations={} --anmations table
    self.animations.idle=anim8.newAnimation(self.grid('1-4',1), 0.1)
    self.animations.moving=anim8.newAnimation(self.grid('5-8',1), 0.1)
    self.currentAnim=self.animations.idle  
    self.shadow=Shadows:newShadow('medium')  --shadow

    --'metatable' containing info of the player's current state
    self.state={}
    self.state.facing='right'
    self.state.moving=false
    self.state.movingHorizontally=false 
    self.state.movingVertially=false 
    self.state.isNearNode=false 

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
    --draw shadow before sprite
    self.shadow:draw(self.xPos,self.yPos)

    local scaleX=1 --used to flip sprite when facing left
    if self.state.facing=='left' then scaleX=-1 end

    --update current animation based on self.state
    if self.state.moving==true then 
        self.currentAnim=self.animations.moving 
    else --defaults to idle animation
        self.currentAnim=self.animations.idle
    end
    
    --draw the appropriate current animation
    self.currentAnim:draw(self.spriteSheet,self.xPos,self.yPos,nil,scaleX,1,8,20)
end

function Player:move()
    --default movement states to idle
    self.state.moving=false 
    self.state.movingHorizontally=false 
    self.state.movingVertically=false 

    if love.keyboard.isDown('left') then 
        self.xVel=self.xVel-self.moveSpeed
        self.state.facing='left'
        self.state.moving=true
        self.state.movingHorizontally=true
    end
    if love.keyboard.isDown('right') then 
        self.xVel=self.xVel+self.moveSpeed 
        self.state.facing='right'
        self.state.moving=true
        self.state.movingHorizontally=true
    end
    if love.keyboard.isDown('up') then 
        --accomodate for diagonal speed
        if self.state.movingHorizontally then 
            self.yVel=self.yVel-self.moveSpeedDiag
        else            
            self.yVel=self.yVel-self.moveSpeed
        end 
        self.state.moving=true
        self.state.movingVertially=true
    end
    if love.keyboard.isDown('down') then 
        --accomodate for diagonal speed
        if self.state.movingHorizontally then 
            self.yVel=self.yVel+self.moveSpeedDiag
        else            
            self.yVel=self.yVel+self.moveSpeed
        end 
        self.state.moving=true
        self.state.movingVertially=true 
    end

    --apply updated velocities to collider
    self.collider:setLinearVelocity(self.xVel,self.yVel)
end

--Query the world for any nearby resource nodes. If there is one nearby,
--begin harvesting it's resource by calling the node's harvestResource function
--also used for door buttons to open/reveal adjacent rooms.
function Player:query()
    local nodeColliders=world:queryRectangleArea(
        self.xPos-9,self.yPos-6,18,12,{'resourceNode','doorButton'}
    )
        if #nodeColliders>0 then --found a resource node
            --gets the resourceNode object attached to the collider
            local nearbyNode=nodeColliders[1]:getObject()

            --set combatInteract button state to update sprite 
            ActionButtons.combatInteract:setNodeNearPlayer(true)

            if love.keyboard.isDown('x') then 
                --face player toward that node
                if nearbyNode.xPos<self.xPos then self.state.facing='left' 
                else self.state.facing='right' end

                --interact with node by calling its 'nodeInteract' function
                nearbyNode:nodeInteract()
            end
        else
            --set combatInteract button state to update sprite 
            ActionButtons.combatInteract:setNodeNearPlayer(false)
        end 
end

--Called by items when they collide with player
function Player:addToInventory(_item) Inventory:addItem(_item) end