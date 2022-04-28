PlayState={}

function PlayState:load()
    love.graphics.setBackgroundColor(2/15,2/15,2/15)    
    love.graphics.setFont( --set the font
        love.graphics.newImageFont(
            "assets/fonts/myFont.png",
            " abcdefghijklmnopqrstuvwxyz" ..
            "ABCDEFGHIJKLMNOPQRSTUVWXYZ" ..
            "1234567890.!,'+"
        )
    )

    cam=camera()
    camSmoother=cam.smooth.damped(10)
    camTarget={} --camera will look at this object's position
    --1x zoom for every 400px width and 300px height
    cam:zoomTo((WINDOWSCALE_X*0.5)+(WINDOWSCALE_Y*0.5))

    world=wf.newWorld() --initialize physics world which handles colliders
    world:addCollisionClass('player')
    world:addCollisionClass('enemy')
    world:addCollisionClass('resourceNode')
    world:addCollisionClass('depletedNode')
    world:addCollisionClass('craftingNode')
    world:addCollisionClass('doorButton')
    world:addCollisionClass('doorButtonActivated')
    world:addCollisionClass('item', {ignores={'player'}})
    world:addCollisionClass('doorBarrier')
    world:addCollisionClass('ladder')
    world:addCollisionClass('innerWall') --small walls within rooms
    world:addCollisionClass('outerWall') --big walls that create the rooms

    Shadows:load() --initialize shadows
    Entities:load() --initialize table of entities
    ProtectionMagics:load() --initialize protectionMagics
    Player:load() --initialize player character
    Enemies:load() --initialize enemies
    ResourceNodes:load() --initialize resource nodes
    CraftingNodes:load() --initialize crafting nodes
    Dungeon:load() --initialize dungeon
    Items:load() --initialize items
    Projectiles:load() --initialize projectiles
    Hud:load() --initialize Heads Up Display

    self:start()
end

function PlayState:update()

    world:update(dt) --update physics colliders
    Dungeon:update() --update dungeon
    Entities:update() --update all entities

    cam:lockPosition(camTarget.xPos,camTarget.yPos,camSmoother) --update camera

    Hud:update() --update Heads Up Display

    return true --IMPORTANT! return true to remain on statestack
end

--Draw state associated with playState
function PlayState:draw()
    cam:attach()
        Dungeon:draw() --draw the dungeon's rooms
        -- world:draw() --draws all physics colliders
        Entities:draw() --draw all entities in order of their yPos value
        Dungeon:drawForeground() --draw room's foreground features 
        UI:draw() --draw ui elements
    cam:detach()
    
    Hud:draw() --draw hud 
end

--start the playstate
function PlayState:start()
    --move the player to the starting room
    local playerStartX=Dungeon.startRoom[1]*Rooms.ROOMWIDTH+love.math.random(64,256)
    local playerStartY=Dungeon.startRoom[2]*Rooms.ROOMHEIGHT+love.math.random(80,184)
    Player.collider:setPosition(playerStartX,playerStartY)

    --set camera target to be the player's position
    cam:lookAt(playerStartX,playerStartY)
    camTarget=Player

    --testing----------------------------------
    world:setQueryDebugDrawing(true) --draws collider queries for 10 frames
    print('spawning enemy')
    -- Enemies.enemySpawner.t1[1](playerStartX,playerStartY)
    -- Enemies.enemySpawner.t1[2](playerStartX,playerStartY)
    -- Enemies.enemySpawner.t1[3](playerStartX,playerStartY)
    -- Enemies.enemySpawner.t2[1](playerStartX,playerStartY)
    -- Enemies.enemySpawner.t2[2](playerStartX,playerStartY)
    -- Enemies.enemySpawner.t2[3](playerStartX,playerStartY)
    -- Enemies.enemySpawner.t3[1](playerStartX,playerStartY)
    -- Enemies.enemySpawner.t3[2](playerStartX,playerStartY)

    -- Items:spawn_item(playerStartX,playerStartY,'weapon_staff_t3')
    -- Items:spawn_item(playerStartX,playerStartY,'weapon_bow_t1')
    -- Items:spawn_item(playerStartX,playerStartY,'armor_head_t2')
    -- Items:spawn_item(playerStartX,playerStartY,'armor_chest_t2')
    -- Items:spawn_item(playerStartX,playerStartY,'armor_legs_t2')
    -- Items:spawn_item(playerStartX,playerStartY,'arcane_orb')
    -- Items:spawn_item(playerStartX,playerStartY,'arcane_bowstring')
    -- Items:spawn_item(playerStartX,playerStartY,'fish_cooked')
    -- Items:spawn_item(playerStartX,playerStartY,'potion')
    -- Items:spawn_item(playerStartX,playerStartY,'fungi_mushroom')
    -- Items:spawn_item(playerStartX,playerStartY,'fungi_mushroom')
    -- for i=1,10 do Items:spawn_item(playerStartX,playerStartY,'arcane_shards') end
    --testing----------------------------------
end
