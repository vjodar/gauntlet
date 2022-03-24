CraftingNodes={}

function CraftingNodes:load()
    self.sprites={} --stores sprites
    self.sprites.furnace=love.graphics.newImage('assets/crafting_furnace.png')
    self.sprites.grill=love.graphics.newImage('assets/crafting_grill.png')
    self.sprites.sawmill=love.graphics.newImage('assets/crafting_furnace.png')
    self.sprites.spinning_wheel=love.graphics.newImage('assets/crafting_spinning_wheel.png')

    self.particles={} --particle sprites

    self.grids={} --animation grids
    self.grids.furnace=anim8.newGrid(
        25,25,self.sprites.furnace:getWidth(),self.sprites.furnace:getHeight()
    )
    self.grids.grill=anim8.newGrid(
        19,16,self.sprites.grill:getWidth(),self.sprites.grill:getHeight()
    )
    self.grids.sawmill=anim8.newGrid(
        25,25,self.sprites.sawmill:getWidth(),self.sprites.sawmill:getHeight()
    )
    self.grids.spinning_wheel=anim8.newGrid(
        20,16,self.sprites.spinning_wheel:getWidth(),self.sprites.spinning_wheel:getHeight()
    )

    self.animations={}
    self.animations.furnace={
        idle=anim8.newAnimation(self.grids.furnace('1-1',1), 0.15),
        crafting=anim8.newAnimation(self.grids.furnace('1-4',1), 0.15)
    }
    self.animations.grill={
        idle=anim8.newAnimation(self.grids.grill('1-1',1), 0.15),
        crafting=anim8.newAnimation(self.grids.grill('1-4',1), 0.15)
    }
    self.animations.sawmill={
        idle=anim8.newAnimation(self.grids.sawmill('1-1',1), 0.1),
        crafting=anim8.newAnimation(self.grids.sawmill('1-4',1), 0.1)
    }
    self.animations.spinning_wheel={
        idle=anim8.newAnimation(self.grids.spinning_wheel('1-1',1), 0.1),
        crafting=anim8.newAnimation(self.grids.spinning_wheel('2-5',1), 0.1)
    }

    self.offsets={} --offset each sprite to have its collider be at its shadow
    self.offsets.furnace={x=12,y=20}
    self.offsets.grill={x=9.5,y=15}
    self.offsets.sawmill={x=12,y=20}
    self.offsets.spinning_wheel={x=10,y=15}

    self.items={} --items the crafting node will spawn
    self.items.furnace='rock_metal'
    self.items.grill='fish_cooked'
    self.items.sawmill='tree_planks'
    self.items.spinning_wheel='vine_thread'

    self.shadows={} --shadows
    self.shadows.furnace=Shadows:newShadow('furnace')
    self.shadows.grill=Shadows:newShadow('grill')
    self.shadows.sawmill=Shadows:newShadow('sawmill')
    self.shadows.spinning_wheel=Shadows:newShadow('spinning_wheel')

    self.colliderSizes={} --collider widths and heights
    self.colliderSizes.furnace={w=19,h=8}
    self.colliderSizes.grill={w=19,h=8}
    self.colliderSizes.sawmill={w=19,h=8}
    self.colliderSizes.spinning_wheel={w=19,h=8}
end

function CraftingNodes:spawnCraftingNode(_type,_x,_y)
    local node={}

    function node:load()
        --collider and vectors
        self.collider=world:newBSGRectangleCollider(
            _x,_y, --position vectors
            CraftingNodes.colliderSizes[_type].w, --width
            CraftingNodes.colliderSizes[_type].h, --height
            3 --corner size
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

        --shadow
        self.shadow=CraftingNodes.shadows[_type]

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
        end
        
        self.currentAnim:update(dt) --animate

        --spawn an item 
        if self.state.craftProgress>0.7 then --takes ~0.7s to craft

            --choose a starting point around node for the item to spawn
            local startX=love.math.random(self.xPos-7,self.xPos+5)
            local startY=love.math.random(self.yPos-7,self.yPos+5)

            --spawn appropriate item, restart craft progress
            Items:spawn_item(startX,startY,self.item)
            self.state.craftProgress=0
        end

        --update crafting progress
        self.state.craftProgressPrev=self.state.craftProgress
    end

    function node:draw()
        self.shadow:draw(self.xPos,self.yPos) --draw shadow first

        --draw node
        self.currentAnim:draw(self.spriteSheet,self.xPos,self.yPos,nil,1,1,self.xOffset,self.yOffset)
    end

    --called by Player, increases craftProgress by time delta
    function node:nodeInteract()
        self.state.craftProgress=self.state.craftProgress+dt 
    end

    node:load()
end