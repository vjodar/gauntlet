require 'inventory'
require 'actionButtons'
require 'meters'
require 'clock'

Hud={}

function Hud:load()     
    Meters:load() --health and mana bars    
    ActionButtons:load() --action 'buttons' cluster    
    Inventory:load() --HUD inventory
    Clock:load() --load clock
end

function Hud:update()
    Meters:update()
    ActionButtons:update()
    Inventory:update()
    Clock:update()
end

function Hud:draw()
    Meters:draw()
    ActionButtons:draw()
    Inventory:draw()
    Clock:draw()
end