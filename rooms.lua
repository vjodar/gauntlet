require 'doorButton'
require 'walls'

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

    --room lighting (to show player what buttons are pressed)
    self.lightSprites={}
    self.lightSprites.top=love.graphics.newImage('assets/maps/room_light_top.png')
    self.lightSprites.bottom=love.graphics.newImage('assets/maps/room_light_bottom.png')
    self.lightSprites.side=love.graphics.newImage('assets/maps/room_light_side.png')
    
    DoorButton:load() --initialize DoorButton class
    Walls:load() --initialize Walls class
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

    room.lightSprites={}
    room.lightSprites.top=self.lightSprites.top
    room.lightSprites.bottom=self.lightSprites.bottom
    room.lightSprites.left=self.lightSprites.side
    room.lightSprites.right=self.lightSprites.side 
    room.isLit={} --to check which light needs to be on
    room.isLit.top=false 
    room.isLit.bottom=false 
    room.isLit.left=false 
    room.isLit.right=false 

    --create and emtpy room complete with collision boxes that fit the room layout
    --then generate doorButtons and room lights
    if _coordinates[1]==1 then 
        --room is on leftmost position
        if _coordinates[2]==1 then 
            --room is topleft corner
            room.type='cornerTopLeft'
            room.backgroundSprite=self.roomSprites.cornerTopLeft 
            room.foregroundSprite=self.roomSprites.cornerTopLeftForeground
            self:generateWalls(room)
            self:generateDoorButtons(room)
            self:generateLights(room)
        elseif _coordinates[2]==7 then 
            --room is bottomleft corner
            room.type='cornerBottomLeft'
            room.backgroundSprite=self.roomSprites.cornerBottomLeft 
            room.foregroundSprite=self.roomSprites.cornerBottomLeftForeground
            self:generateWalls(room)
            self:generateDoorButtons(room)
            self:generateLights(room)
        else
            --room is left side
            room.type='sideLeft'
            room.backgroundSprite=self.roomSprites.sideLeft
            room.foregroundSprite=self.roomSprites.sideLeftForeground
            self:generateWalls(room)
            self:generateDoorButtons(room)
            self:generateLights(room)
        end
    elseif _coordinates[1]==7 then 
        --room is on rightmost position
        if _coordinates[2]==1 then 
            --room is topright corner
            room.type='cornerTopRight'
            room.backgroundSprite=self.roomSprites.cornerTopRight
            room.foregroundSprite=self.roomSprites.cornerTopRightForeground
            self:generateWalls(room)
            self:generateDoorButtons(room)
            self:generateLights(room)
        elseif _coordinates[2]==7 then 
            --room is bottomright corner
            room.type='cornerBottomRight'
            room.backgroundSprite=self.roomSprites.cornerBottomRight
            room.foregroundSprite=self.roomSprites.cornerBottomRightForeground
            self:generateWalls(room)
            self:generateDoorButtons(room)
            self:generateLights(room)
        else
            --room is right side
            room.type='sideRight'
            room.backgroundSprite=self.roomSprites.sideRight
            room.foregroundSprite=self.roomSprites.sideRightForeground
            self:generateWalls(room)
            self:generateDoorButtons(room)
            self:generateLights(room)
        end
    elseif _coordinates[2]==1 then 
        --room is top side
        room.type='sideTop'
        room.backgroundSprite=self.roomSprites.sideTop
        room.foregroundSprite=self.roomSprites.sideTopForeground
        self:generateWalls(room)
        self:generateDoorButtons(room)
        self:generateLights(room)
    elseif _coordinates[2]==7 then 
        --room is bottom side
        room.type='sideBottom'
        room.backgroundSprite=self.roomSprites.sideBottom
        room.foregroundSprite=self.roomSprites.sideBottomForeground
        self:generateWalls(room)
        self:generateDoorButtons(room)
        self:generateLights(room)
    else
        --room is a middle room
        room.type='middle'
        room.backgroundSprite=self.roomSprites.middle 
        room.foregroundSprite=self.roomSprites.middleForeground
        self:generateWalls(room)
        self:generateDoorButtons(room)
        self:generateLights(room)
        --choose a random layout for innerroom walls
        -- Walls.layouts[love.math.random(#Walls.layouts)](room)
        Walls.layouts[#Walls.layouts](room)
    end

    function room:update() 
        --update all buttons in this room
        for i,button in pairs(self.doorButtons) do 

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
                --also update current room's lights
                if pressedButtonName=='doorButtonTop' then 
                    Rooms:newRoom({self.coordinates[1],self.coordinates[2]-1})
                    self.isLit.top=true 
                elseif pressedButtonName=='doorButtonBottom' then 
                    Rooms:newRoom({self.coordinates[1],self.coordinates[2]+1})
                    self.isLit.bottom=true 
                elseif pressedButtonName=='doorButtonLeft' then 
                    Rooms:newRoom({self.coordinates[1]-1,self.coordinates[2]})
                    self.isLit.left=true 
                elseif pressedButtonName=='doorButtonRight' then 
                    Rooms:newRoom({self.coordinates[1]+1,self.coordinates[2]})
                    self.isLit.right=true 
                end
            end
            
            --update buttons, remove any button that was pressed and finished its animation
            if button:update()==false then table.remove(self.doorButtons,i) end            
        end
    end

    function room:draw() 
        love.graphics.draw(self.backgroundSprite,self.xPos,self.yPos)
        for i,button in pairs(self.doorButtons) do button:draw() end 
    end

    function room:drawForeground() 
        love.graphics.draw(self.foregroundSprite,self.xPos,self.yPos)
        --draw room lights
        if self.isLit.top then 
            love.graphics.draw(self.lightSprites.top,self.xPos+130,self.yPos) 
            love.graphics.draw(self.lightSprites.top,self.xPos+242,self.yPos)
        end
        if self.isLit.bottom then 
            love.graphics.draw(self.lightSprites.bottom,self.xPos+130,self.yPos+274) 
            love.graphics.draw(self.lightSprites.bottom,self.xPos+242,self.yPos+274) 
        end
        if self.isLit.left then 
            love.graphics.draw(self.lightSprites.left,self.xPos,self.yPos+83)
            love.graphics.draw(self.lightSprites.left,self.xPos,self.yPos+192)
        end
        
        if self.isLit.right then --must flip horizontally
            love.graphics.draw(self.lightSprites.right,self.xPos+384,self.yPos+83,nil,-1,1)
            love.graphics.draw(self.lightSprites.right,self.xPos+384,self.yPos+192,nil,-1,1)
        end
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

    table.insert(Dungeon.roomsTable,room) --insert into Dungeon's roomsTable
end 

--generates the appropriate pattern of collision boxes for the _type room
function Rooms:generateWalls(_room)
    local _xPos=_room.xPos
    local _yPos=_room.yPos
    local _type=_room.type
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
function Rooms:generateDoorButtons(_room)
    local xPos=_room.xPos 
    local yPos=_room.yPos 
    local type=_room.type 
    local tab=_room.doorButtons
    local x=_room.coordinates[1]
    local y=_room.coordinates[2]
    --adjacent rooms flag
    local roomAbove,roomBelow,roomOnLeft,roomOnRight=false,false,false,false 
    --adjacent rooms store here
    local adjRoomTop,adjRoomBottom,adjRoomLeft,adjRoomRight=nil,nil,nil,nil

    --see what existing rooms are adjacent to this room
    for i,room in pairs(Dungeon.roomsTable) do 
        if room.coordinates[1]==x and room.coordinates[2]==y-1 then 
            roomAbove=true 
            adjRoomTop=room --store room
        end
        if room.coordinates[1]==x and room.coordinates[2]==y+1 then 
            roomBelow=true 
            adjRoomBottom=room  --store room
        end 
        if room.coordinates[1]==x-1 and room.coordinates[2]==y then 
            roomOnLeft=true 
            adjRoomLeft=room  --store room
        end 
        if room.coordinates[1]==x+1 and room.coordinates[2]==y then 
            roomOnRight=true 
            adjRoomRight=room  --store room
        end 
    end

    --create doorButtons only for those that don't already have existing adjacent rooms
    if type=='middle' then 
        if not roomAbove then 
            table.insert(tab,DoorButton:newDoorButton(xPos+130,yPos+32,'doorButtonTop'))
            table.insert(tab,DoorButton:newDoorButton(xPos+242,yPos+32,'doorButtonTop')) 
        end 
        if not roomOnLeft then 
            table.insert(tab,DoorButton:newDoorButton(xPos+36,yPos+114,'doorButtonLeft'))
            table.insert(tab,DoorButton:newDoorButton(xPos+36,yPos+226,'doorButtonLeft'))
        end
        if not roomOnRight then 
            table.insert(tab,DoorButton:newDoorButton(xPos+348,yPos+114,'doorButtonRight'))
            table.insert(tab,DoorButton:newDoorButton(xPos+348,yPos+226,'doorButtonRight'))
        end
        if not roomBelow then 
            table.insert(tab,DoorButton:newDoorButton(xPos+130,yPos+295,'doorButtonBottom'))
            table.insert(tab,DoorButton:newDoorButton(xPos+242,yPos+295,'doorButtonBottom'))
        end
    elseif type=='sideTop' then 
        if not roomOnLeft then 
            table.insert(tab,DoorButton:newDoorButton(xPos+36,yPos+114,'doorButtonLeft'))
            table.insert(tab,DoorButton:newDoorButton(xPos+36,yPos+226,'doorButtonLeft'))
        end
        if not roomOnRight then 
            table.insert(tab,DoorButton:newDoorButton(xPos+348,yPos+114,'doorButtonRight'))
            table.insert(tab,DoorButton:newDoorButton(xPos+348,yPos+226,'doorButtonRight'))
        end
        if not roomBelow then 
            table.insert(tab,DoorButton:newDoorButton(xPos+130,yPos+295,'doorButtonBottom'))
            table.insert(tab,DoorButton:newDoorButton(xPos+242,yPos+295,'doorButtonBottom'))
        end
    elseif type=='sideBottom' then 
        if not roomAbove then 
            table.insert(tab,DoorButton:newDoorButton(xPos+130,yPos+32,'doorButtonTop'))
            table.insert(tab,DoorButton:newDoorButton(xPos+242,yPos+32,'doorButtonTop')) 
        end 
        if not roomOnLeft then 
            table.insert(tab,DoorButton:newDoorButton(xPos+36,yPos+114,'doorButtonLeft'))
            table.insert(tab,DoorButton:newDoorButton(xPos+36,yPos+226,'doorButtonLeft'))
        end
        if not roomOnRight then 
            table.insert(tab,DoorButton:newDoorButton(xPos+348,yPos+114,'doorButtonRight'))
            table.insert(tab,DoorButton:newDoorButton(xPos+348,yPos+226,'doorButtonRight'))
        end
    elseif type=='sideLeft' then 
        if not roomAbove then 
            table.insert(tab,DoorButton:newDoorButton(xPos+130,yPos+32,'doorButtonTop'))
            table.insert(tab,DoorButton:newDoorButton(xPos+242,yPos+32,'doorButtonTop')) 
        end
        if not roomOnRight then 
            table.insert(tab,DoorButton:newDoorButton(xPos+348,yPos+114,'doorButtonRight'))
            table.insert(tab,DoorButton:newDoorButton(xPos+348,yPos+226,'doorButtonRight'))
        end
        if not roomBelow then 
            table.insert(tab,DoorButton:newDoorButton(xPos+130,yPos+295,'doorButtonBottom'))
            table.insert(tab,DoorButton:newDoorButton(xPos+242,yPos+295,'doorButtonBottom'))
        end
    elseif type=='sideRight' then 
        if not roomAbove then 
            table.insert(tab,DoorButton:newDoorButton(xPos+130,yPos+32,'doorButtonTop'))
            table.insert(tab,DoorButton:newDoorButton(xPos+242,yPos+32,'doorButtonTop')) 
        end 
        if not roomOnLeft then 
            table.insert(tab,DoorButton:newDoorButton(xPos+36,yPos+114,'doorButtonLeft'))
            table.insert(tab,DoorButton:newDoorButton(xPos+36,yPos+226,'doorButtonLeft'))
        end
        if not roomBelow then 
            table.insert(tab,DoorButton:newDoorButton(xPos+130,yPos+295,'doorButtonBottom'))
            table.insert(tab,DoorButton:newDoorButton(xPos+242,yPos+295,'doorButtonBottom'))
        end
    elseif type=='cornerTopLeft' then 
        if not roomOnRight then 
            table.insert(tab,DoorButton:newDoorButton(xPos+348,yPos+114,'doorButtonRight'))
            table.insert(tab,DoorButton:newDoorButton(xPos+348,yPos+226,'doorButtonRight'))
        end
        if not roomBelow then 
            table.insert(tab,DoorButton:newDoorButton(xPos+130,yPos+295,'doorButtonBottom'))
            table.insert(tab,DoorButton:newDoorButton(xPos+242,yPos+295,'doorButtonBottom'))
        end
    elseif type=='cornerTopRight' then 
        if not roomOnLeft then 
            table.insert(tab,DoorButton:newDoorButton(xPos+36,yPos+114,'doorButtonLeft'))
            table.insert(tab,DoorButton:newDoorButton(xPos+36,yPos+226,'doorButtonLeft'))
        end
        if not roomBelow then 
            table.insert(tab,DoorButton:newDoorButton(xPos+130,yPos+295,'doorButtonBottom'))
            table.insert(tab,DoorButton:newDoorButton(xPos+242,yPos+295,'doorButtonBottom'))
        end
    elseif type=='cornerBottomLeft' then 
        if not roomAbove then 
            table.insert(tab,DoorButton:newDoorButton(xPos+130,yPos+32,'doorButtonTop'))
            table.insert(tab,DoorButton:newDoorButton(xPos+242,yPos+32,'doorButtonTop')) 
        end 
        if not roomOnRight then 
            table.insert(tab,DoorButton:newDoorButton(xPos+348,yPos+114,'doorButtonRight'))
            table.insert(tab,DoorButton:newDoorButton(xPos+348,yPos+226,'doorButtonRight'))
        end
    elseif type=='cornerBottomRight' then 
        if not roomAbove then 
            table.insert(tab,DoorButton:newDoorButton(xPos+130,yPos+32,'doorButtonTop'))
            table.insert(tab,DoorButton:newDoorButton(xPos+242,yPos+32,'doorButtonTop')) 
        end 
        if not roomOnLeft then 
            table.insert(tab,DoorButton:newDoorButton(xPos+36,yPos+114,'doorButtonLeft'))
            table.insert(tab,DoorButton:newDoorButton(xPos+36,yPos+226,'doorButtonLeft'))
        end
    end

    --go through any adjacent rooms and 'press' any buttons that should be pressed
    --and update lighting accordingly.
    --i.e. if the player goes left>up>right instead of just up, the top doorButtons
    --     won't be pressed but the room above would be spawned.
    if roomAbove then 
        for i,button in pairs(adjRoomTop.doorButtons) do 
            if button.name=='doorButtonBottom' then button.currentAnim:resume() end
        end
        adjRoomTop.isLit.bottom=true
    end
    if roomBelow then 
        for i,button in pairs(adjRoomBottom.doorButtons) do 
            if button.name=='doorButtonTop' then button.currentAnim:resume() end 
        end
        adjRoomBottom.isLit.top=true
    end
    if roomOnLeft then 
        for i,button in pairs(adjRoomLeft.doorButtons) do 
            if button.name=='doorButtonRight' then button.currentAnim:resume() end 
        end
        adjRoomLeft.isLit.right=true
    end
    if roomOnRight then 
        for i,button in pairs(adjRoomRight.doorButtons) do 
            if button.name=='doorButtonLeft' then button.currentAnim:resume() end 
        end
        adjRoomRight.isLit.left=true
    end
end

--generate a room's isLit table to reflect which light should be turned on
--by seeing which button are pressed (what buttons are no longer in the doorButtons table)
function Rooms:generateLights(_room)
    local hasTop,hasBottom,hasLeft,hasRight=false,false,false,false
    local room=_room 

    for i,button in pairs(room.doorButtons) do 
        if button.name=='doorButtonTop' then hasTop=true end 
        if button.name=='doorButtonBottom' then hasBottom=true end 
        if button.name=='doorButtonLeft' then hasLeft=true end 
        if button.name=='doorButtonRight' then hasRight=true end         
    end

    --update all isLit properties to match which light should be on
    if hasTop then room.isLit.top=false else room.isLit.top=true end 
    if hasBottom then room.isLit.bottom=false else room.isLit.bottom=true end 
    if hasLeft then room.isLit.left=false else room.isLit.left=true end 
    if hasRight then room.isLit.right=false else room.isLit.right=true end 

    --now remove lights based on the type of room.
    --'middle' rooms should have all 4 sets of lights (no change)
    --'side' rooms should have 3 sets
    --'corner' rooms should have 2 sets
    if room.type=='sideTop' then room.isLit.top=false end
    if room.type=='sideBottom' then room.isLit.bottom=false end
    if room.type=='sideLeft' then room.isLit.left=false end 
    if room.type=='sideRight' then room.isLit.right=false end 
    if room.type=='cornerTopLeft' then room.isLit.top=false room.isLit.left=false end
    if room.type=='cornerBottomLeft' then room.isLit.bottom=false room.isLit.left=false end
    if room.type=='cornerTopRight' then room.isLit.top=false room.isLit.right=false end
    if room.type=='cornerBottomRight' then room.isLit.bottom=false room.isLit.right=false end
end