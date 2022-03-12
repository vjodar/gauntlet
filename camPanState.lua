CamPanState={}

function CamPanState:update()
    if self.panComplete==true then
        camTarget=Player --return camTarget to be the Player
        return false --remove CamPanState from gameStates
    end
    return true --return true to remain on gameStates 
end

function CamPanState:draw() end

--uses timerState tween to pan camera from the current position to (_xPos,_yPos)
function CamPanState:pan(_xPos,_yPos)
    self.panComplete=false

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