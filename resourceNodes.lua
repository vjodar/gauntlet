ResourceNodes={}

function ResourceNodes:add_tree(_x,_y) 
    local node={}

    function node:load() 
        --setup collider and position vectors
        self.collider=world:newRectangleCollider(_x,_y,14,6)
        self.xPos, self.yPos = self.collider:getPosition()
        self.collider:setType('static')
        self.collider:setCollisionClass('resourceNode')
        self.collider:setObject(self) --attach collider to this object

        --sprites
        self.sprite=love.graphics.newImage('assets/tree.png')
        self.spriteDepleted=love.graphics.newImage('assets/tree_depleted.png')
        self.spriteTool=love.graphics.newImage('assets/tool_hatchet.png')
        self.spriteParticle=love.graphics.newImage('assets/tree_particle.png')
        self.spriteShake=0

        --particles
        self.particles=love.graphics.newParticleSystem(self.spriteParticle,100)
        self.particles:setParticleLifetime(0.5,1) --particles live 0.5s - 1s
        self.particles:setSpeed(100,200) --min and max speed
        self.particles:setLinearDamping(10) --'friction'
        self.particles:setLinearAcceleration(0,100,0,200) --min and max acceleration
        self.particles:setDirection(1.6)
        self.particles:setSpread(2*math.pi) --particles will spread 360degrees
        self.particles:setEmissionArea('ellipse',3,5) 
        self.particles:setRotation(0,math.pi*2)

        --node state metatable
        self.state={}
        self.state.resources=3 --available resources to give
        self.state.depleted=false
        self.state.harvestProgress=0 
        self.state.harvestProgressPrev=self.state.harvestProgress
        self.state.beingHarvested=false 

        table.insert(Entities.entitiesTable,self)
    end

    function node:update() 
        if self.state.harvestProgressPrev~=self.state.harvestProgress then 
            self.state.beingHarvested=true 
        else
            self.state.beingHarvested=false
        end

        if self.state.harvestProgress>1.5 then --takes ~1.5s to harvest
            --spawn appropriate item, restart harvest progress
            Items:spawn_item(self.xPos,self.yPos,'tree_wood')
            self.state.harvestProgress=0

            --after spawning item, reduce available resources by 1
            --update depleted state when resources are 0
            self.state.resources=self.state.resources-1
            if self.state.resources==0 then self.state.depleted=true end 
        end

        self.particles:update(dt) --update particle system

        self.spriteShake=0 --spriteShake defaults to 0

        --use sine wave funtion to syncronize shaking and particle emission
        --with hatchet hit
        --only shake and emit particles if node is actively being harvested
        if (math.sin(self.state.harvestProgress*14)>0.9) and self.state.beingHarvested then 
            if Player.state.facing=='right' then
                 self.spriteShake=1
            else --player is facing left
                self.spriteShake=-1
            end
            self.particles:emit(1) --shoot out particles
        end

        --once depleted, change collision class to prevent further harvesting
        if self.state.depleted==true then 
            self.collider:setCollisionClass('depletedNode')
        end

        --update harvestProgressPrev
        self.state.harvestProgressPrev=self.state.harvestProgress
    end

    function node:draw() 
        if self.state.depleted then 
            love.graphics.draw(self.spriteDepleted,self.xPos,self.yPos,nil,1,1,7,22)
        else 
            love.graphics.draw(
                self.sprite,self.xPos+self.spriteShake,self.yPos,nil,1,1,7,22
            )
            if self.state.beingHarvested==true then self:animateHatchet() end
        end
        love.graphics.draw(self.particles,self.xPos,self.yPos-12)
    end

    function node:harvestResource()
        self.state.harvestProgress=self.state.harvestProgress+dt
    end

    --draws and animates the hatchet sprite when node is being harvested
    function node:animateHatchet()
        if Player.state.facing=='right' then 
            love.graphics.draw( --animate hatchet swing to the right
                self.spriteTool,
                --draw the hatchet between the player and node
                (self.xPos+Player.xPos)/2-6,(self.yPos+Player.yPos)/2,
                math.sin(self.state.harvestProgress*14)*0.9,
                1,1,8,18
            )
        else --player is facing left
            love.graphics.draw( --animate hatchet swing to the left
                self.spriteTool,
                --draw the hatchet between the player and node
                (self.xPos+Player.xPos)/2+6,(self.yPos+Player.yPos)/2,
                math.sin(self.state.harvestProgress*14+math.pi)*0.9,
                -1,1,8,18
            )
        end
    end

    node:load()
