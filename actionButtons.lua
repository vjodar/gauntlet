ActionButtons={} --action button cluster on HUD

function ActionButtons:load()
    self.blank=love.graphics.newImage('assets/hud_action_blank.png') --blank button
    self.weapons=self:addActionButtonWeapons()
    self.supplies=self:addActionButtonSupplies()
    self.protectionMagics=self:addActionButtonProtectionMagics()
    self.combatInteract=self:addActionButtonCombatInteract()
end

function ActionButtons:update()
    self.weapons:update()
    self.supplies:update()
    self.protectionMagics:update()
    self.combatInteract:update()
end

function ActionButtons:draw()
    self:drawBlankButtons()
    self.weapons:draw()
    self.supplies:draw()
    self.protectionMagics:draw()
    self.combatInteract:draw()
end

--draw blank buttons beneath real buttons to have transparent icons functionality
function ActionButtons:drawBlankButtons()
    love.graphics.draw( --top button
        self.blank,
        love.graphics.getWidth()-60*WINDOWSCALE_X,
        love.graphics.getHeight()-70*WINDOWSCALE_Y,
        nil,WINDOWSCALE_X,WINDOWSCALE_Y,0,0
    )
    love.graphics.draw( --bottom button
        self.blank,
        love.graphics.getWidth()-60*WINDOWSCALE_X,
        love.graphics.getHeight()-30*WINDOWSCALE_Y,
        nil,WINDOWSCALE_X,WINDOWSCALE_Y,0,0
    )
    love.graphics.draw( --left button
        self.blank,
        love.graphics.getWidth()-80*WINDOWSCALE_X,
        love.graphics.getHeight()-50*WINDOWSCALE_Y,
        nil,WINDOWSCALE_X,WINDOWSCALE_Y,0,0
    )
    love.graphics.draw( --right button
        self.blank,
        love.graphics.getWidth()-40*WINDOWSCALE_X,
        love.graphics.getHeight()-50*WINDOWSCALE_Y,
        nil,WINDOWSCALE_X,WINDOWSCALE_Y,0,0
    )
end

