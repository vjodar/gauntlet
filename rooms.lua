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

    --ladder sprite
    self.ladderSprite=love.graphics.newImage('assets/nodes/ladder.png')
    
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

    --room lighting
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

    --fog
    room.fogTable={top={},bottom={},left={},right={}}
    room.fogColor=2/15 --palette black
    room.fogAlpha=0.51
    --fog states to prevent unnecessary additional function calls 
    --fog will be removed next frame
    room.fogTable.toRemove={top=false,bottom=false,left=false,right=false}
    --fog is already in the process of being removed
    room.fogTable.beingRemoved={top=false,bottom=false,left=false,right=false}

    --invisible doorway barriers
    room.doorBarriers={top={},bottom={},left={},right={}}

    --create and emtpy room complete with collision boxes that fit the room layout
    if _coordinates[1]==1 then 
        --room is on leftmost position
        if _coordinates[2]==1 then 
            --room is topleft corner
            room.type='cornerTopLeft'
            room.backgroundSprite=self.roomSprites.cornerTopLeft 
            room.foregroundSprite=self.roomSprites.cornerTopLeftForeground
        elseif _coordinates[2]==7 then 
            --room is bottomleft corner
            room.type='cornerBottomLeft'
            room.backgroundSprite=self.roomSprites.cornerBottomLeft 
            room.foregroundSprite=self.roomSprites.cornerBottomLeftForeground
        else
            --room is left side
            room.type='sideLeft'
            room.backgroundSprite=self.roomSprites.sideLeft
            room.foregroundSprite=self.roomSprites.sideLeftForeground
        end
    elseif _coordinates[1]==7 then 
        --room is on rightmost position
        if _coordinates[2]==1 then 
            --room is topright corner
            room.type='cornerTopRight'
            room.backgroundSprite=self.roomSprites.cornerTopRight
            room.foregroundSprite=self.roomSprites.cornerTopRightForeground
        elseif _coordinates[2]==7 then 
            --room is bottomright corner
            room.type='cornerBottomRight'
            room.backgroundSprite=self.roomSprites.cornerBottomRight
            room.foregroundSprite=self.roomSprites.cornerBottomRightForeground
        else
            --room is right side
            room.type='sideRight'
            room.backgroundSprite=self.roomSprites.sideRight
            room.foregroundSprite=self.roomSprites.sideRightForeground
        end
    elseif _coordinates[2]==1 then 
        --room is top side
        room.type='sideTop'
        room.backgroundSprite=self.roomSprites.sideTop
        room.foregroundSprite=self.roomSprites.sideTopForeground
    elseif _coordinates[2]==7 then 
        --room is bottom side
        room.type='sideBottom'
        room.backgroundSprite=self.roomSprites.sideBottom
        room.foregroundSprite=self.roomSprites.sideBottomForeground
    else
        --room is a middle room
        room.type='middle'
        room.backgroundSprite=self.roomSprites.middle 
        room.foregroundSprite=self.roomSprites.middleForeground
    end

    --generate doorButtons, room lights, fog, and doorway barriers
    self:generateWalls(room)
    self:generateDoorButtons(room)
    self:generateLights(room)
    self:generateFog(room)
    self:generateDoorBarriers(room)
    self:manageAdjacentBarriers(room)

    if room.coordinates[1]==4 and room.coordinates[2]==4 then
        --center room, spawn the ladder that leads to the boss room
        self:spawnLadder(room) 
    elseif room.coordinates[1]==Dungeon.startRoom[1] 
        and room.coordinates[2]==Dungeon.startRoom[2] then 
        --base/starting room, spawn only crafting nodes

    else
        --regular room, spawn walls, resource nodes, and/or enemies
        --choose a random inner wall layout to generate
        Walls.layouts[love.math.random(#Walls.layouts)](room)
        self:spawnResourceNodes(room) --spawn resource nodes
        self:spawnEnemies(room) --spawn enemies
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

                --insert new gamestate to handle camera panning and to suspend 
                --control from player until camera returns
                table.insert(gameStates,CamPanState)
                --used to store what the camera will pan to. Offset to center
                local adjRoomX=self.xPos+(Rooms.ROOMWIDTH/2)
                local adjRoomY=self.yPos+(Rooms.ROOMHEIGHT/2)

                --create a new room adjacent to the pressed doorButton
                --also update current room's lights, fog, and doorBarriers
                --pan camera to room and back using CamPanState
                if pressedButtonName=='doorButtonTop' then 
                    Rooms:newRoom({self.coordinates[1],self.coordinates[2]-1})
                    self.isLit.top=true 
                    self.fogTable.toRemove.top=true
                    self.doorBarriers.top:setActive(false)
                    adjRoomY=adjRoomY-Rooms.ROOMHEIGHT
                elseif pressedButtonName=='doorButtonBottom' then 
                    Rooms:newRoom({self.coordinates[1],self.coordinates[2]+1})
                    self.isLit.bottom=true 
                    self.fogTable.toRemove.bottom=true
                    self.doorBarriers.bottom:setActive(false)
                    adjRoomY=adjRoomY+Rooms.ROOMHEIGHT
                elseif pressedButtonName=='doorButtonLeft' then 
                    Rooms:newRoom({self.coordinates[1]-1,self.coordinates[2]})
                    self.isLit.left=true 
                    self.fogTable.toRemove.left=true
                    self.doorBarriers.left:setActive(false)
                    adjRoomX=adjRoomX-Rooms.ROOMWIDTH
                elseif pressedButtonName=='doorButtonRight' then 
                    Rooms:newRoom({self.coordinates[1]+1,self.coordinates[2]})
                    self.isLit.right=true 
                    self.fogTable.toRemove.right=true
                    self.doorBarriers.right:setActive(false)
                    adjRoomX=adjRoomX+Rooms.ROOMWIDTH
                end

                CamPanState:pan(adjRoomX,adjRoomY)
            end
            
            --update buttons, remove any button that was pressed and finished its animation
            if button:update()==false then table.remove(self.doorButtons,i) end   

            --update fog 
            if self.isLit.top and #self.fogTable.top>0 then self.fogTable.toRemove.top=true end 
            if self.isLit.bottom and #self.fogTable.bottom>0 then self.fogTable.toRemove.bottom=true end
            if self.isLit.left and #self.fogTable.left>0 then self.fogTable.toRemove.left=true end 
            if self.isLit.right and #self.fogTable.right>0 then self.fogTable.toRemove.right=true end 
            --remove any fog that should be removed, but don't remove fog that's currently being removed
            if self.fogTable.toRemove.top and 
            not self.fogTable.beingRemoved.top then 
                Rooms:removeFog(room,'top')
                self.fogTable.beingRemoved.top=true
            end
            if self.fogTable.toRemove.bottom and 
            not self.fogTable.beingRemoved.bottom then 
                Rooms:removeFog(room,'bottom')
                self.fogTable.beingRemoved.bottom=true
            end    
            if self.fogTable.toRemove.left and 
            not self.fogTable.beingRemoved.left then 
                Rooms:removeFog(room,'left')
                self.fogTable.beingRemoved.left=true
            end    
            if self.fogTable.toRemove.right and 
            not self.fogTable.beingRemoved.right then 
                Rooms:removeFog(room,'right')
                self.fogTable.beingRemoved.right=true
            end            
        end        
    end

    function room:draw() 
        love.graphics.draw(self.backgroundSprite,self.xPos,self.yPos)
        for i,button in pairs(self.doorButtons) do button:draw() end 
        --draw room lights
        if self.isLit.top then 
            love.graphics.draw(self.lightSprites.top,self.xPos+130,self.yPos) 
            love.graphics.draw(self.lightSprites.top,self.xPos+242,self.yPos)
        end
        if self.isLit.left then 
            love.graphics.draw(self.lightSprites.left,self.xPos,self.yPos+83)
        end        
        if self.isLit.right then --must flip horizontally
            love.graphics.draw(self.lightSprites.right,self.xPos+384,self.yPos+83,nil,-1,1)
        end
    end

    function room:drawForeground() 
        love.graphics.draw(self.foregroundSprite,self.xPos,self.yPos)
        --draw foreground room lights
        if self.isLit.bottom then 
            love.graphics.draw(self.lightSprites.bottom,self.xPos+130,self.yPos+274) 
            love.graphics.draw(self.lightSprites.bottom,self.xPos+242,self.yPos+274) 
        end
        if self.isLit.left then 
            love.graphics.draw(self.lightSprites.left,self.xPos,self.yPos+192)
        end        
        if self.isLit.right then --must flip horizontally
            love.graphics.draw(self.lightSprites.right,self.xPos+384,self.yPos+192,nil,-1,1)
        end

        --draw fog
        if #room.fogTable.top>0 then 
            love.graphics.setColor(room.fogColor,room.fogColor,room.fogColor,room.fogAlpha)
            for i,fog in pairs(room.fogTable.top) do 
                love.graphics.rectangle('fill',fog.x,fog.y,fog.w,fog.h)
            end
        end
        if #room.fogTable.bottom>0 then 
            love.graphics.setColor(room.fogColor,room.fogColor,room.fogColor,room.fogAlpha)
            for i,fog in pairs(room.fogTable.bottom) do 
                love.graphics.rectangle('fill',fog.x,fog.y,fog.w,fog.h)
            end
        end
        if #room.fogTable.left>0 then 
            love.graphics.setColor(room.fogColor,room.fogColor,room.fogColor,room.fogAlpha)
            for i,fog in pairs(room.fogTable.left) do 
                love.graphics.rectangle('fill',fog.x,fog.y,fog.w,fog.h)
            end
        end
        if #room.fogTable.right>0 then 
            love.graphics.setColor(room.fogColor,room.fogColor,room.fogColor,room.fogAlpha)
            for i,fog in pairs(room.fogTable.right) do 
                love.graphics.rectangle('fill',fog.x,fog.y,fog.w,fog.h)
            end
        end
        love.graphics.setColor(1,1,1,1) --reset colors and alpha
    end   

    table.insert(Dungeon.roomsTable,room) --insert into Dungeon's roomsTable
end

--generates the appropriate pattern of collision boxes for the _type room
function Rooms:generateWalls(_room)
    local _xPos=_room.xPos
    local _yPos=_room.yPos
    local _type=_room.type
    if _type=='middle' then 
        --top left walls
        self:addWallCollider(_xPos,_yPos,37,144,3)
        self:addWallCollider(_xPos+37,_yPos,128,48,3)
        --bottom left walls
        self:addWallCollider(_xPos,_yPos+203,37,117,3)        
        self:addWallCollider(_xPos+37,_yPos+298,128,22,3)
        --top right walls
        self:addWallCollider(_xPos+347,_yPos,37,144,3)
        self:addWallCollider(_xPos+219,_yPos,128,48,3) 
        --bottom right walls
        self:addWallCollider(_xPos+347,_yPos+203,37,117,3)   
        self:addWallCollider(_xPos+219,_yPos+298,128,22,3)
    elseif _type=='sideLeft' then  
        --left walls
        self:addWallCollider(_xPos,_yPos,37,320,3)
        self:addWallCollider(_xPos+37,_yPos,128,48,3)
        self:addWallCollider(_xPos+37,_yPos+298,128,22,3)
        --top right walls
        self:addWallCollider(_xPos+347,_yPos,37,144,3)
        self:addWallCollider(_xPos+219,_yPos,128,48,3)
        --bottom right walls
        self:addWallCollider(_xPos+347,_yPos+203,37,117,3)    
        self:addWallCollider(_xPos+219,_yPos+298,128,22,3)
    elseif _type=='sideRight' then 
        --top left walls
        self:addWallCollider(_xPos,_yPos,37,144,3) 
        self:addWallCollider(_xPos+37,_yPos,128,48,3)
        --bottom left walls
        self:addWallCollider(_xPos,_yPos+203,37,117,3)        
        self:addWallCollider(_xPos+37,_yPos+298,128,22,3)
        --right walls
        self:addWallCollider(_xPos+347,_yPos,37,320,3)
        self:addWallCollider(_xPos+219,_yPos,128,48,3)    
        self:addWallCollider(_xPos+219,_yPos+298,128,22,3)
    elseif _type=='sideTop' then 
        --top walls
        self:addWallCollider(_xPos,_yPos,37,144,3)
        self:addWallCollider(_xPos+37,_yPos,310,48,3)
        self:addWallCollider(_xPos+347,_yPos,37,144,3)
        --bottom left walls
        self:addWallCollider(_xPos,_yPos+203,37,117,3)        
        self:addWallCollider(_xPos+37,_yPos+298,128,22,3)
        --bottom right walls
        self:addWallCollider(_xPos+347,_yPos+203,37,117,3)    
        self:addWallCollider(_xPos+219,_yPos+298,128,22,3)
    elseif _type=='sideBottom' then 
        --top left walls
        self:addWallCollider(_xPos,_yPos,37,144,3)
        self:addWallCollider(_xPos+37,_yPos,128,48,3)
        --top right walls
        self:addWallCollider(_xPos+347,_yPos,37,144,3) 
        self:addWallCollider(_xPos+219,_yPos,128,48,3) 
        --bottom walls
        self:addWallCollider(_xPos+347,_yPos+203,37,117,3) 
        self:addWallCollider(_xPos,_yPos+203,37,117,3)        
        self:addWallCollider(_xPos+37,_yPos+298,310,22,3)
    elseif _type=='cornerTopLeft' then 
        --top left walls
        self:addWallCollider(_xPos,_yPos,37,320,3)  
        self:addWallCollider(_xPos+37,_yPos,310,48,3)  
        --bottom left wall      
        self:addWallCollider(_xPos+37,_yPos+298,128,22,3) 
        --top right wall
        self:addWallCollider(_xPos+347,_yPos,37,144,3)  
        --bottom right walls
        self:addWallCollider(_xPos+347,_yPos+203,37,117,3)      
        self:addWallCollider(_xPos+219,_yPos+298,128,22,3) 
    elseif _type=='cornerBottomLeft' then 
        --top left walls
        self:addWallCollider(_xPos+37,_yPos,128,48,3)  
        --bottom left walls
        self:addWallCollider(_xPos,_yPos,37,320,3)         
        self:addWallCollider(_xPos+37,_yPos+298,310,22,3) 
        --top right walls
        self:addWallCollider(_xPos+347,_yPos,37,144,3)  
        self:addWallCollider(_xPos+219,_yPos,128,48,3)  
        --bottom right walls
        self:addWallCollider(_xPos+347,_yPos+203,37,117,3) 
    elseif _type=='cornerTopRight' then 
        --top left walls
        self:addWallCollider(_xPos,_yPos,37,144,3)  
        --bottom left walls
        self:addWallCollider(_xPos,_yPos+203,37,117,3)         
        self:addWallCollider(_xPos+37,_yPos+298,128,22,3) 
        --top right walls
        self:addWallCollider(_xPos+347,_yPos,37,320,3)  
        self:addWallCollider(_xPos+37,_yPos,310,48,3)  
        --bottom right walls    
        self:addWallCollider(_xPos+219,_yPos+298,128,22,3) 
    elseif _type=='cornerBottomRight' then 
        --top left walls
        self:addWallCollider(_xPos,_yPos,37,144,3)  
        self:addWallCollider(_xPos+37,_yPos,128,48,3)  
        --bottom walls
        self:addWallCollider(_xPos,_yPos+203,37,117,3)         
        self:addWallCollider(_xPos+37,_yPos+298,310,22,3) 
        --right walls
        self:addWallCollider(_xPos+347,_yPos,37,320,3)  
        self:addWallCollider(_xPos+219,_yPos,128,48,3)  
    end
end

--helper function for generateWalls(). Creates collider, sets it to static,
--adds it to 'outerWall' collision class
function Rooms:addWallCollider(_x,_y,_w,_h) 
    local w=world:newBSGRectangleCollider(_x,_y,_w,_h,1)
    w:setType('static')
    w:setCollisionClass('outerWall')
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

--generates 'fog' that creates an alpha gradient between a room and any empty space
--surrounding it. Uses a room's lighting to determine where there should be no fog. 
function Rooms:generateFog(_room)
    local room=_room  

    --any doorway that isn't lit should have fog. 
    --Also take into account what room types don't have certain doorways.
    if not room.isLit.top and 
    not (room.type=='sideTop' or room.type=='cornerTopLeft' or room.type=='cornerTopRight')
    then      
        for i=1,8 do 
            room.fogTable.top[i]={
                x=room.xPos+32,
                y=room.yPos-16,
                --height is taller than other sides in order to allow tall sprites
                --such as the staff_t3 attack animation.
                w=320,h=50-(2*i)
            }
        end 
    end
    if not room.isLit.bottom and 
    not (room.type=='sideBottom' or room.type=='cornerBottomLeft' or room.type=='cornerBottomRight')
    then     
        for i=1,8 do 
            room.fogTable.bottom[i]={
                x=room.xPos+129,
                y=room.yPos+278+(2*i),
                w=126,h=42-(2*i)
            }
        end 
    end
    if not room.isLit.left and 
    not (room.type=='sideLeft' or room.type=='cornerBottomLeft' or room.type=='cornerTopLeft')
    then     
        for i=1,8 do 
            room.fogTable.left[i]={
                x=room.xPos,
                y=room.yPos+82,
                w=26-(2*i),h=122
            }
        end 
    end
    if not room.isLit.right and 
    not (room.type=='sideRight' or room.type=='cornerBottomRight' or room.type=='cornerTopRight')
    then       
        for i=1,8 do 
            room.fogTable.right[i]={
                x=room.xPos+358+(2*i),
                y=room.yPos+82,
                w=26-(2*i),h=122
            }
        end 
    end
end

--gradually removes the fog from the _dir doorway by removing its fog rectangles over time
function Rooms:removeFog(_room,_dir)
    for i=1,10 do 
        TimerState:after((0.015*i),function() table.remove(_room.fogTable[_dir],1) end)
    end
end

--generate invisible barriers in doorways which are not yet lit and don't yet lead into other rooms
--only generate barriers if the room type has a doorway there.
function Rooms:generateDoorBarriers(_room)
    if not _room.isLit.top and 
    not (_room.type=='sideTop' or _room.type=='cornerTopLeft' or _room.type=='cornerTopRight')
    then
        _room.doorBarriers.top=world:newRectangleCollider(_room.xPos+165,_room.yPos,54,32)
        _room.doorBarriers.top:setType('static')
        _room.doorBarriers.top:setCollisionClass('doorBarrier')
    end
    if not _room.isLit.bottom and 
    not (_room.type=='sideBottom' or _room.type=='cornerBottomLeft' or _room.type=='cornerBottomRight')
    then 
        _room.doorBarriers.bottom=world:newRectangleCollider(_room.xPos+165,_room.yPos+298,54,22) 
        _room.doorBarriers.bottom:setType('static')
        _room.doorBarriers.bottom:setCollisionClass('doorBarrier')
    end
    if not _room.isLit.left and 
    not (_room.type=='sideLeft' or _room.type=='cornerBottomLeft' or _room.type=='cornerTopLeft')
    then 
        _room.doorBarriers.left=world:newRectangleCollider(_room.xPos,_room.yPos+144,16,60) 
        _room.doorBarriers.left:setType('static')
        _room.doorBarriers.left:setCollisionClass('doorBarrier')
    end
    if not _room.isLit.right and 
    not (_room.type=='sideRight' or _room.type=='cornerBottomRight' or _room.type=='cornerTopRight')
    then 
        _room.doorBarriers.right=world:newRectangleCollider(_room.xPos+368,_room.yPos+144,16,60) 
        _room.doorBarriers.right:setType('static')
        _room.doorBarriers.right:setCollisionClass('doorBarrier')
    end
end

--takes a room and checks if any adjacent room has doorBarriers that should be cleared
--this can happen when a doorway is indirectly opened. 
--I.E. the player goes up>right>down instead of just right
function Rooms:manageAdjacentBarriers(_room)
    local x=_room.coordinates[1]
    local y=_room.coordinates[2]
    local adjRooms={top=nil,bottom=nil,left=nil,right=nil}

    --store any existing rooms that are adjacent to this room
    for i,room in pairs(Dungeon.roomsTable) do 
        if room.coordinates[1]==x and room.coordinates[2]==y-1 then 
            adjRooms.top=room --store room
        end
        if room.coordinates[1]==x and room.coordinates[2]==y+1 then 
            adjRooms.bottom=room  --store room
        end 
        if room.coordinates[1]==x-1 and room.coordinates[2]==y then 
            adjRooms.left=room  --store room
        end 
        if room.coordinates[1]==x+1 and room.coordinates[2]==y then 
            adjRooms.right=room  --store room
        end 
    end

    --go through all existing adjacent rooms, query the world for any doorBarriers
    --that exist in doorways that are already lit, and make them inactive
    for dir,val in pairs(adjRooms) do
        if adjRooms[dir] then
            local topDoorBarriers=world:queryRectangleArea(
                adjRooms[dir].xPos+184,adjRooms[dir].yPos+7,32,32,{'doorBarrier'}
            )
            local bottomDoorBarriers=world:queryRectangleArea(
                adjRooms[dir].xPos+184,adjRooms[dir].yPos+295,32,32,{'doorBarrier'}
            )
            local leftDoorBarriers=world:queryRectangleArea(
                adjRooms[dir].xPos+8,adjRooms[dir].yPos+160,32,32,{'doorBarrier'}
            )
            local rightDoorBarriers=world:queryRectangleArea(
                adjRooms[dir].xPos+360,adjRooms[dir].yPos+160,32,32,{'doorBarrier'}
            )
            if dir=='top' and adjRooms[dir].isLit.bottom and #bottomDoorBarriers>0 then 
                bottomDoorBarriers[1]:setActive(false)
            end
            if dir=='bottom' and adjRooms[dir].isLit.top and #topDoorBarriers>0 then 
                topDoorBarriers[1]:setActive(false)
            end
            if dir=='left' and adjRooms[dir].isLit.right and #rightDoorBarriers>0 then 
                rightDoorBarriers[1]:setActive(false)
            end
            if dir=='right' and adjRooms[dir].isLit.left and #leftDoorBarriers>0 then 
                leftDoorBarriers[1]:setActive(false)
            end
        end
    end
end

--takes a room and fills it with a random assortment of up to 6 resource nodes
function Rooms:spawnResourceNodes(_room)
    local room=_room

    --80% chance to spawn resource nodes, 20% chance to spawn none
    if love.math.random(5)==1 then return end

    --spawn in groups of 3, 50% chance to spawn a second group.
    local numNodes=3+(3*love.math.random(0,1))

    local spawnZone={} --designated spawning area
    spawnZone.x1=room.xPos+64
    spawnZone.x2=spawnZone.x1+256
    spawnZone.y1=room.yPos+80
    spawnZone.y2=spawnZone.y1+184

    local spawnZoneVineA={} --right side of doorway
    spawnZoneVineA.x1=room.xPos+259
    spawnZoneVineA.x2=room.xPos+332
    spawnZoneVineA.y=room.yPos+17

    local spawnZoneVineB={} --left side of doorway
    spawnZoneVineB.x1=room.xPos+36
    spawnZoneVineB.x2=room.xPos+109

    local spawnZoneVineC={} --for top corners and side rooms
    spawnZoneVineC.x1=room.xPos+36
    spawnZoneVineC.x2=room.xPos+332
    
    for i=1,numNodes do 
        local selectedFunction=love.math.random(5) --select a random spawn function

        --if spawn vine function is selected, spawn it within vine spawn zone
        if selectedFunction==3 then 
            if room.coordinates[2]==1 then --top side or corner room
                ResourceNodes.nodeSpawnFunctions[selectedFunction](
                        love.math.random(spawnZoneVineC.x1,spawnZoneVineC.x2),
                        --add decimal value to yPos to prevent visual stutter
                        spawnZoneVineA.y+love.math.random()
                    )
            else --any other room with top doorway
                if love.math.random(2)==1 then --spawn in vine zone A
                    ResourceNodes.nodeSpawnFunctions[selectedFunction](
                        love.math.random(spawnZoneVineA.x1,spawnZoneVineA.x2),
                        --add decimal value to yPos to prevent visual stutter
                        spawnZoneVineA.y+love.math.random()
                    )
                else --spawn in vine zone B
                    ResourceNodes.nodeSpawnFunctions[selectedFunction](
                        love.math.random(spawnZoneVineB.x1,spawnZoneVineB.x2),
                        --add decimal value to yPos to prevent visual stutter
                        spawnZoneVineA.y+love.math.random()
                    )
                end
            end
        else         
            --otherwise spawn the resource node within the general spawn zone
            ResourceNodes.nodeSpawnFunctions[selectedFunction](
                love.math.random(spawnZone.x1,spawnZone.x2),
                love.math.random(spawnZone.y1,spawnZone.y2)
            )
        end
    end
end

--takes a room and fills it with up to 3 of the appropriate teir of enemies 
--based on the room's coordinates.
function Rooms:spawnEnemies(_room)
    --80% chance to spawn an enemy/group, 20% chance to spawn none.
    if love.math.random(5)==1 then return end

    local room=_room --store room
    local spawnZone={} --designated spawning area
    spawnZone.x1=room.xPos+37
    spawnZone.x2=spawnZone.x1+310
    spawnZone.y1=room.yPos+48
    spawnZone.y2=spawnZone.y1+220

    local spawnZoneT3={} --smaller spawning area for T3 enemies    
    spawnZoneT3.x1=room.xPos+96
    spawnZoneT3.x2=spawnZoneT3.x1+192
    spawnZoneT3.y1=room.yPos+96
    spawnZoneT3.y2=spawnZoneT3.y1+128  

    --inner ring, only spawn T1 enemies
    if (room.coordinates[1]==3 or room.coordinates[1]==4 or room.coordinates[1]==5) 
        and (room.coordinates[2]==3 or room.coordinates[2]==4 or room.coordinates[2]==5) then
        Enemies:fillRoomT1(spawnZone)

    --outer ring, can spawn T1, T2,or T3 enemies
    elseif room.coordinates[1]==1 or room.coordinates[2]==1 
        or room.coordinates[1]==7 or room.coordinates[2]==7 then
        local spawnDemiBoss=(love.math.random(3)==1) --33% chance to spawn T3 enemy
        if spawnDemiBoss then 
            Enemies:fillRoomT3(spawnZoneT3)
        else
            local enemyTierSelection=love.math.random(2) --choose between T1 and T2 enemies
            if enemyTierSelection==1 then --fill with T1 enemies
                Enemies:fillRoomT1(spawnZone)
            else --fill with T2 enemies
                Enemies:fillRoomT2(spawnZone)
            end
        end

    else --middle ring, can spawn T1 or T2 enemies
        local enemyTierSelection=love.math.random(2) --choose what enemy tier to spawn
        if enemyTierSelection==1 then --fill with T1 enemies
            Enemies:fillRoomT1(spawnZone)
        else --fill with T2 enemies
            Enemies:fillRoomT2(spawnZone)
        end
    end
end

function Rooms:spawnLadder(_room)
    local ladder={}

    function ladder:load()
        self.sprite=Rooms.ladderSprite
        self.collider=world:newBSGRectangleCollider( --place in center of room
            _room.xPos+Rooms.ROOMWIDTH*0.5-8,
            _room.yPos+Rooms.ROOMHEIGHT*0.5-4,
            16,8,2
        )
        self.xPos, self.yPos = self.collider:getPosition()
        self.collider:setType('static')
        self.collider:setFixedRotation(true)
        self.collider:setCollisionClass('ladder')
        self.collider:setObject(self) --attach collider to this object

        --testing--------------------
        print("adding ladder testing features")
        self.dialogBoolean=true 
        --testing--------------------

        table.insert(Entities.entitiesTable,self)
    end

    function ladder:update() end

    function ladder:draw()
        love.graphics.draw(self.sprite,self.xPos-8,self.yPos-8)
    end

    function ladder:nodeInteract()
        --TODO---------------------------
        --go to boss room
        --TODO---------------------------
    end

    ladder:load()
end