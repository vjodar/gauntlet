Player={}

function Player:load()
    --setup player's physics collider and position, velocity vectors
    self.collider=world:newBSGRectangleCollider(0,0,12,5,3)
    self.xPos, self.yPos=self.collider:getPosition()
    self.xVel, self.yVel=self.collider:getLinearVelocity()
    self.collider:setLinearDamping(20) --apply increased 'friction'
    self.collider:setFixedRotation(true) --collider won't spin/rotate
    self.collider:setCollisionClass('player')
    self.collider:setRestitution(0)
    self.collider:setObject(self) --attach collider to this object
    self.moveSpeed=2400 --40 at 60fps
    self.moveSpeedDiag=self.moveSpeed*0.3
    self.scaleX=1 --used to flip sprites horizontally

    --colliders that will be used for sprites that pop in and out of game (like weapons)
    --these colliders will be sensors until their associated sprites are drawn in the game
    self.collider:addShape('left','RectangleShape',self.xPos-14,self.yPos-2,8,4)
    self.collider.fixtures['left']:setSensor(true)
    self.collider:addShape('right','RectangleShape',self.xPos+2,self.yPos-2,8,4)
    self.collider.fixtures['right']:setSensor(true)
    self.collider:addShape(
        'magic','PolygonShape',
        self.xPos-21,self.yPos-3,
        self.xPos-12,self.yPos-6,
        self.xPos,self.yPos-6,
        self.xPos+9,self.yPos-3,
        self.xPos+9,self.yPos-1,
        self.xPos,self.yPos+2,
        self.xPos-12,self.yPos+2,
        self.xPos-21,self.yPos-1
    )
    self.collider.fixtures['magic']:setSensor(true)

    --manually set collider's mass to ignore added shapes/fixtures
    self.collider:setMass(0.09375)

    --sprites and animations
    self.spriteSheets={
        head_t0=love.graphics.newImage('assets/hero/armor_head_t0.png'),
        head_t1=love.graphics.newImage('assets/hero/armor_head_t1.png'),
        head_t2=love.graphics.newImage('assets/hero/armor_head_t2.png'),
        head_t3=love.graphics.newImage('assets/hero/armor_head_t3.png'),
        chest_t0=love.graphics.newImage('assets/hero/armor_chest_t0.png'),
        chest_t1=love.graphics.newImage('assets/hero/armor_chest_t1.png'),
        chest_t2=love.graphics.newImage('assets/hero/armor_chest_t2.png'),
        chest_t3=love.graphics.newImage('assets/hero/armor_chest_t3.png'),
        legs_t0=love.graphics.newImage('assets/hero/armor_legs_t0.png'),
        legs_t1=love.graphics.newImage('assets/hero/armor_legs_t1.png'),
        legs_t2=love.graphics.newImage('assets/hero/armor_legs_t2.png'),
        legs_t3=love.graphics.newImage('assets/hero/armor_legs_t3.png'),

        bow_t1=love.graphics.newImage('assets/hero/weapon_bow_t1.png'),
        bow_t2=love.graphics.newImage('assets/hero/weapon_bow_t2.png'),
        bow_t3=love.graphics.newImage('assets/hero/weapon_bow_t3.png'),
        staff_t1=love.graphics.newImage('assets/hero/weapon_staff_t1.png'),
        staff_t2=love.graphics.newImage('assets/hero/weapon_staff_t2.png'),
        staff_t3=love.graphics.newImage('assets/hero/weapon_staff_t3.png'),

        fish_cooked=love.graphics.newImage('assets/items/fish_cooked.png'),
        potion=love.graphics.newImage('assets/items/potion.png'),

        health_particle=love.graphics.newImage('assets/hero/health_particle.png'),
        mana_particle=love.graphics.newImage('assets/hero/mana_particle.png'),
    }    
    self.grids={} --holds animation grids
    self.grids.armor=anim8.newGrid(
        16,22,self.spriteSheets.head_t0:getWidth(),
        self.spriteSheets.head_t0:getHeight()
    )
    self.grids.bow=anim8.newGrid(
        32,32,self.spriteSheets.bow_t1:getWidth(),
        self.spriteSheets.bow_t1:getHeight()
    )
    self.grids.staff=anim8.newGrid(
        16,48,self.spriteSheets.staff_t1:getWidth(),
        self.spriteSheets.staff_t1:getHeight()
    )
    self.animations={ --animations for each armor piece and tier
        idle=anim8.newAnimation(self.grids.armor('1-4',1), 0.1),
        moving=anim8.newAnimation(self.grids.armor('5-8',1), 0.1),
        bow=anim8.newAnimation(
            self.grids.bow('1-9',1),0.075,
            --onLoop function
            function()
                Projectiles:launch( --at the end of animation, launch projectile
                    self.xPos+(self.scaleX*8),self.yPos,
                    self.equippedWeapon,self.combatData.currentEnemy
                )
                self.animations.bow:pauseAtStart() 
            end
        ),        
        staff=anim8.newAnimation(
            self.grids.staff('1-16',1),0.0375,
            --onLoop function
            function()                  
                Projectiles:launch( --at the end of animation, launch projectile
                    self.xPos+(self.scaleX*7),self.yPos,
                    self.equippedWeapon,self.combatData.currentEnemy
                )
                self.animations.staff:pauseAtStart() 
            end
        )
    }
    --immediately pause attack animations
    self.animations.bow:pause()
    self.animations.staff:pause() 
    --used to swap between character moving and idle animations
    self.currentAnim=self.animations.idle

    self.shadow=Shadows:newShadow('medium')  --shadow
    
    self.inventory={
        arcane_shards=0, 
        broken_bow=0,
        broken_staff=0,
        arcane_orb=0,
        arcane_bowstring=0,
        tree_wood=0,
        rock_ore=0,
        vine_fiber=0,
        fungi_mushroom=0,
        fish_raw=0,
        rock_metal=0,
        tree_planks=0,
        vine_thread=0,

        armor_head_t1=0,
        armor_head_t2=0,
        armor_head_t3=0,
        armor_chest_t1=0,
        armor_chest_t2=0,
        armor_chest_t3=0,
        armor_legs_t1=0,
        armor_legs_t2=0,
        armor_legs_t3=0,

        weapon_bow_t1=0,
        weapon_bow_t2=0,
        weapon_bow_t3=0,
        weapon_staff_t1=0,
        weapon_staff_t2=0,
        weapon_staff_t3=0
    }

    self.suppliesPouch={
        fish_cooked=0,
        potion=0
    }

    --currently equipped weapons and armor, used mainly for easy draw()
    self.currentGear={ 
        weapons={bow='bow_t0',staff='staff_t0'},
        armor={head='head_t0',chest='chest_t0',legs='legs_t0'}
    }

    --what weapon the player will attack with when entering combat
    --updated by weapons actionButton and updateCurrentGear()
    self.equippedWeapon='bow_t0'

    self.dialog=Dialog:newDialogSystem() --dialog system

    --system that manages the floating symbols when using protection magics
    self.protectionMagics=ProtectionMagics:newProtectionMagicSystem()

    self.suppliesData={ --data related to consuming supplies
        consuming={ --true when currently consuming fish/potion
            fish=false,
            potion=false
        },
        yOffsetFish=0,
        yOffsetPotion=0,
        oscillation=0, --used to increase/decrease offsets with sin()        
        --true for attackCooldown (1.35) seconds after start of consuming a supply.
        --this is to delay attacking after consuming a fish or potion.
        consumingCooldown=false
    }

    self.particleSystems={} --holds all particle systems

    --particle system for restoring health
    self.particleSystems.health=love.graphics.newParticleSystem(self.spriteSheets.health_particle,100)    
    self.particleSystems.health:setParticleLifetime(0.6)
    self.particleSystems.health:setLinearAcceleration(-50,-50,50,-200)
    self.particleSystems.health:setEmissionArea('uniform',9,4)  
    self.particleSystems.health:setSizes(0.5,1,0)

    --particle system for restoring mana
    self.particleSystems.mana=love.graphics.newParticleSystem(self.spriteSheets.mana_particle,100)    
    self.particleSystems.mana:setParticleLifetime(1)
    self.particleSystems.mana:setLinearAcceleration(0,-10,0,-20)
    self.particleSystems.mana:setEmissionArea('uniform',11,9)
    self.particleSystems.mana:setSizes(0,1,0)

    --'metatable' containing info of the player's current state
    self.state={}
    self.state.facing='right'
    self.state.moving=false
    self.state.movingHorizontally=false 
    self.state.isNearNode=false 
    self.state.protectionActivated=false --true when protection magics activated

    self.combatData={} --combat related data
    self.combatData.inCombat=false 
    self.combatData.currentEnemy=nil --current combat target
    self.combatData.prevEnemies={} --holds previously targeted enemies
    self.combatData.prevEnemiesLimit=6 
    self.combatData.attackOnCooldown=false --true when awaiting for cooldown between attacks
    self.combatData.attackCooldownTime=1.35 --time in sec between attacks

    --health and mana
    self.health={
        max=100,
        current=100
    }
    self.mana={
        max=100,
        current=100
    }

    table.insert(Entities.entitiesTable,self)
