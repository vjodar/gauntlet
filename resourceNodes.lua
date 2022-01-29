ResourceNodes={}

function ResourceNodes:add_tree(_x,_y) 
    local node={}

    function node:load() 
        --setup collider and position vectors
        self.collider=world:newRectangleCollider(_x,_y,14,6)
        self.xPos, self.yPos = self.collider:getPosition()
        self.collider:setType('static')
        self.collider:setCollisionClass('resourceNode')
        self.collider:setObject(self) --attach collider to this object

        self.sprite=love.graphics.newImage('assets/tree.png')
        self.spriteDepleted=love.graphics.newImage('assets/tree_depleted.png')

        --node state metatable
        self.state={}
        self.state.resources=3 --available resources to give
        self.state.depleted=false
        self.state.harvestProgress=0 
        self.state.harvestProgressPrev=self.state.harvestProgress
        self.state.beingHarvested=false 

        table.insert(Entities.entitiesTable,self)
    end

    function node:update() 
        if self.state.harvestProgressPrev~=self.state.harvestProgress then 
            self.state.beingHarvested=true 
        else
            self.state.beingHarvested=false
        end

        if self.state.harvestProgress>1.5 then --takes ~1.5s to harvest
            --spawn appropriate item, restart harvest progress
            Items:spawn_item(self.xPos,self.yPos,'tree_wood')
            self.state.harvestProgress=0

            --after spawning item, reduce available resources by 1
            --update depleted state when resources are 0
            self.state.resources=self.state.resources-1
            if self.state.resources==0 then self.state.depleted=true end 
        end

        --once depleted, change collision class to prevent further harvesting
        if self.state.depleted==true then 
            self.collider:setCollisionClass('depletedNode')
        end

        --update harvestProgressPrev
        self.state.harvestProgressPrev=self.state.harvestProgress
    end

    function node:draw() 
        if self.state.depleted then 
            love.graphics.draw(self.spriteDepleted,self.xPos,self.yPos,nil,1,1,7,22)
        else 
            love.graphics.draw(self.sprite,self.xPos,self.yPos,nil,1,1,7,22)
        end
    end

    function node:harvestResource()
        self.state.harvestProgress=self.state.harvestProgress+dt
    end

    node:load()
end 

function ResourceNodes:add_rock(_x,_y) 
    local node={}

    function node:load() 
        --setup collider and position vectors
        self.collider=world:newRectangleCollider(_x,_y,16,9)
        self.xPos, self.yPos = self.collider:getPosition()
        self.collider:setType('static')
        self.collider:setCollisionClass('resourceNode')
        self.collider:setObject(self) --attach collider to this object

        self.sprite=love.graphics.newImage('assets/rock.png')
        self.spriteDepleted=love.graphics.newImage('assets/rock_depleted.png')

        --node state metatable
        self.state={}
        self.state.resources=3 --available resources to give
        self.state.depleted=false 
        self.state.harvestProgress=0
        self.state.harvestProgressPrev=self.state.harvestProgress
        self.state.beingHarvested=false 

        table.insert(Entities.entitiesTable,self)
    end

    function node:update() 
        if self.state.harvestProgressPrev~=self.state.harvestProgress then 
            self.state.beingHarvested=true 
        else
            self.state.beingHarvested=false
        end

        if self.state.harvestProgress>1.5 then --takes ~1.5s to harvest
            --spawn appropriate item, restart harvest progress
            Items:spawn_item(self.xPos,self.yPos,'rock_ore')
            self.state.harvestProgress=0

            --after spawning item, reduce available resources by 1
            --update depleted state when resources are 0
            self.state.resources=self.state.resources-1
            if self.state.resources==0 then self.state.depleted=true end 
        end

        --once depleted, change collision class to prevent further harvesting
        if self.state.depleted==true then 
            self.collider:setCollisionClass('depletedNode')
        end

        --update harvestProgressPrev
        self.state.harvestProgressPrev=self.state.harvestProgress
    end

    function node:draw() 
        if self.state.depleted==true then 
            love.graphics.draw(self.spriteDepleted,self.xPos,self.yPos,nil,1,1,8,7.5)
        else 
            love.graphics.draw(self.sprite,self.xPos,self.yPos,nil,1,1,8,7.5)
        end
    end

    function node:harvestResource()
        self.state.harvestProgress=self.state.harvestProgress+dt
    end

    node:load()
