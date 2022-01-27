--This class is used to draw all players,enemies,resource nodes, etc to the screen
--in order of their y-position value in order to achieve a 3D look. Entities with
--higher yPos values are drawn later in order to make them look like they're in the
--foreground.
Entities={}

function Entities:load() 
    --All other entity classes will add their objects to this table to be
    --updated and then sorted by their yPos value before being drawn
    self.entitiesTable={}
end

function Entities:update() 
    --sort the entitiesTable by yPos value
    table.sort(self.entitiesTable, function(e1,e2) return e1.yPos<e2.yPos end)

    for i,entity in pairs(self.entitiesTable) do entity:update() end
end

function Entities:draw() 
    for i,entity in pairs(self.entitiesTable) do entity:draw() end
end