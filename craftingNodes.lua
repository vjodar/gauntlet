CraftingNodes={}

function CraftingNodes:load()
    self.sprites={} --stores sprites
    self.sprites.furnace=love.graphics.newImage('assets/demon_t3.png')
    self.sprites.grill=love.graphics.newImage('assets/demon_t3.png')
    self.sprites.sawmill=love.graphics.newImage('assets/demon_t3.png')
    self.sprites.spinning_wheel=love.graphics.newImage('assets/demon_t3.png')

    self.particles={} --particle sprites

    self.grids={} --animation grids
    self.grids.furnace=anim8.newGrid(
        32,32,self.sprites.furnace:getWidth(),self.sprites.furnace:getHeight()
    )
    self.grids.grill=anim8.newGrid(
        32,32,self.sprites.grill:getWidth(),self.sprites.grill:getHeight()
    )
    self.grids.sawmill=anim8.newGrid(
        32,32,self.sprites.sawmill:getWidth(),self.sprites.sawmill:getHeight()
    )
    self.grids.spinning_wheel=anim8.newGrid(
        32,32,self.sprites.spinning_wheel:getWidth(),self.sprites.spinning_wheel:getHeight()
    )

    self.items={} --items the crafting node will spawn
    self.items.furnace='rock_metal'
    self.items.grill='fish_cooked'
    self.items.sawmill='tree_planks'
    self.items.spinning_wheel='vine_thread'

    self.shadows={} --shadows
    self.shadows.furnace=Shadows:newShadow('large')
    self.shadows.grill=Shadows:newShadow('large')
    self.shadows.sawmill=Shadows:newShadow('large')
    self.shadows.spinning_wheel=Shadows:newShadow('large')

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
            4 --corner size
        )
        self.collider:setType('static')
        self.collider:setCollisionClass('craftingNode')
        self.collider:setObject(node)
        self.xPos,self.yPos=self.collider:getPosition()

        --sprites and animations
        node.spriteSheet=CraftingNodes.sprites[_type]
        node.grid=CraftingNodes.grids[_type]
        node.animation=anim8.newAnimation(self.grid('1-4',1), 0.1)

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

        --only animate when node is currently being harvested
        if self.state.craftProgressPrev==self.state.craftProgress then
            self.animation:pauseAtStart()
        else
            self.animation:resume()
        end
        
        self.animation:update(dt) --animate

        --spawn an item 
        if self.state.craftProgress>0.5 then --takes ~0.5s to craft

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
        self.animation:draw(self.spriteSheet,self.xPos,self.yPos,nil,1,1,16,29)
    end

    --called by Player, increases craftProgress by time delta
    function node:nodeInteract()
        self.state.craftProgress=self.state.craftProgress+dt 
    end

    node:load()
end