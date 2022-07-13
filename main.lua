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

function love.load()
    --set pixelated look
    love.graphics.setDefaultFilter('nearest','nearest')

    --Commenting out for current, primary build (for web). Will create secondary
    --branches for binaries (Windows/Max/Linux) which will have the ability to 
    --change resolution. 
    -- --set display resolution to be as large as possible while still fitting
    -- --in the users monitor, in 4x3 aspect ratio, and in windowed mode
    -- local desktopW,desktopH=love.window.getDesktopDimensions()
    -- local nearestHeight=math.floor(desktopH/300)*300
    -- local nearestWidth=nearestHeight*(4/3)
    -- changeDisplaySettings(nearestWidth,nearestHeight,false)
    
    --resizing and rescaling game to match new display settings.
    WINDOW_WIDTH=love.graphics.getWidth()
    WINDOW_HEIGHT=love.graphics.getHeight()
    WINDOWSCALE_X=WINDOW_WIDTH/400 --1x scale per 400px width
    WINDOWSCALE_Y=WINDOW_HEIGHT/300 --1x scale per 300px width
    
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
    TitleScreenState:load()
    PlayerTransitionState:load()
    PlayState:load()
    CraftingMenuState:load()

    table.insert(gameStates,TimerState) --timer state is always first on gamestates stack
    table.insert(gameStates,PlayState)
    table.insert(gameStates,TitleScreenState)
end

function love.update(_dt)
    dt=_dt --update delta time

    Controls:update()

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
function changeDisplaySettings(_w,_h,_isFullscreen)
    local _,_,flags=love.window.getMode() --gets the index of current monitor
    love.window.setMode(
        math.max(_w,400),math.max(_h,300), --resolution can't be lower than 400x300
        {
            display=flags.display,
            fullscreen=_isFullscreen,
            fullscreentype='exclusive',
        }
    )
    
    --resizing and rescaling game to match new display settings.
    WINDOW_WIDTH=love.graphics.getWidth()
    WINDOW_HEIGHT=love.graphics.getHeight()
    WINDOWSCALE_X=WINDOW_WIDTH/400 --1x scale per 400px width
    WINDOWSCALE_Y=WINDOW_HEIGHT/300 --1x scale per 300px width
    if cam~=nil then cam:zoomTo((WINDOWSCALE_X*0.5)+(WINDOWSCALE_Y*0.5)) end
end