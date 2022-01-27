ResourceNodes={}

function ResourceNodes:load() 
    self.resourceNodesTable={}
end

function ResourceNodes:update() 
    for i,node in pairs(self.resourceNodesTable) do node:update() end 
end

function ResourceNodes:draw() 
    for i,node in pairs(self.resourceNodesTable) do node:draw() end 
end

function ResourceNodes:add_tree(_x,_y) 
    local node={}

    function node:load() 
        --setup collider and position vectors
        self.xPos, self.yPos = _x,_y 
        self.collider=world:newRectangleCollider(_x,_y,14,4)
        self.collider:setType('static')
        self.sprite=love.graphics.newImage('assets/tree.png')

        --node state metatable
        self.state={}
        self.state.depleted=false 

        table.insert(ResourceNodes.resourceNodesTable,self)
    end

    function node:update() 
    end

    function node:draw() 
        love.graphics.draw(self.sprite,self.xPos,self.yPos,nil,1,1,0,18)
    end

    node:load()
end 

function ResourceNodes:add_rock(_x,_y) 
    local node={}

    function node:load() 
        --setup collider and position vectors
        self.xPos, self.yPos = _x,_y 
        self.collider=world:newRectangleCollider(_x,_y,16,4)
        self.collider:setType('static')
        self.sprite=love.graphics.newImage('assets/rock.png')

        --node state metatable
        self.state={}
        self.state.depleted=false 

        table.insert(ResourceNodes.resourceNodesTable,self)
    end

    function node:update() 
    end

    function node:draw() 
        love.graphics.draw(self.sprite,self.xPos,self.yPos,nil,1,1,0,8)
    end

    node:load()
end 

function ResourceNodes:add_vine(_x,_y) 
    local node={}

    function node:load() 
        --setup collider and position vectors
        self.xPos, self.yPos = _x,_y 
        self.collider=world:newRectangleCollider(_x,_y,16,28)
        self.collider:setType('static')
        self.sprite=love.graphics.newImage('assets/vine.png')

        --node state metatable
        self.state={}
        self.state.depleted=false 

        table.insert(ResourceNodes.resourceNodesTable,self)
    end

    function node:update() end

    function node:draw() 
        love.graphics.draw(self.sprite,self.xPos,self.yPos,nil,1,1,0,0)
    end

    node:load()
end 

function ResourceNodes:add_fungi(_x,_y) 
    local node={}

    function node:load() 
        --setup collider and position vectors
        self.xPos, self.yPos = _x,_y 
        self.collider=world:newRectangleCollider(_x,_y,8,4)
        self.collider:setType('static')
        self.sprite=love.graphics.newImage('assets/fungi.png')

        --node state metatable
        self.state={}
        self.state.depleted=false 

        table.insert(ResourceNodes.resourceNodesTable,self)
    end

    function node:update() 
    end

    function node:draw() 
        love.graphics.draw(self.sprite,self.xPos,self.yPos,nil,1,1,5,5)
    end

    node:load()
end 

function ResourceNodes:add_fishing_hole(_x,_y) 
    local node={}

    function node:load() 
        --setup collider and position vectors
        self.xPos, self.yPos = _x,_y 
        self.collider=world:newBSGRectangleCollider(_x,_y,16,8,3)
        self.collider:setType('static')

        --animations
        self.spriteSheet=love.graphics.newImage('assets/fishing_hole.png')
        self.grid=anim8.newGrid(16,9,self.spriteSheet:getWidth(),self.spriteSheet:getHeight())
        self.animations={}
        self.animations.full=anim8.newAnimation(self.grid('1-4',1), 0.15)
        self.currentAnim=self.animations.full 

        --node state metatable
        self.state={}
        self.state.depleted=false 

        table.insert(ResourceNodes.resourceNodesTable,self)
    end

    function node:update() 
        self.currentAnim:update(dt)
    end

    function node:draw() 
        self.currentAnim:draw(self.spriteSheet,self.xPos,self.yPos,nil,1,1,0,-4)
    end

    node:load()
end 
