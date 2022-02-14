Items={}

function Items:load()
    --load item sprites
    self.tree_wood=love.graphics.newImage('assets/tree_wood.png')
    self.tree_planks=love.graphics.newImage('assets/tree_planks.png')
    self.rock_ore=love.graphics.newImage('assets/rock_ore.png')
    self.rock_metal=love.graphics.newImage('assets/rock_metal.png')
    self.vine_fiber=love.graphics.newImage('assets/vine_fiber.png')
    self.vine_thread=love.graphics.newImage('assets/vine_thread.png')
    self.fungi_mushroom=love.graphics.newImage('assets/fungi_mushroom.png')
    self.fish_raw=love.graphics.newImage('assets/fish_raw.png')
    self.fish_cooked=love.graphics.newImage('assets/fish_cooked.png')
    self.arcane_bowstring=love.graphics.newImage('assets/arcane_bowstring.png')
    self.arcane_orb=love.graphics.newImage('assets/arcane_orb.png')
    self.arcane_shards=love.graphics.newImage('assets/arcane_shards.png')
    self.broken_bow=love.graphics.newImage('assets/broken_bow.png')
    self.broken_staff=love.graphics.newImage('assets/broken_staff.png')
    self.vial=love.graphics.newImage('assets/vial.png')
    self.potion=love.graphics.newImage('assets/potion.png')
    self.weapon_bow_t1=love.graphics.newImage('assets/weapon_bow_t1_item.png')
    self.weapon_bow_t2=love.graphics.newImage('assets/weapon_bow_t2_item.png')
    self.weapon_bow_t3=love.graphics.newImage('assets/weapon_bow_t3_item.png')
    self.weapon_staff_t1=love.graphics.newImage('assets/weapon_staff_t1_item.png')
    self.weapon_staff_t2=love.graphics.newImage('assets/weapon_staff_t2_item.png')
    self.weapon_staff_t3=love.graphics.newImage('assets/weapon_staff_t3_item.png')
    self.armor_head_t1=love.graphics.newImage('assets/armor_head_t1_item.png')
    self.armor_head_t2=love.graphics.newImage('assets/armor_head_t2_item.png')
    self.armor_head_t3=love.graphics.newImage('assets/armor_head_t3_item.png')
    self.armor_chest_t1=love.graphics.newImage('assets/armor_chest_t1_item.png')
    self.armor_chest_t2=love.graphics.newImage('assets/armor_chest_t2_item.png')
    self.armor_chest_t3=love.graphics.newImage('assets/armor_chest_t3_item.png')
    self.armor_legs_t1=love.graphics.newImage('assets/armor_legs_t1_item.png')
    self.armor_legs_t2=love.graphics.newImage('assets/armor_legs_t2_item.png')
    self.armor_legs_t3=love.graphics.newImage('assets/armor_legs_t3_item.png')
end

