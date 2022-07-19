require 'controls'
require 'timerState'
require 'playState'
require 'camPanState'
require 'craftingMenuState'
require 'entities'
require 'player'
require 'dungeon'
require 'enemies'
require 'specialAttacks'
require 'resourceNodes'
require 'craftingNodes'
require 'items'
require 'shadows'
require 'projectiles'
require 'hud'
require 'dialog'
require 'protectionMagics'
require 'ui'
require 'bossRoom'
require 'fadeState'
require 'playerTransitionState'
require 'endScreenState'
require 'sounds'
require 'titleScreenState'

function love.load(_args)
    --set pixelated look
    love.graphics.setDefaultFilter('nearest','nearest')
    
    --read and store settings file. If none exist or if the settings file was
    --modified in a way that makes it invalid, setting file will be set to 
    --default values. See safeStorage.lua
    --unless love.load caller specifies that settings should be kept, apply.
    SafeStorage=require 'safeStorage'
    CurrentSettings=SafeStorage.readSettings()
    if not _args.keepSettings then applyCurrentSettings() end 
    
    --libraries
    wf=require 'libraries/windfield'
    anim8=require 'libraries/anim8'
    camera=require 'libraries/camera'
    
    dt=0 --delta time global
    gameStates={} --state stack
    acceptInput=false --flag to restrict inputs to one state at a time

    --Initialize all states in gamestates that need loading
    Sounds:load()
    Controls:load()
    TimerState:load()
    FadeState:load()
    PlayerTransitionState:load()
    PlayState:load()
    TitleScreenState:load()
    CraftingMenuState:load()

    table.insert(gameStates,TimerState) --timer state is always first on gamestates stack
    table.insert(gameStates,PlayState)
    table.insert(gameStates,TitleScreenState)
end

function love.update(_dt)
    dt=_dt --update delta time

    Controls:update() --read user input

    for i,state in pairs(gameStates) do
        --input should only be accepted by gamestate on top of stack (last in table)
        acceptInput=(i==#gameStates)
        --run each state in gameStates, remove any that return false
        if not state:update()==true then table.remove(gameStates,i) end 
    end
end

function love.draw()
    for i,state in pairs(gameStates) do state:draw() end 
end

--resizes display, enters/exits fullscreen, rescales game assets appropriately
--sets volume levels for sound effects and music
--set control bindings
--all settings taken from global CurrentSettings which is read and loaded from  
--'settings' file. After settings are applied, 'settings' file is rewritten
function applyCurrentSettings()

    --DISPLAY
    local _,_,flags=love.window.getMode() --gets index of current window
    love.window.setMode(
        CurrentSettings.width,CurrentSettings.height,
        {
            display=flags.display,
            fullscreen=CurrentSettings.isFullscreen,
            fullscreentype='exclusive',
        }
    )
    
    --resizing and rescaling game to match new display settings.
    WINDOW_WIDTH=love.graphics.getWidth()
    WINDOW_HEIGHT=love.graphics.getHeight()
    WINDOWSCALE_X=WINDOW_WIDTH/400 --1x scale per 400px width
    WINDOWSCALE_Y=WINDOW_HEIGHT/300 --1x scale per 300px width
    if cam~=nil then cam:zoomTo((WINDOWSCALE_X*0.5)+(WINDOWSCALE_Y*0.5)) end
    
    --AUDIO
    Volume={ --volumes are from 0 to 1
        sound=CurrentSettings.sound*0.01,
        music=CurrentSettings.music*0.01,
    } 

    --finally save CurrentSettings to 'settings' file
    SafeStorage.writeSettings(CurrentSettings)
end

--closes the game. In the browser version, the game stops updating but displays
--the last thing drawn to screen. So display a "Thank you" to leave plays with.
function closeGame() 
    love.update=function(dt) end 
    love.draw=function() 
        love.graphics.printf(
            'Thank you for playing!',
            0-((0.5*WINDOW_WIDTH)*(WINDOWSCALE_X-1)),WINDOW_HEIGHT*0.5,
            WINDOW_WIDTH,'center',
            nil,WINDOWSCALE_X
        )    
    end        

    love.event.quit()
end
