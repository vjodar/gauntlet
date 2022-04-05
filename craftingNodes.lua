CraftingNodes={}

function CraftingNodes:load()
    self.sprites={} --stores sprites
    self.sprites.furnace=love.graphics.newImage('assets/crafting_furnace.png')
    self.sprites.grill=love.graphics.newImage('assets/crafting_grill.png')
    self.sprites.sawmill=love.graphics.newImage('assets/crafting_sawmill.png')
    self.sprites.spinning_wheel=love.graphics.newImage('assets/crafting_spinning_wheel.png')
    self.sprites.crafting_table=love.graphics.newImage('assets/crafting_table.png')

    self.grids={} --animation grids
    self.grids.furnace=anim8.newGrid(
        25,25,self.sprites.furnace:getWidth(),self.sprites.furnace:getHeight()
    )
    self.grids.grill=anim8.newGrid(
        19,16,self.sprites.grill:getWidth(),self.sprites.grill:getHeight()
    )
    self.grids.sawmill=anim8.newGrid(
        23,13,self.sprites.sawmill:getWidth(),self.sprites.sawmill:getHeight()
    )
    self.grids.spinning_wheel=anim8.newGrid(
        21,16,self.sprites.spinning_wheel:getWidth(),self.sprites.spinning_wheel:getHeight()
    )

    self.animations={} --idle and crafting animations
    self.animations.furnace={
        idle=anim8.newAnimation(self.grids.furnace('1-2',1), 0.5),
        crafting=anim8.newAnimation(self.grids.furnace('3-6',1), 0.2)
    }
    self.animations.grill={
        idle=anim8.newAnimation(self.grids.grill('1-1',1), 0.15),
        crafting=anim8.newAnimation(self.grids.grill('1-4',1), 0.15)
    }
    self.animations.sawmill={
        idle=anim8.newAnimation(self.grids.sawmill('1-1',1), 0.1),
        crafting=anim8.newAnimation(self.grids.sawmill('1-2',1), 0.1)
    }
    self.animations.spinning_wheel={
        idle=anim8.newAnimation(self.grids.spinning_wheel('1-1',1), 0.1),
        crafting=anim8.newAnimation(self.grids.spinning_wheel('2-5',1), 0.1)
    }

    self.offsets={} --offset each sprite to have its collider be at its shadow
    self.offsets.furnace={x=12.5,y=22}
    self.offsets.grill={x=9.5,y=14.5}
    self.offsets.sawmill={x=11.5,y=13}
    self.offsets.spinning_wheel={x=10,y=15}
    self.offsets.crafting_table={x=16,y=12}
    
    self.items={} --items the crafting node will spawn
    self.items.furnace='rock_metal'
    self.items.grill='fish_cooked'
    self.items.sawmill='tree_planks'
    self.items.spinning_wheel='vine_thread'

    self.reqItems={} --items the crafting node will take from player
    self.reqItems.rock_metal='rock_ore'
    self.reqItems.fish_cooked='fish_raw'
    self.reqItems.tree_planks='tree_wood'
    self.reqItems.vine_thread='vine_fiber'

    self.shadows={} --shadows (will cause bugs if more than a single of each node)
    self.shadows.furnace=Shadows:newShadow('furnace')
    self.shadows.grill=Shadows:newShadow('grill')
    self.shadows.sawmill=Shadows:newShadow('sawmill')
    self.shadows.spinning_wheel=Shadows:newShadow('spinning_wheel')
    self.shadows.crafting_table=Shadows:newShadow('crafting_table')

    self.colliderSizes={} --collider widths, heights, and corner sizes
    self.colliderSizes.furnace={w=25,h=8,c=3}
    self.colliderSizes.grill={w=19,h=8,c=3}
    self.colliderSizes.sawmill={w=23,h=4,c=1}
    self.colliderSizes.spinning_wheel={w=20,h=4,c=1}
    self.colliderSizes.crafting_table={w=32,h=12,c=3}

    self.particleSprites={} --particle sprites
    self.particleSprites.furnace=love.graphics.newImage('assets/crafting_furnace_particle.png')
    self.particleSprites.grill=love.graphics.newImage('assets/crafting_grill_particle.png')
    self.particleSprites.sawmill=love.graphics.newImage('assets/crafting_sawmill_particle.png')
    self.particleSprites.spinning_wheel=love.graphics.newImage('assets/tree_particle.png')

    self.particleOffsets={ --offsets to draw particles in correct area with respect to node
        furnace={x=0,y=-7},
        grill={x=0,y=-11},
        sawmill={x=0,y=-10},
        spinning_wheel={x=0,y=0}
    } 

    self.particleEmissionRates={ --how many frames between particle emission
        furnace=8,
        grill=5,
        sawmill=2,
        spinning_wheel=5
    } 

    self.particleSystems={} --particle systems

    self.particleSystems.furnace=love.graphics.newParticleSystem(self.particleSprites.furnace,50)
    self.particleSystems.furnace:setParticleLifetime(0.8) 
    self.particleSystems.furnace:setSpeed(25,80) 
    self.particleSystems.furnace:setDirection(1.6) --shoot downward
    self.particleSystems.furnace:setSpread(1) --60degree spread
    self.particleSystems.furnace:setLinearAcceleration(0,-200) --accelerate upward
    self.particleSystems.furnace:setEmissionArea('uniform',8,4)
    self.particleSystems.furnace:setRelativeRotation(true)
    self.particleSystems.furnace:setColors(1,1,1,0.9, 1,1,1,0) --particles will fade out
    self.particleSystems.furnace:setSizes(0.5,3) --particles will grow

    self.particleSystems.grill=love.graphics.newParticleSystem(self.particleSprites.grill,50)
    self.particleSystems.grill:setParticleLifetime(0.6) 
    self.particleSystems.grill:setDirection(4.7) --shoot upward
    self.particleSystems.grill:setLinearAcceleration(0,0,0,-150)
    self.particleSystems.grill:setEmissionArea('uniform',7,4)
    self.particleSystems.grill:setRotation(0,6.3)
    self.particleSystems.grill:setColors(1,1,1,0.2, 1,1,1,0) --particles will fade out
    self.particleSystems.grill:setSizes(0.1,2) --particles will grow

    self.particleSystems.sawmill=love.graphics.newParticleSystem(self.particleSprites.sawmill,50)
    self.particleSystems.sawmill:setParticleLifetime(0.2,0.4) 
    self.particleSystems.sawmill:setSpeed(100,150) 
    self.particleSystems.sawmill:setDirection(4.7) --shoot upward
    self.particleSystems.sawmill:setSpread(1.5) --90degree spread
    self.particleSystems.sawmill:setEmissionArea('uniform',4,4)
    self.particleSystems.sawmill:setRelativeRotation(true)
    self.particleSystems.sawmill:setColors(1,1,1,1, 1,1,1,0) --particles will fade out

    --currently no particle system for spinning wheel, so immediately stop
    self.particleSystems.spinning_wheel=love.graphics.newParticleSystem(self.particleSprites.spinning_wheel,50)
    self.particleSystems.spinning_wheel:stop()
