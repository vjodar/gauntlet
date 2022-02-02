require 'timerState'
require 'playState'
require 'entities'
require 'player'
require 'walls'
require 'enemies'
require 'resourceNodes'
require 'items'
require 'shadows'

function love.load()
    --set pixelated look
    love.graphics.setDefaultFilter('nearest','nearest')
    
    --libraries
    wf=require 'libraries/windfield'
    anim8=require 'libraries/anim8'
    sti=require 'libraries/sti'
    camera=require 'libraries/camera'

    dt=0 --delta time global
    gameStates={} --state stack
    acceptInput=false --flag to restrict inputs to one state at a time

    table.insert(gameStates,TimerState) --timer state is always first on gamestates stack

    --Initial game state 
    table.insert(gameStates,PlayState) --only allow input to be accepted in gamestates[2]

    --Initialize all states in gamestates
    for i,state in pairs(gameStates) do state:load() end
end

function love.update(_dt)
    dt=_dt --update delta time
    for i,state in pairs(gameStates) do
        acceptInput=(i==2) --input will only be accepted for state in gameStates[2]
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