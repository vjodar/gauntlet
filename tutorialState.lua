TutorialState={}

function TutorialState:load()
    self.sprites={
        wasd=love.graphics.newImage('assets/menus/tutorial/wasd.png'),
        leftArrow=love.graphics.newImage('assets/menus/tutorial/leftArrow.png'),
        rightArrow=love.graphics.newImage('assets/menus/tutorial/rightArrow.png'),
        upArrow=love.graphics.newImage('assets/menus/tutorial/upArrow.png'),
        downArrow=love.graphics.newImage('assets/menus/tutorial/downArrow.png'),
        interact=love.graphics.newImage('assets/menus/tutorial/interact.png'),

        text_1=love.graphics.newImage('assets/menus/tutorial/text_1.png'),
        text_2=love.graphics.newImage('assets/menus/tutorial/text_2.png'),
        text_3=love.graphics.newImage('assets/menus/tutorial/text_3.png'),
        text_4=love.graphics.newImage('assets/menus/tutorial/text_4.png'),
        text_5=love.graphics.newImage('assets/menus/tutorial/text_5.png'),
        text_6=love.graphics.newImage('assets/menus/tutorial/text_6.png'),
        text_7=love.graphics.newImage('assets/menus/tutorial/text_7.png'),
        text_8=text_7,
        text_9=love.graphics.newImage('assets/menus/tutorial/text_9.png'),
    }

    self.room={
        xPos=0,yPos=0,
        sprites={
            floor=love.graphics.newImage('assets/maps/room_tutorial_floor.png'),
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

    self.objectives={} --holds tutorial objectives
    self.resourceNodes={} --holds resources used in tutorials
    self.enemies={} --holds enemies used in tutorials

    self.sfx={
        completion=Sounds.objective_complete()
    }

    self._upd=nil 
    self._drw=nil 

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

        --set tutorial objectives
        self.objectives.t1={
            movement={
                text="Reach the bottom right corner of the room.",
                color='gray', --green when complete
                complete=false,
            },
        }
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

        --tutorial text
        love.graphics.draw(self.sprites.text_1,self.room.xPos,self.room.yPos-19)

        Entities:draw() --draw all entities
        self.room:drawForeground() --draw foreground walls
        UI:draw() --draw ui elements

        --objectives text
        love.graphics.printf(
            self.objectives.t1.movement.text,
            fonts[self.objectives.t1.movement.color],
            self.room.xPos,self.room.yPos+244,400,'center'
        )

        cam:detach()
    end

    function TutorialState:checkObjectivesT1()
        if self.objectives.t1.movement.complete==false then 
            if Player.xPos>=266 and Player.yPos>=190 then --movement objective
                self:setObjectiveComplete(self.objectives.t1.movement)
            end
        end 

        --advance to Tutorial #2
        if self.objectives.t1.movement.complete then self:endT1() end
    end

    function TutorialState:endT1()
        self.checkObjectivesT1=function()end --stop checking objectives

        self:gotoTutorial(2)
    end

    --Tutorial #2: Interaction
    function TutorialState:startT2()
        self._upd=self.updateT2
        self._drw=self.drawT2

        self:clearPlayerInventory()
        Player.collider:setPosition(self.room.xPos+64,self.room.yPos+64)
        Player.dialogLines.noEnemies={ --changing combat dialog for this tutorial
            "Nothing to interact with here!","I Need to move closer!"
        }
        
        --0.2s after fading out, fade in and drop player into room
        TimerState:after(0.2,function()
            FadeState:fadeIn()
            PlayerTransitionState:enterRoom(Player)

            --spawn tree and rock
            ResourceNodes.nodeSpawnFunctions[1](self.room.xPos+151,self.room.yPos+133)
            ResourceNodes.nodeSpawnFunctions[2](self.room.xPos+251,self.room.yPos+162)
        end)
        
        --set tutorial objectives
        self.objectives.t2={
            logs={
                text="Chop some logs from the tree.",
                color='gray', --green when complete
                complete=false,
            },
            ore={
                text="Mine some ore from the rock.",
                color='gray', --green when complete
                complete=false,
            },
        }
    end

    function TutorialState:updateT2()
        world:update(dt) --update physics colliders
        Dungeon:update() --update dungeon
        Entities:update() --update all entities

        cam:lockPosition(camTarget.xPos,camTarget.yPos,camSmoother) --update camera

        if acceptInput then 
            ActionButtons.combatInteract:update()
            if Controls.releasedInputs.btnSelect then PauseMenuState:open() end
        end

        self:checkObjectivesT2()

        return true
    end

    function TutorialState:drawT2()
        cam:attach()

        self.room:drawBackground() --draw floor and bg walls

        --tutorial text
        love.graphics.draw(self.sprites.text_2,self.room.xPos,self.room.yPos-2)

        Entities:draw() --draw all entities
        self.room:drawForeground() --draw foreground walls
        UI:draw() --draw ui elements

        --objectives text
        love.graphics.printf(
            self.objectives.t2.logs.text,
            fonts[self.objectives.t2.logs.color],
            self.room.xPos,self.room.yPos+244,400,'center'
        )
        love.graphics.printf(
            self.objectives.t2.ore.text,
            fonts[self.objectives.t2.ore.color],
            self.room.xPos,self.room.yPos+254,400,'center'
        )

        cam:detach()
        ActionButtons.combatInteract:draw()
    end

    function TutorialState:checkObjectivesT2()
        local objectivesComplete=true 

        if self.objectives.t2.logs.complete==false then 
            objectivesComplete=false 
            
            if Player.inventory.tree_wood>0 then 
                self:setObjectiveComplete(self.objectives.t2.logs)
            end
        end
        
        if self.objectives.t2.ore.complete==false then 
            objectivesComplete=false 

            if Player.inventory.rock_ore>0 then 
                self:setObjectiveComplete(self.objectives.t2.ore)
            end
        end 

        --When all objectives are complete, end current tutorial
        if objectivesComplete then self:endT2() end 
    end

    function TutorialState:endT2()
        --Stop checking objectives, Reset Player inventory, go to next tutorial
        self.checkObjectivesT2=function()end
        
        Player.dialogLines.noEnemies={
            "No enemies nearby!","Nothing to fight!","Can't see any enemies!"
        }

        self:gotoTutorial(3)
    end

    --Tutorial #3: Crafting pt.1 and Inventory
    function TutorialState:startT3()
        self._upd=self.updateT3
        self._drw=self.drawT3

        self:clearPlayerInventory()
        Player.collider:setPosition(self.room.xPos+64,self.room.yPos+64)
        Player.dialogLines.noEnemies={ --changing combat dialog for this tutorial
            "Nothing to interact with here!","I Need to move closer!"
        }
        
        --0.2s after fading out, fade in and drop player into room
        TimerState:after(0.2,function()
            FadeState:fadeIn()
            PlayerTransitionState:enterRoom(Player)

            --spawn tree, rock, vine, and fishing_hole resourceNodes
            ResourceNodes.nodeSpawnFunctions[1](self.room.xPos+86,self.room.yPos+68)
            ResourceNodes.nodeSpawnFunctions[2](self.room.xPos+152,self.room.yPos+100)
            ResourceNodes.nodeSpawnFunctions[3](self.room.xPos+218,self.room.yPos+17)
            ResourceNodes.nodeSpawnFunctions[5](self.room.xPos+280,self.room.yPos+68)

            --spawn sawmill, furnace, spinning_wheel, and grill craftingNodes
            CraftingNodes:spawnCraftingNode('sawmill',self.room.xPos+84,self.room.yPos+190)
            CraftingNodes:spawnCraftingNode('furnace',self.room.xPos+147,self.room.yPos+190)
            CraftingNodes:spawnCraftingNode('spinning_wheel',self.room.xPos+215,self.room.yPos+190)
            CraftingNodes:spawnCraftingNode('grill',self.room.xPos+282,self.room.yPos+190)
        end)
        
        --set tutorial objectives
        self.objectives.t3={                
            gather={
                preReqs={'tree_wood','rock_ore','vine_fiber','fish_raw',},
                text="Gather some Logs, Ore, Fiber, and Fish.",
                color='gray', --green when complete
                complete=false,
            },
            make={
                preReqs={'tree_planks','rock_metal','vine_thread','fish_cooked',},
                text="Make some Planks, Metal Bars, Thread, and Cooked Fish.",
                color='gray', --green when complete
                complete=false,
            },
            inventory={
                text="Open your inventory to see your items.",
                color='gray', --green when complete
                complete=false,
            }
        }
    end

    function TutorialState:updateT3()
        world:update(dt) --update physics colliders
        Dungeon:update() --update dungeon
        Entities:update() --update all entities
        Inventory:update() --update inventory

        cam:lockPosition(camTarget.xPos,camTarget.yPos,camSmoother) --update camera

        if acceptInput then 
            ActionButtons.combatInteract:update()
            if Controls.releasedInputs.btnSelect then PauseMenuState:open() end
        end

        self:checkObjectivesT3()

        return true
    end

    function TutorialState:drawT3()
        cam:attach()

        self.room:drawBackground() --draw floor and bg walls

        --tutorial text
        love.graphics.draw(self.sprites.text_3,self.room.xPos,self.room.yPos-2)

        Entities:draw() --draw all entities
        self.room:drawForeground() --draw foreground walls
        UI:draw() --draw ui elements

        --objective text
        love.graphics.printf(
            self.objectives.t3.inventory.text,
            fonts[self.objectives.t3.inventory.color],
            self.room.xPos,self.room.yPos+244,400,'center'
        )
        love.graphics.printf(
            self.objectives.t3.gather.text,
            fonts[self.objectives.t3.gather.color],
            self.room.xPos,self.room.yPos+254,400,'center'
        )
        love.graphics.printf(
            self.objectives.t3.make.text,
            fonts[self.objectives.t3.make.color],
            self.room.xPos,self.room.yPos+264,400,'center'
        )

        cam:detach()
        ActionButtons.combatInteract:draw()
        Inventory:draw()
    end

    function TutorialState:checkObjectivesT3()
        local objectivesComplete=true 

        if self.objectives.t3.gather.complete==false then 
            objectivesComplete=false 

            --once player gathers an item, remove it from objective preReqs
            for i,req in pairs(self.objectives.t3.gather.preReqs) do 
                if Player.inventory[req]>0 then 
                    self.sfx.completion:play()
                    table.remove(self.objectives.t3.gather.preReqs,i)
                end
            end

            --once all preReqs are aquired, objective is complete
            if #self.objectives.t3.gather.preReqs==0 then
                self:setObjectiveComplete(self.objectives.t3.gather)
            end        
        end
        
        if self.objectives.t3.make.complete==false then 
            objectivesComplete=false 

            --once player gathers an item, remove it from objective preReqs
            --account for fish_cooked not being in inventory
            for i,req in pairs(self.objectives.t3.make.preReqs) do 
                if (Player.inventory[req] and Player.inventory[req]>0)
                or (Player.suppliesPouch[req] and Player.suppliesPouch[req]>0)
                then 
                    self.sfx.completion:play()
                    table.remove(self.objectives.t3.make.preReqs,i)
                end
            end
            
            --once all preReqs are aquired, objective is complete
            if #self.objectives.t3.make.preReqs==0 then 
                self:setObjectiveComplete(self.objectives.t3.make)
            end
        end

        if self.objectives.t3.inventory.complete==false then 
            objectivesComplete=false 

            if Inventory.state.open then 
                self:setObjectiveComplete(self.objectives.t3.inventory)
            end
        end

        if objectivesComplete then self:endT3() end --end current tutorial
    end

    function TutorialState:endT3()
        self.checkObjectivesT3=function()end --stop checking objectives
        
        --reset Player dialog
        Player.dialogLines.noEnemies={
            "No enemies nearby!","Nothing to fight!","Can't see any enemies!"
        }    
        
        self:gotoTutorial(4) --continue to next tutorial
    end

    --Tutorial #4: Crafting pt.2 (crafting table)
    function TutorialState:startT4()
        self._upd=self.updateT4
        self._drw=self.drawT4

        self:clearPlayerInventory()
        Player.collider:setPosition(self.room.xPos+64,self.room.yPos+64)
        Player.dialogLines.noEnemies={ --changing combat dialog for this tutorial
            "Nothing to interact with here!","I Need to move closer!"
        }
        
        --0.2s after fading out, fade in and drop player into room
        TimerState:after(0.2,function()
            FadeState:fadeIn()
            PlayerTransitionState:enterRoom(Player)

            --spawn fungi and crafting table
            ResourceNodes.nodeSpawnFunctions[4](self.room.xPos+186,self.room.yPos+196)
            CraftingNodes:spawnEnchantedCraftingTable(self.room.xPos+176,self.room.yPos+116)

            --spawn items for crafting
            for i=1,3 do 
                Items:spawn_item(self.room.xPos+176,self.room.yPos+74,'tree_planks')
                Items:spawn_item(self.room.xPos+176,self.room.yPos+74,'rock_metal')
                Items:spawn_item(self.room.xPos+176,self.room.yPos+74,'vine_thread')
            end
            for i=1,10 do 
                Items:spawn_item(self.room.xPos+176,self.room.yPos+74,'arcane_shards') 
            end 
            Player:addToInventory('arcane_shards',20)
            Items:spawn_item(self.room.xPos+176,self.room.yPos+74,'broken_bow')
            Items:spawn_item(self.room.xPos+176,self.room.yPos+74,'broken_staff')
        end)
        
        --set tutorial objectives
        self.objectives.t4={
            potion={
                text="Craft a Potion.",
                color='gray', --green when complete
                complete=false,
            },
            armor={
                preReqs={'armor_head_t1','armor_chest_t1','armor_legs_t1'},
                text="Craft a full set of Bronze Armor.",
                color='gray', --green when complete
                complete=false,
            },
            weapons={
                preReqs={'weapon_bow_t1','weapon_staff_t1'},
                text="Craft a Bow and a Staff.",
                color='gray', --green when complete
                complete=false,
            },
        }
    end

    function TutorialState:updateT4()
        world:update(dt) --update physics colliders
        Dungeon:update() --update dungeon
        Entities:update() --update all entities
        Inventory:update() --update inventory

        cam:lockPosition(camTarget.xPos,camTarget.yPos,camSmoother) --update camera

        if acceptInput then 
            ActionButtons.combatInteract:update()
            if Controls.releasedInputs.btnSelect then PauseMenuState:open() end
        end

        self:checkObjectivesT4()

        return true
    end

    function TutorialState:drawT4()
        cam:attach()

        self.room:drawBackground() --draw floor and bg walls

        --tutorial text
        love.graphics.draw(self.sprites.text_4,self.room.xPos,self.room.yPos-19)

        Entities:draw() --draw all entities
        self.room:drawForeground() --draw foreground walls
        UI:draw() --draw ui elements

        --objective text
        love.graphics.printf(
            self.objectives.t4.potion.text,
            fonts[self.objectives.t4.potion.color],
            self.room.xPos,self.room.yPos+244,400,'center'
        )
        love.graphics.printf(
            self.objectives.t4.armor.text,
            fonts[self.objectives.t4.armor.color],
            self.room.xPos,self.room.yPos+254,400,'center'
        )
        love.graphics.printf(
            self.objectives.t4.weapons.text,
            fonts[self.objectives.t4.weapons.color],
            self.room.xPos,self.room.yPos+264,400,'center'
        )

        cam:detach()
        ActionButtons.combatInteract:draw()
        Inventory:draw()
    end

    function TutorialState:checkObjectivesT4()
        local objectivesComplete=true 

        if self.objectives.t4.potion.complete==false then 
            objectivesComplete=false 

            if Player.suppliesPouch.potion>0 then 
                self:setObjectiveComplete(self.objectives.t4.potion)
            end
        end

        if self.objectives.t4.armor.complete==false then 
            objectivesComplete=false 

            for i,req in pairs(self.objectives.t4.armor.preReqs) do 
                if Player.inventory[req]>0 then 
                    table.remove(self.objectives.t4.armor.preReqs,i)
                    self.sfx.completion:play()
                end
            end
            if #self.objectives.t4.armor.preReqs==0 then 
                self:setObjectiveComplete(self.objectives.t4.armor)
            end
        end

        if self.objectives.t4.weapons.complete==false then 
            objectivesComplete=false 

            for i,req in pairs(self.objectives.t4.weapons.preReqs) do 
                if Player.inventory[req]>0 then 
                    table.remove(self.objectives.t4.weapons.preReqs,i)
                    self.sfx.completion:play()
                end
            end
            if #self.objectives.t4.weapons.preReqs==0 then 
                self:setObjectiveComplete(self.objectives.t4.weapons)
            end
        end

        if objectivesComplete then self:endT4() end 
    end

    function TutorialState:endT4()
        self.checkObjectivesT4=function()end --stop checking objectives

        --prevent player from using crafting table 
        Dungeon.craftingTable.collider:setCollisionClass('depletedNode')
        
        --reset Player dialog
        Player.dialogLines.noEnemies={
            "No enemies nearby!","Nothing to fight!","Can't see any enemies!"
        }

        --close inventory
        Inventory:close()
        
        self:gotoTutorial(5) --continue to next tutorial
    end

    --Tutorial #5: Combat pt.1 (targetting enemies)
    function TutorialState:startT5()
        self._upd=self.updateT5
        self._drw=self.drawT5

        self:clearPlayerInventory()
        Player.collider:setPosition(self.room.xPos+192,self.room.yPos+64)
        
        --0.2s after fading out, fade in and drop player into room
        TimerState:after(0.2,function()
            FadeState:fadeIn()
            PlayerTransitionState:enterRoom(Player)

            --spawn depleted trees to act as a barrier
            for i=1,22 do 
                local tree=ResourceNodes.nodeSpawnFunctions[1](
                    self.room.xPos+144,self.room.yPos+35+(i*10))
                tree.state.depleted=true 
                tree.collider:setType('static')
            end
            for i=1,22 do 
                local tree=ResourceNodes.nodeSpawnFunctions[1](
                    self.room.xPos+224,self.room.yPos+35+(i*10))
                tree.state.depleted=true 
                tree.collider:setType('static')
            end

            --spawn enemies, remove their combat functionality
            self.enemies.goblin=Enemies.enemySpawner.t1[1](self.room.xPos+38,self.room.yPos+128)
            self.enemies.goblin.checkTargetPosition=function() end
            self.enemies.imp=Enemies.enemySpawner.t1[2](self.room.xPos+336,self.room.yPos+128)
            self.enemies.imp.checkTargetPosition=function() end
        end)
        
        --set tutorial objectives
        self.objectives.t5={
            goblin={
                text="Defeat the Goblin",
                color='gray', --green when complete
                complete=false,
            },
            imp={
                text="Defeat the Imp",
                color='gray', --green when complete
                complete=false,
            },
        }
    end 

    function TutorialState:updateT5()
        world:update(dt) --update physics colliders
        Dungeon:update() --update dungeon
        Entities:update() --update all entities
        Inventory:update() --update inventory

        cam:lockPosition(camTarget.xPos,camTarget.yPos,camSmoother) --update camera

        if acceptInput then 
            ActionButtons.combatInteract:update()
            if Controls.releasedInputs.btnSelect then PauseMenuState:open() end
        end

        self:checkObjectivesT5()

        return true
    end

    function TutorialState:drawT5()
        cam:attach()

        self.room:drawBackground() --draw floor and bg walls

        --tutorial text
        love.graphics.draw(self.sprites.text_5,self.room.xPos,self.room.yPos-30)

        Entities:draw() --draw all entities
        self.room:drawForeground() --draw foreground walls
        UI:draw() --draw ui elements

        --objective text
        love.graphics.printf(
            self.objectives.t5.goblin.text,
            fonts[self.objectives.t5.goblin.color],
            self.room.xPos,self.room.yPos+244,400,'center'
        )
        love.graphics.printf(
            self.objectives.t5.imp.text,
            fonts[self.objectives.t5.imp.color],
            self.room.xPos,self.room.yPos+254,400,'center'
        )

        cam:detach()
        ActionButtons.combatInteract:draw()
        Inventory:draw()
    end

    function TutorialState:checkObjectivesT5()
        local objectivesComplete=true 

        if self.objectives.t5.goblin.complete==false then 
            objectivesComplete=false 
            if self.enemies.goblin and self.enemies.goblin.state.willDie then 
                self:setObjectiveComplete(self.objectives.t5.goblin)
            end
        end
        if self.objectives.t5.imp.complete==false then 
            objectivesComplete=false 
            if self.enemies.imp and self.enemies.imp.state.willDie then 
                self:setObjectiveComplete(self.objectives.t5.imp)
            end
        end

        if objectivesComplete then self:endT5() end 
    end

    function TutorialState:endT5()
        self.checkObjectivesT5=function()end --stop checking objectives

        --close inventory
        Inventory:close()

        self.enemies={} --clear enemies table
        
        self:gotoTutorial(6) --continue to next tutorial
    end

    --Tutorial #6: Combat pt.2, switching weapons
    function TutorialState:startT6()
        self._upd=self.updateT6
        self._drw=self.drawT6

        self:clearPlayerInventory()
        Player.collider:setPosition(self.room.xPos+96,self.room.yPos+96)
        
        --0.2s after fading out, fade in and drop player into room
        TimerState:after(0.2,function()
            FadeState:fadeIn()
            PlayerTransitionState:enterRoom(Player)

            --spawn depleted trees to act as a barrier
            for i=1,22 do 
                local tree=ResourceNodes.nodeSpawnFunctions[1](
                    self.room.xPos+185,self.room.yPos+35+(i*10))
                tree.state.depleted=true 
                tree.collider:setType('static')
            end

            --spawn enemies, remove their combat functionality
            for i=1,4 do 
                local e=Enemies.enemySpawner.t1[love.math.random(2)](
                    self.room.xPos+love.math.random(208,304),
                    self.room.yPos+love.math.random(64,207)
                )
                e.checkTargetPosition=function() end 
                table.insert(self.enemies,e)
            end

            --spawn bow and staff
            Items:spawn_item(self.room.xPos+96,self.room.yPos+96,'weapon_staff_t1')
            Items:spawn_item(self.room.xPos+96,self.room.yPos+96,'weapon_bow_t1')
        end)
        
        --set tutorial objectives
        self.objectives.t6={
            bow={
                text="Defeat an enemy with the Bow",
                color='gray', --green when complete
                complete=false,
            },
            staff={
                text="Defeat an enemy with the Staff",
                color='gray', --green when complete
                complete=false,
            },
        }
    end

    function TutorialState:updateT6()
        world:update(dt) --update physics colliders
        Dungeon:update() --update dungeon
        Entities:update() --update all entities
        Inventory:update() --update inventory

        cam:lockPosition(camTarget.xPos,camTarget.yPos,camSmoother) --update camera

        if acceptInput then 
            ActionButtons.combatInteract:update()
            ActionButtons.weapons:update()
            if Controls.releasedInputs.btnSelect then PauseMenuState:open() end
        end

        self:checkObjectivesT6()

        self:populateRoomWithEnemiesT6()

        return true
    end

    function TutorialState:drawT6()
        cam:attach()
        self.room:drawBackground() --draw floor and bg walls

        --tutorial text
        love.graphics.draw(self.sprites.text_6,self.room.xPos,self.room.yPos-18)

        Entities:draw() --draw all entities
        self.room:drawForeground() --draw foreground walls
        UI:draw() --draw ui elements

        --objective text
        love.graphics.printf(
            self.objectives.t6.bow.text,
            fonts[self.objectives.t6.bow.color],
            self.room.xPos,self.room.yPos+244,400,'center'
        )
        love.graphics.printf(
            self.objectives.t6.staff.text,
            fonts[self.objectives.t6.staff.color],
            self.room.xPos,self.room.yPos+254,400,'center'
        )

        cam:detach()
        ActionButtons.combatInteract:draw()
        ActionButtons.weapons:draw()
        Inventory:draw()
    end

    function TutorialState:checkObjectivesT6()
        local objectivesComplete=true 

        if self.objectives.t6.bow.complete==false then 
            objectivesComplete=false 
            for _,e in pairs(self.enemies) do 
                if e.state.willDie and e.state.lastDamageTypeTaken=='physical' then 
                    self:setObjectiveComplete(self.objectives.t6.bow)
                end
            end
        end 

        if self.objectives.t6.staff.complete==false then 
            objectivesComplete=false 
            for _,e in pairs(self.enemies) do 
                if e.state.willDie and e.state.lastDamageTypeTaken=='magical' then 
                    self:setObjectiveComplete(self.objectives.t6.staff)
                end
            end
        end 

        if objectivesComplete then self:endT6() end 
    end

    --if all enemies are dead, clear table and spawn another set of enemies
    function TutorialState:populateRoomWithEnemiesT6()
        if #self.enemies==0 then return end --wait for enemies to spawn

        local allDead=true 

        for _,e in pairs(self.enemies) do 
            if not e.state.willDie then allDead=false end
        end

        if allDead then 
            self.enemies={}
            for i=1,4 do 
                local e=Enemies.enemySpawner.t1[love.math.random(2)](
                    self.room.xPos+love.math.random(208,304),
                    self.room.yPos+love.math.random(64,207)
                )
                e.checkTargetPosition=function() end 
                table.insert(self.enemies,e)
            end
        end
    end

    function TutorialState:endT6()
        self.checkObjectivesT6=function()end --stop checking objectives
        self.populateRoomWithEnemiesT6=function()end --stop spawning enemies

        --close inventory
        Inventory:close()

        for _,e in pairs(self.enemies) do e.health.current=0 end --kill all enemies
        self.enemies={} --clear enemies table
        
        self:gotoTutorial(7) --continue to next tutorial
    end

    --Tutorial #7: Protection Magics pt.1 (Physical protection)
    function TutorialState:startT7()
        self._upd=self.updateT7
        self._drw=self.drawT7

        self:clearPlayerInventory()
        Player.collider:setPosition(self.room.xPos+192,self.room.yPos+80)
        Player.protectionMagics:deactivate("no sound")
        
        --0.2s after fading out, fade in and drop player into room
        TimerState:after(0.2,function()
            FadeState:fadeIn()
            PlayerTransitionState:enterRoom(Player)

            --spawn inner walls
            Walls:newWall(self.room.xPos+128,16+self.room.yPos+125,'horizontal',144)

            --spawn enemy
            self.enemies.orc=Enemies.enemySpawner.t2[1](192,176)
        end)
        
        --set tutorial objectives
        self.objectives.t7={
            protectPhysical={
                text="Use protection magics to block physical damage.",
                color='gray', --green when complete
                instances=0, --need to block 3 instances of damage
                complete=false,            
            },
        }
    end

    function TutorialState:updateT7()
        world:update(dt) --update physics colliders
        Dungeon:update() --update dungeon
        Entities:update() --update all entities
        Inventory:update() --update inventory

        cam:lockPosition(camTarget.xPos,camTarget.yPos,camSmoother) --update camera

        if acceptInput then
            ActionButtons.combatInteract:update()
            ActionButtons.weapons:update()
            ActionButtons.protectionMagics:update()
            if Controls.releasedInputs.btnSelect then PauseMenuState:open() end
        end

        --automatically restore player's health/mana when they get too low
        if Player.health.current<20 then Player.health.current=Player.health.max end 
        if Player.mana.current<20 then Player.mana.current=Player.mana.max end 

        self:checkObjectivesT7()

        self:populateRoomWithEnemiesT7()

        return true
    end

    function TutorialState:drawT7()
        cam:attach()
        self.room:drawBackground() --draw floor and bg walls

        --tutorial text
        love.graphics.draw(self.sprites.text_7,self.room.xPos,self.room.yPos-18)

        Entities:draw() --draw all entities
        self.room:drawForeground() --draw foreground walls
        UI:draw() --draw ui elements

        --objective text
        love.graphics.printf(
            self.objectives.t7.protectPhysical.text.." ("..
            self.objectives.t7.protectPhysical.instances.."/3)",
            fonts[self.objectives.t7.protectPhysical.color],
            self.room.xPos,self.room.yPos+244,400,'center'
        )

        cam:detach()
        ActionButtons.combatInteract:draw()
        ActionButtons.weapons:draw()
        ActionButtons.protectionMagics:draw()
        Inventory:draw()
    end

    function TutorialState:checkObjectivesT7()
        local objectivesComplete=true 

        if self.objectives.t7.protectPhysical.complete==false then 
            objectivesComplete=false 
            if Player.combatData.blockedDamage==true then
                local newInstances=self.objectives.t7.protectPhysical.instances+1
                self.objectives.t7.protectPhysical.instances=newInstances
                Player.combatData.blockedDamage=false 
                TimerState:after(0.1,function() --delay completion ding by 0.1s
                    self.sfx.completion:play()
                end)
            end
            if self.objectives.t7.protectPhysical.instances==3 then 
                self:setObjectiveComplete(self.objectives.t7.protectPhysical,'no sound')
            end
        end 

        if objectivesComplete then self:endT7() end 
    end

    --respawn the orc if player kills it before completing the objective
    function TutorialState:populateRoomWithEnemiesT7()
        if self.enemies.orc and self.enemies.orc.state.willDie then 
            self.enemies.orc=Enemies.enemySpawner.t2[1](192,160)
        end
    end

    function TutorialState:endT7()
        self.checkObjectivesT7=function()end --stop checking objectives
        self.populateRoomWithEnemiesT7=function()end --stop spawning enemies
        Player.state.invincible=true 

        --close inventory
        Inventory:close()

        for _,e in pairs(self.enemies) do e.health.current=0 end --kill all enemies
        self.enemies={} --clear enemies table
        
        self:gotoTutorial(8) --continue to next tutorial
    end

    --Tutorial #8: Protection Magics pt.1 (Magical protection)
    function TutorialState:startT8()
        self._upd=self.updateT8
        self._drw=self.drawT8

        self:clearPlayerInventory()
        Player.collider:setPosition(self.room.xPos+192,self.room.yPos+80)
        Player.protectionMagics:deactivate("no sound")
        
        --0.2s after fading out, fade in and drop player into room
        TimerState:after(0.2,function()
            FadeState:fadeIn()
            PlayerTransitionState:enterRoom(Player)
            Player.state.invincible=false 

            --spawn inner walls
            Walls:newWall(self.room.xPos+128,16+self.room.yPos+125,'horizontal',144)

            --spawn enemy
            self.enemies.mage=Enemies.enemySpawner.t2[3](192,176)
        end)
        
        --set tutorial objectives
        self.objectives.t8={
            protectMagical={
                text="Use protection magics to block magical damage.",
                color='gray', --green when complete
                instances=0, --need to block 3 instances of damage
                complete=false,            
            },
        }
    end

    function TutorialState:updateT8()
        world:update(dt) --update physics colliders
        Dungeon:update() --update dungeon
        Entities:update() --update all entities
        Inventory:update() --update inventory

        cam:lockPosition(camTarget.xPos,camTarget.yPos,camSmoother) --update camera

        if acceptInput then
            ActionButtons.combatInteract:update()
            ActionButtons.weapons:update()
            ActionButtons.protectionMagics:update()
            if Controls.releasedInputs.btnSelect then PauseMenuState:open() end
        end

        --automatically restore player's health/mana when they get too low
        if Player.health.current<20 then Player.health.current=Player.health.max end 
        if Player.mana.current<20 then Player.mana.current=Player.mana.max end 

        self:checkObjectivesT8()

        self:populateRoomWithEnemiesT8()

        return true
    end

    function TutorialState:drawT8()
        cam:attach()
        self.room:drawBackground() --draw floor and bg walls

        --tutorial text
        love.graphics.draw(self.sprites.text_7,self.room.xPos,self.room.yPos-18)

        Entities:draw() --draw all entities
        self.room:drawForeground() --draw foreground walls
        UI:draw() --draw ui elements

        --objective text
        love.graphics.printf(
            self.objectives.t8.protectMagical.text.." ("..
            self.objectives.t8.protectMagical.instances.."/3)",
            fonts[self.objectives.t8.protectMagical.color],
            self.room.xPos,self.room.yPos+244,400,'center'
        )

        cam:detach()
        ActionButtons.combatInteract:draw()
        ActionButtons.weapons:draw()
        ActionButtons.protectionMagics:draw()
        Inventory:draw()
    end

    function TutorialState:checkObjectivesT8()
        local objectivesComplete=true 

        if self.objectives.t8.protectMagical.complete==false then 
            objectivesComplete=false 
            if Player.combatData.blockedDamage==true then
                local newInstances=self.objectives.t8.protectMagical.instances+1
                self.objectives.t8.protectMagical.instances=newInstances
                Player.combatData.blockedDamage=false 
                TimerState:after(0.1,function() --delay completion ding by 0.1s
                    self.sfx.completion:play()
                end)
            end
            if self.objectives.t8.protectMagical.instances==3 then 
                self:setObjectiveComplete(self.objectives.t8.protectMagical,'no sound')
            end
        end 

        if objectivesComplete then self:endT8() end 
    end

    --respawn the mage if player kills it before completing the objective
    function TutorialState:populateRoomWithEnemiesT8()
        if self.enemies.mage and self.enemies.mage.state.willDie then 
            self.enemies.mage=Enemies.enemySpawner.t2[3](192,160)
        end
    end

    function TutorialState:endT8()
        self.checkObjectivesT8=function()end --stop checking objectives
        self.populateRoomWithEnemiesT8=function()end --stop spawning enemies
        Player.health.current=Player.health.max
        Player.mana.current=Player.mana.max
        Player.state.invincible=true

        --close inventory
        Inventory:close()

        for _,e in pairs(self.enemies) do e.health.current=0 end --kill all enemies
        self.enemies={} --clear enemies table
        
        self:gotoTutorial(9) --continue to next tutorial
    end

    --Tutorial #9: Conumables
    function TutorialState:startT9()
        self._upd=self.updateT9
        self._drw=self.drawT9

        self:clearPlayerInventory()
        Player.collider:setPosition(self.room.xPos+192,self.room.yPos+128)
        Player.protectionMagics:deactivate("no sound")
        Player.health.current=10
        Player.mana.current=10
        Player:updateHealth(0)
        Player:updateMana(0)
        
        --0.2s after fading out, fade in and drop player into room
        TimerState:after(0.2,function()
            FadeState:fadeIn()
            PlayerTransitionState:enterRoom(Player)
            Player.state.invincible=false

            --spawn cooked fish and potions
            for i=1,5 do 
                Items:spawn_item(self.room.xPos+192,self.room.yPos+112,'fish_cooked')
            end
        end)
        
        --set tutorial objectives
        self.objectives.t9={
            restoreHealth={
                text="Fully restore your health by eating Cooked Fish.",
                color='gray', --green when complete
                complete=false,            
            },
            restoreMana={
                text="Fully restore your mana by drinking Potions.",
                color='gray', --green when complete
                complete=false,            
            },
        }
    end

    function TutorialState:updateT9()
        world:update(dt) --update physics colliders
        Dungeon:update() --update dungeon
        Entities:update() --update all entities
        Inventory:update() --update inventory
        Meters:update() --update health and mana bars

        cam:lockPosition(camTarget.xPos,camTarget.yPos,camSmoother) --update camera

        if acceptInput then
            ActionButtons.combatInteract:update()
            ActionButtons.weapons:update()
            ActionButtons.protectionMagics:update()
            ActionButtons.supplies:update()
            if Controls.releasedInputs.btnSelect then PauseMenuState:open() end
        end

        self:checkObjectivesT9()

        --prevent softlock from running out of potions without fully restoring mana
        if Player.suppliesPouch.potion==0 and #Entities.entitiesTable==1 then 
            for i=1,5 do 
                Items:spawn_item(self.room.xPos+192,self.room.yPos+144,'potion')
            end
        end

        return true
    end

    function TutorialState:drawT9()
        cam:attach()
        self.room:drawBackground() --draw floor and bg walls

        --tutorial text
        love.graphics.draw(self.sprites.text_9,self.room.xPos,self.room.yPos-18)

        Entities:draw() --draw all entities
        self.room:drawForeground() --draw foreground walls
        UI:draw() --draw ui elements

        --objective text
        love.graphics.printf(
            self.objectives.t9.restoreHealth.text,
            fonts[self.objectives.t9.restoreHealth.color],
            self.room.xPos,self.room.yPos+244,400,'center'
        )
        love.graphics.printf(
            self.objectives.t9.restoreMana.text,
            fonts[self.objectives.t9.restoreMana.color],
            self.room.xPos,self.room.yPos+254,400,'center'
        ) 
        cam:detach()

        ActionButtons.combatInteract:draw()
        ActionButtons.weapons:draw()
        ActionButtons.protectionMagics:draw()
        ActionButtons.supplies:draw()
        Inventory:draw()
        Meters:draw()
    end

    function TutorialState:checkObjectivesT9()
        local objectivesComplete=true 

        if self.objectives.t9.restoreHealth.complete==false then 
            objectivesComplete=false 
            if Player.health.current==Player.health.max then 
                self:setObjectiveComplete(self.objectives.t9.restoreHealth)
            end
        end
        
        if self.objectives.t9.restoreMana.complete==false then 
            objectivesComplete=false 
            if Player.mana.current==Player.mana.max then
                self:setObjectiveComplete(self.objectives.t9.restoreMana)
            end
        end

        if objectivesComplete then self:endT9() end 
    end

    function TutorialState:endT9()
        self.checkObjectivesT9=function()end --stop checking objectives
        self.populateRoomWithEnemiesT9=function()end --stop spawning enemies
        
        self:endTutorial()
    end

end --end load()

--update and draw state machine
function TutorialState:update() return self:_upd() end 
function TutorialState:draw() self:_drw() drawTransitionScreen() end 

--creates the outer walls of the tutorial room
function TutorialState:createOuterWalls(_room)
    local x,y=_room.xPos,_room.yPos
    local walls={}

    walls.left=world:newRectangleCollider(x,y,36,288)
    walls.right=world:newRectangleCollider(x+347,y,36,288)
    walls.top=world:newRectangleCollider(x+37,y,310,48)
    walls.bottom=world:newRectangleCollider(x+37,y+266,310,22)

    --make them static colliders and set their collision class
    for _,w in pairs(walls) do w:setType('static') w:setCollisionClass('outerWall') end

    return walls
end

--creates the inner walls for the Movement Tutorial
function TutorialState:createT1InnerWalls(_room)   
    Walls:newWall(_room.xPos+127,16+_room.yPos+33,'vertical',180)
    Walls:newWall(_room.xPos+255,16+_room.yPos+61,'vertical',212)
    Walls:newWall(_room.xPos+127,16+_room.yPos+197,'horizontal',96)
    Walls:newWall(_room.xPos+160,16+_room.yPos+61,'horizontal',96)
end

--Clear all entities except the player, fades out, and goes to another tutorial
function TutorialState:gotoTutorial(_tutorialNum)
    local afterFn=function()
        Entities:removeAll() --clear entitiesTable
        self['startT'.._tutorialNum](self)
    end
    TimerState:after(0.5,function() FadeState:fadeOut(1,afterFn) end)
end

--Sets an objective to the complete state and plays an sfx
function TutorialState:setObjectiveComplete(_obj,_noSound)
    _obj.complete=true 
    _obj.color='green'
    if _noSound then return end
    self.sfx.completion:play()
end

--emtpy the player's inventory
function TutorialState:clearPlayerInventory()
    for item,qty in pairs(Player.inventory) do  
        if qty>0 then Player:removeFromInventory(item,qty) end
    end
    for supply,qty in pairs(Player.suppliesPouch) do  
        if qty>0 then Player:removeFromInventory(supply,qty) end
    end
end

--Player says "Tutorial Complete" message, then fade out to Title Screen
function TutorialState:endTutorial()
    TimerState:after(0.5,function() Player.dialog:say("Congratulations!") end)
    TimerState:after(1.25,function() Player.dialog:say("Tutorial Complete!") end)
    local afterFn=function() love.load({keepSettings=true}) end
    TimerState:after(2.5,function() FadeState:fadeOut(1,afterFn) end)
end