end 

function ResourceNodes:add_vine(_x,_y) 
    local node={}

    function node:load() 
        --setup collider and position vectors
        self.collider=world:newBSGRectangleCollider(_x,_y,16,32,4)
        self.xPos, self.yPos = self.collider:getPosition()
        self.collider:setType('static')
        self.collider:setCollisionClass('resourceNode')
        self.collider:setObject(self) --attach collider to this object

        self.sprite=love.graphics.newImage('assets/vine.png')
        self.spriteDepleted=love.graphics.newImage('assets/vine_depleted.png')

        --node state metatable
        self.state={}
        self.state.resources=3 --available resources to give
        self.state.depleted=false 
        self.state.harvestProgress=0
        self.state.harvestProgressPrev=self.state.harvestProgress 
        self.state.beingHarvested=false 

        table.insert(Entities.entitiesTable,self)
    end

    function node:update() 
        if self.state.harvestProgressPrev~=self.state.harvestProgress then 
            self.state.beingHarvested=true 
        else
            self.state.beingHarvested=false
        end

        if self.state.harvestProgress>1.5 then --takes ~1.5s to harvest
            --spawn appropriate item, restart harvest progress
            Items:spawn_item(self.xPos,self.yPos,'vine_fiber')
            self.state.harvestProgress=0

            --after spawning item, reduce available resources by 1
            --update depleted state when resources are 0
            self.state.resources=self.state.resources-1
            if self.state.resources==0 then self.state.depleted=true end 
        end

        --once depleted, change collision class to prevent further harvesting
        if self.state.depleted==true then 
            self.collider:setCollisionClass('depletedNode')
        end

        --update harvestProgressPrev
        self.state.harvestProgressPrev=self.state.harvestProgress
    end

    function node:draw() 
        if self.state.depleted==true then 
            love.graphics.draw(self.spriteDepleted,self.xPos,self.yPos,nil,1,1,8,16) 
        else
            if self.state.beingHarvested then 
                love.graphics.draw(
                    self.sprite,self.xPos,self.yPos,nil,
                    --animate by oscillating x,y stretching and y-offset
                    1.1+math.sin(self.state.harvestProgressPrev*6+math.pi)*0.1,
                    1.1+math.sin(self.state.harvestProgressPrev*6)*0.05,
                    8,16-(1.1+math.sin(self.state.harvestProgressPrev*6))
                )
            else
                love.graphics.draw(self.sprite,self.xPos,self.yPos,nil,1,1,8,16)
            end
        end
    end

    function node:harvestResource()
        self.state.harvestProgress=self.state.harvestProgress+dt
        -- print(self.state.harvestProgress)
    end

    node:load()
end 

