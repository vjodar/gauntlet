CraftingMenuState={}

function CraftingMenuState:load()
    self.xPos,self.yPos=0,0
    self.alpha=0

    self.menu={}
    self.menu.sprite=love.graphics.newImage('assets/crafting_menu/menu.png')
    self.menu.xPos,self.menu.yPos=0,0

    self.cursor={}
    self.cursor.sprite=love.graphics.newImage('assets/crafting_menu/cursor.png')
    self.cursor.xPos,self.cursor.yPos=0,0
    self.cursor.selection='potion' --potion, head, chest, legs, bow, or staff

    self.icons={}
    self.icons.sprites={
        potion=Items.sprites['potion'],
        armor_head_t1=Items.sprites['armor_head_t1'],
        armor_head_t2=Items.sprites['armor_head_t2'],
        armor_head_t3=Items.sprites['armor_head_t3'],
        armor_chest_t1=Items.sprites['armor_chest_t1'],
        armor_chest_t2=Items.sprites['armor_chest_t2'],
        armor_chest_t3=Items.sprites['armor_chest_t3'],
        armor_legs_t1=Items.sprites['armor_legs_t1'],
        armor_legs_t2=Items.sprites['armor_legs_t2'],
        armor_legs_t3=Items.sprites['armor_legs_t3'],
        weapon_bow_t1=Items.sprites['weapon_bow_t1'],
        weapon_bow_t2=Items.sprites['weapon_bow_t2'],
        weapon_bow_t3=Items.sprites['weapon_bow_t3'],
        weapon_staff_t1=Items.sprites['weapon_staff_t1'],
        weapon_staff_t2=Items.sprites['weapon_staff_t2'],
        weapon_staff_t3=Items.sprites['weapon_staff_t3']
    }
    self.icons.positions={
        potion={x=0,y=0},
        head={x=0,y=0},
        chest={x=0,y=0},
        legs={x=0,y=0},
        bow={x=0,y=0},
        staff={x=0,y=0}
    }

    self.currentCraftOptions={ --start with tier 1 gear, will progress as player crafts
        potion='potion',
        head='armor_head_t1',
        chest='armor_chest_t1',
        legs='armor_legs_t1',
        bow='weapon_bow_t1',
        staff='weapon_staff_t1'
    }

    --items and their quantities required to craft each item
    self.reqs={
        armor_head_t1={
            {name='arcane_shards',quantity=4},
            {name='rock_metal',quantity=1},
            {name='tree_planks',quantity=1},
            {name='vine_thread',quantity=1},
        },
        armor_chest_t1={
            {name='arcane_shards',quantity=4},
            {name='rock_metal',quantity=1},
            {name='tree_planks',quantity=1},
            {name='vine_thread',quantity=1},
        },
        armor_legs_t1={
            {name='arcane_shards',quantity=4},
            {name='rock_metal',quantity=1},
            {name='tree_planks',quantity=1},
            {name='vine_thread',quantity=1},
        },
        armor_head_t2={
            {name='arcane_shards',quantity=6},
            {name='rock_metal',quantity=1},
            {name='tree_planks',quantity=1},
            {name='vine_thread',quantity=1},
            {name='armor_head_t1',quantity=1},
        },
        armor_chest_t2={
            {name='arcane_shards',quantity=6},
            {name='rock_metal',quantity=2},
            {name='tree_planks',quantity=2},
            {name='vine_thread',quantity=2},
            {name='armor_chest_t1',quantity=1},
        },
        armor_legs_t2={
            {name='arcane_shards',quantity=6},
            {name='rock_metal',quantity=1},
            {name='tree_planks',quantity=1},
            {name='vine_thread',quantity=1},
            {name='armor_legs_t1',quantity=1},
        },
        armor_head_t3={
            {name='arcane_shards',quantity=8},
            {name='rock_metal',quantity=2},
            {name='tree_planks',quantity=2},
            {name='vine_thread',quantity=2},
            {name='armor_head_t2',quantity=1},
        },
        armor_chest_t3={
            {name='arcane_shards',quantity=8},
            {name='rock_metal',quantity=2},
            {name='tree_planks',quantity=2},
            {name='vine_thread',quantity=2},
            {name='armor_chest_t2',quantity=1},
        },
        armor_legs_t3={
            {name='arcane_shards',quantity=8},
            {name='rock_metal',quantity=2},
            {name='tree_planks',quantity=2},
            {name='vine_thread',quantity=2},
            {name='armor_legs_t2',quantity=1},
        },
        weapon_bow_t1={
            {name='arcane_shards',quantity=2},
            {name='broken_bow',quantity=1},
        },
        weapon_bow_t2={
            {name='arcane_shards',quantity=6},
            {name='weapon_bow_t1',quantity=1},
        },
        weapon_bow_t3={            
            {name='weapon_bow_t2',quantity=1},
            {name='arcane_bowstring',quantity=1},
        },
        weapon_staff_t1={
            {name='arcane_shards',quantity=2},
            {name='broken_staff',quantity=1},
        },
        weapon_staff_t2={
            {name='arcane_shards',quantity=6},
            {name='weapon_staff_t1',quantity=1},
        },
        weapon_staff_t3={
            {name='weapon_staff_t2',quantity=1},
            {name='arcane_orb',quantity=1},
        },
        potion={
            {name='arcane_shards',quantity=2},
            {name='fungi_mushroom',quantity=1},
        }
    }

    --dialogs the player will say upon failing to craft an item due to insufficient requirements
    self.failedCraftDialog={
        arcane_shards='Arcane Shards',
        tree_planks='Wood Planks',
        rock_metal='Metal Bars',
        vine_thread='Thread',
        fungi_mushroom='a Magical Mushroom',

        armor_head_t1='a Bronze Helmet',
        armor_chest_t1='a Bronze Platebody',
        armor_legs_t1='a Bronze Boots',

        armor_head_t2='a Steel Helmet',
        armor_chest_t2='a Steel Platebody',
        armor_legs_t2='a Steel Boots',
        
        broken_bow='a Broken Bow',
        broken_staff='a Broken Staff',

        weapon_bow_t1='a Basic Bow',
        weapon_bow_t2='an Upgraded Bow',

        weapon_staff_t1='a Basic Staff',
        weapon_staff_t2='an Upgraded Staff',

        arcane_orb='an Arcane Orb',
        arcane_bowstring='an Arcane Bowstring'
    }

    self.state={} --metatable
    self.state.keyIsReleased=false --checks if the player released the 'open menu' button 