end

function Player:update()
    --update position and velocity vectors
    self.xPos, self.yPos=self.collider:getPosition()
    self.xVel, self.yVel=self.collider:getLinearVelocity()
    
    --default movement states to idle
    self.state.moving=false 
    self.state.movingHorizontally=false 

    --default sprite colliders to be sensors (have no collision)
    self.collider.fixtures[self.state.facing]:setSensor(true)

    --update scaleX
    if self.state.facing=='left' then self.scaleX=-1 else self.scaleX=1 end       
    
    --Only accept inputs when currently on top of state stack
    if acceptInput then 
        self:move()
        if self.combatData.inCombat then
            self:fightEnemy()
        else 
            --query for interactables with not in combat
            self:queryInteractables() 
        end
    end

    --set current animation based on self.state
    if self.state.moving==true then 
        self.currentAnim=self.animations.moving 
    else --defaults to idle animation
        self.currentAnim=self.animations.idle 
    end

    --animate appropriate supply when player is consuming a fish/potion
    if self.suppliesData.consuming.fish_cooked then 
        self.suppliesData.oscillation=self.suppliesData.oscillation+dt*4
        self.suppliesData.yOffsetFish=-40*math.sin(1.4*self.suppliesData.oscillation)
    elseif self.suppliesData.consuming.potion then 
        self.suppliesData.oscillation=self.suppliesData.oscillation+dt*4
        self.suppliesData.yOffsetPotion=-40*math.sin(1.4*self.suppliesData.oscillation)
    end

    self.currentAnim:update(dt) --update animation 
    self.animations.bow:update(dt)
    self.animations.staff:update(dt)
    self.dialog:update() --update dialog system
    for i,p in pairs(self.particleSystems) do p:update(dt) end --update particle systems