end 

function ResourceNodes:add_rock(_x,_y) 
    local node={}

    function node:load() 
        --setup collider and position vectors
        self.collider=world:newRectangleCollider(_x,_y,16,9)
        self.xPos, self.yPos = self.collider:getPosition()
        self.collider:setType('static')
        self.collider:setCollisionClass('resourceNode')
        self.collider:setObject(self) --attach collider to this object

        --sprites
        self.sprite=love.graphics.newImage('assets/rock.png')
        self.spriteTool=love.graphics.newImage('assets/tool_pickaxe.png')
        self.spriteDepleted=love.graphics.newImage('assets/rock_depleted.png')
        self.spriteParticle=love.graphics.newImage('assets/rock_particle.png')
        self.spriteShake=0

        --particles
        self.particles=love.graphics.newParticleSystem(self.spriteParticle,100)
        self.particles:setParticleLifetime(0.5,1) --particles live 1 to 2 sec
        self.particles:setSpeed(50,100) --min and max speed
        self.particles:setLinearDamping(1) --'friction'
        self.particles:setLinearAcceleration(0,100)
        self.particles:setDirection(4.7) --particles will shoot upward
        self.particles:setSpread(1.5) --particles will spread 90degrees
        self.particles:setRotation(0,2*math.pi) --particles will be rotated randomly

        --node state metatable
        self.state={}
        self.state.resources=3 --available resources to give
        self.state.depleted=false 
        self.state.harvestProgress=0
        self.state.harvestProgressPrev=self.state.harvestProgress
        self.state.beingHarvested=false 

        table.insert(Entities.entitiesTable,self)
    end

    function node:update() 
        if self.state.harvestProgressPrev~=self.state.harvestProgress then 
            self.state.beingHarvested=true 
        else
            self.state.beingHarvested=false
        end

        if self.state.harvestProgress>1.5 then --takes ~1.5s to harvest
            --spawn appropriate item, restart harvest progress
            Items:spawn_item(self.xPos,self.yPos,'rock_ore')
            self.state.harvestProgress=0 --reset harvestProgress

            --after spawning item, reduce available resources by 1
            --update depleted state when resources are 0
            self.state.resources=self.state.resources-1
            if self.state.resources==0 then self.state.depleted=true end 
        end

        self.particles:update(dt) --update particle systems

        self.spriteShake=0 --spriteShake defaults to 0

        --uses sine wave function to syncronize shaking and particle emission
        --with pickaxe swings
        --only shake and emit particles if node is actively being harvested
        if (math.sin(self.state.harvestProgress*14)>0.9) and self.state.beingHarvested then 
            if Player.state.facing=='right' then
                 self.spriteShake=1
            else --player is facing left
                self.spriteShake=-1
            end
            self.particles:emit(1) --emit particles
        end

        --once depleted, change collision class to prevent further harvesting
        if self.state.depleted==true then 
            self.collider:setCollisionClass('depletedNode')
        end

        --update harvestProgressPrev
        self.state.harvestProgressPrev=self.state.harvestProgress
    end

    function node:draw() 
        if self.state.depleted==true then 
            love.graphics.draw(self.spriteDepleted,self.xPos,self.yPos,nil,1,1,8,7.5)
        else 
            love.graphics.draw(
                self.sprite,
                self.xPos+self.spriteShake,self.yPos,
                nil,1,1,8,7.5)
            if self.state.beingHarvested==true then self:animatePickaxe() end
        end
        --draw particles
        love.graphics.draw(self.particles,self.xPos,self.yPos)
    end

    function node:harvestResource()
        self.state.harvestProgress=self.state.harvestProgress+dt
    end

    --Draws and animates the pickaxe sprite when this node is being harvested
    function node:animatePickaxe()
        if Player.state.facing=='right' then 
            love.graphics.draw( --animate pickaxe swing to the right
                self.spriteTool,
                --draw pickaxe between the player and node
                (self.xPos+Player.xPos)/2-6,(self.yPos-5 + Player.yPos)/2,
                math.sin(self.state.harvestProgress*14),
                1,1,8,16
            )
        else --player is facing left
            love.graphics.draw( --animate pickaxe swing to the left
                self.spriteTool,
                --draw the pickaxe between the player and node
                (self.xPos + Player.xPos)/2+6,(self.yPos-5 + Player.yPos)/2,
                math.sin(self.state.harvestProgress*14+math.pi),
                1,1,8,16
            )
        end
    end

    node:load()
