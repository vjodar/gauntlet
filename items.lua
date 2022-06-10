Items={}

function Items:load()
    --load item sprites
    self.sprites={
        tree_wood=love.graphics.newImage('assets/items/tree_wood.png'),
        tree_planks=love.graphics.newImage('assets/items/tree_planks.png'),
        rock_ore=love.graphics.newImage('assets/items/rock_ore.png'),
        rock_metal=love.graphics.newImage('assets/items/rock_metal.png'),
        vine_fiber=love.graphics.newImage('assets/items/vine_fiber.png'),
        vine_thread=love.graphics.newImage('assets/items/vine_thread.png'),
        fungi_mushroom=love.graphics.newImage('assets/items/fungi_mushroom.png'),
        fish_raw=love.graphics.newImage('assets/items/fish_raw.png'),
        fish_cooked=love.graphics.newImage('assets/items/fish_cooked.png'),
        arcane_bowstring=love.graphics.newImage('assets/items/arcane_bowstring.png'),
        arcane_orb=love.graphics.newImage('assets/items/arcane_orb.png'),
        arcane_shards=love.graphics.newImage('assets/items/arcane_shards.png'),
        broken_bow=love.graphics.newImage('assets/items/broken_bow.png'),
        broken_staff=love.graphics.newImage('assets/items/broken_staff.png'),
        potion=love.graphics.newImage('assets/items/potion.png'),
        weapon_bow_t1=love.graphics.newImage('assets/items/weapon_bow_t1_item.png'),
        weapon_bow_t2=love.graphics.newImage('assets/items/weapon_bow_t2_item.png'),
        weapon_bow_t3=love.graphics.newImage('assets/items/weapon_bow_t3_item.png'),
        weapon_staff_t1=love.graphics.newImage('assets/items/weapon_staff_t1_item.png'),
        weapon_staff_t2=love.graphics.newImage('assets/items/weapon_staff_t2_item.png'),
        weapon_staff_t3=love.graphics.newImage('assets/items/weapon_staff_t3_item.png'),
        armor_head_t1=love.graphics.newImage('assets/items/armor_head_t1_item.png'),
        armor_head_t2=love.graphics.newImage('assets/items/armor_head_t2_item.png'),
        armor_head_t3=love.graphics.newImage('assets/items/armor_head_t3_item.png'),
        armor_chest_t1=love.graphics.newImage('assets/items/armor_chest_t1_item.png'),
        armor_chest_t2=love.graphics.newImage('assets/items/armor_chest_t2_item.png'),
        armor_chest_t3=love.graphics.newImage('assets/items/armor_chest_t3_item.png'),
        armor_legs_t1=love.graphics.newImage('assets/items/armor_legs_t1_item.png'),
        armor_legs_t2=love.graphics.newImage('assets/items/armor_legs_t2_item.png'),
        armor_legs_t3=love.graphics.newImage('assets/items/armor_legs_t3_item.png'),
    }

    self.sizes={
        tree_wood=7,
        tree_planks=7,
        rock_ore=6,
        rock_metal=6,
        vine_fiber=6,
        vine_thread=5,
        fungi_mushroom=5,
        fish_raw=4,
        fish_cooked=4,
        arcane_bowstring=5,
        arcane_orb=4,
        arcane_shards=5,
        broken_bow=5,
        broken_staff=5,
        potion=4,
        weapon_bow_t1=4,
        weapon_bow_t2=4,
        weapon_bow_t3=4,
        weapon_staff_t1=4,
        weapon_staff_t2=4,
        weapon_staff_t3=4,
        armor_head_t1=5,
        armor_head_t2=5,
        armor_head_t3=5,
        armor_chest_t1=4,
        armor_chest_t2=4,
        armor_chest_t3=4,
        armor_legs_t1=4,
        armor_legs_t2=4,
        armor_legs_t3=4,
    }    
end

function Items:spawn_item(_x,_y,_name) 
    local item={}

    function item:load() 
        self.name=_name
        self.sprite=Items.sprites[self.name] --Select appropriate sprite for item
        self.size=Items.sizes[self.name]
        
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
        self.yOffset=0
        self.height=self.sprite:getHeight()+2
        self.oscillation=love.math.random()*2*math.pi

        self.isCollectable=false --boolean determines when the item can be collected
        self.removeEntity=false --should item be removed from entities table

        --choose a random x,y velocity to shoot out of node
        self.xVel=(8-love.math.random()*16)*60
        self.yVel=(7-love.math.random()*14)*60

        self.collider:setLinearVelocity(self.xVel,self.yVel) --launch item from node
        --after 1s from spawning, item becomes collectable
        TimerState:after(1,function() self.isCollectable=true end)
        
        table.insert(Entities.entitiesTable,self)
    end 

    function item:update()
        self.xPos,self.yPos=self.collider:getPosition() --update position

        if self.isCollectable then self:gravitateToPlayer()  end

        --make the item look like it's bobbing/floating up and down
        self.oscillation=(self.oscillation+dt*4)
        self.yOffset=4*math.sin(self.oscillation)+self.height

        --return false when item should be removed from entitiesTable
        --destroy item's collider
        if self.removeEntity then self.collider:destroy() return false end 
    end 

    function item:draw() 
        self.shadow:draw(self.xPos,self.yPos) --draw shadow
        love.graphics.draw(
            self.sprite,self.xPos,self.yPos,nil,1,1,self.xOffset,self.yOffset
        )
    end 

    --move item toward the player when they are in range
    --when item and player collide, "remove" and add item to player inventory
    function item:gravitateToPlayer()
        if Player.state.isDead then return end --don't gravitate to a dead player
        if math.abs(self.xPos-Player.xPos)<40 and math.abs(self.yPos-Player.yPos)<30 then
            if self.xPos<Player.xPos then --item is left of player
                self.collider:applyLinearImpulse(45*dt,0)
            else --item is right of player
                self.collider:applyLinearImpulse(-45*dt,0)
            end
            if self.yPos<Player.yPos then --item is above player
                self.collider:applyLinearImpulse(0,45*dt)
            else --item is below player
                self.collider:applyLinearImpulse(0,-45*dt)
            end
        end

        if math.abs(self.xPos-Player.xPos)<15 and math.abs(self.yPos-Player.yPos)<10 then 
            --remove item from entities table
            self.removeEntity=true
            --add item to player's inventory
            Player:addToInventory(self.name,1)
        end
    end

    item:load()
end 
