PlayState={}

function PlayState:load()
    gameMap=sti('assets/maps/testMap.lua')
    cam=camera()
    cam:zoom(3) --1x zoom for every 400px width / 300px height

    world=wf.newWorld() --initialize physics world which handles colliders

    Walls:load() --create colliders for all walls in map
    Player:load() --initialize player character
    Enemies:load() --initialize enemies class

    --Testing enemies------------------
    Enemies:add_orc_t1(150,150)
    Enemies:add_demon_t1(200,150)
    Enemies:add_skeleton_t1(250,150)
    Enemies:add_orc_t2(300,150)
    Enemies:add_demon_t2(350,150)
    Enemies:add_mage_t2(400,150)
    Enemies:add_orc_t3(450,150)
    Enemies:add_demon_t3(500,150)
    --Testing enemies------------------
end

function PlayState:update()

    world:update(dt) --update physics colliders
    Player:update() --update player
    Enemies:update() --update enemies

    cam:lookAt(Player.xPos,Player.yPos)

    --For testing----------------------
    if acceptInput then 
        if love.keyboard.isDown("escape") then love.event.quit() end --easy close for devs.
    end
    --For testing----------------------

    return true --IMPORTANT! return true to remain on statestack
end

--Draw state associated with playState
function PlayState:draw()
    cam:attach()
        gameMap:drawLayer(gameMap.layers['Ground'])
        gameMap:drawLayer(gameMap.layers['Walls'])
        --world:draw() --draws all physics colliders
        Enemies:draw()
        Player:draw()
        gameMap:drawLayer(gameMap.layers['Foreground'])
    cam:detach()

    --debug---------------
    --love.graphics.print(#Enemies.enemiesTable,10,10)
    --debug---------------
end
