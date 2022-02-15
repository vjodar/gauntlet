TimerState={}

function TimerState:load() 
    self.timers={} --table of all timers
end

function TimerState:update()
    for i,timer in pairs(self.timers) do 
        --Update each timer, remove any that return false
        if not timer:update()==true then table.remove(self.timers,i) end
    end
    return true --return true to remain in gameStates
end

function TimerState:draw() end

--Uses timer objects to perform some action after the given _time (in seconds)
function TimerState:after(_time,_fn)
    table.insert(self.timers,{
        t=_time,
        fn=_fn,
        --when time is up, call callback function, return false to remove timer from timers
        update=function(self) 
            if self.t<=0 then
                self.fn()
                return false
            end
            --increment timer, return true to keep in timers table
            self.t=self.t-dt
            return true
        end
    })
end

--Uses timer objects to perform _callback every _interval second intervals
--WARNING: no current way to remove this timer
function TimerState:every(_interval,_fn)
    table.insert(self.timers, {
        interval=_time,
        t=0,
        fn=_fn,
        update=function(self)
            --When time counter reaches interval, call function, reset time counter
            if self.t>=self.interval then
                self.fn()
                self.t=0
            end
            --increment timer
            self.t=self.t+dt 
            return true 
        end
    })
end

--Creates a timer to "tween" or move _obj from it's current (x,y) to an end (x,y) in _time seconds
function TimerState:tweenPos(_obj,_endPos,_time)
    table.insert(self.timers,{ 
        t=_time,
        obj=_obj,
        velX=(_endPos.xPos-_obj.xPos)/_time,
        velY=(_endPos.yPos-_obj.yPos)/_time,
        update=function(self)
            if self.t<=0 then return false end --timer is complete, remove this timer from timers
            --move object, decrement t
            self.obj.xPos=self.obj.xPos+self.velX*dt
            self.obj.yPos=self.obj.yPos+self.velY*dt
            self.t=self.t-dt
            return true 
        end
    })
end