require 'doorButton'

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

    DoorButton:load() --load the DoorButton class
end

--Creates a new dungeon room of the correct type given dungeon coordinates.
--First creates an emtpy room, then populates it with obstacles, enemies, 
--and resource nodes at random.
function Rooms:newRoom(_coordinates)
    local room={}

    --coordinates in dungeon
    room.coordinates=_coordinates
    --absolute position in pixels
    room.xPos=room.coordinates[1]*self.ROOMWIDTH
    room.yPos=room.coordinates[2]*self.ROOMHEIGHT

    room.doorButtons={} --table to hold this room's door buttons

    --create and emtpy room complete with collision boxes that fit the room layout
    if _coordinates[1]==1 then 
        --room is on leftmost position
        if _coordinates[2]==1 then 
            --room is topleft corner
            room.type='cornerTopLeft'
            room.backgroundSprite=self.roomSprites.cornerTopLeft 
            room.foregroundSprite=self.roomSprites.cornerTopLeftForeground
            self:generateWalls(room.xPos,room.yPos,room.type)
        elseif _coordinates[2]==7 then 
            --room is bottomleft corner
            room.type='cornerBottomLeft'
            room.backgroundSprite=self.roomSprites.cornerBottomLeft 
            room.foregroundSprite=self.roomSprites.cornerBottomLeftForeground
            self:generateWalls(room.xPos,room.yPos,room.type)
        else
            --room is left side
            room.type='sideLeft'
            room.backgroundSprite=self.roomSprites.sideLeft
            room.foregroundSprite=self.roomSprites.sideLeftForeground
            self:generateWalls(room.xPos,room.yPos,room.type)
        end
    elseif _coordinates[1]==7 then 
        --room is on rightmost position
        if _coordinates[2]==1 then 
            --room is topright corner
            room.type='cornerTopRight'
            room.backgroundSprite=self.roomSprites.cornerTopRight
            room.foregroundSprite=self.roomSprites.cornerTopRightForeground
            self:generateWalls(room.xPos,room.yPos,room.type)
        elseif _coordinates[2]==7 then 
            --room is bottomright corner
            room.type='cornerBottomRight'
            room.backgroundSprite=self.roomSprites.cornerBottomRight
            room.foregroundSprite=self.roomSprites.cornerBottomRightForeground
            self:generateWalls(room.xPos,room.yPos,room.type)
        else
            --room is right side
            room.type='sideRight'
            room.backgroundSprite=self.roomSprites.sideRight
            room.foregroundSprite=self.roomSprites.sideRightForeground
            self:generateWalls(room.xPos,room.yPos,room.type)
        end
    elseif _coordinates[2]==1 then 
        --room is top side
        room.type='sideTop'
        room.backgroundSprite=self.roomSprites.sideTop
        room.foregroundSprite=self.roomSprites.sideTopForeground
        self:generateWalls(room.xPos,room.yPos,room.type)
    elseif _coordinates[2]==7 then 
        --room is bottom side
        room.type='sideBottom'
        room.backgroundSprite=self.roomSprites.sideBottom
        room.foregroundSprite=self.roomSprites.sideBottomForeground
        self:generateWalls(room.xPos,room.yPos,room.type)
    else
        --room is a middle room
        room.type='middle'
        room.backgroundSprite=self.roomSprites.middle 
        room.foregroundSprite=self.roomSprites.middleForeground
        self:generateWalls(room.xPos,room.yPos,room.type)
        self:generateDoorButtons(room.xPos,room.yPos,room.type,room.doorButtons)
    end

    --TODO
    --Randomly select a layout of obstacles that entities cannot pass nor spawn in
    --TODO

    --TODO
    --Randomly spawn some resource nodes
        --resource nodes shouldn't spawn too close to any other resource nodes or doorButtons
    --TODO

    --TODO
    --Randomly spawn some enemies
        --Only t1 enemies can spawn in the innermost ring of rooms
        --t2 enemies can spawn anywhere past the innermost ring except for rooms with mini bosses
        --if a Mage spawns, only t1 enemies can spawn alongside it (because it uses magical projectile)
        --t3 enemies/Mini bosses should only spawn on the outermost rooms
    --TODO

    function room:update() 
        --update all buttons in this room
        for i,button in pairs(self.doorButtons) do 
            button:update()

            --check if a doorButton has been pressed by the player
            if button.pressed==true then 
                button.pressed=false --prevent infinite loops
                local pressedButtonName=button.name 
                --one of the doorButtons have been pressed by the player, activate
                --it and its sister button on opposite side of the doorway
                for i,b in pairs(self.doorButtons) do 
                    if b.name==pressedButtonName then 
                        b.currentAnim:resume() --animate button press
                    end
                end

                --create a new room adjacent to the pressed doorButtons
                if pressedButtonName=='doorButtonTop' then 
                    Rooms:newRoom({self.coordinates[1],self.coordinates[2]-1})
                elseif pressedButtonName=='doorButtonBottom' then 
                    Rooms:newRoom({self.coordinates[1],self.coordinates[2]+1})
                elseif pressedButtonName=='doorButtonLeft' then 
                    Rooms:newRoom({self.coordinates[1]-1,self.coordinates[2]})
                elseif pressedButtonName=='doorButtonRight' then 
                    Rooms:newRoom({self.coordinates[1]+1,self.coordinates[2]})
                end
            end
        end
    end

    function room:draw() 
        love.graphics.draw(self.backgroundSprite,self.xPos,self.yPos)
        for i,button in pairs(self.doorButtons) do button:draw() end 
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

--takes a room's doorButtons table, its position, and its type/layout, 
--generates the appropriate set of door button objects, and fills the _table with them
function Rooms:generateDoorButtons(_xPos,_yPos,_type,_table)
    local xPos=_xPos 
    local yPos=_yPos 
    local type=_type 
    local tab=_table

    if type=='middle' then 
        table.insert(tab,DoorButton:newDoorButton(xPos+131,yPos+32,'doorButtonTop'))
        table.insert(tab,DoorButton:newDoorButton(xPos+242,yPos+32,'doorButtonTop'))
        table.insert(tab,DoorButton:newDoorButton(xPos+36,yPos+114,'doorButtonLeft'))
        table.insert(tab,DoorButton:newDoorButton(xPos+36,yPos+226,'doorButtonLeft'))
        table.insert(tab,DoorButton:newDoorButton(xPos+348,yPos+114,'doorButtonRight'))
        table.insert(tab,DoorButton:newDoorButton(xPos+348,yPos+226,'doorButtonRight'))
    end
end