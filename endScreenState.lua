EndScreenState={}

function EndScreenState:update()     
    ActionButtons:update()
    return self:restartOrMainMenu()
end

function EndScreenState:draw() 
    cam:draw(self._drw) 
    ActionButtons:draw() --redraw menu buttons
end

function EndScreenState:lose()
    ActionButtons:setMenuMode(true)
    self._drw=function()
        love.graphics.printf("Game Over!",cam.x-400,cam.y-100,400,'center',nil,2)
    end
    self.acceptInput=false --wait 1sec before able to close menu
    TimerState:after(1,function() self.acceptInput=true end)

    table.insert(gameStates,self)
end

function EndScreenState:win()
    ActionButtons:setMenuMode(true)
    local dt,bt=Clock.internalTimer.dungeon,Clock.internalTimer.boss
    local ct=dt+bt 
    self.dungeonTime=tostring(math.floor(dt/60)).."min  "..string.format("%0.2f",dt%60).."sec"
    self.bossTime=tostring(math.floor(bt/60)).."min  "..string.format("%0.2f",bt%60).."sec"
    self.completionTime=tostring(math.floor(ct/60)).."min  "..string.format("%0.2f",ct%60).."sec" 
    self._drw=function()
        love.graphics.printf("Congratulations!",cam.x-400,cam.y-100,400,'center',nil,2)

        love.graphics.printf("Dungeon time: ",cam.x-200,cam.y-50,200,'right')
        love.graphics.print(self.dungeonTime, fonts.gray,cam.x+10,cam.y-50)

        love.graphics.printf("Boss Battle time: ",cam.x-200,cam.y-25,200,'right')
        love.graphics.print(self.bossTime,fonts.blue,cam.x+10,cam.y-25)

        love.graphics.printf("Completion time: ",cam.x-200,cam.y,200,'right')
        love.graphics.print(self.completionTime,fonts.red,cam.x+10,cam.y)
    end
    self.acceptInput=false --wait 1sec before able to close menu
    TimerState:after(1,function() self.acceptInput=true end)

    table.insert(gameStates,self)
end

function EndScreenState:restartOrMainMenu()
    if acceptInput and self.acceptInput then 
        if love.keyboard.isDown(controls.btnDown) then --restart game
            local afterFn=function()
                PlayState:load()
                ActionButtons:setMenuMode(false)
            end
            FadeState:fadeOut(1,afterFn)
            return false
        end
    end
    return true --return true to remain on gamestates
end
