Clock={} --'clock' to show time limit. It's more of a timer though really.

function Clock:load() 
    self.sprite=love.graphics.newImage('assets/hud/meters/clock_border.png')
    self.w=self.sprite:getWidth()
    self.xPos=WINDOW_WIDTH-WINDOWSCALE_X*(self.w+2)
    self.yPos=WINDOWSCALE_Y
    self.runClock=false --used to pause and resume clock
    self.mode="" --used to show either dungeon or boss clock
    self.internalTimer={ --used to keep track of completion times
        dungeon=0,boss=0
    }

    self._upd=nil --holds the appropriate update function

    self.min={ --minutes
        val=10,
        xPos=WINDOW_WIDTH-WINDOWSCALE_X*(self.w-5),
        yPos=WINDOWSCALE_Y*7,
    }

    self.colon={
        xPos=WINDOW_WIDTH-WINDOWSCALE_X*(self.w-15),
        yPos=WINDOWSCALE_Y*7,
    }

    self.sec={
        val=0,
        xPos=WINDOW_WIDTH-WINDOWSCALE_X*(self.w-20),
        yPos=WINDOWSCALE_Y*7,
    }
    
    self:setMode('dungeon') --initialize update function to be dungeon
end

function Clock:update()
    if not self.runClock then return end --allows for pausing and resuming clock

    if self.mode=='dungeon' then --update dungeon clock
        self.internalTimer.dungeon=self.internalTimer.dungeon+dt
        if self.internalTimer.dungeon>=600 then --10min are up, start boss battle
            self.internalTimer.dungeon=600 
            local afterFn=function()             
                PlayerTransitionState:enterRoom(Player)
                PlayState:startBossBattle() 
            end
            self:pause()
            FadeState:fadeOut(1,afterFn)
        end
    elseif self.mode=='boss' then --update boss clock
        self.internalTimer.boss=self.internalTimer.boss+dt
        if self.internalTimer.boss>=5999.99 then --clock is maxed, stop counting
            self.internalTimer.boss=5999.99
            self:pause()
        end
    end
end

function Clock:draw()
    love.graphics.draw(self.sprite,self.xPos,self.yPos,nil,WINDOWSCALE_X,WINDOWSCALE_Y)
    love.graphics.print(":",self.colon.xPos,self.colon.yPos,nil,WINDOWSCALE_X,WINDOWSCALE_Y)

    if self.mode=='dungeon' then --draw dungeon clock
        love.graphics.print( --minutes
            string.format("%02d",math.floor(10-(self.internalTimer.dungeon/60))),
            self.min.xPos,self.min.yPos,
            nil,WINDOWSCALE_X,WINDOWSCALE_Y
        )
        love.graphics.print( --seconds
            string.format("%02d",math.floor((60-self.internalTimer.dungeon)%60)),
            self.sec.xPos,self.sec.yPos,
            nil,WINDOWSCALE_X,WINDOWSCALE_Y
        )
    elseif self.mode=='boss' then --draw boss clock
        love.graphics.print( --minutes
            string.format("%02d",math.floor(self.internalTimer.boss/60)),
            self.min.xPos,self.min.yPos,
            nil,WINDOWSCALE_X,WINDOWSCALE_Y
        )
        love.graphics.print( --seconds
            string.format("%02d",math.floor(self.internalTimer.boss%60)),
            self.sec.xPos,self.sec.yPos,
            nil,WINDOWSCALE_X,WINDOWSCALE_Y
        )
    end
end

function Clock:setMode(_mode) self.mode=_mode end --sets mode (dungeon or boss)

function Clock:start() self.runClock=true end --start the clock
function Clock:pause() self.runClock=false end --pause the clock
function Clock:stop() --stop and set clock to 0:00
    self.runClock=false
    self.min.val,self.sec.val=0,0 
end 
