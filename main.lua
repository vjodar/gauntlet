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
require 'pauseMenu'
require 'tutorialState'

function love.load(_args)
    --set pixelated look
    love.graphics.setDefaultFilter('nearest','nearest')

    Controls=require 'controls'  

    --read and store settings file. If none exist or if the settings file was
    --modified in a way that makes it invalid, setting file will be set to 
    --default values. See safeStorage.lua
    --unless love.load caller specifies that settings should be kept, apply.
    Settings=require 'settings'
    if not _args.keepSettings then Settings:applyCurrentSettings() end
    
    --libraries
    wf=require 'libraries/windfield'
    anim8=require 'libraries/anim8'
    camera=require 'libraries/camera'
    
    dt=0 --delta time global
    gameStates={} --state stack
    acceptInput=false --flag to restrict inputs to one state at a time

    --color and alpha of screen used for fading in and out
    black=2/15
    transitionScreenAlpha=1

    --Initialize all states in gamestates that need loading
    Sounds:load()
    TimerState:load()
    TutorialState:load()
    FadeState:load()
    PlayerTransitionState:load()
    PlayState:load()
    TitleScreenState:load()
    CraftingMenuState:load()
    PauseMenuState:load()

    table.insert(gameStates,TimerState) --timer state is always first on gamestates stack
    table.insert(gameStates,PlayState)
    table.insert(gameStates,TitleScreenState)
end

function love.update(_dt)
    dt=_dt --update delta time

    Controls:readInput() --read user input

    for i,state in pairs(gameStates) do
        --input should only be accepted by gamestate on top of stack (last in table)
        acceptInput=(i==#gameStates)
        --run each state in gameStates, remove any that return false
        if not state:update()==true then table.remove(gameStates,i) end 
    end
end

function love.draw()
    for i,state in pairs(gameStates) do state:draw() end 
    -- love.graphics.print(#Entities.entitiesTable,0,0,nil,3)
end

--draw transition screen for fading in and out (alpha is controlled by FadeState)
function drawTransitionScreen()
    cam:attach()
        love.graphics.setColor(black,black,black,transitionScreenAlpha)
        love.graphics.rectangle(
            'fill',cam.x-(WINDOW_WIDTH*0.5),cam.y-(WINDOW_HEIGHT*0.5),
            WINDOW_WIDTH,WINDOW_HEIGHT
        )
        love.graphics.setColor(1,1,1,1)
    cam:detach()
end

--closes the game.
function closeGame()   
    love.event.quit()
    -- love.load({keepSettings=true}) --WEB VERSION
end
