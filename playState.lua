PlayState={}

function PlayState:load()
    love.graphics.setBackgroundColor(2/15,2/15,2/15)
    local glyphs=( --used for fonts
        " abcdefghijklmnopqrstuvwxyz" ..
        "ABCDEFGHIJKLMNOPQRSTUVWXYZ" ..
        "1234567890.:!,'+"
    )
    fonts={
        yellow=love.graphics.newImageFont("assets/fonts/font_yellow.png",glyphs), --default/dialog
        gray=love.graphics.newImageFont("assets/fonts/font_gray.png",glyphs), --physical damage
        blue=love.graphics.newImageFont("assets/fonts/font_blue.png",glyphs), --magical damage
        red=love.graphics.newImageFont("assets/fonts/font_red.png",glyphs), --pure damage
    }
    love.graphics.setFont(fonts.yellow)

    cam=camera()
    camSmoother=cam.smooth.damped(10)
    camTarget={} --camera will look at this object's position
    --1x zoom for every 400px width and 300px height
    cam:zoomTo((WINDOWSCALE_X*0.5)+(WINDOWSCALE_Y*0.5))

    --color and alpha of screen used for fading in and out
    black=2/15
    transitionScreenAlpha=1

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
    world:addCollisionClass('tornado',
        {ignores={'tornado','player','enemy','resourceNode','depletedNode'}}
    )
    world:addCollisionClass(
        'flame',{ignores={'flame','tornado','player','enemy','item'}}
    )
    world:addCollisionClass('lava') --boss room lava

    Shadows:load() --initialize shadows
    Entities:load() --initialize table of entities
    ProtectionMagics:load() --initialize protectionMagics
    Player:load() --initialize player character
    Enemies:load() --initialize enemies
    SpecialAttacks:load() --initialize demiboss' special attacks
    ResourceNodes:load() --initialize resource nodes
    CraftingNodes:load() --initialize crafting nodes
    Dungeon:load() --initialize dungeon
    Items:load() --initialize items
    Projectiles:load() --initialize projectiles
    Hud:load() --initialize Heads Up Display
    BossRoom:load() --initialize boss room

    self:startDungeonPhase()
end

--update and draw functions. They will be changed depending on which part of
--the game the player is currently on (starting room, dungeon, and boss battle)
function PlayState:update() return self:_update() end
function PlayState:draw() self:_draw() self:drawTransitionScreen() end

--draw transition screen (alpha is controlled by FadeState)
function PlayState:drawTransitionScreen()
    cam:attach()
        love.graphics.setColor(black,black,black,transitionScreenAlpha)
        love.graphics.rectangle(
            'fill',cam.x-(WINDOW_WIDTH*0.5),cam.y-(WINDOW_HEIGHT*0.5),
            WINDOW_WIDTH,WINDOW_HEIGHT
        )
        love.graphics.setColor(1,1,1,1)
    cam:detach()
end

function PlayState:updateDungeonPhase() --update function of gathering/crafting phase
    world:update(dt) --update physics colliders
    Dungeon:update() --update dungeon
    Entities:update() --update all entities

    cam:lockPosition(camTarget.xPos,camTarget.yPos,camSmoother) --update camera

    Hud:update() --update Heads Up Display

    return true --IMPORTANT! return true to remain on statestack
end

