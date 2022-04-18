require 'inventory'
require 'actionButtons'

Hud={}

function Hud:load() 
    --health and mana bar
    self.healthbar={
        sprite=love.graphics.newImage('assets/hud/bars/hud_healthbar.png'),
        xPos=2*WINDOWSCALE_X, yPos=2*WINDOWSCALE_Y
    }
    self.manabar={
        sprite=love.graphics.newImage('assets/hud/bars/hud_manabar.png'),
        xPos=2*WINDOWSCALE_X, yPos=22*WINDOWSCALE_Y
    }

    --action 'buttons' cluster
    ActionButtons:load()

    --inventory
    Inventory:load()
end

function Hud:update()
    Inventory:update()
    ActionButtons:update()
end

function Hud:draw()
    love.graphics.draw( --healthbar
        self.healthbar.sprite,
        self.healthbar.xPos, self.healthbar.yPos,
        nil,WINDOWSCALE_X,WINDOWSCALE_Y
    )
    love.graphics.draw( --manabar
        self.manabar.sprite,
        self.manabar.xPos, self.manabar.yPos,
        nil,WINDOWSCALE_X,WINDOWSCALE_Y
    )

    --action buttons
    ActionButtons:draw()

    --inventory
    Inventory:draw()
end