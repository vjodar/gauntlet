Walls={} --walls class builds inner room wall layouts and objects

function Walls:load()
    self.wallSprites={}
    self.wallSprites[1]=love.graphics.newImage('assets/maps/wall_01.png')
    self.wallSprites[2]=love.graphics.newImage('assets/maps/wall_02.png')

    self.layouts={} --table to store all layout generation functions
    self.layouts[1]=function(_room) 
        self:newWall(1,_room.xPos+112,_room.yPos+140)
        self:newWall(2,_room.xPos+64,_room.yPos+204)
        self:newWall(2,_room.xPos+224,_room.yPos+204)
    end 
end

function Walls:newWall(_type,_xPos,_yPos)
    local wall={}

    wall.sprite=self.wallSprites[_type]
    wall.xPos=_xPos
    wall.yPos=_yPos

    --create physical collider
    if _type==1 then world:newRectangleCollider(wall.xPos,wall.yPos,160,4):setType('static')
    elseif _type==2 then world:newRectangleCollider(wall.xPos,wall.yPos,96,4):setType('static')
    end

    function wall:update() end

    function wall:draw() love.graphics.draw(wall.sprite,wall.xPos,wall.yPos,nil,1,1,0,16) end

    --insert into entitiesTable to have dynamic draw order
    table.insert(Entities.entitiesTable,wall)
end