function PlayState:drawDungeonPhase() --draw funtion of the gathering/crafting phase
    cam:attach()
        Dungeon:drawFloorObjects() --draw objects on floor, beneath entities
        Dungeon:drawRooms() --draw the dungeon's rooms
        -- world:draw() --draws all physics colliders
        Entities:draw() --draw all entities in order of their yPos value
        Dungeon:drawForeground() --draw room's foreground features 
        UI:draw() --draw ui elements
    cam:detach()
    
    Hud:draw() --draw hud 

    --testing--------------------------
    -- love.graphics.print(love.timer:getFPS(),0,0,nil,6)
    -- love.graphics.print(#TimerState.timers,0,30,nil,3)
    --testing--------------------------
end

function PlayState:updateBossBattle()
    world:update(dt) --update physics
    BossRoom:update() --update boss room
    Entities:update() --update all entities
    cam:lockPosition(camTarget.xPos,camTarget.yPos,camSmoother) --update camera
    Hud:update() --update HUD
    
    return true --return true to remain on state stack
end

function PlayState:drawBossBattle()
    cam:attach()
        BossRoom:draw() 
        -- world:draw() --draws colliders
        Entities:draw() --draw all entities, sorted by yPos
        UI:draw() --draw ui elements (dialog,healthbars,etc.)
    cam:detach()
    Hud:draw() --draw HUD outside camera

    -- --testing--------------------------
    -- love.graphics.print(love.timer:getFPS(),0,0,nil,6)
    -- love.graphics.print(#TimerState.timers,0,40,nil,6)
    -- --testing--------------------------
end

function PlayState:startDungeonPhase()
    --set associated update and draw functions
    self._update=self.updateDungeonPhase
    self._draw=self.drawDungeonPhase

    --move the player to the starting room
    local playerStartX=Dungeon.startRoom[1]*Rooms.ROOMWIDTH+love.math.random(64,256)
    local playerStartY=Dungeon.startRoom[2]*Rooms.ROOMHEIGHT+love.math.random(80,184)
    Player.collider:setPosition(playerStartX,playerStartY)

    --set camera target to be the player's position
    cam:lookAt(playerStartX,playerStartY) 
    camTarget=Player

    --fade in, start clock after fade in complete
    local afterFn=function() Clock:start() end 
    FadeState:fadeIn()
    PlayerTransitionState:enterRoom(Player,afterFn)


    --testing----------------------------------
    world:setQueryDebugDrawing(true) --draws collider queries for 10 frames
    local function randomPoints()
        return Dungeon.startRoom[1]*Rooms.ROOMWIDTH+love.math.random(64,256),
        Dungeon.startRoom[2]*Rooms.ROOMHEIGHT+love.math.random(80,184)
    end

    -- TimerState:after(3,function() self:startBossBattle() end)
    -- TimerState:after(3,function() Player.state.falling=true end)

    -- SpecialAttacks:spawnFissure(randomPoints(),randomPoints(),Player)
    -- SpecialAttacks:spawnFireCircle(randomPoints())
    -- SpecialAttacks:launchFireball(randomPoints(),randomPoints(),Player)
    -- SpecialAttacks:spawnTornado(playerStartX,playerStartY+50,0)
    -- SpecialAttacks:spawnFlamePillar(playerStartX,playerStartY+30,love.math.random()*2*math.pi-math.pi)
    -- Enemies.enemySpawner.t1[1](randomPoints())
    -- Enemies.enemySpawner.t1[2](randomPoints())
    -- Enemies.enemySpawner.t1[3](randomPoints())
    -- Enemies.enemySpawner.t2[1](randomPoints())
    -- Enemies.enemySpawner.t2[2](randomPoints())
    -- Enemies.enemySpawner.t2[3](randomPoints())
    -- Enemies.enemySpawner.t3[1](randomPoints())
    -- Enemies.enemySpawner.t3[2](randomPoints())

    -- Items:spawn_item(playerStartX,playerStartY,'weapon_staff_t3')
    -- Items:spawn_item(playerStartX,playerStartY,'weapon_bow_t3')
    -- Items:spawn_item(playerStartX,playerStartY,'armor_head_t3')
    -- Items:spawn_item(playerStartX,playerStartY,'armor_chest_t3')
    -- Items:spawn_item(playerStartX,playerStartY,'armor_legs_t3')
    -- for i=1,20 do 
        -- Items:spawn_item(playerStartX,playerStartY,'tree_wood')
        -- Items:spawn_item(playerStartX,playerStartY,'rock_ore')
        -- Items:spawn_item(playerStartX,playerStartY,'fish_raw')
        -- Items:spawn_item(playerStartX,playerStartY,'fish_cooked')
        -- Items:spawn_item(playerStartX,playerStartY,'potion')
        -- Items:spawn_item(playerStartX,playerStartY,'fungi_mushroom')
        -- Items:spawn_item(playerStartX,playerStartY,'arcane_shards')
    -- end
    --testing----------------------------------
end

function PlayState:startBossBattle()
    --set associated update and draw function
    self._update=self.updateBossBattle
    self._draw=self.drawBossBattle

    Clock:pause() --stop clock

    Dungeon:closeDungeon() --delete dungeon rooms and entities

    --if player has active protection magics, deactivate
    if Player.state.protectionActivated then Player.protectionMagics:deactivate() end

    --remove shapes associated with weapon and magic sprites
    Player.collider:removeShape('left')
    Player.collider:removeShape('right')
    Player.collider:removeShape('magic')
    Player:updateCurrentGear() --recalculate mass after removing shapes

    --increase the range the player can query for enemies (to accomodate larger boss room)
    Player.combatData.queryCombatRange={x=800,y=600}
    --increase the distance the player can be from enemy before disengaging combat
    Player.combatData.aggroRange={x=800,y=600} 

    --spawn boss on the next frame (must allow entitiesTable to clear)
    TimerState:after(0.001,function() Enemies.enemySpawner.t4[1](410,300) end)

    Player.collider:setPosition(424,370)
    cam:lookAt(Player.collider:getPosition())

    --Start boss AI after 2s
    local afterFn=function() 
        TimerState:after(2,function() BossRoom.boss.state.wait=false end) 
        Clock:setMode('boss') --set clock to count up 
        Clock:start()
    end
    FadeState:fadeIn(0,afterFn)
end