function ActionButtons:addActionButtonWeapons()
    local button={}

    --sprites and animations
    button.spriteSheet={
        bow=love.graphics.newImage('assets/hud_action_weapons_bow.png'),
        staff=love.graphics.newImage('assets/hud_action_weapons_staff.png')
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
    button.buttonDuration=0 --used to differentiate between button taps and holds
    button.acceptInput=true --used to prevent player from pressing before animation ends.
    button.state={} --state metatable
    button.state.hasBow=true --player has a bow
    button.state.hasStaff=true --player has a staff
    button.state.currentWeapon='bow' --either 'bow' or 'staff'
    

    function button:update()
        button.currentAnim:update(dt)

        if acceptInput and button.acceptInput then --if gamestate and button are accepting input 
            if love.keyboard.isDown(controls.btnUp) then 
                button.buttonDuration=button.buttonDuration+dt 
            end 

            if releasedKey==controls.btnUp then 
                if button.buttonDuration<0.2 then --button tap
                    button.currentAnim:resume() --resume animation to go to next icon
                    button.acceptInput=false --won't accept input until animation is done
                    --TODO
                    --set current weapon to be opposite the one currently chosen
                    --TODO

                    --set timer to restore input accepting
                    TimerState:after(button.animationTime, function()
                        button.acceptInput=true 
                        --swap current weapons
                        if button.state.currentWeapon=='bow' then 
                            button.state.currentWeapon='staff'
                        else button.state.currentWeapon='bow' end 
                    end)
                    button.buttonDuration=0 --reset buttonDuration

                elseif button.buttonDuration>=0.2 then --button hold
                    --CURRENTLY NO BUTTON HOLD ACTIONS SET FOR THIS BUTTON
                    button.buttonDuration=0 --reset buttonDuration
                end
            end
        end
    end

    function button:draw()
        if Player.currentGear.weapons.bow=='bow_t0' then --reduce alpha when player has no bow
            love.graphics.setColor(1,1,1,0.7)
        end
        button.currentAnim:draw( --draw bow half
            button.spriteSheet.bow,
            love.graphics.getWidth()-60*WINDOWSCALE_X,
            love.graphics.getHeight()-70*WINDOWSCALE_Y,
            nil,WINDOWSCALE_X,WINDOWSCALE_Y,0,0
        )
        love.graphics.setColor(1,1,1,1) --restore alpha

        if Player.currentGear.weapons.staff=='staff_t0' then --reduce alpha when player has no staff
            love.graphics.setColor(1,1,1,0.7)
        end
        button.currentAnim:draw( --draw staff half
            button.spriteSheet.staff,
            love.graphics.getWidth()-60*WINDOWSCALE_X,
            love.graphics.getHeight()-70*WINDOWSCALE_Y,
            nil,WINDOWSCALE_X,WINDOWSCALE_Y,0,0
        )
        love.graphics.setColor(1,1,1,1) --restore alpha
    end

    return button 
end

function ActionButtons:addActionButtonSupplies()
    local button={}

    --sprites and animations
    button.spriteSheet={
        fish=love.graphics.newImage('assets/hud_action_supplies_fish.png'),
        potion=love.graphics.newImage('assets/hud_action_supplies_potion.png')
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
    button.buttonDuration=0 --used to differentiate between button taps and holds
    button.acceptInput=true --used to prevent player from pressing before animation ends.
    button.state={} --state metatable
    button.state.hasFish=true --player has a bow
    button.state.hasPotion=true --player has a staff
    button.state.currentSupply='fish' --either 'fish' or 'potion'
    

    function button:update()
        button.currentAnim:update(dt)

        if acceptInput and button.acceptInput then --if gamestate and button are accepting input 
            if love.keyboard.isDown(controls.btnLeft) then 
                button.buttonDuration=button.buttonDuration+dt 
            end 

            if releasedKey==controls.btnLeft then 
                if button.buttonDuration<0.2 then --button tap
                    button.currentAnim:resume() --resume animation to go to next icon
                    button.acceptInput=false --won't accept input until animation is done
                    --TODO
                    --set current supply to be opposite the one currently chosen
                    --TODO

                    --set timer to restore input accepting
                    TimerState:after(button.animationTime, function() 
                        button.acceptInput=true 
                        --swap current supply
                        if button.state.currentSupply=='fish' then 
                            button.state.currentSupply='potion'
                        else button.state.currentSupply='fish' end 
                    end)
                    button.buttonDuration=0 --reset buttonDuration

                elseif button.buttonDuration>=0.2 then --button hold
                    --TODO eat the fish/drink the potion
                    button.buttonDuration=0 --reset buttonDuration
                end
            end
        end
    end

    function button:draw()
        if Player.suppliesPouch.fish_cooked==0 then --reduce alpha when out of fish
            love.graphics.setColor(1,1,1,0.7)
        end
        button.currentAnim:draw( --draw fish half
            button.spriteSheet.fish,
            love.graphics.getWidth()-80*WINDOWSCALE_X,
            love.graphics.getHeight()-50*WINDOWSCALE_Y,
            nil,WINDOWSCALE_X,WINDOWSCALE_Y,0,0
        )
        love.graphics.setColor(1,1,1,1) --restore alpha

        if Player.suppliesPouch.potion==0 then --reduce alpha when out of potions
            love.graphics.setColor(1,1,1,0.7)
        end
        button.currentAnim:draw( --draw potion half
            button.spriteSheet.potion,
            love.graphics.getWidth()-80*WINDOWSCALE_X,
            love.graphics.getHeight()-50*WINDOWSCALE_Y,
            nil,WINDOWSCALE_X,WINDOWSCALE_Y,0,0
        )
        love.graphics.setColor(1,1,1,1) --restore alpha
    end

    return button 
end

function ActionButtons:addActionButtonProtectionMagics()
    local button={}

    --sprites and animations
    button.spriteSheet={
        physical=love.graphics.newImage('assets/hud_action_protection_physical.png'),
        magical=love.graphics.newImage('assets/hud_action_protection_magical.png')
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
    button.buttonDuration=0 --used to differentiate between button taps and holds
    button.acceptInput=true --used to prevent player from pressing before animation ends.
    button.state={} --state metatable
    button.state.currentSpell='protect physical' --either 'physical' or 'magical'
    

    function button:update()
        button.currentAnim:update(dt)

        if acceptInput and button.acceptInput then --if gamestate and button are accepting input 
            if love.keyboard.isDown(controls.btnRight) then 
                button.buttonDuration=button.buttonDuration+dt 
            end 

            if releasedKey==controls.btnRight then 
                if button.buttonDuration<0.2 then --button tap
                    button.currentAnim:resume() --resume animation to go to next icon
                    button.acceptInput=false --won't accept input until animation is done
                    --TODO
                    --set current spell to be opposite the one currently chosen
                    --TODO

                    --set timer to restore input accepting
                    TimerState:after(button.animationTime, function() 
                        button.acceptInput=true 
                        --swap current protection spell
                        if button.state.currentSpell=='protect physical' then 
                            button.state.currentSpell='protect magical'
                        else button.state.currentSpell='protect physical' end 
                    end)
                    button.buttonDuration=0 --reset buttonDuration

                elseif button.buttonDuration>=0.2 then --button hold
                    --TODO start/stop casting protection spell
                    button.buttonDuration=0 --reset buttonDuration
                end
            end
        end
    end

    function button:draw()
        --TODO-------------------------------
        --set reduced alpha when player is all out of mana
        --love.graphics.setColor(1,1,1,0.7)
        --TODO-------------------------------
        button.currentAnim:draw( --draw physical half
            button.spriteSheet.physical,
            love.graphics.getWidth()-40*WINDOWSCALE_X,
            love.graphics.getHeight()-50*WINDOWSCALE_Y,
            nil,WINDOWSCALE_X,WINDOWSCALE_Y,0,0
        )
        button.currentAnim:draw( --draw magical half
            button.spriteSheet.magical,
            love.graphics.getWidth()-40*WINDOWSCALE_X,
            love.graphics.getHeight()-50*WINDOWSCALE_Y,
            nil,WINDOWSCALE_X,WINDOWSCALE_Y,0,0
        )
        love.graphics.setColor(1,1,1,1) --restore alpha
    end

    return button 
end

function ActionButtons:addActionButtonCombatInteract()
    local button={}

    --sprites and animations
    button.spriteSheet=love.graphics.newImage('assets/hud_action_combat_interact.png')
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
    button.buttonDuration=0 --used to differentiate between button taps and holds
    button.acceptInput=true --used to prevent player from pressing before animation ends.
    button.state={} --state metatable
    button.state.isAnimating=false --used to prevent button from switching until animation ends
    button.state.nodeNearPlayer=false --is the player near a resource/crafting node
    button.state.currentAction='combat' --either 'combat' or 'interact'
    

    function button:update()
        button.currentAnim:update(dt)

        -- if acceptInput and button.acceptInput then --if gamestate and button are accepting input 
        --     if love.keyboard.isDown(contros.btnDown) then 
        --         button.buttonDuration=button.buttonDuration+dt 
        --     end 

        --     if releasedKey==controls.btnDown then 
        --         if button.buttonDuration<0.2 then --button tap
        --             button.currentAnim:resume() --resume animation to go to next icon
        --             button.acceptInput=false --won't accept input until animation is done

        --             --set timer to restore input accepting
        --             TimerState:after(button.animationTime, function() button.acceptInput=true end)
        --             button.buttonDuration=0 --reset buttonDuration

        --         elseif button.buttonDuration>=0.2 then --button hold
        --             --TODO engage/disengae combat or interact with resource/crafting nodes
        --             button.buttonDuration=0 --reset buttonDuration
        --         end
        --     end
        -- end

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
        button.currentAnim:draw(
            button.spriteSheet,
            love.graphics.getWidth()-60*WINDOWSCALE_X,
            love.graphics.getHeight()-30*WINDOWSCALE_Y,
            nil,WINDOWSCALE_X,WINDOWSCALE_Y,0,0
        )
    end

    --sets nodeNearPlayer state to _bool. Called be Player
    function button:setNodeNearPlayer(_bool) button.state.nodeNearPlayer=_bool end

    return button 
end