end 

function ResourceNodes:add_vine(_x,_y) 
    local node={}

    function node:load() 
        --setup collider and position vectors
        self.collider=world:newBSGRectangleCollider(_x,_y,16,32,4)
        self.xPos, self.yPos = self.collider:getPosition()
        self.collider:setType('static')
        self.collider:setCollisionClass('resourceNode')
        self.collider:setObject(self) --attach collider to this object

        --sprites
        self.sprite=love.graphics.newImage('assets/vine.png')
        self.spriteDepleted=love.graphics.newImage('assets/vine_depleted.png')
        self.spriteParticle=love.graphics.newImage('assets/vine_particle.png')

        --particles
        self.particles=love.graphics.newParticleSystem(self.spriteParticle,100)
        self.particles:setParticleLifetime(0.5,1.5) --particles live 0.5s - 1.5s
        self.particles:setLinearDamping(1) --'friction'
        self.particles:setLinearAcceleration(0,20,0,50) --min and max acceleration
        self.particles:setSpeed(0,20)
        self.particles:setSpread(2*math.pi) --particles will spread 360degrees
        self.particles:setEmissionArea('uniform',8,16) 
        self.particles:setRotation(0,math.pi*2)
        self.particles:setRelativeRotation(true) --particles will rotate as they speed up

        --node state metatable
        self.state={}
        self.state.resources=3 --available resources to give
        self.state.depleted=false 
        self.state.harvestProgress=0
        self.state.harvestProgressPrev=self.state.harvestProgress 
        self.state.beingHarvested=false 

        table.insert(Entities.entitiesTable,self)
    end

    function node:update() 
        if self.state.harvestProgressPrev~=self.state.harvestProgress then 
            self.state.beingHarvested=true 
        else
            self.state.beingHarvested=false
        end

        if self.state.harvestProgress>1.5 then --takes ~1.5s to harvest
            --spawn appropriate item, restart harvest progress
            Items:spawn_item(self.xPos,self.yPos,'vine_fiber')
            self.state.harvestProgress=0
            self.particles:emit(10) --emit particles

            --after spawning item, reduce available resources by 1
            --update depleted state when resources are 0
            self.state.resources=self.state.resources-1
            if self.state.resources==0 then self.state.depleted=true end 
        end

        self.particles:update(dt) --update particles

        --once depleted, change collision class to prevent further harvesting
        if self.state.depleted==true then 
            self.collider:setCollisionClass('depletedNode')
        end

        --update harvestProgressPrev
        self.state.harvestProgressPrev=self.state.harvestProgress
    end

    function node:draw() 
        if self.state.depleted==true then 
            love.graphics.draw(self.spriteDepleted,self.xPos,self.yPos,nil,1,1,8,16) 
        else
            if self.state.beingHarvested then 
                love.graphics.draw(
                    self.sprite,self.xPos,self.yPos,nil,
                    --animate by oscillating x,y stretching and y-offset
                    1.1+math.sin(self.state.harvestProgress*7+math.pi)*0.1,
                    1.1+math.sin(self.state.harvestProgress*7)*0.05,
                    8,16-(1.1+math.sin(self.state.harvestProgress*7))
                )
            else
                love.graphics.draw(self.sprite,self.xPos,self.yPos,nil,1,1,8,16)
            end
        end
        --draw particles
        love.graphics.draw(self.particles,self.xPos,self.yPos)
    end

    function node:harvestResource()
        self.state.harvestProgress=self.state.harvestProgress+dt
        -- print(self.state.harvestProgress)
    end

    node:load()
