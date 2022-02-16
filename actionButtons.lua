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

    -- --testing-------------------------------------------
    -- love.graphics.print(self.weapons.state.currentWeapon,0,200)
    -- love.graphics.print(self.supplies.state.currentSupply,0,210)
    -- love.graphics.print(self.protectionMagics.state.currentSpell,0,220)
    -- love.graphics.print(self.combatInteract.state.currentAction,0,230)
    -- --testing-------------------------------------------
end

--draw blank buttons beneath real buttons to have transparent icons functionality
function ActionButtons:drawBlankButtons()
    love.graphics.draw( --top button
        self.blank,
        love.graphics.getWidth()-60*windowScaleX,
        love.graphics.getHeight()-70*windowScaleY,
        nil,windowScaleX,windowScaleY,0,0
    )
    love.graphics.draw( --bottom button
        self.blank,
        love.graphics.getWidth()-60*windowScaleX,
        love.graphics.getHeight()-30*windowScaleY,
        nil,windowScaleX,windowScaleY,0,0
    )
    love.graphics.draw( --left button
        self.blank,
        love.graphics.getWidth()-80*windowScaleX,
        love.graphics.getHeight()-50*windowScaleY,
        nil,windowScaleX,windowScaleY,0,0
    )
    love.graphics.draw( --right button
        self.blank,
        love.graphics.getWidth()-40*windowScaleX,
        love.graphics.getHeight()-50*windowScaleY,
        nil,windowScaleX,windowScaleY,0,0
    )
end

function ActionButtons:addActionButtonWeapons()
    local button={}

    --sprites and animations
    button.spriteSheet=love.graphics.newImage('assets/hud_action_weapons.png')
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
            if love.keyboard.isDown('a') then 
                button.buttonDuration=button.buttonDuration+dt 
            end 

            if releasedKey=='a' then 
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
        button.currentAnim:draw(
            button.spriteSheet,
            love.graphics.getWidth()-60*windowScaleX,
            love.graphics.getHeight()-70*windowScaleY,
            nil,windowScaleX,windowScaleY,0,0
        )
    end

    return button 
end

function ActionButtons:addActionButtonSupplies()
    local button={}

    --sprites and animations
    button.spriteSheet=love.graphics.newImage('assets/hud_action_supplies.png')
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
            if love.keyboard.isDown('z') then 
                button.buttonDuration=button.buttonDuration+dt 
            end 

            if releasedKey=='z' then 
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
        button.currentAnim:draw(
            button.spriteSheet,
            love.graphics.getWidth()-80*windowScaleX,
            love.graphics.getHeight()-50*windowScaleY,
            nil,windowScaleX,windowScaleY,0,0
        )
    end

    return button 
end

function ActionButtons:addActionButtonProtectionMagics()
    local button={}

    --sprites and animations
    button.spriteSheet=love.graphics.newImage('assets/hud_action_protection_magics.png')
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
            if love.keyboard.isDown('s') then 
                button.buttonDuration=button.buttonDuration+dt 
            end 

            if releasedKey=='s' then 
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
        button.currentAnim:draw(
            button.spriteSheet,
            love.graphics.getWidth()-40*windowScaleX,
            love.graphics.getHeight()-50*windowScaleY,
            nil,windowScaleX,windowScaleY,0,0
        )
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
        --     if love.keyboard.isDown('x') then 
        --         button.buttonDuration=button.buttonDuration+dt 
        --     end 

        --     if releasedKey=='x' then 
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
            love.graphics.getWidth()-60*windowScaleX,
            love.graphics.getHeight()-30*windowScaleY,
            nil,windowScaleX,windowScaleY,0,0
        )
    end

    --sets nodeNearPlayer state to _bool. Called be Player
    function button:setNodeNearPlayer(_bool) button.state.nodeNearPlayer=_bool end

    return button 
end