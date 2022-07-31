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
    btnSelect=false,
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
    btnSelect=false,
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
    btnSelect=false,
}

--table of keyboard control mappings.
controls.keyMappings={ 
    --directions
    dirLeft={'a','left'},
    dirRight={'d','right'},
    dirUp={'w','up'},
    dirDown={'s','down'},

    --buttons
    btnLeft={'j','kp4'},
    btnRight={'l','kp6'},
    btnUp={'i','kp8'},
    btnDown={'k','kp5'},
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