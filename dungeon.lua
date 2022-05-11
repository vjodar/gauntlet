require 'rooms'

Dungeon={}

function Dungeon:load()
    Rooms:load() --load rooms class

    self.roomsTable={} --holds all rooms in a dungeon

    self.floorObjects={} --holds all objects that on the floor, beneath entities

    self.colliders={} --holds colliders of all outerWalls, doorButtons, and doorBarriers

    --will store the just the crafting table, as we need its reference in order
    --to emit particles from it from within the Crafting Menu code
    self.craftingTable={} 

    --choose a random starting room that's adjacent to the boss room
    local startRoomsTable={{3,4},{4,3},{4,5},{5,4}}
    self.startRoom=startRoomsTable[love.math.random(4)]

    --randomly choose what demi boss will spawn first.
    --will also be used to alternate demi boss spawns
    self.nextDemiBoss=love.math.random(2)

    --randomly choose what broken item will spawn first (bow or staff)
    --will also be used to alternate between next broken item to spawn
    self.nextBrokenItem=love.math.random(2)

    Rooms:newRoom({self.startRoom[1],self.startRoom[2]}) --create starting room
    
    --populate starting room with crafting nodes
    self:spawnCraftingNodes(self.startRoom[1]*Rooms.ROOMWIDTH,self.startRoom[2]*Rooms.ROOMHEIGHT)
end

function Dungeon:spawnCraftingNodes(_x,_y)
    CraftingNodes:spawnCraftingNode('furnace',_x+68,_y+84)
    CraftingNodes:spawnCraftingNode('grill',_x+294,_y+84)
    CraftingNodes:spawnCraftingNode('sawmill',_x+68,_y+248)
    CraftingNodes:spawnCraftingNode('spinning_wheel',_x+294,_y+248)
    CraftingNodes:spawnCraftingNode('crafting_table',_x+176,_y+163)
end

function Dungeon:update()
    for i,room in pairs(self.roomsTable) do room:update() end 
    for i,obj in pairs(self.floorObjects) do obj:update() end
end

--draw floors and objects on the floor, beneath all entities
function Dungeon:drawFloorObjects()
    for i,room in pairs(self.roomsTable) do room:drawFloor() end
    for i,obj in pairs(self.floorObjects) do obj:draw() end 
end

function Dungeon:drawRooms() 
    for i,room in pairs(self.roomsTable) do room:draw() end 
end

function Dungeon:drawForeground()
    --Draw the rooms' foreground features which will appear in front of entities
    for i,room in pairs(self.roomsTable) do room:drawForeground() end 
end

--removes all entities and colliders that were made and used in the dungeon
function Dungeon:closeDungeon()
    Entities:removeAll() --clears entities table (except for player)
    --destroy outerWall and doorBarrier colliders
    for i,collider in pairs(self.colliders) do collider:destroy() end    
    for i,room in pairs(self.roomsTable) do 
        --must destory doorButton colliders using their room. Doesn't work when
        --their collider is added to self.colliders for some reason.
        for j,button in pairs(room.doorButtons) do button.collider:destroy() end 
    end
    for i,floorObj in pairs(self.floorObjects) do floorObj.collider:destroy() end 
end
