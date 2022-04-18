ActionButtons={} --action button cluster on HUD

function ActionButtons:load()
    --pressed and unpressed blank buttons
    self.blankUp=love.graphics.newImage('assets/hud/action_buttons/hud_action_blank_up.png')
    self.blankDown=love.graphics.newImage('assets/hud/action_buttons/hud_action_blank_down.png')
    --create and store action buttons
    self.weapons=self:addActionButtonWeapons()
    self.supplies=self:addActionButtonSupplies()
    self.protectionMagics=self:addActionButtonProtectionMagics()
    self.combatInteract=self:addActionButtonCombatInteract()

    self.hideActionButtons=false --used to not draw the action buttons
end

function ActionButtons:update()
    self.weapons:update()
    self.supplies:update()
    self.protectionMagics:update()
    self.combatInteract:update()
end

function ActionButtons:draw()
    if self.hideActionButtons==false then 
        self.weapons:draw()
        self.supplies:draw()
        self.protectionMagics:draw()
        self.combatInteract:draw()
    end
end

function ActionButtons:addActionButtonWeapons()
    local button={}

    --sprites and animations
    button.blankSprite={self.blankUp,self.blankDown} --[1]=up sprite,[2]=down sprite
    button.spriteSheet={
        bow=love.graphics.newImage('assets/hud/action_buttons/hud_action_weapons_bow.png'),
        staff=love.graphics.newImage('assets/hud/action_buttons/hud_action_weapons_staff.png')
    }
    button.grid=anim8.newGrid(24,24,button.spriteSheet.bow:getWidth(),button.spriteSheet.bow:getHeight())
    button.animations={}
    button.animations.forward=anim8.newAnimation(
        button.grid('1-19',1), 0.015,
        function() --onLoop function
            button.currentAnim=button.animations.backward 
            button.currentAnim:pauseAtStart()
        end
    )
    button.animations.backward=anim8.newAnimation(
        button.grid('19-1',1), 0.015,
        function() --onLoop function
            button.currentAnim=button.animations.forward 
            button.currentAnim:pauseAtStart()
        end
    )
    button.currentAnim=button.animations.forward
    button.currentAnim:pause() --immediately pause animation until input is read
    button.animationTime=0.285 --time it takes for animation to finish (19*0.025s)

    --button data
    button.state={} --state metatable
    button.state.acceptInput=true --used to prevent player from pressing before animation ends.
    button.state.currentWeapon='bow' --either 'bow' or 'staff'
    button.state.pressedFlag=0 --1/0 boolean, not true false.
    

    function button:update()
        button.currentAnim:update(dt)

        button.state.pressedFlag=0 --default to not being pressed
        if acceptInput then
            if love.keyboard.isDown(controls.btnUp) then 
                button.state.pressedFlag=1
            end 

            if button.state.acceptInput and releasedKey==controls.btnUp then
                button.currentAnim:resume() --resume animation to go to next icon
                button.state.acceptInput=false --won't accept input until animation is done

                --set timer to restore input accepting
                TimerState:after(button.animationTime, function()
                    button.state.acceptInput=true 
                    --swap current weapons
                    if button.state.currentWeapon=='bow' then 
                        button.state.currentWeapon='staff'
                    else 
                        button.state.currentWeapon='bow' 
                    end 
                    --update player's equipped weapon type
                    Player.equippedWeapon=Player.currentGear.weapons[button.state.currentWeapon]
                    --reset player weapon animations
                    Player.animations.bow:gotoFrame(1)
                    Player.animations.staff:gotoFrame(1)
                end)
            end
        end
    end

    function button:draw()
        --draw blank button        
        love.graphics.draw(
            self.blankSprite[1+button.state.pressedFlag], --draw blankSprite[2] when pressed
            love.graphics.getWidth()-60*WINDOWSCALE_X,
            --draw 1px (scaled) lower when button is currently pressed
            love.graphics.getHeight()-70*WINDOWSCALE_Y+button.state.pressedFlag*WINDOWSCALE_Y,
            nil,WINDOWSCALE_X,WINDOWSCALE_Y
        )

        --draw icons
        if Player.currentGear.weapons.bow=='bow_t0' then --reduce alpha when player has no bow
            love.graphics.setColor(1,1,1,0.7)
        end
        button.currentAnim:draw( --draw bow half
            button.spriteSheet.bow,
            love.graphics.getWidth()-60*WINDOWSCALE_X,
            --draw 1px (scaled) lower when button is currently pressed
            love.graphics.getHeight()-70*WINDOWSCALE_Y+button.state.pressedFlag*WINDOWSCALE_Y,
            nil,WINDOWSCALE_X,WINDOWSCALE_Y,0,0
        )
        love.graphics.setColor(1,1,1,1) --restore alpha

        if Player.currentGear.weapons.staff=='staff_t0' then --reduce alpha when player has no staff
            love.graphics.setColor(1,1,1,0.7)
        end
        button.currentAnim:draw( --draw staff half
            button.spriteSheet.staff,
            love.graphics.getWidth()-60*WINDOWSCALE_X,
            --draw 1px (scaled) lower when button is currently pressed
            love.graphics.getHeight()-70*WINDOWSCALE_Y+button.state.pressedFlag*WINDOWSCALE_Y,
            nil,WINDOWSCALE_X,WINDOWSCALE_Y,0,0
        )
        love.graphics.setColor(1,1,1,1) --restore alpha
    end

    return button 
