require 'rooms'

Dungeon={}

function Dungeon:load()
    Rooms:load() --load rooms class

    self.roomsTable={} --holds all rooms in a dungeon

    -- --test all rooms
    -- for i=1,7 do for j=1,7 do Rooms:newRoom({i,j}) end end

    --create starting room
    Rooms:newRoom({4,4})
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