function Items:spawn_item(_x,_y,_name) 
    local item={}

    function item:load() 
        self.xPos,self.yPos=_x,_y 
        self.name=_name
        self.shadow=Shadows:newShadow(self.name) --shadow
        --choose a random x,y velocity to shoot out of node
        --multiply by framerate 
        self.xVel=(8-love.math.random()*16)*framerate
        self.yVel=(7-love.math.random()*14)*framerate

        --Select appropriate sprite for item
        if self.name=='tree_wood' then self.sprite=Items.tree_wood
        elseif self.name=='tree_planks' then self.sprite=Items.tree_planks
        elseif self.name=='rock_ore' then self.sprite=Items.rock_ore           
        elseif self.name=='rock_metal' then self.sprite=Items.rock_metal           
        elseif self.name=='fungi_mushroom' then self.sprite=Items.fungi_mushroom       
        elseif self.name=='fish_raw' then self.sprite=Items.fish_raw    
        elseif self.name=='fish_cooked' then self.sprite=Items.fish_cooked
        elseif self.name=='vine_thread' then self.sprite=Items.vine_thread
        elseif self.name=='vine_fiber' then 
            self.sprite=Items.vine_fiber
            --Because vines are only on top walls, vine fibers can only spawn below.
            self.yVel=(3+love.math.random()*4)*framerate
        elseif self.name=='vial' then self.sprite=Items.vial 
        elseif self.name=='potion' then self.sprite=Items.potion 

        elseif self.name=='arcane_bowstring' then self.sprite=Items.arcane_bowstring 
        elseif self.name=='arcane_orb' then self.sprite=Items.arcane_orb 
        elseif self.name=='arcane_shards' then self.sprite=Items.arcane_shards 
        elseif self.name=='broken_bow' then self.sprite=Items.broken_bow 
        elseif self.name=='broken_staff' then self.sprite=Items.broken_staff 

        elseif self.name=='weapon_bow_t1' then self.sprite=Items.weapon_bow_t1 
        elseif self.name=='weapon_bow_t2' then self.sprite=Items.weapon_bow_t2 
        elseif self.name=='weapon_bow_t3' then self.sprite=Items.weapon_bow_t3 
        elseif self.name=='weapon_staff_t1' then self.sprite=Items.weapon_staff_t1
        elseif self.name=='weapon_staff_t2' then self.sprite=Items.weapon_staff_t2
        elseif self.name=='weapon_staff_t3' then self.sprite=Items.weapon_staff_t3

        elseif self.name=='armor_head_t1' then self.sprite=Items.armor_head_t1 
        elseif self.name=='armor_head_t2' then self.sprite=Items.armor_head_t2
        elseif self.name=='armor_head_t3' then self.sprite=Items.armor_head_t3 
        elseif self.name=='armor_chest_t1' then self.sprite=Items.armor_chest_t1 
        elseif self.name=='armor_chest_t2' then self.sprite=Items.armor_chest_t2
        elseif self.name=='armor_chest_t3' then self.sprite=Items.armor_chest_t3 
        elseif self.name=='armor_legs_t1' then self.sprite=Items.armor_legs_t1
        elseif self.name=='armor_legs_t2' then self.sprite=Items.armor_legs_t2
        elseif self.name=='armor_legs_t3' then self.sprite=Items.armor_legs_t3
        end

        --Offset sprite's origin to its center
        self.xOffset=self.sprite:getWidth()*0.5
        self.yOffset=self.sprite:getHeight()-2
        self.oscillation=0

        self.isCollectable=false --boolean determines when the item can be collected
        self.restTimer=0 --timer to allow item to rest before being collectable
        self.removeEntity=false --should item be removed from entities table
        
        table.insert(Entities.entitiesTable,self)
    end 

    function item:update()
        --item will pop out and travel from its node for a bit
        if self.isCollectable==false then self:travelFromNode() end

        if self.isCollectable  then 
            self:gravitateToPlayer()
            self:addToPlayer()
        end

        --make the item look like it's bobbing/floating up and down
        self.oscillation=self.oscillation+0.07
        self.yOffset=self.yOffset+0.25*math.sin(self.oscillation)

        --return false when item should be removed from entitiesTable
        if self.removeEntity==true then return false end 
    end 

    function item:draw() 
        self.shadow:draw(self.xPos,self.yPos) --draw shadow
        love.graphics.draw(self.sprite,self.xPos,self.yPos,nil,1,1,self.xOffset,self.yOffset)
    end 

    function item:travelFromNode()
        if self.xVel~=0 and self.yVel~=0 then 
            self:move()
            --slow down item
            self.xVel=self.xVel*0.8
            self.yVel=self.yVel*0.8
            --stop moving when sufficiently slow
            if math.abs(self.xVel)<0.01 then self.xVel=0 end
            if math.abs(self.yVel)<0.01 then self.yVel=0 end
        else --when item is no longer moving, wait ~0.25s using restTimer
            self.restTimer=self.restTimer+dt
        end
        --item is ready to be picked up by player after resting for ~0.2s
        if self.restTimer>0.25 then self.isCollectable=true end 
    end

    --move item toward the player when they are in range
    function item:gravitateToPlayer()
        if math.abs(self.xPos-Player.xPos)<40 and math.abs(self.yPos-Player.yPos)<30 then
            --accelerate toward player
            if self.xPos > Player.xPos then self.xVel=self.xVel-0.1*framerate end
            if self.xPos < Player.xPos then self.xVel=self.xVel+0.1*framerate end
            if self.yPos > Player.yPos then self.yVel=self.yVel-0.1*framerate end 
            if self.yPos < Player.yPos then self.yVel=self.yVel+0.1*framerate end 

            --restrict velocity
            if self.xVel>0 then self.xVel=math.min(self.xVel,2*framerate) end  
            if self.xVel<0 then self.xVel=math.max(self.xVel,-2*framerate) end  
            if self.yVel>0 then self.yVel=math.min(self.yVel,2*framerate) end 
            if self.yVel<0 then self.yVel=math.max(self.yVel,-2*framerate) end 
        else --when out of range, slow velocity down
            self.xVel=self.xVel*0.9
            self.yVel=self.yVel*0.9
            --stop moving when sufficiently slow
            if math.abs(self.xVel)<0.01 then self.xVel=0 end 
            if math.abs(self.yVel)<0.01 then self.yVel=0 end 
        end
        self:move() --continue to move whenever item has velocity
    end

    --when item and player collide, "remove" and add item to player inventory
    function item:addToPlayer()
        if math.abs(self.xPos-Player.xPos)<10 and math.abs(self.yPos-Player.yPos)<10 then 
            --remove item from entities table
            self.removeEntity=true
            --add item to player's inventory
            Inventory:addItem(self.name)
        end
    end

    --move item by adding its velocity to its position
    --multiply by dt to remain fps independent
    function item:move()
        self.xPos=self.xPos+self.xVel*dt
        self.yPos=self.yPos+self.yVel*dt
    end

    item:load()
end 
