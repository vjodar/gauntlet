Items={}

function Items:add_tree_wood(_x,_y) 
    local item={}

    function item:load() 
        self.xPos,self.yPos=_x,_y 
        self.xVel=8-love.math.random(16) -- -5 to 5
        self.yVel=8-love.math.random(16) -- -5 to 5
        self.sprite=love.graphics.newImage('assets/tree_wood.png')
        self.yOffset=self.sprite:getHeight()/2

        table.insert(Entities.entitiesTable,self)
    end 

    function item:update()
        --item should pop out and travel from its node for a bit
        if self.xVel~=0 and self.yVel~=0 then 
            self.xPos=self.xPos+self.xVel
            self.yPos=self.yPos+self.yVel
            --slow down item
            self.xVel=self.xVel*0.80
            self.yVel=self.yVel*0.80
        end
    end 

    function item:draw() 
        love.graphics.draw(self.sprite,self.xPos,self.yPos,nil,1,1,0,self.yOffset)
    end 

    item:load()
end 

function Items:add_rock_ore(_x,_y) 
    local item={}

    function item:load() 
        self.xPos,self.yPos=_x,_y 
        self.xVel=8-love.math.random(16) 
        self.yVel=8-love.math.random(16)
        self.sprite=love.graphics.newImage('assets/rock_ore.png')
        self.yOffset=self.sprite:getHeight()/2

        table.insert(Entities.entitiesTable,self)
    end 

    function item:update()
        --item should pop out and travel from its node for a bit
        if self.xVel~=0 and self.yVel~=0 then 
            self.xPos=self.xPos+self.xVel
            self.yPos=self.yPos+self.yVel
            --slow down item
            self.xVel=self.xVel*0.80
            self.yVel=self.yVel*0.80
        end
    end 

    function item:draw() 
        love.graphics.draw(self.sprite,self.xPos,self.yPos,nil,1,1,0,self.yOffset)
    end 

    item:load()
end 

function Items:add_vine_fiber(_x,_y) 
    local item={}

    function item:load() 
        self.xPos,self.yPos=_x,_y 
        self.xVel=8-love.math.random(16) 
        self.yVel=love.math.random(8) -- item must travel down
        self.sprite=love.graphics.newImage('assets/vine_fiber.png')
        self.yOffset=self.sprite:getHeight()/2

        table.insert(Entities.entitiesTable,self)
    end 

    function item:update()
        --item should pop out and travel from its node for a bit
        if self.xVel~=0 and self.yVel~=0 then 
            self.xPos=self.xPos+self.xVel
            self.yPos=self.yPos+self.yVel
            --slow down item
            self.xVel=self.xVel*0.80
            self.yVel=self.yVel*0.80
        end
    end 

    function item:draw() 
        love.graphics.draw(self.sprite,self.xPos,self.yPos,nil,1,1,0,self.yOffset)
    end 

    item:load()
end 

function Items:add_fungi_mushroom(_x,_y) 
    local item={}

    function item:load() 
        self.xPos,self.yPos=_x,_y 
        self.xVel=8-love.math.random(16)
        self.yVel=8-love.math.random(16) 
        self.sprite=love.graphics.newImage('assets/fungi_mushroom.png')
        self.yOffset=self.sprite:getHeight()/2

        table.insert(Entities.entitiesTable,self)
    end 

    function item:update()
        --item should pop out and travel from its node for a bit
        if self.xVel~=0 and self.yVel~=0 then 
            self.xPos=self.xPos+self.xVel
            self.yPos=self.yPos+self.yVel
            --slow down item
            self.xVel=self.xVel*0.80
            self.yVel=self.yVel*0.80
        end
    end 

    function item:draw() 
        love.graphics.draw(self.sprite,self.xPos,self.yPos,nil,1,1,0,self.yOffset)
    end 

    item:load()
end 

function Items:add_fish_raw(_x,_y) 
    local item={}

    function item:load() 
        self.xPos,self.yPos=_x,_y 
        self.xVel=8-love.math.random(16) 
        self.yVel=8-love.math.random(16) 
        self.sprite=love.graphics.newImage('assets/fish_raw.png')
        self.yOffset=self.sprite:getHeight()/2

        table.insert(Entities.entitiesTable,self)
    end 

    function item:update()
        --item should pop out and travel from its node for a bit
        if self.xVel~=0 and self.yVel~=0 then 
            self.xPos=self.xPos+self.xVel
            self.yPos=self.yPos+self.yVel
            --slow down item
            self.xVel=self.xVel*0.80
            self.yVel=self.yVel*0.80
        end
    end 

    function item:draw() 
        love.graphics.draw(self.sprite,self.xPos,self.yPos,nil,1,1,0,self.yOffset)
    end 

    item:load()
end 
