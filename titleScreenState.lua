TitleScreenState={}

function TitleScreenState:load() 

    --load menus
    self.mainMenu=self.createMainMenu() --main menu

    self.tutorialMenu=self.createTutorialMenu() --tutorial related menus

    self.settingsMenu=self.createSettingsMenu() --setings related menus
    self.displaySettingsMenu=self.createDisplaySettingsMenu()
    -- self.audioSettingsMenu=self.createSettingsAudioMenu()
    -- self.controlsSettingsMenu=self.createSettingsControlsMenu()

    self.sfx={
        cursorMove=Sounds.menu_move(),
        cursorAccept=Sounds.menu_open(),
        cursorDecline=Sounds.menu_close(),
    }
    
    self:goto('mainMenu') --start in main menu
end 

function TitleScreenState:update() return self:_upd() end 
function TitleScreenState:draw() self:_drw() ActionButtons:draw() end 

function TitleScreenState:goto(_menu) --switches to a specified menu
    if self[_menu] then 
        self._upd=self[_menu].update 
        self._drw=self[_menu].draw
    end
end

--remove TitleScreenState from gamestates stack
function TitleScreenState:closeTitleScreen() 
    self._upd=function() return false end
end

TitleScreenState.createMainMenu=function()
    local menu={}

    menu.xPos,menu.yPos=cam.x-34,cam.y+11

    menu.sprites={
        title=love.graphics.newImage("assets/title_screen/title.png"),
        selections=love.graphics.newImage("assets/title_screen/selections_main_menu.png"),
        cursor=love.graphics.newImage("assets/title_screen/cursor_main_menu.png")
    }

    menu.selections={}
    menu.selections.play={
        name='play',
        xPos=menu.xPos, yPos=menu.yPos,
        selectionFunction=function() --start game
            PlayState:startDungeonPhase()
            ActionButtons:setMenuMode(false)
            TitleScreenState:closeTitleScreen()
        end
    }
    menu.selections.tutorial={
        name='tutorial',
        xPos=menu.xPos, yPos=menu.selections.play.yPos+19,
        selectionFunction=function() 
            TitleScreenState:goto('tutorialMenu')
            TitleScreenState.sfx.cursorAccept:play()
        end  
    }
    menu.selections.settings={
        name='settings',
        xPos=menu.xPos, yPos=menu.selections.tutorial.yPos+19,
        selectionFunction=function()  
            TitleScreenState:goto('settingsMenu')
            TitleScreenState.sfx.cursorAccept:play()
        end 
    }
    menu.selections.exit={
        name='exit',
        xPos=menu.xPos, yPos=menu.selections.settings.yPos+19,
        selectionFunction=function() closeGame() end --closes application
    }

    menu.cursor={xPos=0,yPos=0}
    menu.cursor.currentSelection=menu.selections.play
    menu.cursor.getSelectionAbove=function()
        local selectionAbove={
            play='exit',
            tutorial='play',
            settings='tutorial',
            exit='settings',
        }
        menu.cursor.currentSelection=menu.selections[
            selectionAbove[menu.cursor.currentSelection.name]
        ]
    end
    menu.cursor.getSelectionBelow=function()        
        local selectionBelow={
            play='tutorial',
            tutorial='settings',
            settings='exit',
            exit='play',
        }
        menu.cursor.currentSelection=menu.selections[
            selectionBelow[menu.cursor.currentSelection.name]
        ]
    end
    menu.cursor.updatePosition=function()
        menu.cursor.xPos=menu.cursor.currentSelection.xPos 
        menu.cursor.yPos=menu.cursor.currentSelection.yPos 
    end

    menu.update=function() 
        menu.cursor.updatePosition()
        if acceptInput then 
            ActionButtons:update()
            if Controls.releasedInputs.btnDown then 
                menu.cursor.currentSelection.selectionFunction()
            end
            if Controls.releasedInputs.btnRight then 
                menu.selections.exit.selectionFunction() 
            end 
            if Controls.releasedInputs.dirUp then 
                menu.cursor.getSelectionAbove()
                TitleScreenState.sfx.cursorMove:play()
            end
            if Controls.releasedInputs.dirDown then 
                menu.cursor.getSelectionBelow()
                TitleScreenState.sfx.cursorMove:play()
            end
        end
        return true 
    end 

    menu.draw=function() 
        cam:attach()
            love.graphics.draw(menu.sprites.title,cam.x-130,cam.y-65)
            love.graphics.draw(menu.sprites.selections,menu.xPos,menu.yPos)
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
                TitleScreenState:goto('mainMenu')
                TitleScreenState.sfx.cursorDecline:play()
            end
            if Controls.releasedInputs.btnDown then 
                --TODO------------------
                --enter current selection
                --TODO------------------
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

    menu.xPos,menu.yPos=cam.x-34,cam.y-50

    menu.sprites={
        selections=love.graphics.newImage("assets/title_screen/selections_settings_menu.png"),
        cursor=love.graphics.newImage("assets/title_screen/cursor_main_menu.png")
    }

    menu.selections={}
    menu.selections.display={
        name='display',
        xPos=menu.xPos, yPos=menu.yPos+23,
        selectionFunction=function() 
            TitleScreenState:goto('displaySettingsMenu')
            TitleScreenState.sfx.cursorAccept:play()
        end
    }
    menu.selections.audio={
        name='audio',
        xPos=menu.xPos, yPos=menu.selections.display.yPos+19,
        selectionFunction=function() 
            TitleScreenState:goto('') --TODO: add audio settings menu
            TitleScreenState.sfx.cursorAccept:play()
        end  
    }
    menu.selections.controls={
        name='controls',
        xPos=menu.xPos, yPos=menu.selections.audio.yPos+19,
        selectionFunction=function()  
            TitleScreenState:goto('') --TODO: add controls settings menu
            TitleScreenState.sfx.cursorAccept:play()
        end 
    }
    menu.selections.back={
        name='back',
        xPos=menu.xPos, yPos=menu.selections.controls.yPos+19,
        selectionFunction=function() 
            TitleScreenState:goto('mainMenu')
            TitleScreenState.sfx.cursorDecline:play()

            --default to display selection (so it doesn't stay on exit)
            menu.cursor.currentSelection=menu.selections.display
        end
    }

    menu.cursor={xPos=0,yPos=0}
    menu.cursor.currentSelection=menu.selections.display
    menu.cursor.getSelectionAbove=function()
        local selectionAbove={
            display='back',
            audio='display',
            controls='audio',
            back='controls',
        }
        menu.cursor.currentSelection=menu.selections[
            selectionAbove[menu.cursor.currentSelection.name]
        ]
    end
    menu.cursor.getSelectionBelow=function()        
        local selectionBelow={
            display='audio',
            audio='controls',
            controls='back',
            back='display',
        }
        menu.cursor.currentSelection=menu.selections[
            selectionBelow[menu.cursor.currentSelection.name]
        ]
    end
    menu.cursor.updatePosition=function()
        menu.cursor.xPos=menu.cursor.currentSelection.xPos 
        menu.cursor.yPos=menu.cursor.currentSelection.yPos 
    end

    menu.update=function() 
        menu.cursor.updatePosition()
        if acceptInput then 
            ActionButtons:update()
            if Controls.releasedInputs.btnDown then 
                menu.cursor.currentSelection.selectionFunction() 
            end
            if Controls.releasedInputs.btnRight then 
                menu.selections.back.selectionFunction() 
            end 
            if Controls.releasedInputs.dirUp then 
                menu.cursor.getSelectionAbove()
                TitleScreenState.sfx.cursorMove:play()
            end
            if Controls.releasedInputs.dirDown then 
                menu.cursor.getSelectionBelow()
                TitleScreenState.sfx.cursorMove:play()
            end
        end
        return true --keep TitleScreenState on state stack
    end 

    menu.draw=function() 
        cam:attach()
            love.graphics.draw(menu.sprites.selections,menu.xPos,menu.yPos)
            love.graphics.draw(menu.sprites.cursor,menu.cursor.xPos,menu.cursor.yPos)
            love.graphics.printf("BACK",cam.x,cam.y+103,160,'right')
            love.graphics.printf("ACCEPT",cam.x,cam.y+123,140,'right')
        cam:detach()
    end 

    return menu
end

TitleScreenState.createDisplaySettingsMenu=function()
    local menu={}

    menu.xPos,menu.yPos=cam.x-34,cam.y-50

    menu.sprites={
        selections=love.graphics.newImage("assets/title_screen/selections_display_menu.png"),
        cursor=love.graphics.newImage("assets/title_screen/cursor_display_menu.png")
    }

    menu.resetPendingDisplayValues=function()
        local width,height,flags=love.window.getMode()
        menu.pendingDisplayValues={
            displayMode=flags.fullscreen,
            w=width,
            h=height
        }
    end
    menu.resetPendingDisplayValues()

    menu.selections={}
    menu.selections.displayMode={
        name='displayMode',
        xPos=menu.xPos, yPos=menu.yPos,
        shiftLeft=function() 
            local displayMode=menu.pendingDisplayValues.displayMode
            menu.pendingDisplayValues.displayMode=not displayMode
        end,
        shiftRight=function() 
            local displayMode=menu.pendingDisplayValues.displayMode
            menu.pendingDisplayValues.displayMode=not displayMode
        end,
    }
    menu.selections.resolution={
        name='resolution',
        xPos=menu.xPos, yPos=menu.selections.displayMode.yPos+38,
        shiftLeft=function() 
            --TODO: increase resolution
        end,
        shiftRight=function() 
            --TODO: decrease resolution
        end,
    }

    menu.cursor={xPos=0,yPos=0}
    menu.cursor.currentSelection=menu.selections.displayMode
    menu.cursor.getOtherSelection=function()
        local otherSelection={
            displayMode='resolution',
            resolution='displayMode'
        }
        menu.cursor.currentSelection=menu.selections[
            otherSelection[menu.cursor.currentSelection.name]
        ]
    end
    menu.cursor.updatePosition=function()
        menu.cursor.xPos=menu.cursor.currentSelection.xPos 
        menu.cursor.yPos=menu.cursor.currentSelection.yPos 
    end

    menu.applyPendingValues=function()
        local newSettings={
            w=menu.pendingDisplayValues.w,
            h=menu.pendingDisplayValues.h,
            isFullscreen=menu.pendingDisplayValues.displayMode
        }
        changeDisplaySettings(newSettings)
    end

    menu.update=function() 
        menu.cursor.updatePosition()
        if acceptInput then 
            ActionButtons:update()
            if Controls.releasedInputs.btnDown then 
                menu.applyPendingValues()
            end
            if Controls.releasedInputs.btnRight then 
                menu.resetPendingDisplayValues()
                TitleScreenState:goto('settingsMenu')                
                TitleScreenState.sfx.cursorDecline:play()
            end 
            if Controls.releasedInputs.dirUp or Controls.releasedInputs.dirDown then 
                menu.cursor.getOtherSelection()
                TitleScreenState.sfx.cursorMove:play()
            end
            if Controls.releasedInputs.dirRight then 
                menu.cursor.currentSelection.shiftRight()
            end
            if Controls.releasedInputs.dirLeft then 
                menu.cursor.currentSelection.shiftLeft()
            end
        end
        return true --keep TitleScreenState on state stack
    end 

    menu.draw=function() 
        cam:attach()
            love.graphics.draw(menu.sprites.selections,menu.xPos,menu.yPos)
            love.graphics.draw(menu.sprites.cursor,menu.cursor.xPos,menu.cursor.yPos)
            love.graphics.printf("BACK",cam.x,cam.y+103,160,'right')
            love.graphics.printf("APPLY",cam.x,cam.y+123,140,'right')

            if menu.pendingDisplayValues.displayMode==false then 
                love.graphics.printf('Windowed',menu.xPos,menu.yPos+48,84,'center')
            elseif menu.pendingDisplayValues.displayMode==true then 
                love.graphics.printf('Fullscreen',menu.xPos,menu.yPos+48,84,'center')
            end
            
            love.graphics.printf(
                menu.pendingDisplayValues.w ..'x'.. menu.pendingDisplayValues.h,
                menu.xPos,menu.yPos+86,84,'center'
            )
        cam:detach()
    end 

    return menu
end
