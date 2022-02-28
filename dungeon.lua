Dungeon={}

function Dungeon:load()
    self.roomTypes={}
    self.roomTypes.middle={
        sprite=love.graphics.newImage('assets/maps/room_middle.png'),
        foreground=love.graphics.newImage('assets/maps/room_middle_foreground.png')
    }
    self.ROOMWIDTH=self.roomTypes.middle.sprite:getWidth() --384px
    self.ROOMHEIGHT=self.roomTypes.middle.sprite:getHeight() --320px

    self.roomsTable={} --holds all rooms in a dungeon

    --create center room
    self:newRoom({4,4},self.roomTypes.middle)
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

function Dungeon:newRoom(_coordinates,_type) --room class
    local room={}

    room.sprite=_type.sprite
    room.foreground=_type.foreground 
    room.xPos=_coordinates[1]*Dungeon.ROOMWIDTH
    room.yPos=_coordinates[2]*Dungeon.ROOMHEIGHT

    function room:update() end

    function room:draw() 
        love.graphics.draw(self.sprite,self.xPos,self.yPos)
    end

    function room:drawForeground() 
        love.graphics.draw(self.foreground,self.xPos,self.yPos)
    end 

    table.insert(self.roomsTable,room)
end