CraftingMenuState={}

function CraftingMenuState:load()
    self.craftingMenuSprite=love.graphics.newImage('assets/crafting_menu_ui.png')
    self.xPos,self.yPos=0,0
end

function CraftingMenuState:update()
    if acceptInput then 
        if releasedKey=='z' then return false end --exit crafting menu
    end

    return true --return true to remain on gamestate stack
end

function CraftingMenuState:draw()
    cam:attach()

    --fade out playstate
    love.graphics.setColor(0,0,0,0.7)
    love.graphics.rectangle('fill',self.xPos,self.yPos,400,300)
    love.graphics.setColor(1,1,1,1)

    --draw crafting menu
    love.graphics.draw(self.craftingMenuSprite,self.xPos,self.yPos,nil,1,1)

    --draw crafting menu HUD
    --TODO------------------------
    -- combatInteract button should be accept/craft item
    -- supplies button should be return to game
    --TODO------------------------

    cam:detach()
end

--sets the position of the menu when the player interacts with crafting table
function CraftingMenuState:setPosition(_x,_y)
    --move origin to center of player
    self.xPos=_x-200
    self.yPos=_y-150
end