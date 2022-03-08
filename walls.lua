Walls={} --walls class builds inner room wall layouts and objects

function Walls:load()
    self.wallSprites={}
    self.wallSprites.horizontalLeft=love.graphics.newImage('assets/maps/wall_horizontal_left.png')
    self.wallSprites.horizontalMiddle=love.graphics.newImage('assets/maps/wall_horizontal_middle.png')
    self.wallSprites.horizontalRight=love.graphics.newImage('assets/maps/wall_horizontal_right.png')
    self.wallSprites.verticalTop=love.graphics.newImage('assets/maps/wall_vertical_top.png')
    self.wallSprites.verticalMiddle=love.graphics.newImage('assets/maps/wall_vertical_middle.png')
    self.wallSprites.verticalBottom=love.graphics.newImage('assets/maps/wall_vertical_bottom.png')

    self.layouts={} --table to store all layout generation functions
    self.layouts[1]=function(_room) 
        self:newWall(_room.xPos+112,16+_room.yPos+124,'horizontal',160)
        self:newWall(_room.xPos+64,16+_room.yPos+188,'horizontal',96)
        self:newWall(_room.xPos+224,16+_room.yPos+188,'horizontal',96)
    end 
    self.layouts[2]=function(_room)
        self:newWall(_room.xPos+112,16+_room.yPos+188,'horizontal',160)
        self:newWall(_room.xPos+64,16+_room.yPos+124,'horizontal',96)
        self:newWall(_room.xPos+224,16+_room.yPos+124,'horizontal',96)
    end
    self.layouts[3]=function(_room)
        self:newWall(_room.xPos+219,16+_room.yPos+111,'vertical',96)
        self:newWall(_room.xPos+160,16+_room.yPos+63,'vertical',80)
        self:newWall(_room.xPos+160,16+_room.yPos+175,'vertical',80)
    end
    self.layouts[4]=function(_room)
        self:newWall(_room.xPos+160,16+_room.yPos+111,'vertical',96)
        self:newWall(_room.xPos+219,16+_room.yPos+63,'vertical',80)
        self:newWall(_room.xPos+219,16+_room.yPos+175,'vertical',80)
    end
    -- self.layouts[5]=function(_room)
    --     self:newWall(5,_room.xPos+100,16+_room.yPos+92)
    --     self:newWall(5,_room.xPos+100,16+_room.yPos+236)
    --     self:newWall(6,_room.xPos+96,16+_room.yPos+92)
    --     self:newWall(7,_room.xPos+235,16+_room.yPos+108)
    --     self:newWall(7,_room.xPos+235,16+_room.yPos+220)
    --     self:newWall(8,_room.xPos+283,16+_room.yPos+108)
    -- end
    -- self.layouts[6]=function(_room)
    --     self:newWall(5,_room.xPos+219,16+_room.yPos+92)
    --     self:newWall(5,_room.xPos+219,16+_room.yPos+236)
    --     self:newWall(6,_room.xPos+283,16+_room.yPos+92)
    --     self:newWall(7,_room.xPos+100,16+_room.yPos+108)
    --     self:newWall(7,_room.xPos+100,16+_room.yPos+220)
    --     self:newWall(8,_room.xPos+96,16+_room.yPos+108)
    -- end
end

function Walls:newWall(_xPos,_yPos,_type,_length)
    local wall={}

    wall.xPos=_xPos
    wall.yPos=_yPos
    wall.type=_type
    wall.sprites={}

    if wall.type=='horizontal' then
        wall.sprites.left=self.wallSprites.horizontalLeft
        wall.sprites.right=self.wallSprites.horizontalRight
        wall.sprites.middle=self.wallSprites.horizontalMiddle
        wall.w=_length
        wall.h=20
        wall.numMiddleSegments=(wall.w-32) / 16
    elseif wall.type=='vertical' then
        wall.sprites.top=self.wallSprites.verticalTop
        wall.sprites.bottom=self.wallSprites.verticalBottom 
        wall.sprites.middle=self.wallSprites.verticalMiddle
        wall.w=5
        wall.h=_length
        wall.numMiddleSegments=(wall.h-32) / 16
        print(wall.numMiddleSegments)
    end

    --create physical collider
    world:newRectangleCollider(wall.xPos,wall.yPos,wall.w,wall.h-16):setType('static')

    function wall:update() end

    function wall:draw() 
        if wall.type=='horizontal' then 
            love.graphics.draw(wall.sprites.left,wall.xPos,wall.yPos,nil,1,1,0,16)
            for i=1,wall.numMiddleSegments do 
                love.graphics.draw(wall.sprites.middle,wall.xPos+(16*i),wall.yPos,nil,1,1,0,16)
            end
            love.graphics.draw(wall.sprites.right,wall.xPos+wall.w-16,wall.yPos,nil,1,1,0,16)
        else -- wall.type==vertical
            love.graphics.draw(wall.sprites.top,wall.xPos,wall.yPos,nil,1,1,0,16)
            for i=1,wall.numMiddleSegments do 
                love.graphics.draw(wall.sprites.middle,wall.xPos,wall.yPos+(16*i),nil,1,1,0,16)
            end
            love.graphics.draw(wall.sprites.bottom,wall.xPos,wall.yPos+wall.h-16,nil,1,1,0,16)
        end
    end

    --insert into entitiesTable to have dynamic draw order
    table.insert(Entities.entitiesTable,wall)
end