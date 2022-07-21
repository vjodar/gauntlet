controls={}
   
controls.downInputs={ --stores wether or not each input is currently down
    --directions
    dirUp=false,
    dirDown=false,
    dirLeft=false,
    dirRight=false,

    --buttons
    btnUp=false,
    btnDown=false,
    btnLeft=false,
    btnRight=false,
    btnStart=false,
}

controls.pressedInputs={ --stores wether or not each input is pressed for the first frame
    --directions
    dirUp=false,
    dirDown=false,
    dirLeft=false,
    dirRight=false,

    --buttons
    btnUp=false,
    btnDown=false,
    btnLeft=false,
    btnRight=false,
    btnStart=false,
}

controls.releasedInputs={ --stores wether or not each input has been released each frame
    --directions
    dirUp=false,
    dirDown=false,
    dirLeft=false,
    dirRight=false,

    --buttons
    btnUp=false,
    btnDown=false,
    btnLeft=false,
    btnRight=false,
    btnStart=false,
}

--table of keyboard control mappings.
controls.keyMappings={ 
    --directions
    dirLeft={'a'},
    dirRight={'d'},
    dirUp={'w'},
    dirDown={'s'},

    --buttons
    btnLeft={'left','kp4'},
    btnRight={'right','kp6'},
    btnUp={'up','kp8'},
    btnDown={'down','kp5'},
    btnStart={'space'},
}

--table of joystick control mappings
controls.btnMappings={ --buttons
    dirLeft={"dpleft"},
    dirRight={"dpright"},
    dirUp={"dpup"},
    dirDown={"dpdown"},

    btnLeft={"y"},
    btnRight={"a"},
    btnUp={"x"},
    btnDown={"b"},
    btnStart={"start"},
}
controls.axisMappings={ --analog sticks
    dirLeft={"leftx",'neg'},
    dirRight={"leftx",'pos'},
    dirUp={"lefty",'neg'},
    dirDown={"lefty",'pos'},
}
controls.joystick=nil --added joystick will be referenced here

--reads input from keyboard. If joystick is detected, read from it as well.
function controls:readInput()
    if self.joystick then return self:readKeyboardAndJoystick() end 

    --check for any currently down (pressed) keys
    --enforce that a key cannot be down and released at the same time
    for input,key in pairs(self.keyMappings) do
        if love.keyboard.isDown(key) and not self.releasedInputs[input] then 
            --if love.keyboard.isDown(key)==true and self.downInputs[input]==false,
            --then this was the first frame the key is down; it's just been pressed.
            --if both are true, then the key has been down last frame; it's not pressed
            self.pressedInputs[input]=not self.downInputs[input]
            self.downInputs[input]=true 
        else 
            --if downInputs[input]==true but love.keyboard.isDown(key)==false,
            --then we know the input was pressed last frame, but not anymore.
            --in otherwords it's a releasedInput.
            --so releasedInputs[input] is set to true when:
            --downInputs[input]==true and love.keyboard.isDown(key)==false
            self.releasedInputs[input]=self.downInputs[input]
            self.downInputs[input]=false
            self.pressedInputs[input]=false
        end
    end
end

--reads input from both keyboard and joystick
function controls:readKeyboardAndJoystick()
    for input,_ in pairs(self.downInputs) do
        local axisDown=false
        if self.axisMappings[input] then --check analog stick
            local axis=self.axisMappings[input][1]
            local sign=self.axisMappings[input][2]
            if sign=='pos' then axisDown=self.joystick:getGamepadAxis(axis)>0.5
            elseif sign=='neg' then axisDown=self.joystick:getGamepadAxis(axis)<-0.5
            end
        end
        local btnDown=self.joystick:isGamepadDown(self.btnMappings[input])
        if ( --check if either key, btn, or axis is down
            (love.keyboard.isDown(self.keyMappings[input]) or axisDown or btnDown)
            ) and not self.releasedInputs[input] --can't be both down and released
        then 
            self.pressedInputs[input]=not self.downInputs[input]
            self.downInputs[input]=true 
        else --releasedInputs are downInputs that aren't actually down
            self.releasedInputs[input]=self.downInputs[input]
            self.downInputs[input]=false
            self.pressedInputs[input]=false
        end
    end
end

--add the joytick to Controls if it doesn't already have a joystick
function love.joystickadded(_j)
    print("joystick added: ".._j:getName())    
    if not Controls.joystick then Controls.joystick=_j end 
end

--remove joystick from Controls
function love.joystickremoved(_j)
    print("joystick removed: ".._j:getName())
    if Controls.joystick then Controls.joystick=nil end 
end

--testing----------------------    
function love.keyreleased(_k)
    -- if _k=='escape' then love.event.quit() end --easy close for devs.
    if _k=='return' then love.load({keepSettings=true}) end --easy restart for devs.
    -- if _k=='p' then Player:takeDamage('melee','pure',0,0,999) end
end
--testing----------------------

return controls