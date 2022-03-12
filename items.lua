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
        self.name=_name
        self.size=4 --size of item's collider (defaults to small)

        --Select appropriate sprite for item
        if self.name=='tree_wood' then self.sprite=Items.tree_wood self.size=6
        elseif self.name=='tree_planks' then self.sprite=Items.tree_planks
        elseif self.name=='rock_ore' then self.sprite=Items.rock_ore self.size=6 
        elseif self.name=='rock_metal' then self.sprite=Items.rock_metal           
        elseif self.name=='fungi_mushroom' then self.sprite=Items.fungi_mushroom self.size=5  
        elseif self.name=='fish_raw' then self.sprite=Items.fish_raw    
        elseif self.name=='fish_cooked' then self.sprite=Items.fish_cooked
        elseif self.name=='vine_thread' then self.sprite=Items.vine_thread
        elseif self.name=='vine_fiber' then self.sprite=Items.vine_fiber self.size=6
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
        
        --collider
        self.collider=world:newCircleCollider(_x,_y,self.size)
        self.collider:setMass(0.1) --set standard mass
        self.collider:setObject(self)
        self.collider:setCollisionClass('item')
        self.collider:setLinearDamping(4) --set 'friction'
        self.collider:setRestitution(0.5) --set bounce
        self.xPos,self.yPos=self.collider:getPosition()

        self.shadow=Shadows:newShadow(self.name) --shadow

        --Offset sprite's origin to its center
        self.xOffset=self.sprite:getWidth()*0.5
        self.yOffset=self.sprite:getHeight()-2
        self.oscillation=0

        self.isCollectable=false --boolean determines when the item can be collected
        self.removeEntity=false --should item be removed from entities table

        --choose a random x,y velocity to shoot out of node
        self.xVel=(8-love.math.random()*16)*framerate
        self.yVel=(7-love.math.random()*14)*framerate

        self.collider:setLinearVelocity(self.xVel,self.yVel) --launch item from node
        
        table.insert(Entities.entitiesTable,self)
    end 

    function item:update()
        self.xPos,self.yPos=self.collider:getPosition() --update position
        self.xVel,self.yVel=self.collider:getLinearVelocity() --update velocity

        --once item stops moving, it becomes collectable
        if not self.isCollectable then 
            if math.abs(self.xVel)<2 and math.abs(self.yVel)<2 then
                self.isCollectable=true 
            end
        end

        if self.isCollectable then 
            self:gravitateToPlayer()
            self:addToPlayer()
        end

        --make the item look like it's bobbing/floating up and down
        self.oscillation=self.oscillation+0.07
        self.yOffset=self.yOffset+0.25*math.sin(self.oscillation)

        --return false when item should be removed from entitiesTable
        --destroy item's collider
        if self.removeEntity==true then 
            self.collider:destroy()
            return false 
        end 
    end 

    function item:draw() 
        self.shadow:draw(self.xPos,self.yPos) --draw shadow
        love.graphics.draw(self.sprite,self.xPos,self.yPos,nil,1,1,self.xOffset,self.yOffset)
    end 

    --move item toward the player when they are in range
    function item:gravitateToPlayer()

        if math.abs(self.xPos-Player.xPos)<40 and math.abs(self.yPos-Player.yPos)<30 then
            if self.xPos<Player.xPos then --item is left of player
                self.collider:applyLinearImpulse(0.75,0)
            else --item is right of player
                self.collider:applyLinearImpulse(-0.75,0)
            end
            if self.yPos<Player.yPos then --item is above player
                self.collider:applyLinearImpulse(0,0.75)
            else --item is below player
                self.collider:applyLinearImpulse(0,-0.75)
            end
        end
    end

    --when item and player collide, "remove" and add item to player inventory
    function item:addToPlayer()
        if math.abs(self.xPos-Player.xPos)<10 and math.abs(self.yPos-Player.yPos)<10 then 
            --remove item from entities table
            self.removeEntity=true
            --add item to player's inventory
            Player:addToInventory(self.name)
        end
    end

    item:load()
end 