end

function CraftingNodes:spawnCraftingNode(_type,_x,_y)
    if _type=='crafting_table' then self:spawnEnchantedCraftingTable(_x,_y) return end
    
    local node={}

    function node:load()
        --collider and vectors
        self.collider=world:newBSGRectangleCollider(
            _x,_y, --position vectors
            CraftingNodes.colliderSizes[_type].w, --width
            CraftingNodes.colliderSizes[_type].h, --height
            CraftingNodes.colliderSizes[_type].c --corner size
        )
        self.collider:setType('static')
        self.collider:setCollisionClass('craftingNode')
        self.collider:setObject(node)
        self.xPos,self.yPos=self.collider:getPosition()

        --sprites and animations
        self.spriteSheet=CraftingNodes.sprites[_type]
        self.animations={}
        self.animations.idle=CraftingNodes.animations[_type].idle
        self.animations.crafting=CraftingNodes.animations[_type].crafting
        self.currentAnim=self.animations.idle
        self.xOffset=CraftingNodes.offsets[_type].x
        self.yOffset=CraftingNodes.offsets[_type].y

        --item that will spawn from node
        self.item=CraftingNodes.items[_type]
        self.reqItem=CraftingNodes.reqItems[self.item] 

        --shadow
        self.shadow=CraftingNodes.shadows[_type]

        --particles
        self.particles=CraftingNodes.particleSystems[_type]
        self.particleOffsets={
            x=CraftingNodes.particleOffsets[_type].x,
            y=CraftingNodes.particleOffsets[_type].y
        }
        self.particleEmissionRate=CraftingNodes.particleEmissionRates[_type]
        self.particleTimer=0

        --metatable
        self.state={}
        self.state.craftProgress=0
        self.state.craftProgressPrev=0

        --insert into entities table to have dynamic draw order
        table.insert(Entities.entitiesTable,node) 
    end

    function node:update()

        --When node is being interacted with, change currentAnim to crafting animation,
        --otherwise currentAnim will be the idle animation.
        if self.state.craftProgressPrev==self.state.craftProgress then
            self.currentAnim=self.animations.idle
        else
            self.currentAnim=self.animations.crafting

            self.particleTimer=self.particleTimer+1
            if self.particleTimer>=self.particleEmissionRate then 
                self.particles:emit(1)
                self.particleTimer=0
            end
        end
        
        self.currentAnim:update(dt) --update animations
        self.particles:update(dt) --update particle system

        --spawn an item 
        if self.state.craftProgress>0.7 then --takes ~0.7s to craft

            --choose a starting point around node for the item to spawn
            local startX=love.math.random(self.xPos-7,self.xPos+5)
            local startY=love.math.random(self.yPos-7,self.yPos+5)

            --spawn appropriate item
            Items:spawn_item(startX,startY,self.item)

            --decrease count of the required item from player and HUD by 1
            Player:removeFromInventory(self.reqItem,1)

            self.state.craftProgress=0 --reset craftProgress
        end

        --update crafting progress
        self.state.craftProgressPrev=self.state.craftProgress
    end

    function node:draw()
        self.shadow:draw(self.xPos,self.yPos) --draw shadow first

        --draw node
        self.currentAnim:draw(self.spriteSheet,self.xPos,self.yPos,nil,1,1,self.xOffset,self.yOffset)
        
        --draw particles
        love.graphics.draw(
            self.particles,
            self.xPos+self.particleOffsets.x,
            self.yPos+self.particleOffsets.y
        )
    end

    --called by Player, increases craftProgress by time delta
    --player can only craft items that the player possesses.
    function node:nodeInteract()
        if Player.inventory[self.reqItem]>0 then 
            self.state.craftProgress=self.state.craftProgress+dt
        end
    end

    node:load()
