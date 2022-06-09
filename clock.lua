Clock={} --'clock' to show time limit. It's more of a timer though really.

function Clock:load() 
    self.sprite=love.graphics.newImage('assets/hud/meters/clock_border.png')
    self.w=self.sprite:getWidth()
    self.xPos=WINDOW_WIDTH-WINDOWSCALE_X*(self.w+2)
    self.yPos=WINDOWSCALE_Y
    self.runClock=false --used to pause and resume clock
    self.counter=0 --used to countdown seconds

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
end

function Clock:update()
    if not self.runClock then return end --allows for pausing and resuming clock

    self.counter=self.counter+dt 
    if self.counter>=1 then
        self.counter=0
        self.sec.val=self.sec.val-1
        if self.sec.val==-1 then 
            self.min.val=self.min.val-1
            if self.min.val==-1 then 
                PlayState:startBossBattle()
            else 
                self.sec.val=59 --rollover
            end
        end 
    end
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

function Clock:start() self.runClock=true end --start the clock
function Clock:pause() self.runClock=false end --pause the clock
function Clock:stop() --stop and set clock to 0:00
    self.runClock=false
    self.min.val,self.sec.val=0,0 
end 