end

function Player:draw()
    --draw shadow before sprite
    self.shadow:draw(self.xPos,self.yPos)
    
    --draw the appropriate current animation for each armor piece
    self.currentAnim:draw(
        self.spriteSheets[self.currentGear.armor.head],
        self.xPos,self.yPos,nil,self.scaleX,1,8,20
    )
    self.currentAnim:draw(
        self.spriteSheets[self.currentGear.armor.chest],
        self.xPos,self.yPos,nil,self.scaleX,1,8,20
    )
    self.currentAnim:draw(
        self.spriteSheets[self.currentGear.armor.legs],
        self.xPos,self.yPos,nil,self.scaleX,1,8,20
    )

    --draw weapon when attacking, if player has a bow or staff and isn't 
    --currenlty consuming a fish or potion
    if not self.suppliesData.consumingCooldown then 
        if self.combatData.inCombat and 
            (self.equippedWeapon=='bow_t1' 
            or self.equippedWeapon=='bow_t2'
            or self.equippedWeapon=='bow_t3')
        then 
            self.animations.bow:draw(
                self.spriteSheets[self.equippedWeapon],
                self.xPos,self.yPos,nil,self.scaleX,1,5,23
            )
        elseif self.combatData.inCombat and 
            (self.equippedWeapon=='staff_t1' 
            or self.equippedWeapon=='staff_t2'
            or self.equippedWeapon=='staff_t3')
        then 
            self.animations.staff:draw(
                self.spriteSheets[self.equippedWeapon],
                self.xPos-8+8*self.scaleX,self.yPos-46
            )
        end
    end

    --draw fish/potion when consuming
    if self.suppliesData.consuming.fish_cooked then 
        love.graphics.draw(
            self.spriteSheets.fish_cooked,self.xPos-6,
            self.yPos-14+self.suppliesData.yOffsetFish
        )
    elseif self.suppliesData.consuming.potion then 
        love.graphics.draw(
            self.spriteSheets.potion,self.xPos-5,
            self.yPos-14+self.suppliesData.yOffsetPotion
        )
    end

    --draw particles for each particle system
    for i,p in pairs(self.particleSystems) do
        love.graphics.draw(p,self.xPos,self.yPos-10)
    end
