Rooms={}

function Rooms:load()
    self.ROOMHEIGHT=320
    self.ROOMWIDTH=384
    self.roomSprites={}
    --middle
    self.roomSprites.middle=love.graphics.newImage('assets/maps/room_middle.png')
    self.roomSprites.middleForeground=love.graphics.newImage('assets/maps/room_middle_foreground.png')
    --cornerTopLeft
    self.roomSprites.cornerTopLeft=love.graphics.newImage('assets/maps/room_cornerTopLeft.png')
    self.roomSprites.cornerTopLeftForeground=love.graphics.newImage('assets/maps/room_cornerTopLeft_foreground.png')
    --sideTop
    self.roomSprites.sideTop=love.graphics.newImage('assets/maps/room_sideTop.png')
    self.roomSprites.sideTopForeground=love.graphics.newImage('assets/maps/room_sideTop_foreground.png')
    --cornerTopRight
    self.roomSprites.cornerTopRight=love.graphics.newImage('assets/maps/room_cornerTopRight.png')
    self.roomSprites.cornerTopRightForeground=love.graphics.newImage('assets/maps/room_cornerTopRight_foreground.png')
    --sideLeft
    self.roomSprites.sideLeft=love.graphics.newImage('assets/maps/room_sideLeft.png')
    self.roomSprites.sideLeftForeground=love.graphics.newImage('assets/maps/room_sideLeft_foreground.png')
    --sideRight
    self.roomSprites.sideRight=love.graphics.newImage('assets/maps/room_sideRight.png')
    self.roomSprites.sideRightForeground=love.graphics.newImage('assets/maps/room_sideRight_foreground.png')
    --cornerBottomLeft
    self.roomSprites.cornerBottomLeft=love.graphics.newImage('assets/maps/room_cornerBottomLeft.png')
    self.roomSprites.cornerBottomLeftForeground=love.graphics.newImage('assets/maps/room_cornerBottomLeft_foreground.png')
    --sideBottom
    self.roomSprites.sideBottom=love.graphics.newImage('assets/maps/room_sideBottom.png')
    self.roomSprites.sideBottomForeground=love.graphics.newImage('assets/maps/room_sideBottom_foreground.png')
    --cornerBottomRight
    self.roomSprites.cornerBottomRight=love.graphics.newImage('assets/maps/room_cornerBottomRight.png')
    self.roomSprites.cornerBottomRightForeground=love.graphics.newImage('assets/maps/room_cornerBottomRight_foreground.png')
end

function Rooms:newRoom(_coordinates)
    local room={}

    room.xPos=_coordinates[1]*self.ROOMWIDTH
    room.yPos=_coordinates[2]*self.ROOMHEIGHT

    if _coordinates[1]==1 then 
        --room is on leftmost position
        if _coordinates[2]==1 then 
            --room is topleft corner
            room.backgroundSprite=self.roomSprites.cornerTopLeft 
            room.foregroundSprite=self.roomSprites.cornerTopLeftForeground
            self:generateWalls(room.xPos,room.yPos,'cornerTopLeft')
        elseif _coordinates[2]==7 then 
            --room is bottomleft corner
            room.backgroundSprite=self.roomSprites.cornerBottomLeft 
            room.foregroundSprite=self.roomSprites.cornerBottomLeftForeground
            self:generateWalls(room.xPos,room.yPos,'cornerBottomLeft')
        else
            --room is left side
            room.backgroundSprite=self.roomSprites.sideLeft
            room.foregroundSprite=self.roomSprites.sideLeftForeground
            self:generateWalls(room.xPos,room.yPos,'sideLeft')
        end
    elseif _coordinates[1]==7 then 
        --room is on rightmost position
        if _coordinates[2]==1 then 
            --room is topright corner
            room.backgroundSprite=self.roomSprites.cornerTopRight
            room.foregroundSprite=self.roomSprites.cornerTopRightForeground
            self:generateWalls(room.xPos,room.yPos,'cornerTopRight')
        elseif _coordinates[2]==7 then 
            --room is bottomright corner
            room.backgroundSprite=self.roomSprites.cornerBottomRight
            room.foregroundSprite=self.roomSprites.cornerBottomRightForeground
            self:generateWalls(room.xPos,room.yPos,'cornerBottomRight')
        else
            --room is right side
            room.backgroundSprite=self.roomSprites.sideRight
            room.foregroundSprite=self.roomSprites.sideRightForeground
            self:generateWalls(room.xPos,room.yPos,'sideRight')
        end
    elseif _coordinates[2]==1 then 
        --room is top side
        room.backgroundSprite=self.roomSprites.sideTop
        room.foregroundSprite=self.roomSprites.sideTopForeground
        self:generateWalls(room.xPos,room.yPos,'sideTop')
    elseif _coordinates[2]==7 then 
        --room is bottom side
        room.backgroundSprite=self.roomSprites.sideBottom
        room.foregroundSprite=self.roomSprites.sideBottomForeground
        self:generateWalls(room.xPos,room.yPos,'sideBottom')
    else
        --room is a middle room
        room.backgroundSprite=self.roomSprites.middle 
        room.foregroundSprite=self.roomSprites.middleForeground
        self:generateWalls(room.xPos,room.yPos,'middle')
    end

    function room:update() end

    function room:draw() 
        love.graphics.draw(self.backgroundSprite,self.xPos,self.yPos)
    end

    function room:drawForeground() 
        love.graphics.draw(self.foregroundSprite,self.xPos,self.yPos)
    end 

    table.insert(Dungeon.roomsTable,room) --insert into Dungeon's roomsTable
