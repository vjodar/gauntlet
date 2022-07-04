UI={} --for things like dialog, healthbars, tooltips, etc.

function UI:draw()
    for i,entity in pairs(Entities.entitiesInDrawDistance) do 
        --draw all entities' uiElements, if they have the function
        if entity.drawUIelements then entity:drawUIelements() end
    end

    for i,room in pairs(Dungeon.roomsTable) do 
        for j,button in pairs(room.doorButtons) do 
            if button.drawUIelements then button:drawUIelements() end 
        end
    end
end