end

--seperate function for spawning the enchanted crafting table as its 
--functionality is different from the four basic crafting nodes.
function CraftingNodes:spawnEnchantedCraftingTable(_x,_y)
    local node={}

    function node:load()
        --sprite
        self.sprite=CraftingNodes.sprites.crafting_table
        self.xOffset=CraftingNodes.offsets.crafting_table.x 
        self.yOffset=CraftingNodes.offsets.crafting_table.y 

        --shadow
        self.shadow=CraftingNodes.shadows.crafting_table 

        --collider and vectors
        self.collider=world:newBSGRectangleCollider(
            _x,_y, --position
            CraftingNodes.colliderSizes.crafting_table.w, --width
            CraftingNodes.colliderSizes.crafting_table.h, --height            
            CraftingNodes.colliderSizes.crafting_table.c  --corner size
        )
        self.collider:setType('static')
        self.collider:setCollisionClass('craftingNode')
        self.collider:setObject(node)
        --position origin is center of collider
        self.xPos,self.yPos=self.collider:getPosition()

        --inset into entitiesTable for dynamic draw and update order
        table.insert(Entities.entitiesTable,node)
    end

    function node:update()

    end

    function node:draw()
        self.shadow:draw(self.xPos,self.yPos) --draw shadow first
        love.graphics.draw(self.sprite,self.xPos,self.yPos,nil,1,1,self.xOffset,self.yOffset)
    end

    function node:nodeInteract()
        table.insert(gameStates,CraftingMenuState)
        CraftingMenuState:openCraftingMenu(Player.xPos,Player.yPos)
    end

    node:load()
end