end 

--generates the appropriate pattern of collision boxes for the _type room
function Rooms:generateWalls(_xPos,_yPos,_type)
    if _type=='middle' then 
        --top left walls
        world:newBSGRectangleCollider(_xPos,_yPos,37,144,3):setType('static') 
        world:newBSGRectangleCollider(_xPos+37,_yPos,128,48,3):setType('static') 
        --bottom left walls
        world:newBSGRectangleCollider(_xPos,_yPos+203,37,117,3):setType('static')        
        world:newBSGRectangleCollider(_xPos+37,_yPos+298,128,22,3):setType('static')
        --top right walls
        world:newBSGRectangleCollider(_xPos+347,_yPos,37,144,3):setType('static') 
        world:newBSGRectangleCollider(_xPos+219,_yPos,128,48,3):setType('static') 
        --bottom right walls
        world:newBSGRectangleCollider(_xPos+347,_yPos+203,37,117,3):setType('static')     
        world:newBSGRectangleCollider(_xPos+219,_yPos+298,128,22,3):setType('static')
    elseif _type=='sideLeft' then  
        --left walls
        world:newBSGRectangleCollider(_xPos,_yPos,37,320,3):setType('static') 
        world:newBSGRectangleCollider(_xPos+37,_yPos,128,48,3):setType('static') 
        world:newBSGRectangleCollider(_xPos+37,_yPos+298,128,22,3):setType('static')
        --top right walls
        world:newBSGRectangleCollider(_xPos+347,_yPos,37,144,3):setType('static') 
        world:newBSGRectangleCollider(_xPos+219,_yPos,128,48,3):setType('static') 
        --bottom right walls
        world:newBSGRectangleCollider(_xPos+347,_yPos+203,37,117,3):setType('static')     
        world:newBSGRectangleCollider(_xPos+219,_yPos+298,128,22,3):setType('static')
    elseif _type=='sideRight' then 
        --top left walls
        world:newBSGRectangleCollider(_xPos,_yPos,37,144,3):setType('static') 
        world:newBSGRectangleCollider(_xPos+37,_yPos,128,48,3):setType('static') 
        --bottom left walls
        world:newBSGRectangleCollider(_xPos,_yPos+203,37,117,3):setType('static')        
        world:newBSGRectangleCollider(_xPos+37,_yPos+298,128,22,3):setType('static')
        --right walls
        world:newBSGRectangleCollider(_xPos+347,_yPos,37,320,3):setType('static') 
        world:newBSGRectangleCollider(_xPos+219,_yPos,128,48,3):setType('static')    
        world:newBSGRectangleCollider(_xPos+219,_yPos+298,128,22,3):setType('static')
    elseif _type=='sideTop' then 
        --top walls
        world:newBSGRectangleCollider(_xPos,_yPos,37,144,3):setType('static') 
        world:newBSGRectangleCollider(_xPos+37,_yPos,310,48,3):setType('static')
        world:newBSGRectangleCollider(_xPos+347,_yPos,37,144,3):setType('static') 
        --bottom left walls
        world:newBSGRectangleCollider(_xPos,_yPos+203,37,117,3):setType('static')        
        world:newBSGRectangleCollider(_xPos+37,_yPos+298,128,22,3):setType('static')
        --bottom right walls
        world:newBSGRectangleCollider(_xPos+347,_yPos+203,37,117,3):setType('static')     
        world:newBSGRectangleCollider(_xPos+219,_yPos+298,128,22,3):setType('static')
    elseif _type=='sideBottom' then 
        --top left walls
        world:newBSGRectangleCollider(_xPos,_yPos,37,144,3):setType('static') 
        world:newBSGRectangleCollider(_xPos+37,_yPos,128,48,3):setType('static') 
        --top right walls
        world:newBSGRectangleCollider(_xPos+347,_yPos,37,144,3):setType('static') 
        world:newBSGRectangleCollider(_xPos+219,_yPos,128,48,3):setType('static') 
        --bottom walls
        world:newBSGRectangleCollider(_xPos+347,_yPos+203,37,117,3):setType('static') 
        world:newBSGRectangleCollider(_xPos,_yPos+203,37,117,3):setType('static')        
        world:newBSGRectangleCollider(_xPos+37,_yPos+298,310,22,3):setType('static')
    elseif _type=='cornerTopLeft' then 
        --top left walls
        world:newBSGRectangleCollider(_xPos,_yPos,37,320,3):setType('static') 
        world:newBSGRectangleCollider(_xPos+37,_yPos,310,48,3):setType('static') 
        --bottom left wall      
        world:newBSGRectangleCollider(_xPos+37,_yPos+298,128,22,3):setType('static')
        --top right wall
        world:newBSGRectangleCollider(_xPos+347,_yPos,37,144,3):setType('static') 
        --bottom right walls
        world:newBSGRectangleCollider(_xPos+347,_yPos+203,37,117,3):setType('static')     
        world:newBSGRectangleCollider(_xPos+219,_yPos+298,128,22,3):setType('static')
    elseif _type=='cornerBottomLeft' then 
        --top left walls
        world:newBSGRectangleCollider(_xPos+37,_yPos,128,48,3):setType('static') 
        --bottom left walls
        world:newBSGRectangleCollider(_xPos,_yPos,37,320,3):setType('static')        
        world:newBSGRectangleCollider(_xPos+37,_yPos+298,310,22,3):setType('static')
        --top right walls
        world:newBSGRectangleCollider(_xPos+347,_yPos,37,144,3):setType('static') 
        world:newBSGRectangleCollider(_xPos+219,_yPos,128,48,3):setType('static') 
        --bottom right walls
        world:newBSGRectangleCollider(_xPos+347,_yPos+203,37,117,3):setType('static')
    elseif _type=='cornerTopRight' then 
        --top left walls
        world:newBSGRectangleCollider(_xPos,_yPos,37,144,3):setType('static') 
        --bottom left walls
        world:newBSGRectangleCollider(_xPos,_yPos+203,37,117,3):setType('static')        
        world:newBSGRectangleCollider(_xPos+37,_yPos+298,128,22,3):setType('static')
        --top right walls
        world:newBSGRectangleCollider(_xPos+347,_yPos,37,320,3):setType('static') 
        world:newBSGRectangleCollider(_xPos+37,_yPos,310,48,3):setType('static') 
        --bottom right walls    
        world:newBSGRectangleCollider(_xPos+219,_yPos+298,128,22,3):setType('static')
    elseif _type=='cornerBottomRight' then 
        --top left walls
        world:newBSGRectangleCollider(_xPos,_yPos,37,144,3):setType('static') 
        world:newBSGRectangleCollider(_xPos+37,_yPos,128,48,3):setType('static') 
        --bottom walls
        world:newBSGRectangleCollider(_xPos,_yPos+203,37,117,3):setType('static')        
        world:newBSGRectangleCollider(_xPos+37,_yPos+298,310,22,3):setType('static')
        --right walls
        world:newBSGRectangleCollider(_xPos+347,_yPos,37,320,3):setType('static') 
        world:newBSGRectangleCollider(_xPos+219,_yPos,128,48,3):setType('static') 
    end
end