Player={}

function Player:load()
    --setup player's physics collider and position, velocity vectors
    self.collider=world:newBSGRectangleCollider(0,0,12,5,3)
    self.xPos, self.yPos=self.collider:getPosition()
    self.xVel, self.yVel=self.collider:getLinearVelocity()
    self.collider:setLinearDamping(20) --apply increased 'friction'
    self.collider:setFixedRotation(true) --collider won't spin/rotate
    self.collider:setCollisionClass('player')
    self.collider:setObject(self) --attach collider to this object
    self.moveSpeed=40
    self.moveSpeedDiag=self.moveSpeed*0.61

    --sprites and animations
    self.spriteSheets={
        head_t0=love.graphics.newImage('assets/armor_head_t0.png'),
        head_t1=love.graphics.newImage('assets/armor_head_t1.png'),
        head_t2=love.graphics.newImage('assets/armor_head_t2.png'),
        head_t3=love.graphics.newImage('assets/armor_head_t3.png'),
        chest_t0=love.graphics.newImage('assets/armor_chest_t0.png'),
        chest_t1=love.graphics.newImage('assets/armor_chest_t1.png'),
        chest_t2=love.graphics.newImage('assets/armor_chest_t2.png'),
        chest_t3=love.graphics.newImage('assets/armor_chest_t3.png'),
        legs_t0=love.graphics.newImage('assets/armor_legs_t0.png'),
        legs_t1=love.graphics.newImage('assets/armor_legs_t1.png'),
        legs_t2=love.graphics.newImage('assets/armor_legs_t2.png'),
        legs_t3=love.graphics.newImage('assets/armor_legs_t3.png')
    }
    self.grid=anim8.newGrid(16,22,self.spriteSheets.head_t0:getWidth(),self.spriteSheets.head_t0:getHeight())
    self.animations={ --animations for each armor piece and tier
        idle=anim8.newAnimation(self.grid('1-4',1), 0.1),
        moving=anim8.newAnimation(self.grid('5-8',1), 0.1)
    }
    self.currentAnim={
        head=self.animations.idle,
        chest=self.animations.idle,
        legs=self.animations.idle
    } 
    self.shadow=Shadows:newShadow('medium')  --shadow

    --'metatable' containing info of the player's current state
    self.state={}
    self.state.facing='right'
    self.state.moving=false
    self.state.movingHorizontally=false 
    self.state.movingVertially=false 
    self.state.isNearNode=false 

    self.armor={ --currently equipt armor
        --strings in order to easily draw the correct tier armor in draw()
        head='head_t0',
        chest='chest_t0',
        legs='legs_t0'
    }

    self.weapons={
        bow_tier=0,
        staff_tier=0
    }
    
    self.inventory={
        arcane_shards=0,
        vial=0,
        broken_bow=0,
        broken_staff=0,
        arcane_orb=0,
        arcane_bowstring=0,
        tree_wood=0,
        rock_ore=0,
        vine_fiber=0,
        fungi_mushroom=0,
        fish_raw=0,
        rock_metal=0,
        tree_planks=0,
        vine_thread=0,
    }

    self.suppliesPouch={
        fish_cooked=0,
        potion=0
    }

    table.insert(Entities.entitiesTable,self)
end

function Player:update()
    --update position and velocity vectors
    self.xPos, self.yPos=self.collider:getPosition()
    self.xVel, self.yVel=self.collider:getLinearVelocity()
    
    --default movement states to idle
    self.state.moving=false 
    self.state.movingHorizontally=false 
    self.state.movingVertically=false 
    
    --Only accept inputs when currently on top of state stack
    if acceptInput then 
        self:move() --movement
        self:query()
    end

    --Because the all three armor pieces point to the same syncronized
    --shared animation, updating any one of them is sufficient.
    self.currentAnim.head:update(dt) --update animations for all 3 armor pieces
end