end

function CraftingMenuState:update()
    Inventory:open() --open HUD inventory to show players their items.

    --gameState must be accepting input and the player must have released the
    --'open crafting menu' button before inputs regarding crafting will be taken
    if acceptInput and self.state.keyIsReleased and not self.state.waitingForCursor then
        if releasedKey=='x' then 
            --craft the current selected item
            self:craft(self.currentCraftOptions[self.cursor.selection])
        end

        --move cursor
        if releasedKey=='right' then
            if self.cursor.selection=='staff' then --wrap around to potion
                self.cursor.selection='potion'
                self.cursor.xPos=self.menu.xPos+4
            else --move to the right, update cursor selection
                if self.cursor.selection=='potion' then self.cursor.selection='head'
                elseif self.cursor.selection=='head' then self.cursor.selection='chest'
                elseif self.cursor.selection=='chest' then self.cursor.selection='legs'
                elseif self.cursor.selection=='legs' then self.cursor.selection='bow'
                elseif self.cursor.selection=='bow' then self.cursor.selection='staff'
                end
                self.cursor.xPos=self.cursor.xPos+19
            end
        elseif releasedKey=='left' then 
            if self.cursor.selection=='potion' then --wrap around to staff
                self.cursor.selection='staff'
                self.cursor.xPos=self.menu.xPos+99
            else --move to the left, update cursor selection
                if self.cursor.selection=='staff' then self.cursor.selection='bow'
                elseif self.cursor.selection=='bow' then self.cursor.selection='legs'
                elseif self.cursor.selection=='legs' then self.cursor.selection='chest'
                elseif self.cursor.selection=='chest' then self.cursor.selection='head'
                elseif self.cursor.selection=='head' then self.cursor.selection='potion'
                end
                self.cursor.xPos=self.cursor.xPos-19
            end
        end

        if releasedKey=='z' then return false end --exit crafting menu
    end

    --just to ensure the player releases the 'open crafting menu' button before proceeding
    if self.state.keyIsReleased==false then 
        if acceptInput and releasedKey=='x' then self.state.keyIsReleased=true end
    end

    return true --return true to remain on gamestate stack
end

