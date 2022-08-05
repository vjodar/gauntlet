controls={}

local function defaultInputs() --defines all possible inputs
    return {
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
        btnSelect=false, 
    }
end

--tables that stores what inputs are down, pressed, or released during a given frame
controls.downInputs=defaultInputs()
controls.pressedInputs=defaultInputs()
controls.releasedInputs=defaultInputs()

--table of keyboard control mappings.
controls.keyMappings={ 
    --directions
    dirLeft={'a','left'},
    dirRight={'d','right'},
    dirUp={'w','up'},
    dirDown={'s','down'},

    --buttons
    btnLeft={'j','kp4','z'},
    btnRight={'l','kp6','v'},
    btnUp={'i','kp8','x'},
    btnDown={'k','kp5','c'},
    btnStart={'space'},
    btnSelect={'return'},
}

function controls:readInput()

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

return controls