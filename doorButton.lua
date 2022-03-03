--door button class for creating doorButton objects which will be placed 
--at the exits of a room and will be activated by the player to open/reveal 
--adjacent rooms
DoorButton={}

function DoorButton:load()
    --sprite and animations
    self.doorButtonSpriteSheet=love.graphics.newImage('assets/maps/door_button.png')
    self.grid=anim8.newGrid(
        12,14,
        self.doorButtonSpriteSheet:getWidth(),self.doorButtonSpriteSheet:getHeight()
    )    
end

--creates and returns a new doorButton object at position (_xPos,_yPos)
function DoorButton:newDoorButton(_xPos,_yPos,_name)
    local button={}

    button.xPos=_xPos 
    button.yPos=_yPos
    button.name=_name 
    button.pressed=false --button state

    --physics collider
    button.collider=world:newBSGRectangleCollider(button.xPos,button.yPos,12,19,3)
    button.collider:setType('static')
    button.collider:setCollisionClass('doorButton')
    button.collider:setObject(button)

    --sprite and animations
    button.spriteSheet=self.doorButtonSpriteSheet
    button.grid=self.grid
    button.currentAnim=anim8.newAnimation(
        self.grid('1-4',1),0.05,
        function() --onLoop function
            button.currentAnim:pauseAtEnd() --will only animate once
            --after animation, move collider away (destroy() doesn't work for some reason)
            button.collider:setPosition(0,0)
        end
    )
    button.currentAnim:pause() --immediately pause animation
    
    function button:update()
        button.currentAnim:update(dt)
    end

    function button:draw()
        button.currentAnim:draw(button.spriteSheet,_xPos,_yPos)
    end

    --called by player's query function. Sets this button's pressed state to true,
    --which will then be read by its parent room who will then active this and 
    --the button on the opposite side of the door.
    function button:nodeInteract()
        button.pressed=true
        button.collider:setCollisionClass('doorButtonActivated')
    end

    return button 
end