function ResourceNodes:add_fungi(_x,_y) 
    local node={}

    function node:load() 
        --setup collider and position vectors
        self.collider=world:newRectangleCollider(_x,_y,6,6)
        self.xPos, self.yPos = self.collider:getPosition()
        self.collider:setType('static')
        self.collider:setCollisionClass('resourceNode')
        self.collider:setObject(self) --attach collider to this object

        self.sprite=love.graphics.newImage('assets/fungi.png')
        self.spriteDepleted=love.graphics.newImage('assets/fungi_depleted.png')

        --node state metatable
        self.state={}
        self.state.depleted=false 
        self.state.resources=3 --amount of resource items to give
        self.state.harvestProgress=0
        self.state.harvestProgressPrev=self.state.harvestProgress
        self.state.beingHarvested=false 

        table.insert(Entities.entitiesTable,self)
    end

    function node:update() 

        if self.state.harvestProgressPrev~=self.state.harvestProgress then 
            self.state.beingHarvested=true 
        else
            self.state.beingHarvested=false
        end

        if self.state.harvestProgress>1.5 then --takes ~1.5s to harvest
            --spawn appropriate item, restart harvest progress
            Items:spawn_item(self.xPos,self.yPos,'fungi_mushroom')
            self.state.harvestProgress=0

            --after spawning item, reduce available resources by 1
            --update depleted state when resources are 0
            self.state.resources=self.state.resources-1
            if self.state.resources==0 then self.state.depleted=true end 
        end

        --once depleted, change collision class to prevent further harvesting
        if self.state.depleted==true then 
            self.collider:setCollisionClass('depletedNode')
        end

        --update harvestProgressPrev
        self.state.harvestProgressPrev=self.state.harvestProgress
    end

    function node:draw() 
        if self.state.depleted==true then 
            love.graphics.draw(self.spriteDepleted,self.xPos,self.yPos,nil,1,1,8,8)
        else
            if self.state.beingHarvested then 
                love.graphics.draw(
                    self.sprite,self.xPos,self.yPos,nil,
                    --animate by oscillating x,y stretching and y-offset
                    1.1+math.sin(self.state.harvestProgressPrev*6+math.pi)*0.25,
                    1.1+math.sin(self.state.harvestProgressPrev*6)*0.25,
                    8,8+(1.1+math.sin(self.state.harvestProgressPrev*6))
                )
            else
                love.graphics.draw(self.sprite,self.xPos,self.yPos,nil,1,1,8,8)
            end
        end 
    end

    --this function is called through world queries done by the player
    function node:harvestResource()
        --increment current harvestProgress
        self.state.harvestProgress=self.state.harvestProgress+dt
    end

    node:load()
end 

function ResourceNodes:add_fishing_hole(_x,_y) 
    local node={}

    function node:load() 
        --setup collider and position vectors
        self.collider=world:newBSGRectangleCollider(_x,_y,16,8,2)
        self.xPos, self.yPos = self.collider:getPosition()
        self.collider:setType('static')
        self.collider:setCollisionClass('resourceNode')
        self.collider:setObject(self) --attach collider to this object

        --animations
        self.spriteSheet=love.graphics.newImage('assets/fishing_hole.png')
        self.grid=anim8.newGrid(16,9,self.spriteSheet:getWidth(),self.spriteSheet:getHeight())
        self.animations={}
        self.animations.full=anim8.newAnimation(self.grid('1-4',1), 0.15)
        self.currentAnim=self.animations.full 
        self.spriteDepleted=love.graphics.newImage('assets/fishing_hole_depleted.png')

        --node state metatable
        self.state={}
        self.state.resources=3 --available resources to give
        self.state.depleted=false 
        self.state.harvestProgress=0
        self.state.harvestProgressPrev=self.state.harvestProgress
        self.state.beingHarvested=false 

        table.insert(Entities.entitiesTable,self)
    end

    function node:update() 
        if self.state.depleted==false then self.currentAnim:update(dt) end 

        if self.state.harvestProgressPrev~=self.state.harvestProgress then 
            self.state.beingHarvested=true 
        else
            self.state.beingHarvested=false
        end

        if self.state.harvestProgress>1.5 then --takes ~1.5s to harvest
            --spawn appropriate item, restart harvest progress
            Items:spawn_item(self.xPos,self.yPos,'fish_raw')
            self.state.harvestProgress=0

            --after spawning item, reduce available resources by 1
            --update depleted state when resources are 0
            self.state.resources=self.state.resources-1
            if self.state.resources==0 then self.state.depleted=true end 
        end

        --once depleted, change collision class to prevent further harvesting
        if self.state.depleted==true then 
            self.collider:setCollisionClass('depletedNode')
        end

        --update harvestProgressPrev
        self.state.harvestProgressPrev=self.state.harvestProgress
    end

    function node:draw() 
        if self.state.depleted==true then 
            love.graphics.draw(self.spriteDepleted,self.xPos,self.yPos,nil,1,1,8,3)
        else 
            self.currentAnim:draw(self.spriteSheet,self.xPos,self.yPos,nil,1,1,8,3)
        end
    end

    function node:harvestResource()
        self.state.harvestProgress=self.state.harvestProgress+dt
        -- print(self.state.harvestProgress)
    end

    node:load()
end 
