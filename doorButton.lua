--door button class for creating doorButton objects which will be placed 
--at the exits of a room and will be activated by the player to open/reveal 
--adjacent rooms
DoorButton={}

function DoorButton:load()
    --physics collider

    --sprite and animations
    self.doorButtonSpriteSheet=love.graphics.newImage('assets/maps/door_button.png')
    self.grid=anim8.newGrid(12,14,self.doorButtonSpriteSheet:getWidth(),self.doorButtonSpriteSheet:getHeight())
    self.currentAnim=anim8.newAnimation(
        self.grid('1-4',1),10,
        function() --onLoop function
            self.currentAnim:pauseAtEnd() --will stop animating once pressed
        end
    )

    --button's state
    self.pressed=false 
end

--creates and returns a new doorButton object at position (_xPos,_yPos)
function DoorButton:newDoorButton(_xPos,_yPos)
    local button={}

    --sprite and animations
    button.spriteSheet=self.doorButtonSpriteSheet
    button.grid=self.grid
    button.currentAnim=self.currentAnim 

    function button:update()
        button.currentAnim:update(dt)

        --TODO
        -- if button is pressed, open adjacent room
        --TODO
    end

    function button:draw()
        button.currentAnim:draw(button.spriteSheet,_xPos,_yPos)
    end

    return button 
end