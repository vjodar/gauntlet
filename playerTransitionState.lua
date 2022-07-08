--used to animate the player entering and exiting rooms
PlayerTransitionState={}

function PlayerTransitionState:load()
    self._upd=nil --stores the currently used update function
    self.actor=nil --will point to the actor to be moved
    self.afterFn=nil --will be called once transition is complete
end

function PlayerTransitionState:update() return self:_upd() end
function PlayerTransitionState:draw() end 

function PlayerTransitionState:enterRoom(_actor,_afterFn)
    self._upd=self.enterRoomUpd
    self.actor=_actor 
    self.afterFn=_afterFn or function()end

    --set actor yOffset to above screen, and state to 'falling'
    self.actor.yOffset=self.actor.yOffsetBase+300
    self.actor.state.falling=true 
    self.actor.shadow:changeScale(0)
    self.actor.sfx.falling:play() --play falling sfx

    table.insert(gameStates,self)
end

function PlayerTransitionState:enterRoomUpd() --update function for enterRoom
    if self.actor.yOffset<=self.actor.yOffsetBase+4 then 
        self.actor.yOffset=self.actor.yOffsetBase
        self.actor.state.falling=false 
        self.actor.shadow:changeScale(1)
        self.actor.sfx.landing:play() --play landing sfx
        self.afterFn()
        return false 
    end 

    self.actor.yOffset=self.actor.yOffset-240*dt --make actor 'fall'
    
    self.actor.shadow:changeScale( --increase shadow size as actor approaches ground
        math.min(0.3+(self.actor.yOffsetBase/self.actor.yOffset),1)
    )

    return true 
end

function PlayerTransitionState:exitRoom(_actor,_afterFn) end 
function PlayerTransitionState:exitRoomUpd() end 