end 

function ResourceNodes:add_fungi(_x,_y) 
    local node={}

    function node:load() 
        --setup collider and position vectors
        self.collider=world:newRectangleCollider(_x,_y,6,6)
        self.xPos, self.yPos = self.collider:getPosition()
        self.collider:setType('static')
        self.collider:setCollisionClass('resourceNode')
        self.collider:setObject(self) --attach collider to this object

        --sprites
        self.sprite=love.graphics.newImage('assets/fungi.png')
        self.spriteDepleted=love.graphics.newImage('assets/fungi_depleted.png')
        self.spriteParticle=love.graphics.newImage('assets/fungi_particle.png')

        --particles
        self.particles=love.graphics.newParticleSystem(self.spriteParticle,100)
        self.particles:setParticleLifetime(1,3) --particles live 1s - 3s
        self.particles:setLinearDamping(4) --'friction'
        self.particles:setSpeed(50,100) --min and max speed
        self.particles:setDirection(4.7) --particles will shoot upward
        self.particles:setSpread(4.7) --particles will spread 270degrees
        self.particles:setEmissionArea('uniform',8,7) --particles will spawn throughout sprite
        self.particles:setRotation(0,math.pi*2) --360 degree rotation
        self.particles:setRelativeRotation(true) --particles will rotate as they speed up

        --node state metatable
        self.state={}
        self.state.depleted=false 
        self.state.resources=1 --amount of resource items to give
        self.state.harvestProgress=0
        self.state.harvestProgressPrev=self.state.harvestProgress
        self.state.beingHarvested=false 

        table.insert(Entities.entitiesTable,self)
    end

    function node:update() 

        if self.state.harvestProgressPrev~=self.state.harvestProgress then 
            self.state.beingHarvested=true 
        else
            self.state.beingHarvested=false
        end

        if self.state.harvestProgress>1.5 then --takes ~1.5s to harvest
            --spawn appropriate item, restart harvest progress
            Items:spawn_item(self.xPos,self.yPos,'fungi_mushroom')
            self.state.harvestProgress=0
            self.particles:emit(20) --emit particles

            --after spawning item, reduce available resources by 1
            --update depleted state when resources are 0
            self.state.resources=self.state.resources-1
            if self.state.resources==0 then self.state.depleted=true end 
        end

        self.particles:update(dt) --update particles

        --once depleted, change collision class to prevent further harvesting
        if self.state.depleted==true then 
            self.collider:setCollisionClass('depletedNode')
        end

        --update harvestProgressPrev
        self.state.harvestProgressPrev=self.state.harvestProgress
    end

    function node:draw() 
        if self.state.depleted==true then 
            love.graphics.draw(self.spriteDepleted,self.xPos,self.yPos,nil,1,1,8,8)
        else
            if self.state.beingHarvested then 
                love.graphics.draw(
                    self.sprite,self.xPos,self.yPos,nil,
                    --animate by oscillating x,y stretching and y-offset
                    1.1+math.sin(self.state.harvestProgressPrev*7+math.pi)*0.25,
                    1.1+math.sin(self.state.harvestProgressPrev*7)*0.25,
                    8,8+(1.1+math.sin(self.state.harvestProgressPrev*7))
                )
            else
                love.graphics.draw(self.sprite,self.xPos,self.yPos,nil,1,1,8,8)
            end
        end 
        --draw particles
        love.graphics.draw(self.particles,self.xPos,self.yPos)
    end

    --this function is called through world queries done by the player
    function node:harvestResource()
        --increment current harvestProgress
        self.state.harvestProgress=self.state.harvestProgress+dt
    end

    node:load()
end 

