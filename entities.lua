--This class is used to draw all players,enemies,resource nodes, etc to the screen
--in order of their y-position value in order to achieve a 3D look. Entities with
--higher yPos values are drawn later in order to make them look like they're in the
--foreground.
Entities={}

function Entities:load() 
    --All other entity classes will add their objects to this table to be
    --updated and then sorted by their yPos value before being drawn
    self.entitiesTable={}

    --sorting function to be used in table.sort()
    --takes two entities and returns the one with the larger yPos value.
    self.sort=function(e1,e2) return e1.yPos<e2.yPos end
end

function Entities:update() 
    --sort the entitiesTable by yPos value
    table.sort(self.entitiesTable, self.sort)

    for i,entity in pairs(self.entitiesTable) do 
        if math.abs(Player.xPos-entity.xPos)<500 and 
        math.abs(Player.yPos-entity.yPos)<400 then
            --update entity, if it returns false, remove it from game
            if entity:update()==false then table.remove(self.entitiesTable,i) end 
        end
    end
end

function Entities:draw() 
    for i,entity in pairs(self.entitiesTable) do 
        if math.abs(Player.xPos-entity.xPos)<500 and 
        math.abs(Player.yPos-entity.yPos)<400 then
            entity:draw() 
        end
    end
end