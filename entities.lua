--This class is used to draw all players,enemies,resource nodes, etc to the screen
--in order of their y-position value in order to achieve a 3D look. Entities with
--higher yPos values are drawn later in order to make them look like they're in the
--foreground.
Entities={}

function Entities:load() 
    --All other entity classes will add their objects to this table to be
    --updated and then sorted by their yPos value before being drawn
    self.entitiesTable={}

    --Only entities that are within draw distance (in the camera's view) 
    --will be updated and drawn. This table will hold those entities.
    self.entitiesInDrawDistance={}

    --used to delay the clearing of entities from entitiesTable until
    --after everything is done updating (to prevent bugs).
    self.willRemoveAll=false

    --sorting function to be used in table.sort()
    --takes two entities and returns the one with the larger yPos value.
    self.sort=function(e1,e2) return e1.yPos<e2.yPos end
end

function Entities:update()
    self.entitiesInDrawDistance={} --reset table

    --go through entitiesTable, add entities that are within draw distance to
    --entitiesInDrawDistance table.
    for i,entity in pairs(self.entitiesTable) do 
        if math.abs(camTarget.xPos-entity.xPos)<400
        and math.abs(camTarget.yPos-entity.yPos)<300
        then table.insert(self.entitiesInDrawDistance,entity) end 
    end
    --sort the entitiesInDrawDistance by yPos value
    table.sort(self.entitiesInDrawDistance, self.sort)

    --update all entities within draw distance
    for i,entity in pairs(self.entitiesInDrawDistance) do 
        --update entity, if it returns false, remove it from game (both tables)
        if entity:update()==false then 
            for j,e in pairs(self.entitiesTable) do 
                if e==entity then table.remove(self.entitiesTable,j) end 
            end
            table.remove(self.entitiesInDrawDistance,i)
        end 
    end

    if self.willRemoveAll then 
        local tempPlayer=Player --save Player
        for i,e in pairs(self.entitiesTable) do --destroy any colliders
            if e.collider and e~=tempPlayer then 
                if not e.collider:isDestroyed() then e.collider:destroy() end  
            end 
        end
        self.entitiesTable={} --clear table
        table.insert(self.entitiesTable,tempPlayer) --restore player
        self.willRemoveAll=false
    end
end

function Entities:draw() 
    --draw all entities within draw distance
    for i,entity in pairs(self.entitiesInDrawDistance) do entity:draw() end
end

--clears the entities table and destroys all colliders (except the player)
--on the next frame (will wait for everything to finish their updates)
function Entities:removeAll() self.willRemoveAll=true end
