Clock={} --'clock' to show time limit. It's more of a timer though really.

function Clock:load() 
    self.sprite=love.graphics.newImage('assets/hud/meters/clock_border.png')
    self.w=self.sprite:getWidth()
    self.runClock=false --used to pause and resume clock
    self.mode="" --used to show either dungeon or boss clock
    self.internalTimer={ --used to keep track of completion times
        dungeon=530,boss=0
    }
    self.font=fonts.yellow

    self._upd=nil --holds the appropriate update function
    
    self:setMode('dungeon') --initialize update function to be dungeon
end

function Clock:update()
    if not self.runClock then return end --allows for pausing and resuming clock

    if self.mode=='dungeon' then --update dungeon clock
        self.internalTimer.dungeon=self.internalTimer.dungeon+dt

        --flash clock red every minute or keep clock red when 1min remains
        if self.internalTimer.dungeon>=540 
        or math.floor((60-self.internalTimer.dungeon)%60)==0
        then 
            self.font=fonts.red else self.font=fonts.yellow
        end

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
        self.font=fonts.yellow
        self.internalTimer.boss=self.internalTimer.boss+dt
        if self.internalTimer.boss>=5999.99 then --clock is maxed, stop counting
            self.internalTimer.boss=5999.99
            self:pause()
        end
    end
end

function Clock:draw()
    love.graphics.draw( --clock 'border'
        self.sprite,
        WINDOW_WIDTH-WINDOWSCALE_X*(self.w+2),WINDOWSCALE_Y,
        nil,WINDOWSCALE_X,WINDOWSCALE_Y
    )
    love.graphics.print( --print colon
        ":",self.font,WINDOW_WIDTH-WINDOWSCALE_X*(self.w-15),WINDOWSCALE_Y*7,
        nil,WINDOWSCALE_X,WINDOWSCALE_Y
    )

    if self.mode=='dungeon' then --draw dungeon clock
        love.graphics.print( --minutes
            string.format("%02d",math.floor(10-(self.internalTimer.dungeon/60))),
            self.font,WINDOW_WIDTH-WINDOWSCALE_X*(self.w-5),WINDOWSCALE_Y*7,
            nil,WINDOWSCALE_X,WINDOWSCALE_Y
        )
        love.graphics.print( --seconds
            string.format("%02d",math.floor((60-self.internalTimer.dungeon)%60)),
            self.font,WINDOW_WIDTH-WINDOWSCALE_X*(self.w-20),WINDOWSCALE_Y*7,
            nil,WINDOWSCALE_X,WINDOWSCALE_Y
        )
    elseif self.mode=='boss' then --draw boss clock
        love.graphics.print( --minutes
            string.format("%02d",math.floor(self.internalTimer.boss/60)),
            WINDOW_WIDTH-WINDOWSCALE_X*(self.w-5),WINDOWSCALE_Y*7,
            nil,WINDOWSCALE_X,WINDOWSCALE_Y
        )
        love.graphics.print( --seconds
            string.format("%02d",math.floor(self.internalTimer.boss%60)),
            WINDOW_WIDTH-WINDOWSCALE_X*(self.w-20),WINDOWSCALE_Y*7,
            nil,WINDOWSCALE_X,WINDOWSCALE_Y
        )
    end
end

function Clock:setMode(_mode) self.mode=_mode end --sets mode (dungeon or boss)

function Clock:start() self.runClock=true end --start the clock
function Clock:pause() self.runClock=false end --pause the clock
