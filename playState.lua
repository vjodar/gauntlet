PlayState={}

function PlayState:load()
    love.graphics.setBackgroundColor(2/15,2/15,2/15)
    cam=camera()
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

    Shadows:load() --initialize shadows
    Entities:load() --initialize table of entities
    Player:load() --initialize player character
    Enemies:load() --initialize enemies
    ResourceNodes:load() --initialize resource nodes
    CraftingNodes:load()
    Dungeon:load() --initialize dungeon
    Items:load() --initialize items
    Hud:load() --initialize Heads Up Display

    self:start()
end

function PlayState:update()

    world:update(dt) --update physics colliders

    Dungeon:update() --update dungeon

    Entities:update() --update all entities

    cam:lookAt(camTarget.xPos,camTarget.yPos) --update camera

    Hud:update() --update Heads Up Display

    return true --IMPORTANT! return true to remain on statestack
end

--Draw state associated with playState
function PlayState:draw()
    cam:attach()
        Dungeon:draw() --draw the dungeon's rooms
        -- world:draw() --draws all physics colliders
        Entities:draw() --draw all entities in order of their yPos value
        Dungeon:drawForeground() --draw room's foreground features (these appear in front of entities)
    cam:detach()

    Hud:draw() --draw hud outside of camera

    --testing-----------------------------------
    love.graphics.print(love.timer.getFPS(),0,0)
    love.graphics.print(#Entities.entitiesTable,0,20)
    --testing-----------------------------------
end

--start the playstate
function PlayState:start()
    --move the player to the starting room
    local playerStartX=Dungeon.startRoom[1]*Rooms.ROOMWIDTH+love.math.random(64,256)
    local playerStartY=Dungeon.startRoom[2]*Rooms.ROOMHEIGHT+love.math.random(80,184)
    Player.collider:setPosition(playerStartX,playerStartY)

    --set camera target to be the player's position
    camTarget=Player

    --testing------------------------------------
    print('adding crafting resources')
    for i=1,10 do 
        Player:addToInventory('tree_planks')
        Player:addToInventory('rock_metal')
        Player:addToInventory('vine_thread')
        Player:addToInventory('fish_raw')
    end
    Player:addToInventory('broken_bow')
    Player:addToInventory('broken_staff')
    Player:addToInventory('arcane_orb')
    Player:addToInventory('arcane_bowstring')
    print('adding arcane_shards')
    for i=1,1000 do 
        Player:addToInventory('arcane_shards')
    end
    --testing------------------------------------
end
