require 'timerState'
require 'playState'
require 'entities'
require 'player'
require 'walls'
require 'enemies'
require 'resourceNodes'
require 'items'
require 'shadows'
require 'hud'

function love.load()
    --set pixelated look
    love.graphics.setDefaultFilter('nearest','nearest')
    
    --libraries
    wf=require 'libraries/windfield'
    anim8=require 'libraries/anim8'
    sti=require 'libraries/sti'
    camera=require 'libraries/camera'

    dt=0 --delta time global
    framerate=60 --60fps global var
    windowScaleX=love.graphics.getWidth()/400 --1x scale per 400px width
    windowScaleY=love.graphics.getHeight()/300 --1x scale per 300px width
    gameStates={} --state stack
    acceptInput=false --flag to restrict inputs to one state at a time

    --releasedKey stores keys released from love.keyreleased callback
    --releasedKeyPrev stores the released key from the last frame
    --these are used to enable button pressing and holding functionality
    --while defining behavior in appropriate class/object instead of in callback
    releasedKey,releasedKeyPrev="",""

    table.insert(gameStates,TimerState) --timer state is always first on gamestates stack

    --Initial game state 
    table.insert(gameStates,PlayState) --only allow input to be accepted in gamestates[2]

    --Initialize all states in gamestates
    for i,state in pairs(gameStates) do state:load() end
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
end

function love.draw()
    for i,state in pairs(gameStates) do state:draw() end 
    --Debug-----------------------------------------
    --love.graphics.print(#gameStates,1000,0)
    --for i,timer in pairs(TimerState.timers) do
    --    love.graphics.print(timer.t,0,i*10)
    --end
    --Debug-----------------------------------------
end

function love.keyreleased(_key) releasedKey=_key end 