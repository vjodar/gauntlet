TitleScreenState={}

function TitleScreenState:load() 
    self.mainMenu=self.createMainMenu()
    self.tutorialMenu=self.createTutorialMenu()
    self.settingsMenu=self.createSettingsMenu()

    self._upd=self.mainMenu.update
    self._drw=self.mainMenu.draw 
end 

function TitleScreenState:update() return self:_upd() end 
function TitleScreenState:draw() self:_drw() ActionButtons:draw() end 

TitleScreenState.createMainMenu=function()
    local menu={}

    menu.sprites={
        title=love.graphics.newImage("assets/title_screen/title.png"),
        selections=love.graphics.newImage("assets/title_screen/selections_main_menu.png"),
        cursor=love.graphics.newImage("assets/title_screen/cursor_main_menu.png")
    }

    menu.sfx={
        moveCursor=Sounds.menu_move()
    }

    menu.selections={}
    menu.selections.play={
        xPos=cam.x-34, yPos=cam.y+11,
        getSelectionAbove=function() return menu.selections.exit end,
        getSelectionBelow=function() return menu.selections.tutorial end,
        selectionFunction=function() 
            PlayState:startDungeonPhase()
            ActionButtons:setMenuMode(false)         
            return false --remove titleScreenState from gameStates stack
        end
    }
    menu.selections.tutorial={
        xPos=cam.x-34, yPos=cam.y+30,
        getSelectionAbove=function() return menu.selections.play end,
        getSelectionBelow=function() return menu.selections.settings end,
        selectionFunction=function() 
            TitleScreenState._upd=TitleScreenState.tutorialMenu.update 
            TitleScreenState._drw=TitleScreenState.tutorialMenu.draw

            return true --keep titleScreenState on stack
        end  
    }
    menu.selections.settings={
        xPos=cam.x-34, yPos=cam.y+49,
        getSelectionAbove=function() return menu.selections.tutorial end,
        getSelectionBelow=function() return menu.selections.exit end,
        selectionFunction=function()  
            -- TitleScreenState._upd=TitleScreenState.settingsMenu.update 
            -- TitleScreenState._drw=TitleScreenState.settingsMenu.draw

            return true --keep titleScreenState on stack
        end 
    }
    menu.selections.exit={
        xPos=cam.x-34, yPos=cam.y+68,
        getSelectionAbove=function() return menu.selections.settings end,
        getSelectionBelow=function() return menu.selections.play end,
        selectionFunction=function() closeGame() end 
    }

    menu.cursor={xPos=0,yPos=0}
    menu.cursor.currentSelection=menu.selections.play
    menu.cursor.updatePosition=function()
        menu.cursor.xPos=menu.cursor.currentSelection.xPos 
        menu.cursor.yPos=menu.cursor.currentSelection.yPos 
    end

    menu.update=function() 
        menu.cursor.updatePosition()
        if acceptInput then 
            ActionButtons:update()
            if Controls.releasedInputs.btnDown then 
                return menu.cursor.currentSelection.selectionFunction() 
            end
            if Controls.releasedInputs.btnRight then 
                menu.selections.exit.selectionFunction() 
            end 
            if Controls.releasedInputs.dirUp then 
                menu.cursor.currentSelection=menu.cursor.currentSelection.getSelectionAbove()
                menu.sfx.moveCursor:play()
            end
            if Controls.releasedInputs.dirDown then 
                menu.cursor.currentSelection=menu.cursor.currentSelection.getSelectionBelow()
                menu.sfx.moveCursor:play()
            end
        end
        return true 
    end 

    menu.draw=function() 
        cam:attach()
            love.graphics.draw(menu.sprites.title,cam.x-130,cam.y-65)
            love.graphics.draw(menu.sprites.selections,cam.x-34,cam.y+11)
            love.graphics.draw(menu.sprites.cursor,menu.cursor.xPos,menu.cursor.yPos)
            love.graphics.printf("EXIT",cam.x,cam.y+103,160,'right')
            love.graphics.printf("ACCEPT",cam.x,cam.y+123,140,'right')
        cam:detach()
    end 

    return menu
end

TitleScreenState.createTutorialMenu=function()
    local menu={}

    menu.sprites={
        controls_guide=love.graphics.newImage('assets/title_screen/controls_guide.png'),
    }

    menu.update=function()
        if acceptInput then 
            ActionButtons:update()
            if Controls.releasedInputs.btnRight then 
                TitleScreenState._upd=TitleScreenState.mainMenu.update 
                TitleScreenState._drw=TitleScreenState.mainMenu.draw 
            end
            if Controls.releasedInputs.btnDown then 
                TitleScreenState._upd=TitleScreenState.mainMenu.update 
                TitleScreenState._drw=TitleScreenState.mainMenu.draw 
            end
        end
        return true 
    end

    menu.draw=function()
        cam:attach()
            love.graphics.draw(menu.sprites.controls_guide,cam.x-200,cam.y-131)
            love.graphics.printf("BACK",cam.x,cam.y+103,160,'right')
            love.graphics.printf("ACCEPT",cam.x,cam.y+123,140,'right')
        cam:detach()
    end

    return menu
end

TitleScreenState.createSettingsMenu=function()
    local menu={}



    return menu
end
