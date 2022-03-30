require 'rooms'

Dungeon={}

function Dungeon:load()
    Rooms:load() --load rooms class

    self.roomsTable={} --holds all rooms in a dungeon

    --choose a random starting room that's adjacent to the boss room
    local startRoomsTable={{3,4},{4,3},{4,5},{5,4}}
    self.startRoom=startRoomsTable[love.math.random(4)]

    --randomly choose what demi boss will spawn first.
    --will also be used to alternate demi boss spawns
    self.nextDemiBoss=love.math.random(2)

    Rooms:newRoom({self.startRoom[1],self.startRoom[2]}) --create starting room
    
    --populate starting room with crafting nodes
    self:spawnCraftingNodes(self.startRoom[1]*Rooms.ROOMWIDTH,self.startRoom[2]*Rooms.ROOMHEIGHT)
end

function Dungeon:spawnCraftingNodes(_x,_y)
    CraftingNodes:spawnCraftingNode('furnace',_x+68,_y+84)
    CraftingNodes:spawnCraftingNode('grill',_x+294,_y+84)
    CraftingNodes:spawnCraftingNode('sawmill',_x+68,_y+248)
    CraftingNodes:spawnCraftingNode('spinning_wheel',_x+294,_y+248)
    CraftingNodes:spawnCraftingNode('crafting_table',_x+181,_y+160)
end

function Dungeon:update()
    for i,room in pairs(self.roomsTable) do room:update() end 
end

function Dungeon:draw()
    for i,room in pairs(self.roomsTable) do room:draw() end 
end

function Dungeon:drawForeground()
    --Draw the rooms' foreground features which will appear in front of entities
    for i,room in pairs(self.roomsTable) do room:drawForeground() end 
end