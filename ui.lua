UI={} --for things like dialog, healthbars, tooltips, etc.

function UI:draw()
    for i,entity in pairs(Entities.entitiesInDrawDistance) do 
        --draw all entities' uiElements, if they have the function
        if entity.drawUIelements then entity:drawUIelements() end
    end
end