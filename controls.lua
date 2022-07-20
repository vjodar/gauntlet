controls={}
   
controls.currentInputs={ --stores wether or not each input is currently pressed
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
    dirUp='w',
    dirDown='s',
    dirLeft='a',
    dirRight='d',

    --buttons
    btnUp='up',
    btnDown='down',
    btnLeft='left',
    btnRight='right',
    btnStart='space',
}

function controls:readInput()
    --check for any currently down (pressed) keys
    --enforce that a key cannot be down and released at the same time
    for input,key in pairs(self.keyMappings) do
        if love.keyboard.isDown(key) and not self.releasedInputs[input] then 
            self.currentInputs[input]=true 
        else 
            --if currentInputs[input]==true but love.keyboard.isDown(key)==false,
            --then we know the input was pressed last frame, but not anymore.
            --in otherwords it's a releasedInput.
            --so releasedInputs[input] is set to true when:
            --currentInputs[input]==true and love.keyboard.isDown(key)==false
            self.releasedInputs[input]=self.currentInputs[input]
            self.currentInputs[input]=false
        end
    end
end

--testing----------------------    
function love.keyreleased(_k)
    -- if _k=='escape' then love.event.quit() end --easy close for devs.
    if _k=='return' then love.load({keepSettings=true}) end --easy restart for devs.
    -- if _k=='p' then Player:takeDamage('melee','pure',0,0,999) end
end
--testing----------------------

return controls