end

function Player:move()
    if love.keyboard.isDown(controls.dirLeft) then 
        --can't move left and right at the same time
        if not love.keyboard.isDown(controls.dirRight) then 
            self.xVel=self.xVel-self.moveSpeed*dt
            self.state.facing='left'
            self.state.moving=true
            self.state.movingHorizontally=true
        end
    end
    if love.keyboard.isDown(controls.dirRight) then 
        --can't move left and right at the same time
        if not love.keyboard.isDown(controls.dirLeft) then 
            self.xVel=self.xVel+self.moveSpeed*dt 
            self.state.facing='right'
            self.state.moving=true
            self.state.movingHorizontally=true
        end
    end
    if love.keyboard.isDown(controls.dirUp) then 
        --accomodate for diagonal speed
        if self.state.movingHorizontally then 
            self.yVel=self.yVel-self.moveSpeedDiag*dt
        else            
            self.yVel=self.yVel-self.moveSpeed*dt
        end 
        self.state.moving=true
    end
    if love.keyboard.isDown(controls.dirDown) then 
        --accomodate for diagonal speed
        if self.state.movingHorizontally then 
            self.yVel=self.yVel+self.moveSpeedDiag*dt
        else            
            self.yVel=self.yVel+self.moveSpeed*dt
        end 
        self.state.moving=true
    end

    --apply updated velocities to collider
    self.collider:setLinearVelocity(self.xVel,self.yVel)
end

--Query the world for any nearby resource nodes. If there is one nearby,
--set HUD combatInteract action button to show player that they can interact with it.
--if player presses the action button, call node's nodeInteract() function to
--harvest resources / craft items / open or reveal adjascent rooms
function Player:queryInteractables()
    local nodeColliders=world:queryRectangleArea(
        self.xPos-11,self.yPos-6,22,12, --where to query
        {'resourceNode','doorButton','craftingNode','ladder'} --what to query for
    )
    if #nodeColliders>0 then --found a resource node
        --gets the resourceNode object attached to the collider
        local nearbyNode=nodeColliders[1]:getObject()

        --set combatInteract button state to update sprite 
        ActionButtons.combatInteract:setNodeNearPlayer(true)

        if love.keyboard.isDown(controls.btnDown) then 
            --face player toward that node
            if nearbyNode.xPos<self.xPos then self.state.facing='left' 
            else self.state.facing='right' end

            --interact with node by calling its 'nodeInteract' function
            nearbyNode:nodeInteract()
        end
    else
        --set combatInteract button state to update sprite 
        ActionButtons.combatInteract:setNodeNearPlayer(false)
    end 
end

--Called by items when they collide with player
--increments the amount of an item in the player's inventory as well as in the HUD
function Player:addToInventory(_item,_amount)
    
    if _item=='fish_cooked' or _item=='potion' then --add supplies to supply pouch
        self.suppliesPouch[_item]=self.suppliesPouch[_item]+_amount

    --add armor
    elseif _item=='armor_head_t1' or _item=='armor_head_t2' or _item=='armor_head_t3'
        or _item=='armor_chest_t1' or _item=='armor_chest_t2' or _item=='armor_chest_t3'
        or _item=='armor_legs_t1' or _item=='armor_legs_t2' or _item=='armor_legs_t3'
        or _item=='weapon_bow_t1' or _item=='weapon_bow_t2' or _item=='weapon_bow_t3'
        or _item=='weapon_staff_t1' or _item=='weapon_staff_t2' or _item=='weapon_staff_t3'
    then 
        self.inventory[_item]=self.inventory[_item]+_amount
        self:updateCurrentGear() --update current gear to reflect newly obtained gear

    else --all other items get added to inventory and HUD        
        self.inventory[_item]=self.inventory[_item]+_amount
        Inventory:addItem(_item,_amount)
    end
