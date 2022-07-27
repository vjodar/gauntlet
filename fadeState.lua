FadeState={} --used to fade screen in or out

function FadeState:load()
    self.step=1.2 --used to increment/decrement alpha
    self.target=0 --target alpha value
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

function FadeState:fadeOut(_target,_afterFn)
    self.target=_target or 1
    self.step=1.2 --increment by 0.02 at 60fps
    self._upd=self.fadeOutUpd
    self.afterFn=_afterFn or function()end
    self.done=false 

    table.insert(gameStates,self)
end

function FadeState:fadeOutUpd()
    if transitionScreenAlpha>=self.target then 
        transitionScreenAlpha=self.target
        self.done=true
        self.afterFn()
    end 
end

function FadeState:fadeIn(_target,_afterFn)
    self.target=_target or 0
    self.step=-0.8
    self._upd=self.fadeInUpd
    self.afterFn=_afterFn or function()end
    self.done=false

    table.insert(gameStates,self)
end

function FadeState:fadeInUpd()
    if transitionScreenAlpha<=self.target then 
        transitionScreenAlpha=self.target
        self.done=true 
        self.afterFn()
    end
end
