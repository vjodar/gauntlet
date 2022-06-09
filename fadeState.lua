FadeState={} --used to fade screen in or out

function FadeState:load()
    self.step=1.2
    self._upd=nil --holds the appropriate update function
    self.done=false 
end

function FadeState:update()
    self:_upd()

    if self.done then return false end --return false to exit stack
    
    transitionScreenAlpha=transitionScreenAlpha+self.step*dt --increment/decrement alpha
    
    return true --return true to remain on state stack
end

function FadeState:draw()end

function FadeState:fadeOut(_afterFn)
    transitionScreenAlpha=0
    self.step=1.2 --increment by 0.02 at 60fps
    self._upd=self.fadeOutUpd
    self.afterFn=_afterFn or function()end
    self.done=false 

    table.insert(gameStates,self)
end

function FadeState:fadeOutUpd()
    if transitionScreenAlpha>=1 then 
        self.done=true
        self.afterFn()
    end 
end

function FadeState:fadeIn(_afterFn)
    transitionScreenAlpha=1
    self.step=-1.2 --decrement by 0.02 at 60fps
    self._upd=self.fadeInUpd
    self.afterFn=_afterFn or function()end
    self.done=false

    table.insert(gameStates,self)
end

function FadeState:fadeInUpd()
    if transitionScreenAlpha<=0 then 
        self.done=true 
        self.afterFn()
    end
end

--fade out, hold back screen for _holdTime, then fade back in
function FadeState:fadeComplete(_holdTime,_afterOutFn,_afterInFn) 
    transitionScreenAlpha=0
    self.step=1.2 --increment by 0.02 at 60fps
    self._upd=self.fadeOutUpd
    self.done=false 
    self.afterFn=function() --essentially fadeIn, but wait for _holdTime
        self.done=false
        transitionScreenAlpha=1
        self.step=0 --wait for _holdTime to start decrementing alpha
        TimerState:after(_holdTime,function() self.step=-1.2 end)
        self._upd=self.fadeInUpd
        self.afterFn=_afterInFn or function()end
        if _afterOutFn then _afterOutFn() end --call afterOutFn
    end

    table.insert(gameStates,self)
end
