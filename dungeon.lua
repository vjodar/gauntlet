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

    Rooms:newRoom({4,4}) --create boss room
    Rooms:newRoom({self.startRoom[1],self.startRoom[2]}) --create starting room
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