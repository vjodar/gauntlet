CamPanState={}

function CamPanState:update()
    --begin revealing the room by fading out rectangle
    self.alpha=self.alpha-self.step*dt
    if self.panToRoomDone then --accelerate reveal when room is in full view
        self.alpha=self.alpha-5*self.step*dt
    end

    if self.panToPlayer then
        camTarget=Player --return camTarget to be the Player
        return false --remove CamPanState from gameStates
    end
    
    return true --return true to remain on gameStates 
end

function CamPanState:draw() 
    cam:attach()
        love.graphics.setColor(self.color,self.color,self.color,self.alpha)
        love.graphics.rectangle(
            'fill',
            self.rectangleX,self.rectangleY,
            self.w,self.h
        )
        love.graphics.setColor(1,1,1)
    cam:detach()
    Hud:draw() --draw hud after rectangle to keep it at full alpha
end

--uses timerState tween to pan camera from the current position to (_xPos,_yPos)
function CamPanState:pan(_xPos,_yPos)
    self.panToRoomDone=false --panned to the room
    self.panToPlayer=false --pan back to player, exit CamPanState
    
    --for the rectangle fade out (to reveal the room gradually)
    self.rectangleX=_xPos-Rooms.ROOMWIDTH/2
    self.rectangleY=_yPos-Rooms.ROOMHEIGHT/2
    self.w=Rooms.ROOMWIDTH
    self.h=Rooms.ROOMHEIGHT
    self.alpha=1
    self.color=2/15
    self.step=0.6 --decrement by 0.01 at 60fps

    --create a new target for the camera to look at, but keep its current position
    self.target={}
    self.target.xPos=camTarget.xPos
    self.target.yPos=camTarget.yPos
    camTarget=self.target 
    
    --target the _xPos and _yPos, camera smoother takes care of the pan
    self.target.xPos=_xPos
    self.target.yPos=_yPos

    --After 0.8s, pan back to player
    TimerState:after(0.1,function() CamPanState.panToRoomDone=true end)
    TimerState:after(0.8,function() CamPanState.panToPlayer=true end)
end