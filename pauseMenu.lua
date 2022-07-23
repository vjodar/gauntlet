PauseMenuState={}

function PauseMenuState:load()
    self.xPos,self.yPos=0,0

    self.sprites={
        selections=love.graphics.newImage("assets/menus/pause_menu/selections_pause_menu.png"),
        cursor=love.graphics.newImage("assets/menus/pause_menu/cursor_pause_menu.png"),
    }

    self.sfx={
        move=Sounds.menu_move(),
        accept=Sounds.menu_open(),
        decline=Sounds.menu_close(),
    }

    self.selections={
        backToGame={
            name='backToGame',
            xPos=0,yPos=0,
            fn=function() --remove pauseMenu to go back to game
                ActionButtons:setMenuMode(false)
                self._upd=function() return false end 
                self.sfx.decline:play()
            end,
            updatePos=function(s)
                s.xPos,s.yPos=self.xPos,self.yPos
            end
        },
        titleScreen={
            name='titleScreen',
            xPos=0,yPos=0,
            fn=function() --restart to go to title screen
                self._drw=function() --stop drawing menu/buttons
                    cam:attach()
                    love.graphics.setColor(black,black,black,0.5)
                    love.graphics.rectangle('fill',cam.x-200,cam.y-150,400,300)
                    love.graphics.setColor(1,1,1,1) 
                    cam:detach()
                end
                local afterFn=function() --after fadeOut, restart game
                    self._upd=function() return false end
                    love.load({keepSettings=true}) 
                end
                FadeState:fadeOut(1,afterFn)
                ActionButtons:setMenuMode(false)
                self.sfx.accept:play()                
            end,
            updatePos=function(s)
                s.xPos,s.yPos=self.xPos,self.yPos+21
            end
        },
    }

    self.cursor={
        currentSelection=self.selections.backToGame,
        otherSelection={
            backToGame='titleScreen',
            titleScreen='backToGame',
        }    
    }

    function self:switchSelections() --changes the cursor's current selection
        self.cursor.currentSelection=self.selections[
            self.cursor.otherSelection[self.cursor.currentSelection.name]
        ] 
    end

    self._upd=nil --update state machine
end

function PauseMenuState:update() return self:_upd() end 
function PauseMenuState:draw() self:_drw() end 

function PauseMenuState:updatePauseMenu()    
    --update positions of menu and selections
    if cam then self.xPos,self.yPos=cam.x-52,cam.y-50 end 
    for _,s in pairs(self.selections) do s:updatePos() end
    ActionButtons:update() --update on screen action buttons

    if acceptInput then 
        if Controls.pressedInputs.dirUp 
        or Controls.pressedInputs.dirDown 
        then 
            self:switchSelections()
            self.sfx.move:play()
        end
        if Controls.releasedInputs.btnDown then 
            self.cursor.currentSelection.fn()
        end
        if Controls.releasedInputs.btnRight 
        then 
            self.cursor.currentSelection=self.selections.backToGame 
            self.cursor.currentSelection.fn()
        end
    end

    --close menu if player dies
    if Player.health.current==0 then self.selections.backToGame:fn() end 

    return true 
end

function PauseMenuState:drawPauseMenu()
    cam:attach()

    love.graphics.setColor(black,black,black,0.6)
    love.graphics.rectangle('fill',cam.x-200,cam.y-150,400,300)
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.sprites.selections,self.xPos,self.yPos)
    love.graphics.draw( --draw cursor
        self.sprites.cursor,
        self.cursor.currentSelection.xPos,
        self.cursor.currentSelection.yPos
    )
    love.graphics.printf("BACK",cam.x,cam.y+103,160,'right')
    love.graphics.printf("APPLY",cam.x,cam.y+123,140,'right')

    cam:detach()
    ActionButtons:draw()
end

function PauseMenuState:open() --opens the pause menu
    self._upd=self.updatePauseMenu
    self._drw=self.drawPauseMenu
    ActionButtons:setMenuMode(true)
    table.insert(gameStates,self)
    self.sfx.accept:play()
end