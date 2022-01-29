Items={}

function Items:spawn_item(_x,_y,_name) 
    local item={}

    function item:load() 
        self.xPos,self.yPos=_x,_y 
        self.name=_name 
        --choose a random x,y velocity to shoot out of node
        self.xVel=8-love.math.random(16)
        self.yVel=7-love.math.random(14)       

        --Select appropriate sprite for item
        if self.name=='tree_wood' then 
            self.sprite=love.graphics.newImage('assets/tree_wood.png')
        elseif self.name=='rock_ore' then 
            self.sprite=love.graphics.newImage('assets/rock_ore.png')            
        elseif self.name=='vine_fiber' then 
            self.sprite=love.graphics.newImage('assets/vine_fiber.png')
            --Because vines are only on top walls, vine fibers can only spawn below.
            self.yVel=3+love.math.random(4)
        elseif self.name=='fungi_mushroom' then 
            self.sprite=love.graphics.newImage('assets/fungi_mushroom.png')
        elseif self.name=='fish_raw' then 
            self.sprite=love.graphics.newImage('assets/fish_raw.png')
        end

        --Offset the sprite when drawing to have yPos at the center, oscillation
        --is used with the sine function to achieve a bob/float visual effect
        self.yOffset=self.sprite:getHeight()/2
        self.oscillation=0
        
        print(self.yVel)
        table.insert(Entities.entitiesTable,self)
    end 

    function item:update()
        --item should pop out and travel from its node for a bit
        if self.xVel~=0 and self.yVel~=0 then 
            self.xPos=self.xPos+self.xVel
            self.yPos=self.yPos+self.yVel
            --slow down item
            self.xVel=self.xVel*0.8
            self.yVel=self.yVel*0.8
        end

        --make the item look like it's bobbing/floating up and down
        self.oscillation=self.oscillation+0.07
        self.yOffset=self.yOffset+0.25*math.sin(self.oscillation)
    end 

    function item:draw() 
        love.graphics.draw(self.sprite,self.xPos,self.yPos,nil,1,1,0,self.yOffset)
    end 

    item:load()
end 