end

--decreasee the amount of an item in player's inventory and the HUD by an amount
function Player:removeFromInventory(_item,_amount)
    if _item=='fish_cooked' or _item=='potion' then 
        self.suppliesPouch[_item]=self.suppliesPouch[_item]-_amount
        return
    end

    self.inventory[_item]=self.inventory[_item]-_amount
    
    --if _item is a weapon or armor, update the current gear to reflect the removal
    if _item=='armor_head_t1' or _item=='armor_head_t2' or _item=='armor_head_t3'
    or _item=='armor_chest_t1' or _item=='armor_chest_t2' or _item=='armor_chest_t3'
    or _item=='armor_legs_t1' or _item=='armor_legs_t2' or _item=='armor_legs_t3'
    or _item=='weapon_bow_t1' or _item=='weapon_bow_t2' or _item=='weapon_bow_t3'
    or _item=='weapon_staff_t1' or _item=='weapon_staff_t2' or _item=='weapon_staff_t3'
    then 
        self:updateCurrentGear()
    else --otherwise, update the HUD
        Inventory:removeItem(_item,_amount) --remove an item count from the HUD inventory
    end
end

--update currently equipped weapons and armor to be the highest tier gear the player owns
function Player:updateCurrentGear()
    --update head armor
    if self.inventory['armor_head_t3']>0 then self.currentGear.armor.head='head_t3'
    elseif self.inventory['armor_head_t2']>0 then self.currentGear.armor.head='head_t2'
    elseif self.inventory['armor_head_t1']>0 then self.currentGear.armor.head='head_t1'
    else self.currentGear.armor.head='head_t0'
    end

    --update chest armor
    if self.inventory['armor_chest_t3']>0 then self.currentGear.armor.chest='chest_t3'
    elseif self.inventory['armor_chest_t2']>0 then self.currentGear.armor.chest='chest_t2'
    elseif self.inventory['armor_chest_t1']>0 then self.currentGear.armor.chest='chest_t1'
    else self.currentGear.armor.chest='chest_t0'
    end

    --update legs armor
    if self.inventory['armor_legs_t3']>0 then self.currentGear.armor.legs='legs_t3'
    elseif self.inventory['armor_legs_t2']>0 then self.currentGear.armor.legs='legs_t2'
    elseif self.inventory['armor_legs_t1']>0 then self.currentGear.armor.legs='legs_t1'
    else self.currentGear.armor.legs='legs_t0' 
    end

    --update bow weapon
    if self.inventory['weapon_bow_t3']>0 then self.currentGear.weapons.bow='bow_t3'
    elseif self.inventory['weapon_bow_t2']>0 then self.currentGear.weapons.bow='bow_t2'
    elseif self.inventory['weapon_bow_t1']>0 then self.currentGear.weapons.bow='bow_t1'
    else self.currentGear.weapons.bow='bow_t0'
    end

    --update staff weapon
    if self.inventory['weapon_staff_t3']>0 then self.currentGear.weapons.staff='staff_t3'
    elseif self.inventory['weapon_staff_t2']>0 then self.currentGear.weapons.staff='staff_t2'
    elseif self.inventory['weapon_staff_t1']>0 then self.currentGear.weapons.staff='staff_t1'
    else self.currentGear.weapons.staff='staff_t0'
    end

    --update equipped weapon
    self.equippedWeapon=self.currentGear.weapons[ActionButtons.weapons.state.currentWeapon]
end

