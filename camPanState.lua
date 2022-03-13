CamPanState={}

function CamPanState:update()
    self.alpha=self.alpha-0.04 --fade rectangle out to reveal room
    if self.panComplete==true then
        camTarget=Player --return camTarget to be the Player
        return false --remove CamPanState from gameStates
    end
    return true --return true to remain on gameStates 
end

function CamPanState:draw() 
    cam:attach()
        love.graphics.setColor(2/15,2/15,2/15,self.alpha)
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
    self.panComplete=false --is the panning done
    
    --for the rectangle fade out (to reveal the room gradually)
    self.rectangleX=_xPos-Rooms.ROOMWIDTH/2
    self.rectangleY=_yPos-Rooms.ROOMHEIGHT/2
    self.w=Rooms.ROOMWIDTH
    self.h=Rooms.ROOMHEIGHT
    self.alpha=1

    --create a new target for the camera to look at, but keep its current position
    self.target={}
    self.target.xPos=camTarget.xPos
    self.target.yPos=camTarget.yPos
    camTarget=self.target 
    
    TimerState:tweenPos(self.target,{xPos=_xPos,yPos=_yPos},0.3) --pan to (_xPos,_yPos)
    TimerState:after(0.6,CamPanState.panBackToPlayer) --after 1sec, pan back to player
end

function CamPanState:panBackToPlayer()
    TimerState:tweenPos(CamPanState.target,Player,0.3) --pan back to Player
    TimerState:after(0.3,function() CamPanState.panComplete=true end)
end