function ResourceNodes:add_fishing_hole(_x,_y) 
    local node={}

    function node:load() 
        --setup collider and position vectors
        self.collider=world:newBSGRectangleCollider(_x,_y,16,8,2)
        self.xPos, self.yPos = self.collider:getPosition()
        self.collider:setType('static')
        self.collider:setCollisionClass('resourceNode')
        self.collider:setObject(self) --attach collider to this object

        --sprites and animations
        self.spriteSheet=love.graphics.newImage('assets/fishing_hole.png')
        self.spriteSheetTool=love.graphics.newImage('assets/tool_harpoon.png')
        --  animation grid for fishing hole
        self.grid=anim8.newGrid(16,9,self.spriteSheet:getWidth(),self.spriteSheet:getHeight())
        --  animation grid for harpoon
        self.gridTool=anim8.newGrid(7,26,self.spriteSheetTool:getWidth(),self.spriteSheetTool:getHeight())
        self.animations={}
        self.animations.fishing_hole=anim8.newAnimation(self.grid('1-4',1), 0.15)
        self.animations.tool_harpoon=anim8.newAnimation(self.gridTool('1-20',1), 0.05)
        self.spriteDepleted=love.graphics.newImage('assets/fishing_hole_depleted.png')
        self.spriteParticle=love.graphics.newImage('assets/fishing_hole_particle.png')

        --particles
        self.particles=love.graphics.newParticleSystem(self.spriteParticle,100)
        self.particles:setParticleLifetime(0.4,0.8) --particles live 0.4s - 0.8s
        self.particles:setLinearDamping(4) --'friction'
        self.particles:setSpeed(50,100) --min and max speed
        self.particles:setLinearAcceleration(-10,100,10,100) --min and max x,y acceleration
        self.particles:setDirection(4.7) --particles will shoot upward
        self.particles:setSpread(1.5) --particles will spread 90degrees
        self.particles:setEmissionArea('uniform',4,4) --particles will spawn throughout sprite
        self.particles:setRotation(0,math.pi*2) --360 degree rotation
        self.particles:setRelativeRotation(true) --particles will rotate as they speed up

        --node state metatable
        self.state={}
        self.state.resources=3 --available resources to give
        self.state.depleted=false 
        self.state.harvestProgress=0
        self.state.harvestProgressPrev=self.state.harvestProgress
        self.state.beingHarvested=false 

        table.insert(Entities.entitiesTable,self)
    end

    function node:update() 
        --update fishing hole and harpoon animations unless the node is depleted
        if self.state.depleted==false then 
            self.animations.fishing_hole:update(dt) 
            self.animations.tool_harpoon:update(dt)
        end 

        if self.state.harvestProgressPrev~=self.state.harvestProgress then 
            self.state.beingHarvested=true 
        else
            self.state.beingHarvested=false
        end

        if self.state.harvestProgress>1.5 then --takes ~1.5s to harvest
            --spawn appropriate item, restart harvest progress
            Items:spawn_item(self.xPos,self.yPos,'fish_raw')
            self.state.harvestProgress=0

            --after spawning item, reduce available resources by 1
            --update depleted state when resources are 0
            self.state.resources=self.state.resources-1
            if self.state.resources==0 then self.state.depleted=true end 
        end

        --emit constant pulse of particles when node is being harvested
        if self.state.beingHarvested and math.sin(self.state.harvestProgress*14)>0.9 then 
            self.particles:emit(1) 
        end 

        self.particles:update(dt) --update particles

        --once depleted, change collision class to prevent further harvesting
        if self.state.depleted==true then 
            self.collider:setCollisionClass('depletedNode')
        end

        --update harvestProgressPrev
        self.state.harvestProgressPrev=self.state.harvestProgress
    end

    function node:draw() 
        if self.state.depleted==true then 
            love.graphics.draw(self.spriteDepleted,self.xPos,self.yPos,nil,1,1,8,3)
        else 
            self.animations.fishing_hole:draw(self.spriteSheet,self.xPos,self.yPos,nil,1,1,8,3)
            if self.state.beingHarvested then 
                --draw harpoon animation
                self.animations.tool_harpoon:draw(
                    self.spriteSheetTool,
                    self.xPos,self.yPos+2,
                    --rotate sprite to tilt harpoon handle toward player
                    (Player.xPos-self.xPos)*0.05,
                    1,1,3,28
                )
            end
        end
        --draw particles
        love.graphics.draw(self.particles,self.xPos,self.yPos)
    end

    function node:harvestResource()
        self.state.harvestProgress=self.state.harvestProgress+dt
    end

    node:load()
end 
