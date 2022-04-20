require 'inventory'
require 'actionButtons'
require 'meters'

Hud={}

function Hud:load()     
    Meters:load() --health and mana bars    
    ActionButtons:load() --action 'buttons' cluster    
    Inventory:load() --HUD inventory
end

function Hud:update()
    Meters:update()
    ActionButtons:update()
    Inventory:update()
end

function Hud:draw()
    Meters:draw()
    ActionButtons:draw()
    Inventory:draw()
end