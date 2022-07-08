--door button class for creating doorButton objects which will be placed 
--at the exits of a room and will be activated by the player to open/reveal 
--adjacent rooms
DoorButton={}

function DoorButton:load()
    --sprite and animations (front facing button)
    self.doorButtonSpriteSheet=love.graphics.newImage('assets/maps/door_button.png')
    self.grid=anim8.newGrid(
        12,14,
        self.doorButtonSpriteSheet:getWidth(),self.doorButtonSpriteSheet:getHeight()
    )    
    
    --sprite and animations (side facing button)
    self.doorButtonSpriteSheetSide=love.graphics.newImage('assets/maps/door_button_side.png')
    self.gridSide=anim8.newGrid(
        6,12,
        self.doorButtonSpriteSheetSide:getWidth(),self.doorButtonSpriteSheetSide:getHeight()
    )    
end

--creates and returns a new doorButton object at position (_xPos,_yPos)
function DoorButton:newDoorButton(_xPos,_yPos,_name)
    local button={}
    
    button.name=_name 

    --physics collider
    if button.name=='doorButtonTop' or button.name=='doorButtonBottom' then 
        button.collider=world:newBSGRectangleCollider(_xPos,_yPos,12,19,3)
    elseif button.name=='doorButtonLeft' or button.name=='doorButtonRight' then
        button.collider=world:newBSGRectangleCollider(_xPos-6,_yPos-1,12,14,4)
    end
    button.collider:setType('static')
    button.collider:setCollisionClass('doorButton')
    button.collider:setObject(button)

    button.xPos,button.yPos=button.collider:getPosition()

    --sprite and animations
    if button.name=='doorButtonTop' or button.name=='doorButtonBottom' then 
        button.spriteSheet=self.doorButtonSpriteSheet
        button.grid=self.grid
        button.currentAnim=anim8.newAnimation(
            button.grid('1-4',1),0.05,
            function() --onLoop function
                button.currentAnim:pauseAtEnd() --will only animate once
                button.deleteMe=true --button will be removed from game
            end
        )
    elseif button.name=='doorButtonLeft' or button.name=='doorButtonRight' then 
        button.spriteSheet=self.doorButtonSpriteSheetSide
        button.grid=self.gridSide
        button.currentAnim=anim8.newAnimation(
            button.grid('1-4',1),0.05,
            function() --onLoop function
                button.currentAnim:pauseAtEnd() --will only animate once
                button.deleteMe=true --button will be removed from game
            end
        )
    end
    button.currentAnim:pause() --immediately pause animation

    button.pressed=false --button state
    button.deleteMe=false --when true, remove button from parent room
    button.isNearPlayer=false --true when near player

    button.sfx={
        press=Sounds.button()
    }
    
    function button:update()
        button.currentAnim:update(dt)

        --when button is ready to be deleted, destroy its collider and return false
        if button.deleteMe then 
            button.collider:destroy()
            return false 
        end 

        --check if node is near the player in order to draw name on UI
        if math.abs(Player.xPos-button.xPos)<=24
        and math.abs(Player.yPos-button.yPos)<=24
        then button.isNearPlayer=true else button.isNearPlayer=false end
    end

    function button:draw()
        if button.name=='doorButtonLeft' then 
            --flip sprite
            button.currentAnim:draw(button.spriteSheet,button.xPos,button.yPos-7)
        elseif button.name=='doorButtonRight' then 
            button.currentAnim:draw(button.spriteSheet,button.xPos,button.yPos-7,nil,-1,1)
        else
            button.currentAnim:draw(button.spriteSheet,button.xPos-6,button.yPos-10)
        end 
    end

    --called by player's query function. Sets this button's pressed state to true,
    --which will then be read by its parent room who will then active this and 
    --the button on the opposite side of the door.
    function button:nodeInteract()
        button.pressed=true
        button.collider:setCollisionClass('doorButtonActivated')
        button.sfx.press:play()
    end

    function button:drawUIelements()    
        --when player is near button and button isn't yet pressed, draw name on ui
        if button.isNearPlayer then
            love.graphics.printf(
                "button",fonts.white,button.xPos-100,button.yPos-20,200,'center'
            )
        end
    end

    return button 
end