end

function ActionButtons:addActionButtonSupplies()
    local button={}

    --sprites and animations
    button.blankSprite={self.blankUp,self.blankDown} --[1]=up sprite,[2]=down sprite
    button.spriteSheet={
        fish=love.graphics.newImage('assets/hud/action_buttons/hud_action_supplies_fish.png'),
        potion=love.graphics.newImage('assets/hud/action_buttons/hud_action_supplies_potion.png')
    }
    button.grid=anim8.newGrid(24,24,button.spriteSheet.fish:getWidth(),button.spriteSheet.fish:getHeight())
    button.animations={}
    button.animations.forward=anim8.newAnimation(
        button.grid('1-19',1), 0.015,
        function() --onLoop function
            button.currentAnim=button.animations.backward 
            button.currentAnim:pauseAtStart()
        end
    )
    button.animations.backward=anim8.newAnimation(
        button.grid('19-1',1), 0.015,
        function() --onLoop function
            button.currentAnim=button.animations.forward 
            button.currentAnim:pauseAtStart()
        end
    )
    button.currentAnim=button.animations.forward
    button.currentAnim:pause() --immediately pause animation until input is read
    button.animationTime=0.285 --time it takes for animation to finish (19*0.025s)

    --button data
    button.state={} --state metatable
    button.state.buttonDuration=0 --used to differentiate between button taps and holds
    button.state.acceptInput=true --used to prevent player from pressing before animation ends.
    button.state.hasFish=true --player has a bow
    button.state.hasPotion=true --player has a staff
    button.state.currentSupply='fish' --either 'fish' or 'potion'
    button.state.pressedFlag=0 --1/0 boolean
    

    function button:update()
        button.currentAnim:update(dt)

        button.state.pressedFlag=0 --deafult to not pressed
        if acceptInput then --if gamestate and button are accepting input 
            if love.keyboard.isDown(controls.btnLeft) then 
                button.state.pressedFlag=1
                if button.state.acceptInput then --only increase duration when button is accepting input
                    button.state.buttonDuration=button.state.buttonDuration+dt 
                end
            end 

            if button.state.acceptInput and button.state.buttonDuration>=0.3 then --button hold
                --TODO----------------------------------------------
                --consume fish or potion                
                --TODO----------------------------------------------

                --after button hold, don't listen for any more holds until after 0.3s                
                button.state.acceptInput=false
                TimerState:after(0.3,function() button.state.acceptInput=true end)
            end

            if releasedKey==controls.btnLeft then
                if button.state.acceptInput and button.state.buttonDuration<0.3 then --button tap
                    button.currentAnim:resume() --resume animation to go to next icon
                    button.state.acceptInput=false --won't accept input until animation is done
                    
                    --set timer to restore input accepting
                    TimerState:after(button.animationTime, function() 
                        button.state.acceptInput=true 
                        --swap current supply
                        if button.state.currentSupply=='fish' then 
                            button.state.currentSupply='potion'
                        else button.state.currentSupply='fish' end 
                        --TODO
                        --set player's current supply to be opposite the one currently chosen
                        --TODO
                    end)
                    button.state.buttonDuration=0 --reset buttonDuration
                else 
                    --buttonDuration<0.3 but button is not accepting input;
                    --this was the release after a button hold, not a button tap.
                    button.state.buttonDuration=0
                end
            end
        else --playState no longer accepts input; reset buttonDuration to prevent bugs
            button.state.buttonDuration=0 
        end
    end

    function button:draw()
        --draw blank button
        
        love.graphics.draw( --left button
            self.blankSprite[1+button.state.pressedFlag], --draw blankSprite[2] when pressed
            love.graphics.getWidth()-80*WINDOWSCALE_X,
            --draw 1px (scaled) lower when button is currently pressed
            love.graphics.getHeight()-50*WINDOWSCALE_Y+button.state.pressedFlag*WINDOWSCALE_Y,
            nil,WINDOWSCALE_X,WINDOWSCALE_Y,0,0
        )
        if Player.suppliesPouch.fish_cooked==0 then --reduce alpha when out of fish
            love.graphics.setColor(1,1,1,0.7)
        end
        button.currentAnim:draw( --draw fish half
            button.spriteSheet.fish,
            love.graphics.getWidth()-80*WINDOWSCALE_X,
            --draw 1px (scaled) lower when button is currently pressed
            love.graphics.getHeight()-50*WINDOWSCALE_Y+button.state.pressedFlag*WINDOWSCALE_Y,
            nil,WINDOWSCALE_X,WINDOWSCALE_Y,0,0
        )
        love.graphics.setColor(1,1,1,1) --restore alpha

        if Player.suppliesPouch.potion==0 then --reduce alpha when out of potions
            love.graphics.setColor(1,1,1,0.7)
        end
        button.currentAnim:draw( --draw potion half
            button.spriteSheet.potion,
            love.graphics.getWidth()-80*WINDOWSCALE_X,
            --draw 1px (scaled) lower when button is currently pressed
            love.graphics.getHeight()-50*WINDOWSCALE_Y+button.state.pressedFlag*WINDOWSCALE_Y,
            nil,WINDOWSCALE_X,WINDOWSCALE_Y,0,0
        )
        love.graphics.setColor(1,1,1,1) --restore alpha
    end

    return button 