--fight the currently targeted enemy
function Player:fightEnemy()
    --if enemy died, disengage combat
    if self.combatData.currentEnemy==nil then 
        self.combatData.inCombat=false
        self.animations.bow:pauseAtStart()
        self.animations.staff:pauseAtStart()
        camTarget=self 
        return 
    end

    --update camTarget to be the midpoint between player and enemy
    camTarget={
        xPos=((self.xPos+self.combatData.currentEnemy.xPos)*0.5),
        yPos=((self.yPos+self.combatData.currentEnemy.yPos)*0.5)
    }

    --if enemy is too far, disengage combat
    if math.abs(self.xPos-self.combatData.currentEnemy.xPos)>300
        or math.abs(self.yPos-self.combatData.currentEnemy.yPos)>200
    then 
        self.combatData.inCombat=false
        Player.combatData.prevEnemies={} --clear prevEnemies table
        self.combatData.currentEnemy.state.isTargetted=false
        self.combatData.currentEnemy=nil --remove currentEnemy from player data
        self.animations.bow:pauseAtStart() --reset attack animations
        self.animations.staff:pauseAtStart()
        camTarget=self
        return 
    end

    --face player toward enemy
    if self.combatData.currentEnemy.xPos>self.xPos then 
        self.state.facing='right' else self.state.facing='left'
    end

    --give the bow or staff sprite collision
    if self.equippedWeapon~='bow_t0' and self.equippedWeapon~='staff_t0' then 
        --set the shape to have collision
        self.collider.fixtures[self.state.facing]:setSensor(false)
    end

    --Check LOS. If any obstructions are between player and enemy,
    --reset attack animations, return
    if #world:queryLine(
        self.xPos,self.yPos,
        self.combatData.currentEnemy.xPos,self.combatData.currentEnemy.yPos,
        {'outerWall','innerWall','craftingNode'}
    )>0 then 
        self.animations.bow:pauseAtStart()
        self.animations.staff:pauseAtStart()
        return 
    end

    --if player is currently consuming a supply, delay attack by reseting animations
    if self.suppliesData.consumingCooldown then 
        self.animations.bow:pauseAtStart()
        self.animations.staff:pauseAtStart()
    end

    --Launch projectile toward target when attack is off cooldown and player
    --isn't currently consuming a fish or potion
    if not self.combatData.attackOnCooldown then 
        self.combatData.attackOnCooldown=true
        TimerState:after(self.combatData.attackCooldownTime,function() 
            self.combatData.attackOnCooldown=false
        end)

        self.animations[ActionButtons.weapons.state.currentWeapon]:resume()   
    end
end

function Player:consumeSupply(_supply)
    self.suppliesData.consuming[_supply]=true 
    TimerState:after(0.5,function()
        self.suppliesData.consuming[_supply]=false
        if _supply=='fish_cooked' then 
            self:updateHealthOrMana('health',20)
            self.particleSystems.health:emit(2)
            TimerState:after(0.1,function() self.particleSystems.health:emit(1) end)
            TimerState:after(0.2,function() self.particleSystems.health:emit(1) end)
            TimerState:after(0.3,function() self.particleSystems.health:emit(2) end)
        elseif _supply=='potion' then 
            self:updateHealthOrMana('mana',20)
            self.particleSystems.mana:emit(2)
            TimerState:after(0.1,function() self.particleSystems.mana:emit(2) end)
            TimerState:after(0.2,function() self.particleSystems.mana:emit(2) end)
            TimerState:after(0.3,function() self.particleSystems.mana:emit(2) end)
        end
        Player:removeFromInventory(_supply,1)
        self.suppliesData.oscillation=0 --reset oscillation
    end)
end

--updates the player's health or mana
function Player:updateHealthOrMana(_which,_val)
    if _which=='health' then 
        self.health.current=self.health.current+_val
        if self.health.current>self.health.max then 
            self.health.current=self.health.max 
        elseif self.health.current<=0 then 
            self.health.current=0
            Player.dialog:say("I'm dead")
        end
    elseif _which=='mana' then 
        self.mana.current=self.mana.current+_val 
        if self.mana.current>self.mana.max then 
            self.mana.current=self.mana.max  
        elseif self.mana.current<=0 then 
            self.mana.current=0
            Player.dialog:say('Out of mana')
        end
    end    
    Meters:updateMeterValues() --update the HUD
end

function Player:drawUIelements()
    self.dialog:draw(self.xPos,self.yPos) --draw dialog
end

--player takes some damage depending on the attackType(melee or projectile),
--damageType(physical or magical), knockback, and angle of the hit.
function Player:takeDamage(_attackType,_damageType,_knockback,_angle,_val)
    self:updateHealthOrMana('health',-_val)

    self.collider:applyLinearImpulse( --apply knockback
        math.cos(_angle)*_knockback*dt,math.sin(_angle)*_knockback*dt
    )
end
