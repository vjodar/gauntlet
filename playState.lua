PlayState={}

function PlayState:load()
    love.graphics.setBackgroundColor(2/15,2/15,2/15)
    cam=camera()
    --1x zoom for every 400px width and 300px height
    cam:zoom((love.graphics.getWidth()/800)+(love.graphics.getHeight()/600))

    world=wf.newWorld() --initialize physics world which handles colliders
    world:setQueryDebugDrawing(true) --draws collider queries for 10 frames
    world:addCollisionClass('player')
    world:addCollisionClass('enemy')
    world:addCollisionClass('resourceNode')
    world:addCollisionClass('depletedNode')
    world:addCollisionClass('doorButton')
    world:addCollisionClass('doorButtonActivated')

    Shadows:load() --initialize shadows
    Entities:load() --initialize table of entities
    Player:load() --initialize player character
    Dungeon:load() --initialize dungeon
    Items:load() --initialize items
    Hud:load() --initialize Heads Up Display

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
    -- ResourceNodes.nodeSpawnFunctions[5](1600,1400)
    --Testing resource nodes-----------
end

function PlayState:update()

    world:update(dt) --update physics colliders

    Dungeon:update() --update dungeon

    Entities:update() --update all entities

    cam:lookAt(Player.xPos,Player.yPos) --update camera

    Hud:update() --update Heads Up Display

    --For testing----------------------
    if acceptInput then 
        if releasedKey=='escape' then love.event.quit() end --easy close for devs.
    end
    --For testing----------------------

    return true --IMPORTANT! return true to remain on statestack
end

--Draw state associated with playState
function PlayState:draw()
    cam:attach()
        Dungeon:draw() --draw the dungeon's rooms
        world:draw() --draws all physics colliders
        Entities:draw() --draw all entities in order of their yPos value
        Dungeon:drawForeground() --draw room's foreground features (these appear in front of entities)
    cam:detach()

    Hud:draw() --draw hud outside of camera

    --debug---------------
    -- love.graphics.print(Player.xPos,10,0)
    -- love.graphics.print(Player.yPos,10,10)
    -- love.graphics.print(#Entities.entitiesTable,0,500)
    --debug---------------
end
