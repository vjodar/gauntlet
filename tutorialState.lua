TutorialState={}

function TutorialState:load()
    self.icons={
        wasd=love.graphics.newImage('assets/menus/tutorial/wasd.png'),
        leftArrow=love.graphics.newImage('assets/menus/tutorial/leftArrow.png'),
        rightArrow=love.graphics.newImage('assets/menus/tutorial/rightArrow.png'),
        upArrow=love.graphics.newImage('assets/menus/tutorial/upArrow.png'),
        downArrow=love.graphics.newImage('assets/menus/tutorial/downArrow.png'),
    }

    self.room={
        xPos=0,yPos=0,
        sprites={
            floor=love.graphics.newImage('assets/maps/room_floor.png'),
            bg=love.graphics.newImage('assets/maps/room_tutorial.png'),
            fg=love.graphics.newImage('assets/maps/room_tutorial_foreground.png'),
        },
        outerWalls=nil,
    }
    self.room.drawBackground=function(_room)
        love.graphics.draw(_room.sprites.floor,_room.xPos,_room.yPos)
        love.graphics.draw(_room.sprites.bg,_room.xPos,_room.yPos)
    end
    self.room.drawForeground=function(_room)
        love.graphics.draw(_room.sprites.fg,_room.xPos,_room.yPos)
    end

    self.objectives={
        t1={
            movement={
                text="Reach the bottom right side of the room.",
                color='gray', --green when complete
                complete=false,
            },
        }
    }

    self.sfx={
        completion=Sounds.objective_complete()
    }

    self._upd=nil 
    self._drw=nil 
end 

--update and draw state machine
function TutorialState:update() return self:_upd() end 
function TutorialState:draw() self:_drw() drawTransitionScreen() end 

--creates the outer walls of the tutorial room
function TutorialState:createOuterWalls(_room)
    local x,y=_room.xPos,_room.yPos
    local walls={}

    walls.left=world:newRectangleCollider(x,y,36,320)
    walls.right=world:newRectangleCollider(x+347,y,36,320)
    walls.top=world:newRectangleCollider(x+37,y,310,48)
    walls.bottom=world:newRectangleCollider(x+37,y+298,310,22)

    --make them static colliders and set their collision class
    for _,w in pairs(walls) do w:setType('static') w:setCollisionClass('outerWall') end

    return walls
end

--creates the inner walls for the Movement Tutorial
function TutorialState:createT1InnerWalls(_room)   
    Walls:newWall(_room.xPos+127,16+_room.yPos+33,'vertical',212)
    Walls:newWall(_room.xPos+255,16+_room.yPos+61,'vertical',244)
    Walls:newWall(_room.xPos+127,16+_room.yPos+229,'horizontal',96)
    Walls:newWall(_room.xPos+160,16+_room.yPos+61,'horizontal',96)
end

--Tutorial #1: Movement
function TutorialState:startT1()
    table.insert(gameStates,self)

    self.room.outerWalls=self:createOuterWalls(self.room)
    TimerState:after(0.1,function()
        self.room.innerWalls=self:createT1InnerWalls(self.room)
    end)

    self._upd=self.updateT1
    self._drw=self.drawT1    

    --move player to topleft corner of room and attach cam
    Player.collider:setPosition(self.room.xPos+64,self.room.yPos+64)
    camTarget=Player
end

function TutorialState:updateT1()
    world:update(dt) --update physics colliders
    Dungeon:update() --update dungeon
    Entities:update() --update all entities

    cam:lockPosition(camTarget.xPos,camTarget.yPos,camSmoother) --update camera

    if acceptInput and Controls.releasedInputs.btnSelect then PauseMenuState:open() end

    self:checkObjectivesT1()

    return true
end

function TutorialState:drawT1()
    cam:attach()

    self.room:drawBackground() --draw floor and bg walls
    Entities:draw() --draw all entities
    UI:draw() --draw ui elements
    self.room:drawForeground() --draw foreground walls

    love.graphics.printf(
        "Movement: use              to move around",
        self.room.xPos,self.room.yPos,400,'center'
    )
    love.graphics.draw(self.icons.wasd,self.room.xPos+173,self.room.yPos-19)

    love.graphics.printf(
        self.objectives.t1.movement.text,
        fonts[self.objectives.t1.movement.color],
        self.room.xPos,self.room.yPos+276,400,'center'
    )

    cam:detach()
end

function TutorialState:checkObjectivesT1()
    if self.objectives.t1.movement.complete==false then 
        if Player.xPos>=266 and Player.yPos>=190 then --movement objective
            self.objectives.t1.movement.color='green'
            self.objectives.t1.movement.complete=true 
            self.sfx.completion:play()
        end
    end 

    if self.objectives.t1.movement.complete then 
        --move to Tutorial #2
        local afterFn=function()
            Entities:removeAll() --clear entitiesTable
            self:startT2()
        end
        TimerState:after(0.5,function()
            FadeState:fadeOut(1,afterFn)
        end)
        self.checkObjectivesT1=function() end --stop checking objectives
    end
end

function TutorialState:startT2()
    self._upd=self.updateT2
    self._drw=self.drawT2

    Player.collider:setPosition(self.room.xPos+64,self.room.yPos+64)

    --0.2s after fading out, fade in and drop player into room
    TimerState:after(0.2,function()
        FadeState:fadeIn()
        PlayerTransitionState:enterRoom(Player)
    end)
end

function TutorialState:updateT2()
    world:update(dt) --update physics colliders
    Dungeon:update() --update dungeon
    Entities:update() --update all entities

    cam:lockPosition(camTarget.xPos,camTarget.yPos,camSmoother) --update camera

    if acceptInput and Controls.releasedInputs.btnSelect then PauseMenuState:open() end

    self:checkObjectivesT2()

    return true
end

function TutorialState:drawT2()
    cam:attach()

    self.room:drawBackground() --draw floor and bg walls
    Entities:draw() --draw all entities
    UI:draw() --draw ui elements
    self.room:drawForeground() --draw foreground walls

    love.graphics.printf(
        "Hold     near an object to interact with it.",
        self.room.xPos,self.room.yPos-20,400,'center'
    )
    love.graphics.printf(
        "Notice the      .",
        self.room.xPos,self.room.yPos,400,'center'
    )
    love.graphics.draw(self.icons.downArrow,self.room.xPos+100,self.room.yPos-15)
    love.graphics.draw(self.icons.downArrow,self.room.xPos+170,self.room.yPos-5)

    -- love.graphics.printf(
    --     self.objectives.t1.movement.text,
    --     fonts[self.objectives.t1.movement.color],
    --     self.room.xPos,self.room.yPos+276,400,'center'
    -- )

    cam:detach()
end

function TutorialState:checkObjectivesT2()

end