end

function ActionButtons:addActionButtonProtectionMagics()
    local button={}

    --sprites and animations
    button.blankSprite={self.blankUp,self.blankDown} --[1]=up sprite,[2]=down sprite
    button.spriteSheet={
        physical=love.graphics.newImage('assets/hud/action_buttons/hud_action_protection_physical.png'),
        magical=love.graphics.newImage('assets/hud/action_buttons/hud_action_protection_magical.png')
    }
    button.grid=anim8.newGrid(24,24,button.spriteSheet.physical:getWidth(),button.spriteSheet.physical:getHeight())
    button.animations={}
    button.animations.forward=anim8.newAnimation(
        button.grid('1-19',1), 0.015,
        function() --onLoop function
            button.currentAnim=button.animations.backward 
            button.currentAnim:pauseAtStart()
        end
    )
    button.animations.backward=anim8.newAnimation(
        button.grid('19-1',1), 0.015,
        function() --onLoop function
            button.currentAnim=button.animations.forward 
            button.currentAnim:pauseAtStart()
        end
    )
    button.currentAnim=button.animations.forward
    button.currentAnim:pause() --immediately pause animation until input is read
    button.animationTime=0.285 --time it takes for animation to finish (19*0.025s)

    --button data
    button.state={} --state metatable
    button.state.buttonDuration=0 --used to differentiate between button taps and holds
    button.state.acceptInput=true --used to prevent player from pressing before animation ends.
    button.state.currentSpell='protect physical' --either 'physical' or 'magical'
    button.state.pressedFlag=0 --1/0 boolean, not true false.
    

    function button:update()
        button.currentAnim:update(dt)

        button.state.pressedFlag=0 --default to not pressed
        if acceptInput then 
            if love.keyboard.isDown(controls.btnRight) then 
                button.state.pressedFlag=1
                if button.state.acceptInput then --only increase duration when button is pressed
                    button.state.buttonDuration=button.state.buttonDuration+dt 
                end
            end 

            if button.state.acceptInput and button.state.buttonDuration>=0.3 then --button HOLD
                --TODO-----------------------
                --Start/Stop casting protection spell
                --TODO-----------------------
                
                --after button hold, don't listen for any more holds until 0.3s
                button.state.acceptInput=false 
                TimerState:after(0.3,function() button.state.acceptInput=true end)
            end

            if releasedKey==controls.btnRight  then --only change items when button accepts input
                if button.state.acceptInput and button.state.buttonDuration<0.3 then 
                    button.currentAnim:resume() --resume animation to go to next icon
                    button.state.acceptInput=false --won't accept input until animation is done
                    --TODO
                    --set current spell to be opposite the one currently chosen
                    --TODO
                    
                    --set timer to restore input accepting
                    TimerState:after(button.animationTime, function() 
                        button.state.acceptInput=true 
                        --swap current protection spell
                        if button.state.currentSpell=='protect physical' then 
                            button.state.currentSpell='protect magical'
                        else button.state.currentSpell='protect physical' end 
                    end)
                    button.state.buttonDuration=0 --reset buttonDuration
                else 
                    --This is a release after a button HOLD, not a button TAP
                    button.state.buttonDuration=0
                end
            end
        else --playState no longer accepts input; reset buttonDuration to prevent bugs
            button.state.buttonDuration=0 
        end
    end

    function button:draw()
        love.graphics.draw( --draw blank button
            self.blankSprite[1+button.state.pressedFlag], --draw blankSprite[2] when pressed
            love.graphics.getWidth()-40*WINDOWSCALE_X,
            --draw 1px (scaled) lower when button is currently pressed
            love.graphics.getHeight()-50*WINDOWSCALE_Y+button.state.pressedFlag*WINDOWSCALE_Y,
            nil,WINDOWSCALE_X,WINDOWSCALE_Y,0,0
        )
        --TODO-------------------------------
        --set reduced alpha when player is all out of mana
        --love.graphics.setColor(1,1,1,0.7)
        --TODO-------------------------------
        button.currentAnim:draw( --draw physical half
            button.spriteSheet.physical,
            love.graphics.getWidth()-40*WINDOWSCALE_X,
            --draw 1px (scaled) lower when button is currently pressed
            love.graphics.getHeight()-50*WINDOWSCALE_Y+button.state.pressedFlag*WINDOWSCALE_Y,
            nil,WINDOWSCALE_X,WINDOWSCALE_Y,0,0
        )
        button.currentAnim:draw( --draw magical half
            button.spriteSheet.magical,
            love.graphics.getWidth()-40*WINDOWSCALE_X,
            --draw 1px (scaled) lower when button is currently pressed
            love.graphics.getHeight()-50*WINDOWSCALE_Y+button.state.pressedFlag*WINDOWSCALE_Y,
            nil,WINDOWSCALE_X,WINDOWSCALE_Y,0,0
        )
        love.graphics.setColor(1,1,1,1) --restore alpha
    end

    return button 
