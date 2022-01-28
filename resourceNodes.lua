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

        --node state metatable
        self.state={}
        self.state.depleted=false
        self.state.harvestProgress=0 

        table.insert(Entities.entitiesTable,self)
    end

    function node:update() 
        if self.state.harvestProgress>1.5 then --takes ~1.5s to harvest
            Items:spawn_item(self.xPos,self.yPos,'tree_wood')
            self.state.harvestProgress=0
        end
    end

    function node:draw() 
        love.graphics.draw(self.sprite,self.xPos,self.yPos,nil,1,1,7,22)
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

        --node state metatable
        self.state={}
        self.state.depleted=false 
        self.state.harvestProgress=0

        table.insert(Entities.entitiesTable,self)
    end

    function node:update() 
        if self.state.harvestProgress>1.5 then --takes ~1.5s to harvest
            Items:spawn_item(self.xPos,self.yPos,'rock_ore')
            self.state.harvestProgress=0
        end
    end

    function node:draw() 
        love.graphics.draw(self.sprite,self.xPos,self.yPos,nil,1,1,8,7.5)
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
        self.collider=world:newRectangleCollider(_x,_y,16,32)
        self.xPos, self.yPos = self.collider:getPosition()
        self.collider:setType('static')
        self.collider:setCollisionClass('resourceNode')
        self.collider:setObject(self) --attach collider to this object

        self.sprite=love.graphics.newImage('assets/vine.png')

        --node state metatable
        self.state={}
        self.state.depleted=false 
        self.state.harvestProgress=0

        table.insert(Entities.entitiesTable,self)
    end

    function node:update() 
        if self.state.harvestProgress>1.5 then --takes ~1.5s to harvest
            Items:spawn_item(self.xPos,self.yPos,'vine_fiber')
            self.state.harvestProgress=0
        end
    end

    function node:draw() 
        love.graphics.draw(self.sprite,self.xPos,self.yPos,nil,1,1,8,16)
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

        --node state metatable
        self.state={}
        self.state.depleted=false 
        self.state.harvestProgress=0

        table.insert(Entities.entitiesTable,self)
    end

    function node:update() 
        if self.state.harvestProgress>1.5 then --takes ~1.5s to harvest
            Items:spawn_item(self.xPos,self.yPos,'fungi_mushroom')
            self.state.harvestProgress=0
        end
    end

    function node:draw() 
        love.graphics.draw(self.sprite,self.xPos,self.yPos,nil,1,1,8,8)
    end

    function node:harvestResource()
        self.state.harvestProgress=self.state.harvestProgress+dt
        -- print(self.state.harvestProgress)
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

        --node state metatable
        self.state={}
        self.state.depleted=false 
        self.state.harvestProgress=0

        table.insert(Entities.entitiesTable,self)
    end

    function node:update() 
        self.currentAnim:update(dt)

        if self.state.harvestProgress>1.5 then --takes ~1.5s to harvest
            Items:spawn_item(self.xPos,self.yPos,'fish_raw')
            self.state.harvestProgress=0
        end
    end

    function node:draw() 
        self.currentAnim:draw(self.spriteSheet,self.xPos,self.yPos,nil,1,1,8,3)
    end

    function node:harvestResource()
        self.state.harvestProgress=self.state.harvestProgress+dt
        -- print(self.state.harvestProgress)
    end

    node:load()
end 
