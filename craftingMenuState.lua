CraftingMenuState={}

function CraftingMenuState:load()
    self.craftingMenuSprite=love.graphics.newImage('assets/crafting_menu_ui.png')
    self.xPos,self.yPos=0,0
end

function CraftingMenuState:update()
    if acceptInput then 
        if releasedKey=='x' then 
            --choose a starting point around node for the item to spawn
            local startX=love.math.random(self.xPos-7,self.xPos+5)
            local startY=love.math.random(self.yPos-7,self.yPos+5)

            --spawn appropriate item
            Items:spawn_item(startX,startY,'armor_head_t1')
            Items:spawn_item(startX,startY,'armor_chest_t1')
            Items:spawn_item(startX,startY,'armor_legs_t1')
            Items:spawn_item(startX,startY,'weapon_bow_t1')
            Items:spawn_item(startX,startY,'weapon_staff_t1')
        end

        if releasedKey=='z' then return false end --exit crafting menu
    end

    return true --return true to remain on gamestate stack
end

function CraftingMenuState:draw()
    cam:attach()

    --fade out playstate
    love.graphics.setColor(0,0,0,0.7)
    love.graphics.rectangle('fill',self.xPos+self.xOffset,self.yPos+self.yOffset,400,300)
    love.graphics.setColor(1,1,1,1)

    --draw crafting menu
    love.graphics.draw(self.craftingMenuSprite,self.xPos+self.xOffset,self.yPos+self.yOffset,nil,1,1)

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
    self.xOffset=-200
    self.yOffset=-150
end