function CraftingMenuState:draw()
    cam:attach()

    --fade out playstate
    love.graphics.setColor(0,0,0,self.alpha)
    love.graphics.rectangle('fill',self.xPos-200,self.yPos-150,400,300)
    love.graphics.setColor(1,1,1,self.alpha+0.5)

    Player.dialog:draw(Player.xPos,Player.yPos) --redraw player dialog so it isn't faded

    --draw crafting menu
    love.graphics.draw(self.menu.sprite,self.menu.xPos,self.menu.yPos)
    --draw cursor
    love.graphics.draw(self.cursor.sprite,self.cursor.xPos,self.cursor.yPos)
    --draw icons of current crafting options
    for icon,value in pairs(self.currentCraftOptions) do 
        love.graphics.draw(
            self.icons.sprites[self.currentCraftOptions[icon]],
            self.icons.positions[icon].x,self.icons.positions[icon].y
        )
    end

    cam:detach()

    --draw HUD again to keep it on top of menu
    Hud:draw()
end

--opens the crafting menu. Called by the enchanted crafting table craftingNode
function CraftingMenuState:openCraftingMenu(_x,_y)
    self.xPos=_x 
    self.yPos=_y

    self.menu.xPos=self.xPos-63
    self.menu.yPos=self.yPos-100

    self.cursor.selection='potion'
    self.cursor.xPos=self.menu.xPos+4
    self.cursor.yPos=self.menu.yPos+4

    self.icons.positions={
        potion={x=self.menu.xPos+10,y=self.menu.yPos+18},
        head={x=self.menu.xPos+26,y=self.menu.yPos+15},
        chest={x=self.menu.xPos+48,y=self.menu.yPos+22},
        legs={x=self.menu.xPos+67,y=self.menu.yPos+22},
        bow={x=self.menu.xPos+87,y=self.menu.yPos+9},
        staff={x=self.menu.xPos+106,y=self.menu.yPos+7}
    }

    self.alpha=0

    TimerState:tweenVal(self,'alpha',0.7,0.2)

    self.state.keyIsReleased=false --hasn't yet released the key used to open this menu
    
    --TODO------------------------
    -- combatInteract button should be accept/craft item
    -- supplies button should be return to game
    --TODO------------------------
end

--Craft the item as long as player has all the necessary components
function CraftingMenuState:craft(_item)
    local failureDialog='I need' --will build to let the player know what they don't have enough of.

    --check if player has full quantities of all required items
    for i,requiredItem in pairs(self.reqs[_item]) do 
        --if player doesn't have enough of any required item, 
        --add the item to the failure dialog.
        if Player.inventory[requiredItem.name] < requiredItem.quantity then 
            if #failureDialog==6 then 
                --add the word 'more' where appropriate
                if requiredItem.name=='arcane_shards'
                or requiredItem.name=='wood_planks'
                or requiredItem.name=='rock_metal'
                or requiredItem.name=='vine_thread'
                then failureDialog=failureDialog..' more' end 
            end
            failureDialog=failureDialog.." "..self.failedCraftDialog[requiredItem.name]..','
        end
    end
    failureDialog=string.sub(failureDialog,1,#failureDialog-1) --remove the last comma

    if #failureDialog>6 then Player.dialog:say(failureDialog) return end 

    --at this point, they player has full quantities of all required items,
    --remove them from player's inventory
    for i,requiredItem in pairs(self.reqs[_item]) do 
        Player:removeFromInventory(requiredItem.name,requiredItem.quantity)
    end
    
    Items:spawn_item(Player.xPos,Player.yPos,_item) --spawn crafted item
    if _item=='potion' then --if potion, spawn 2 more (1 mushroom makes 3 potions)
        for i=1,2 do Items:spawn_item(Player.xPos,Player.yPos,_item) end 
    end

    self:updateCraftingOptions(_item) --update current craft options
end

--updates the current crafting options based on what was last crafted
function CraftingMenuState:updateCraftingOptions(_lastItemCrafted)
    local last=_lastItemCrafted
    local options=self.currentCraftOptions

    if last=='armor_head_t1' then options.head='armor_head_t2' 
    elseif last=='armor_head_t2' then options.head='armor_head_t3'  

    elseif last=='armor_chest_t1' then options.chest='armor_chest_t2'  
    elseif last=='armor_chest_t2' then options.chest='armor_chest_t3'  

    elseif last=='armor_legs_t1' then options.legs='armor_legs_t2'  
    elseif last=='armor_legs_t2' then options.legs='armor_legs_t3'  

    elseif last=='weapon_bow_t1' then options.bow='weapon_bow_t2'  
    elseif last=='weapon_bow_t2' then options.bow='weapon_bow_t3'  

    elseif last=='weapon_staff_t1' then options.staff='weapon_staff_t2'  
    elseif last=='weapon_staff_t2' then options.staff='weapon_staff_t3'
    end
end