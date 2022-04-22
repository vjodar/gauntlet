require 'timerState'
require 'playState'
require 'camPanState'
require 'craftingMenuState'
require 'entities'
require 'player'
require 'dungeon'
require 'enemies'
require 'resourceNodes'
require 'craftingNodes'
require 'items'
require 'shadows'
require 'projectiles'
require 'hud'
require 'dialog'
require 'protectionMagics'
require 'ui'

function love.load()
    --set pixelated look
    love.graphics.setDefaultFilter('nearest','nearest')
    
    --libraries
    wf=require 'libraries/windfield'
    anim8=require 'libraries/anim8'
    camera=require 'libraries/camera'

    dt=0 --delta time global
    WINDOWSCALE_X=love.graphics.getWidth()/400 --1x scale per 400px width
    WINDOWSCALE_Y=love.graphics.getHeight()/300 --1x scale per 300px width
    gameStates={} --state stack
    acceptInput=false --flag to restrict inputs to one state at a time

    --releasedKey stores keys released from love.keyreleased callback
    --releasedKeyPrev stores the released key from the last frame
    --these are used to enable button pressing and holding functionality
    --while defining behavior in appropriate class/object instead of in callback
    releasedKey,releasedKeyPrev="",""

    --global table of controls. Defaults to keyboard control values
    controls={ 
        --directions
        dirUp='w',
        dirDown='s',
        dirLeft='a',
        dirRight='d',
        --buttons
        btnUp='kp8',
        btnDown='kp5',
        btnLeft='kp4',
        btnRight='kp6',
        btnStart='space'
    }

    table.insert(gameStates,TimerState) --timer state is always first on gamestates stack

    --Initial game state 
    table.insert(gameStates,PlayState)

    --Initialize all states in gamestates that need loading
    TimerState:load()
    PlayState:load()
    CraftingMenuState:load()
end

function love.update(_dt)
    dt=_dt --update delta time
    --releasedKey only stores released keys for 1 frame
    if releasedKey==releasedKeyPrev then releasedKey="" end
    releasedKeyPrev=releasedKey --update releasedKeyPrev

    for i,state in pairs(gameStates) do
        --input should only be accepted by gamestate on top of stack (last in table)
        acceptInput=(i==#gameStates)
        --run each state in gameStates, remove any that return false
        if not state:update()==true then table.remove(gameStates,i) end 
    end

    --For testing----------------------
    
    if releasedKey=='escape' then love.event.quit() end --easy close for devs.
    if releasedKey=='backspace' then love.load() end --easy restart for devs.
    
    --For testing----------------------
end

function love.draw()
    for i,state in pairs(gameStates) do state:draw() end 
end

function love.keyreleased(_key) releasedKey=_key end 