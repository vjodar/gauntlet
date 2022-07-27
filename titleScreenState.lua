TitleScreenState={}

function TitleScreenState:load() 

    --load menus
    self.mainMenu=self.createMainMenu() --main menu

    self.tutorialMenu=self.createTutorialMenu() --tutorial related menus
    self.controlsGuideMenu=self.createControlsGuideMenu()

    self.settingsMenu=self.createSettingsMenu() --setings related menus
    self.displaySettingsMenu=self.createDisplaySettingsMenu()
    self.audioSettingsMenu=self.createAudioSettingsMenu()
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
    PlayState:startDungeonPhase()
    ActionButtons:setMenuMode(false)
    self._drw=function() end
    self._upd=function() return false end
end

TitleScreenState.createMainMenu=function()
    local menu={}

    menu.xPos,menu.yPos=cam.x-34,cam.y+11

    menu.sprites={
        title=love.graphics.newImage("assets/menus/title_screen/title.png"),
        selections=love.graphics.newImage("assets/menus/title_screen/selections_main_menu.png"),
        cursor=love.graphics.newImage("assets/menus/title_screen/cursor_main_menu.png")
    }

    menu.selections={}
    menu.selections.play={
        name='play',
        xPos=menu.xPos, yPos=menu.yPos,
        selectionFunction=function() --start game
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
            if Controls.pressedInputs.dirUp then 
                menu.cursor.getSelectionAbove()
                TitleScreenState.sfx.cursorMove:play()
            end
            if Controls.pressedInputs.dirDown then 
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

    menu.xPos,menu.yPos=cam.x-49,cam.y-50

    menu.sprites={
        selections=love.graphics.newImage('assets/menus/title_screen/selections_tutorial_menu.png'),
        cursor=love.graphics.newImage('assets/menus/title_screen/cursor_tutorial_menu.png'),
    }

    menu.selections={
        viewControls={
            name='viewControls',
            xPos=menu.xPos,yPos=menu.yPos,
            selectionFunction=function()
                TitleScreenState:goto('controlsGuideMenu')
                TitleScreenState.sfx.cursorAccept:play()
            end
        },
        startTutorial={
            name='startTutorial',
            xPos=menu.xPos,yPos=menu.yPos+21,
            selectionFunction=function()
                --close titleScreenState
                TitleScreenState._upd=function() return false end
                TitleScreenState._drw=function() end
                
                local afterOutFn=function() 
                    --close dungeon, bossRoom, and playState
                    Dungeon:closeDungeon()
                    for _,c in pairs(BossRoom.lavaColliders) do c:destroy() end
                    PlayState._update=function() return false end 

                    --start tutorialState
                    TutorialState:startT1()

                    --0.2s after fading out, fade in and drop player into room
                    TimerState:after(0.2,function()
                        FadeState:fadeIn()       
                        PlayerTransitionState:enterRoom(Player)
                        ActionButtons:setMenuMode(false)
                    end)
                end

                FadeState:fadeOut(1,afterOutFn)
            end
        },
        back={
            name='back',            
            xPos=menu.xPos,yPos=menu.yPos+42,
            selectionFunction=function()
                TitleScreenState:goto('mainMenu')
                TitleScreenState.sfx.cursorDecline:play()
            end
        },
    }

    menu.cursor={
        currentSelection=menu.selections.viewControls,
        selectionBelow={
            viewControls='startTutorial',
            startTutorial='back',
            back='viewControls'
        },
        selectionAbove={
            viewControls='back',
            startTutorial='viewControls',
            back='startTutorial'
        },
    }

    --returns the selection below the current selection
    menu.getSelectionBelow=function()
        local current=menu.cursor.currentSelection.name
        local below=menu.cursor.selectionBelow[current]
        return menu.selections[below]
    end

    --returns the selection above the current selection
    menu.getSelectionAbove=function()
        local current=menu.cursor.currentSelection.name
        local above=menu.cursor.selectionAbove[current]
        return menu.selections[above]
    end

    menu.update=function()
        if acceptInput then 
            ActionButtons:update()
            if Controls.pressedInputs.dirUp then 
                menu.cursor.currentSelection=menu.getSelectionAbove()
                TitleScreenState.sfx.cursorMove:play()
            end
            if Controls.pressedInputs.dirDown then 
                menu.cursor.currentSelection=menu.getSelectionBelow()
                TitleScreenState.sfx.cursorMove:play()
            end
            if Controls.releasedInputs.btnRight then 
                TitleScreenState:goto('mainMenu')
                TitleScreenState.sfx.cursorDecline:play()
            end
            if Controls.releasedInputs.btnDown then 
                menu.cursor.currentSelection.selectionFunction()
            end
        end
        return true 
    end

    menu.draw=function()
        cam:attach()
            love.graphics.draw(menu.sprites.selections,menu.xPos,menu.yPos)
            love.graphics.draw(
                menu.sprites.cursor,
                menu.cursor.currentSelection.xPos,
                menu.cursor.currentSelection.yPos
            )
            love.graphics.printf("BACK",cam.x,cam.y+103,160,'right')
            love.graphics.printf("ACCEPT",cam.x,cam.y+123,140,'right')
        cam:detach()
    end

    return menu
end

TitleScreenState.createControlsGuideMenu=function()
    local menu={}

    menu.sprites={
        keyboard=love.graphics.newImage('assets/menus/title_screen/keyboard_controls_guide.png'),
        controller=love.graphics.newImage('assets/menus/title_screen/controller_controls_guide.png'),
    }

    menu.update=function()
        if acceptInput then 
            ActionButtons:update()
            if Controls.releasedInputs.btnRight 
            or Controls.releasedInputs.btnDown 
            then 
                TitleScreenState:goto('tutorialMenu')
                TitleScreenState.sfx.cursorDecline:play()
            end
        end
        return true 
    end

    menu.draw=function()
        cam:attach()
            love.graphics.draw(menu.sprites.keyboard,cam.x-200,cam.y-150)
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
        selections=love.graphics.newImage("assets/menus/title_screen/selections_settings_menu.png"),
        cursor=love.graphics.newImage("assets/menus/title_screen/cursor_main_menu.png")
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
            TitleScreenState:goto('audioSettingsMenu')
            TitleScreenState.sfx.cursorAccept:play()
        end  
    }
    menu.selections.back={
        name='back',
        xPos=menu.xPos, yPos=menu.selections.audio.yPos+19,
        selectionFunction=function() 
            TitleScreenState:goto('mainMenu')
            TitleScreenState.sfx.cursorDecline:play()

            --default to display selection (so it doesn't stay on exit)
            menu.cursor.currentSelection=menu.selections.display --audio in WEB VERSION
        end
    }

    menu.cursor={xPos=0,yPos=0}
    menu.cursor.currentSelection=menu.selections.display --audio in WEB VERSION
    menu.cursor.getSelectionAbove=function()
        local selectionAbove={
            display='back', --NOT IN WEB VERSION
            audio='display',
            back='audio',
        }
        menu.cursor.currentSelection=menu.selections[
            selectionAbove[menu.cursor.currentSelection.name]
        ]
    end
    menu.cursor.getSelectionBelow=function()        
        local selectionBelow={
            display='audio', --NOT IN WEB VERSION
            audio='back',
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
            if Controls.pressedInputs.dirUp then 
                menu.cursor.getSelectionAbove()
                TitleScreenState.sfx.cursorMove:play()
            end
            if Controls.pressedInputs.dirDown then 
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

    menu.xPos,menu.yPos=cam.x-42,cam.y-50

    menu.sprites={
        selections=love.graphics.newImage("assets/menus/title_screen/selections_display_menu.png"),
        cursor=love.graphics.newImage("assets/menus/title_screen/cursor_display_menu.png")
    }

    menu.resetPendingDisplayValues=function()
        local w,h,flags=love.window.getMode()
        menu.pendingDisplayValues={
            isFullscreen=flags.fullscreen,
            width=w,
            height=h
        }
    end
    menu.resetPendingDisplayValues() 

    menu.applyPendingValues=function() 
        --update Settings.currentSettings and apply to game
        for field,setting in pairs(menu.pendingDisplayValues) do 
            Settings.currentSettings.display[field]=setting
        end
        Settings:applyCurrentSettings()
        --reset pending values in case settings validation rejected something
        menu.resetPendingDisplayValues()
    end

    --returns the largest 4x3 resolution that can fit in current display
    menu.getMaxResolution=function()
        local desktopW,desktopH=love.window.getDesktopDimensions()
        local maxHeight=math.floor(desktopH/300)*300 
        local maxWidth=maxHeight*(4/3) 
        return {width=maxWidth,height=maxHeight}
    end

    menu.selections={}
    menu.selections.isFullscreen={
        name='isFullscreen',
        xPos=menu.xPos, yPos=menu.yPos,
        shiftLeft=function() 
            local isFullscreen=menu.pendingDisplayValues.isFullscreen
            menu.pendingDisplayValues.isFullscreen=not isFullscreen
            TitleScreenState.sfx.cursorAccept:play()
        end,
        shiftRight=function() 
            local isFullscreen=menu.pendingDisplayValues.isFullscreen
            menu.pendingDisplayValues.isFullscreen=not isFullscreen
            TitleScreenState.sfx.cursorAccept:play()
        end,
    }
    menu.selections.resolution={
        name='resolution',
        xPos=menu.xPos, yPos=menu.selections.isFullscreen.yPos+38,
        shiftLeft=function() --decrease resolution
            local minRes={width=400,height=300}
            local currentRes={
                width=menu.pendingDisplayValues.width,
                height=menu.pendingDisplayValues.height
            }     
            for dimension,_ in pairs(currentRes) do 
                if currentRes[dimension]<=minRes[dimension] then 
                    --already at min res, don't change
                    TitleScreenState.sfx.cursorDecline:play()
                else
                    --resolution can decrease
                    menu.pendingDisplayValues.width=currentRes.width-400
                    menu.pendingDisplayValues.height=currentRes.height-300
                    TitleScreenState.sfx.cursorAccept:play()                
                end
            end
        end,
        shiftRight=function() --increase resolution
            local maxRes=menu.getMaxResolution()
            local currentRes={
                width=menu.pendingDisplayValues.width,
                height=menu.pendingDisplayValues.height
            }            
            for dimension,_ in pairs(currentRes) do 
                if currentRes[dimension]>=maxRes[dimension] then 
                    --already at max res, don't change
                    TitleScreenState.sfx.cursorDecline:play()
                else 
                    --resolution can increase
                    menu.pendingDisplayValues.width=currentRes.width+400
                    menu.pendingDisplayValues.height=currentRes.height+300
                    TitleScreenState.sfx.cursorAccept:play()
                end
            end
        end,
    }

    menu.cursor={xPos=0,yPos=0}
    menu.cursor.currentSelection=menu.selections.isFullscreen
    menu.cursor.getOtherSelection=function()
        local otherSelection={
            isFullscreen='resolution',
            resolution='isFullscreen'
        }
        menu.cursor.currentSelection=menu.selections[
            otherSelection[menu.cursor.currentSelection.name]
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
                menu.applyPendingValues()
            end
            if Controls.releasedInputs.btnRight then 
                menu.resetPendingDisplayValues()
                TitleScreenState:goto('settingsMenu')                
                TitleScreenState.sfx.cursorDecline:play()
            end 
            if Controls.pressedInputs.dirUp or Controls.pressedInputs.dirDown then 
                menu.cursor.getOtherSelection()
                TitleScreenState.sfx.cursorMove:play()
            end
            if Controls.pressedInputs.dirRight then 
                menu.cursor.currentSelection.shiftRight()
            end
            if Controls.pressedInputs.dirLeft then 
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

            if menu.pendingDisplayValues.isFullscreen==false then 
                love.graphics.printf('Windowed',menu.xPos,menu.yPos+48,84,'center')
            elseif menu.pendingDisplayValues.isFullscreen==true then 
                love.graphics.printf('Fullscreen',menu.xPos,menu.yPos+48,84,'center')
            end
            
            love.graphics.printf(
                menu.pendingDisplayValues.width ..'x'.. menu.pendingDisplayValues.height,
                menu.xPos,menu.yPos+86,84,'center'
            )
        cam:detach()
    end 

    return menu
end

TitleScreenState.createAudioSettingsMenu=function()
    local menu={}

    menu.xPos,menu.yPos=cam.x-42,cam.y-50

    menu.sprites={
        selections=love.graphics.newImage("assets/menus/title_screen/selections_audio_menu.png"),
        cursor=love.graphics.newImage("assets/menus/title_screen/cursor_audio_menu.png")
    }

    menu.resetPendingAudioValues=function()
        menu.pendingAudioValues={
            sound=Settings.currentSettings.audio.sound,
            music=Settings.currentSettings.audio.music,
        }
    end
    menu.resetPendingAudioValues()

    --applies audio settings to game. Must restart in order to initialize
    --everything to have the correct audio volumes
    menu.applyPendingValues=function()
        Settings.currentSettings.audio.sound=menu.pendingAudioValues.sound
        Settings.currentSettings.audio.music=menu.pendingAudioValues.music
        Settings:applyCurrentSettings()
        love.load({keepSettings=true})
    end

    menu.selections={}
    menu.selections.sound={
        name='sound',
        xPos=menu.xPos, yPos=menu.yPos,
        shiftLeft=function() --decrease sound volume
            if menu.pendingAudioValues.sound<=0 then 
                TitleScreenState.sfx.cursorDecline:play()
            else 
                TitleScreenState.sfx.cursorAccept:play()
            end
            menu.pendingAudioValues.sound=math.max(
                menu.pendingAudioValues.sound-10,0
            )
        end,
        shiftRight=function() --increase sound volume
            if menu.pendingAudioValues.sound>=100 then 
                TitleScreenState.sfx.cursorDecline:play()
            else 
                TitleScreenState.sfx.cursorAccept:play()
            end
            menu.pendingAudioValues.sound=math.min(
                menu.pendingAudioValues.sound+10,100
            )            
        end,
    }
    menu.selections.music={
        name='music',
        xPos=menu.xPos, yPos=menu.selections.sound.yPos+38,
        shiftLeft=function() --decrease music volume
            if menu.pendingAudioValues.music<=0 then 
                TitleScreenState.sfx.cursorDecline:play()
            else 
                TitleScreenState.sfx.cursorAccept:play()
            end
            menu.pendingAudioValues.music=math.max(
                menu.pendingAudioValues.music-10,0
            )
        end,
        shiftRight=function() --increase music volume
            if menu.pendingAudioValues.music>=100 then 
                TitleScreenState.sfx.cursorDecline:play()
            else 
                TitleScreenState.sfx.cursorAccept:play()
            end
            menu.pendingAudioValues.music=math.min(
                menu.pendingAudioValues.music+10,100
            )    
        end,
    }

    menu.cursor={xPos=0,yPos=0}
    menu.cursor.currentSelection=menu.selections.sound
    menu.cursor.switchSelection=function()
        local otherSelection={
            sound='music',
            music='sound'
        }
        menu.cursor.currentSelection=menu.selections[
            otherSelection[menu.cursor.currentSelection.name]
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
                menu.applyPendingValues()
                TitleScreenState.sfx.cursorAccept:play()
            end
            if Controls.releasedInputs.btnRight then 
                menu.resetPendingAudioValues()
                TitleScreenState:goto('settingsMenu')                
                TitleScreenState.sfx.cursorDecline:play()
            end 
            if Controls.pressedInputs.dirUp or Controls.pressedInputs.dirDown then 
                menu.cursor.switchSelection()
                TitleScreenState.sfx.cursorMove:play()
            end
            if Controls.pressedInputs.dirRight then 
                menu.cursor.currentSelection.shiftRight()
            end
            if Controls.pressedInputs.dirLeft then 
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

            love.graphics.printf(
                menu.pendingAudioValues.sound,menu.xPos,menu.yPos+48,84,'center'
            )
            love.graphics.printf(
                menu.pendingAudioValues.music,menu.xPos,menu.yPos+86,84,'center'
            )
            cam:detach()
    end 

    return menu
end
