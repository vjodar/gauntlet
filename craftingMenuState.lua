CraftingMenuState={}

function CraftingMenuState:load()
    self.craftingMenuSprite=love.graphics.newImage('assets/crafting_menu_ui.png')
    self.xPos,self.yPos=0,0

    --items and their quantities required to craft each item
    self.reqs={
        armor_head_t1={
            {name='arcane_shards',quantity=40},
            {name='rock_metal',quantity=1},
            {name='tree_planks',quantity=1},
            {name='vine_thread',quantity=1},
        },
        armor_chest_t1={
            {name='arcane_shards',quantity=40},
            {name='rock_metal',quantity=1},
            {name='tree_planks',quantity=1},
            {name='vine_thread',quantity=1},
        },
        armor_legs_t1={
            {name='arcane_shards',quantity=40},
            {name='rock_metal',quantity=1},
            {name='tree_planks',quantity=1},
            {name='vine_thread',quantity=1},
        },
        armor_head_t2={
            {name='arcane_shards',quantity=60},
            {name='rock_metal',quantity=1},
            {name='tree_planks',quantity=1},
            {name='vine_thread',quantity=1},
            {name='armor_head_t1',quantity=1},
        },
        armor_chest_t2={
            {name='arcane_shards',quantity=60},
            {name='rock_metal',quantity=2},
            {name='tree_planks',quantity=2},
            {name='vine_thread',quantity=2},
            {name='armor_chest_t1',quantity=1},
        },
        armor_legs_t2={
            {name='arcane_shards',quantity=60},
            {name='rock_metal',quantity=1},
            {name='tree_planks',quantity=1},
            {name='vine_thread',quantity=1},
            {name='armor_legs_t1',quantity=1},
        },
        armor_head_t3={
            {name='arcane_shards',quantity=80},
            {name='rock_metal',quantity=2},
            {name='tree_planks',quantity=2},
            {name='vine_thread',quantity=2},
            {name='armor_head_t2',quantity=1},
        },
        armor_chest_t3={
            {name='arcane_shards',quantity=80},
            {name='rock_metal',quantity=2},
            {name='tree_planks',quantity=2},
            {name='vine_thread',quantity=2},
            {name='armor_chest_t2',quantity=1},
        },
        armor_legs_t3={
            {name='arcane_shards',quantity=80},
            {name='rock_metal',quantity=2},
            {name='tree_planks',quantity=2},
            {name='vine_thread',quantity=2},
            {name='armor_legs_t2',quantity=1},
        },
        weapon_bow_t1={
            {name='arcane_shards',quantity=20},
            {name='broken_bow',quantity=1},
        },
        weapon_bow_t2={
            {name='arcane_shards',quantity=60},
            {name='weapon_bow_t1',quantity=1},
        },
        weapon_bow_t3={            
            {name='weapon_bow_t2',quantity=1},
            {name='arcane_bowstring',quantity=1},
        },
        weapon_staff_t1={
            {name='arcane_shards',quantity=20},
            {name='broken_staff',quantity=1},
        },
        weapon_staff_t2={
            {name='arcane_shards',quantity=60},
            {name='weapon_staff_t1',quantity=1},
        },
        weapon_staff_t3={
            {name='weapon_staff_t2',quantity=1},
            {name='arcane_orb',quantity=1},
        },
        vial={
            {name='arcane_shards',quantity=10},
        },
        potion={
            {name='arcane_shards',quantity=1},
            {name='vial',quantity=1},
        }
    }
end

function CraftingMenuState:update()
    if acceptInput then 
        if releasedKey=='x' then 
            self:craft('potion') --testing
        end

        if releasedKey=='z' then return false end --exit crafting menu
    end

    return true --return true to remain on gamestate stack
end

function CraftingMenuState:draw()
    cam:attach()

    --fade out playstate
    love.graphics.setColor(0,0,0,0.7)
    love.graphics.rectangle('fill',self.xPos-200,self.yPos-150,400,300)
    love.graphics.setColor(1,1,1,1)

    --draw crafting menu
    love.graphics.draw(self.craftingMenuSprite,self.xPos-200,self.yPos-150,nil,1,1)

    --draw crafting menu HUD
    --TODO------------------------
    -- combatInteract button should be accept/craft item
    -- supplies button should be return to game
    --TODO------------------------

    cam:detach()
end

--sets the position of the menu when the player interacts with crafting table
function CraftingMenuState:setPosition(_x,_y)
    self.xPos=_x
    self.yPos=_y
end

--Craft the item as long as player has all the necessary components
function CraftingMenuState:craft(_item)
    --check if player has full quantities of all required items
    for i,requiredItem in pairs(self.reqs[_item]) do 
        --if player doesn't have enough of any required item, just return
        if Player.inventory[requiredItem.name] < requiredItem.quantity then 
            print("don't have enough "..requiredItem.name) 
            --TODO------------------------------
            --notify player that they don't have enough of the required item
            --TODO------------------------------
            return 
        end
    end

    --at this point, they player has full quantities of all required items,
    --remove them from player's inventory
    for i,requiredItem in pairs(self.reqs[_item]) do 
        Player:removeFromInventory(requiredItem.name, requiredItem.quantity)
    end

    --choose a starting point for the item to spawn
    local startX=love.math.random(self.xPos-10,self.xPos+8)
    local startY=love.math.random(self.yPos-10,self.yPos+8)
    
    Items:spawn_item(startX,startY,_item) --spawn the crafted item
end