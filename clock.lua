Clock={} --'clock' to show time limit. It's more of a timer though really.

function Clock:load() 
    self.sprite=love.graphics.newImage('assets/hud/meters/clock_border.png')
    self.w=self.sprite:getWidth()
    self.xPos=WINDOW_WIDTH-WINDOWSCALE_X*(self.w+2)
    self.yPos=WINDOWSCALE_Y
    self.runClock=false --used to pause and resume clock
    self.counter=0 --used to count seconds
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
    
    self:setMode('countDown') --initialize update function to be countDown
end

function Clock:update()
    if not self.runClock then return end --allows for pausing and resuming clock
    self:_upd()
end

function Clock:countDown() --countDown update function
    self.counter=self.counter+dt 
    if self.counter>=1 then --count seconds
        self.counter=0
        self.sec.val=self.sec.val-1
        if self.sec.val==-1 then  --count minutes
            self.min.val=self.min.val-1
            if self.min.val==-1 then --minute is 0, start boss battle
                local afterFn=function()             
                    PlayerTransitionState:enterRoom(Player)
                    PlayState:startBossBattle() 
                end
                Clock:pause()
                FadeState:fadeOut(afterFn)
            else 
                self.sec.val=59 --rollover seconds
            end
        end 
    end
    self.internalTimer.dungeon=self.internalTimer.dungeon+dt
end

function Clock:countUp() --countUp update function
    self.counter=self.counter+dt 
    if self.counter>=1 then --count seconds
        self.counter=0
        self.sec.val=self.sec.val+1
        if self.sec.val==60 then  --count minutes
            self.min.val=self.min.val+1
            if self.min.val==99 then --minute is max val, pause clock
                self.sec.val=59
                Clock:pause()
            else 
                self.sec.val=0 --rollover seconds
            end
        end 
    end
    self.internalTimer.boss=self.internalTimer.boss+dt
end

function Clock:draw()
    love.graphics.draw(self.sprite,self.xPos,self.yPos,nil,WINDOWSCALE_X,WINDOWSCALE_Y)
    love.graphics.print( --minutes
        string.format("%02d",self.min.val),
        self.min.xPos,self.min.yPos,
        nil,WINDOWSCALE_X,WINDOWSCALE_Y
    )
    love.graphics.print(":",self.colon.xPos,self.colon.yPos,nil,WINDOWSCALE_X,WINDOWSCALE_Y)
    love.graphics.print( --seconds
        string.format("%02d",self.sec.val),
        self.sec.xPos,self.sec.yPos,
        nil,WINDOWSCALE_X,WINDOWSCALE_Y
    )
end

function Clock:setMode(_mode) self._upd=self[_mode] end --sets mode (countDown or countUp)

function Clock:start() self.runClock=true end --start the clock
function Clock:pause() self.runClock=false end --pause the clock
function Clock:stop() --stop and set clock to 0:00
    self.runClock=false
    self.min.val,self.sec.val=0,0 
end 
