PlayState={}

function PlayState:load()
    gameMap=sti('assets/maps/testMap.lua')
    cam=camera()
    cam:zoom(3) --1x zoom for every 400px width / 300px height

    world=wf.newWorld() --initialize physics world which handles colliders

    Walls:load() --create colliders for all walls in map
    ResourceNodes:load() --initialize resourceNodes class
    Enemies:load() --initialize enemies class
    Player:load() --initialize player character

    --Testing enemies------------------
    Enemies:add_orc_t1(350,170)
    Enemies:add_demon_t1(400,170)
    Enemies:add_skeleton_t1(450,170)
    Enemies:add_orc_t2(350,120)
    Enemies:add_demon_t2(400,120)
    Enemies:add_mage_t2(450,120)
    Enemies:add_orc_t3(375,70)
    Enemies:add_demon_t3(435,70)
    --Testing enemies------------------

    --Testing resource nodes-----------
    ResourceNodes:add_tree(580,80)
    ResourceNodes:add_rock(640,75)
    ResourceNodes:add_vine(700,16)
    ResourceNodes:add_fungi(600,130)
    ResourceNodes:add_fishing_hole(710,135)
    --Testing resource nodes-----------
end

function PlayState:update()

    world:update(dt) --update physics colliders

    ResourceNodes:update() --update resource nodes
    Enemies:update() --update enemies
    Player:update() --update player

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
        world:draw() --draws all physics colliders
        ResourceNodes:draw()
        Enemies:draw()
        Player:draw()
        gameMap:drawLayer(gameMap.layers['Foreground'])
    cam:detach()

    --debug---------------
    love.graphics.print(Player.xPos,10,0)
    love.graphics.print(Player.yPos,10,10)    
    love.graphics.print(#Enemies.enemiesTable,0,520)
    --debug---------------
end