function Player:draw()
    --draw shadow before sprite
    self.shadow:draw(self.xPos,self.yPos)

    local scaleX=1 --used to flip sprite when facing left
    if self.state.facing=='left' then scaleX=-1 end

    --update current animation based on self.state
    if self.state.moving==true then 
        self.currentAnim.head=self.animations.moving 
        self.currentAnim.chest=self.animations.moving 
        self.currentAnim.legs=self.animations.moving 
    else --defaults to idle animation
        self.currentAnim.head=self.animations.idle 
        self.currentAnim.chest=self.animations.idle 
        self.currentAnim.legs=self.animations.idle 
    end
    
    --draw the appropriate current animation for each armor piece
    self.currentAnim.head:draw(self.spriteSheets[self.armor.head],self.xPos,self.yPos,nil,scaleX,1,8,20)
    self.currentAnim.chest:draw(self.spriteSheets[self.armor.chest],self.xPos,self.yPos,nil,scaleX,1,8,20)
    self.currentAnim.legs:draw(self.spriteSheets[self.armor.legs],self.xPos,self.yPos,nil,scaleX,1,8,20)
end

function Player:move()

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
--set HUD combatInteract action button to show player that they can interact with it.
--if player presses the action button, call node's nodeInteract() function to
--harvest resources / craft items / open or reveal adjascent rooms
function Player:query()
    local nodeColliders=world:queryRectangleArea(
        self.xPos-9,self.yPos-6,18,12, --where to query
        {'resourceNode','doorButton','craftingNode'} --what to query for
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
--increases the amount of an item in the player's inventory as well as in the HUD
function Player:addToInventory(_item)
    
    if _item=='fish_cooked' or _item=='potion' then --add supplies to supply pouch
        self.suppliesPouch[_item]=self.suppliesPouch[_item]+1

    elseif _item=='weapon_bow_t1' or _item=='weapon_bow_t2' or _item=='weapon_bow_t3' 
    or _item=='weapon_staff_t1' or _item=='weapon_staff_t2' or _item=='weapon_staff_t3'
    then --add weapons to player's current weapon
        --TODO--------------------
        -- maybe have a 'current weapon' for both bow and staff and update them here
        --TODO--------------------

    -- Head armors
    elseif _item=='armor_head_t1' then 
        if self.armor.head=='head_t0' then 
            self.armor.head='head_t1'
        else print("you already have a better head armor!") end 
    elseif _item=='armor_head_t2' then 
        if self.armor.head=='head_t1' then 
            self.armor.head='head_t2'
        else print("you already have a better head armor!") end 
    elseif _item=='armor_head_t3' then 
        if self.armor.head=='head_t2' then 
            self.armor.head='head_t3'
        else print("you already have a better head armor!") end 
        
    -- Chest armors
    elseif _item=='armor_chest_t1' then 
        if self.armor.chest=='chest_t0' then 
            self.armor.chest='chest_t1'
        else print("you already have a better chest armor!") end 
    elseif _item=='armor_chest_t2' then 
        if self.armor.chest=='chest_t1' then 
            self.armor.chest='chest_t2'
        else print("you already have a better chest armor!") end 
    elseif _item=='armor_chest_t3' then 
        if self.armor.chest=='chest_t2' then 
            self.armor.chest='chest_t3'
        else print("you already have a better chest armor!") end 
       
    -- Leg armors
    elseif _item=='armor_legs_t1' then 
        if self.armor.legs=='legs_t0' then 
            self.armor.legs='legs_t1'
        else print("you already have a better leg armor!") end 
    elseif _item=='armor_legs_t2' then 
        if self.armor.legs=='legs_t1' then 
            self.armor.legs='legs_t2'
        else print("you already have a better leg armor!") end 
    elseif _item=='armor_legs_t3' then 
        if self.armor.legs=='legs_t2' then 
            self.armor.legs='legs_t3'
        else print("you already have a better leg armor!") end 

    else --all other items get added to inventory and HUD        
        self.inventory[_item]=self.inventory[_item]+1
        Inventory:addItem(_item)
    end
end

--Called by crafting nodes when they take an item to give its processed version.
--decreases the amount of an item in player's inventory and the HUD
function Player:removeFromInventory(_item)
    self.inventory[_item]=self.inventory[_item]-1
    Inventory:removeItem(_item)
end