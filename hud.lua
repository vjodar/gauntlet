require 'inventory'
require 'actionButtons'

Hud={}

function Hud:load() 
    --health and mana bar
    self.healthbar={
        sprite=love.graphics.newImage('assets/hud_healthbar.png'),
        xPos=2*windowScaleX, yPos=2*windowScaleY
    }
    self.manabar={
        sprite=love.graphics.newImage('assets/hud_manabar.png'),
        xPos=2*windowScaleX, yPos=22*windowScaleY
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
        nil,windowScaleX,windowScaleY
    )
    love.graphics.draw( --manabar
        self.manabar.sprite,
        self.manabar.xPos, self.manabar.yPos,
        nil,windowScaleX,windowScaleY
    )

    --action buttons
    ActionButtons:draw()

    --inventory
    Inventory:draw()
end