end

function ActionButtons:addActionButtonCombatInteract()
    local button={}

    --sprites and animations
    button.blankSprite={self.blankUp,self.blankDown} --[1]=up sprite,[2]=down sprite
    button.spriteSheet=love.graphics.newImage('assets/hud/action_buttons/hud_action_combat_interact.png')
    button.grid=anim8.newGrid(24,24,button.spriteSheet:getWidth(),button.spriteSheet:getHeight())
    button.animations={}
    button.animations.forward=anim8.newAnimation(
        button.grid('1-19',1), 0.015,
        function() --onLoop function
            button.currentAnim=button.animations.backward 
            button.currentAnim:pauseAtStart()
        end
    )
    button.animations.backward=anim8.newAnimation(
        button.grid('19-1',1), 0.015,
        function() --onLoop function
            button.currentAnim=button.animations.forward 
            button.currentAnim:pauseAtStart()
        end
    )
    button.currentAnim=button.animations.backward --default to combat until near interactable node
    button.currentAnim:pause() --immediately pause animation until input is read
    button.animationTime=0.285 --time it takes for animation to finish (19*0.025s)

    --button data
    button.state={}
    button.state.buttonDuration=0 --used to differentiate between button taps and holds
    button.state.acceptInput=true --used to suspend input for this button
    button.state.isAnimating=false --used to prevent button from switching until animation ends
    button.state.nodeNearPlayer=false --is the player near a resource/crafting node
    button.state.currentAction='combat' --either 'combat' or 'interact'
    button.state.pressedFlag=0 --1/0 boolean

    button.sortFn=function(e1,e2) --sorts enemies by distance to player in increasing order
        local e1x,e1y=e1:getPosition()
        local e2x,e2y=e2:getPosition()
        return ( --simple approximation of the pythagorean theorem
            (math.abs(Player.xPos-e1x)+math.abs(Player.yPos-e1y)) 
            < (math.abs(Player.xPos-e2x)+math.abs(Player.yPos-e2y))
        )
    end

    function button:update()
        button.currentAnim:update(dt)

        button.state.pressedFlag=0 --default to not pressed
        if acceptInput then 
            if love.keyboard.isDown(controls.btnDown) then 
                button.state.pressedFlag=1            
                button.state.buttonDuration=button.state.buttonDuration+dt

                if button.state.buttonDuration>=0.3 and button.state.acceptInput then --button HOLD
                    --if player is in combat; disengage
                    if Player.combatData.inCombat then 
                        Player.combatData.inCombat=false
                        Player.combatData.prevEnemies={} --clear prevEnemies table
                        Player.combatData.currentEnemy=nil --remove currentEnemy from player data
                        --reset player attack animation
                        Player.animations.bow:pauseAtStart()
                        Player.animations.staff:pauseAtStart()
                        camTarget=Player --restore camera to following player
                    end

                    --after a HOLD, don't listen for any more HOLDs until after 0.3s
                    button.state.acceptInput=false
                    TimerState:after(0.3,function() button.state.acceptInput=true end)
                end
            end 

            if releasedKey==controls.btnDown then 
                if button.state.buttonDuration<0.3 then --button TAP
                    --find a combat target for the player, is possible
                    Player.combatData.currentEnemy=self:getCombatTarget()
                                
                    button.state.buttonDuration=0 --reset buttonDuration
                else
                    --button was released with duration>=0.3 which means it was released
                    --after a HOLD; don't count at TAP
                    button.state.buttonDuration=0 
                end
            end
        else --playState no longer accepts input; reset buttonDuration to prevent bugs
            button.state.buttonDuration=0 
        end

        --if the player is near a resource/crafting node, switch to 'interact' but only if button
        --is currently in 'combat' state and button is not currently animating.
        if button.state.nodeNearPlayer 
        and button.state.currentAction=='combat' 
        and not button.state.isAnimating then
            button.currentAnim:resume()
            button.state.currentAction='interact'
            button.state.isAnimating=true 
            --set timer to make isAnimating false after animation time is complete
            TimerState:after(button.animationTime, function() button.state.isAnimating=false end)
        end

        --if the button is currently 'interact' and the player is not near a resource/crafting node,
        --switch back to 'combat'
        if not button.state.nodeNearPlayer 
        and button.state.currentAction=='interact' 
        and not button.state.isAnimating then
            button.currentAnim:resume()
            button.state.currentAction='combat'
            button.state.isAnimating=true 
            --set timer to make isAnimating false after animation time is complete
            TimerState:after(button.animationTime, function() button.state.isAnimating=false end)
        end
    end

    function button:draw()
        love.graphics.draw( --draw blank button
            self.blankSprite[1+button.state.pressedFlag], --draw blankSprite[2] when pressed
            love.graphics.getWidth()-60*WINDOWSCALE_X,
            --draw 1px (scaled) lower when button is currently pressed
            love.graphics.getHeight()-30*WINDOWSCALE_Y+button.state.pressedFlag*WINDOWSCALE_Y,
            nil,WINDOWSCALE_X,WINDOWSCALE_Y,0,0
        )
        button.currentAnim:draw(
            button.spriteSheet,
            love.graphics.getWidth()-60*WINDOWSCALE_X,
            --draw 1px (scaled) lower when button is currently pressed
            love.graphics.getHeight()-30*WINDOWSCALE_Y+button.state.pressedFlag*WINDOWSCALE_Y,
            nil,WINDOWSCALE_X,WINDOWSCALE_Y,0,0
        )
    end

    --sets nodeNearPlayer state to _bool. Called be Player
    function button:setNodeNearPlayer(_bool) button.state.nodeNearPlayer=_bool end

    --queries around the player for any enemies. If player isn't yet in combat,
    --sets the player's current target to be the closest enemy. If player is 
    --already in combat, switch to another enemy.
    function button:getCombatTarget()
        if self.state.currentAction=='combat' then
            local nearbyColliders=world:queryRectangleArea( --query for enemies
                Player.xPos-200,Player.yPos-150,400,300,{'enemy'}
            )
            if #nearbyColliders>0 then 
                --sort by distance to player
                table.sort(nearbyColliders,self.sortFn)
            else 
                if not Player.combatData.inCombat then
                    --not in combat and no enemies nearby, return nil
                    Player.dialog:say('No enemies nearby')
                    return nil 
                end
            end

            if not Player.combatData.inCombat then
                --pass nearest enemy to the Player
                Player.combatData.inCombat=true
                return nearbyColliders[1]:getObject()
            end 

            --player is already in combat, switch to next target, if availble
            if Player.combatData.inCombat and #nearbyColliders>1 then 
                local switch=nil --stores the enemy to switch to

                --Using the prevEnemies table, we can construct a 'history' of targeted
                --and when they were targeted in relation to each other by comparing 
                --their elements and positions to those of our queried nearbyColliders.

                --First we update the prevEnemies table, being sure to limit its size
                table.insert(
                    Player.combatData.prevEnemies,
                    Player.combatData.currentEnemy.collider --be sure to store collider
                )
                if #Player.combatData.prevEnemies>Player.combatData.prevEnemiesLimit then
                    table.remove(Player.combatData.prevEnemies,1) --remove oldest first
                end

                --Basically checks if an enemy was previously targeted and switches to next closest.
                --If that other one was targeted before the last, switch to yet another, and so on.
                --When the prevEnemies table fully matches the nearbyColliders in both element and
                --position, clear the prevEnemies table and rollback over to target the nearest.
                for i,e in pairs(nearbyColliders) do
                    if #Player.combatData.prevEnemies<i then switch=e break end
                    if e~=Player.combatData.prevEnemies[i] then 
                        if e==Player.combatData.currentEnemy.collider then --prevent duplicates
                            switch=nearbyColliders[i+1] break 
                        else switch=e break end 
                    end
                end
                if switch==nil then
                    Player.combatData.prevEnemies={} --clear prevEnemies table
                    switch=nearbyColliders[1] --'rollback' and target the closest enemy
                end 

                return switch:getObject() --return the enemy object (not collider)
            
            elseif #nearbyColliders<=1 then 
                --either the player is already targeting the only nearby enemy
                --or there is no nearby enemy but player is already in combat (which
                --can happen due to query area being smaller than disengage distance)
                return Player.combatData.currentEnemy --remain fighting the same enemy
            end
        end
    end

    return button 
end
