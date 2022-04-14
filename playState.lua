PlayState={}

function PlayState:load()
    love.graphics.setBackgroundColor(2/15,2/15,2/15)    
    love.graphics.setFont( --set the font
        love.graphics.newImageFont(
            "assets/font/myFont.png",
            " abcdefghijklmnopqrstuvwxyz" ..
            "ABCDEFGHIJKLMNOPQRSTUVWXYZ" ..
            "1234567890.,'+"
        )
    )

    cam=camera()
    camSmoother=cam.smooth.damped(10)
    camTarget={} --camera will look at this object's position
    --1x zoom for every 400px width and 300px height
    cam:zoomTo((WINDOWSCALE_X*0.5)+(WINDOWSCALE_Y*0.5))

    world=wf.newWorld() --initialize physics world which handles colliders
    world:setQueryDebugDrawing(true) --draws collider queries for 10 frames
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
    Player:load() --initialize player character
    Enemies:load() --initialize enemies
    ResourceNodes:load() --initialize resource nodes
    CraftingNodes:load()
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
    Projectiles:update() --update all projectiles

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
        Projectiles:draw() --draw all projectiles
        Dungeon:drawForeground() --draw room's foreground features (these appear in front of entities)

        Player.dialog:draw(Player.xPos,Player.yPos) --will probably move this later
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
    print('spawning enemy')
    Enemies.enemySpawner.t3[2](playerStartX,playerStartY)

    Items:spawn_item(playerStartX,playerStartY,'broken_staff')
    Items:spawn_item(playerStartX,playerStartY,'broken_bow')
    Items:spawn_item(playerStartX,playerStartY,'arcane_orb')
    Items:spawn_item(playerStartX,playerStartY,'arcane_bowstring')
    for i=1,24 do Items:spawn_item(playerStartX,playerStartY,'arcane_shards') end
    --testing----------------------------------
end
