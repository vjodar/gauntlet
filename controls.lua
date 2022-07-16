Controls={}

function Controls:load()     
    self.currentInputs={ --stores wether or not each input is currently pressed
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
    
    self.releasedInputs={ --stores wether or not each input has been released each frame
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

    --table of control mappings.
    self.keyMappings={ 
        --directions
        ['w']='dirUp',
        ['s']='dirDown',
        ['a']='dirLeft',
        ['d']='dirRight',

        --buttons
        -- ['kp8']='btnUp',
        -- ['kp5']='btnDown',
        -- ['kp4']='btnLeft',
        -- ['kp6']='btnRight',
        -- ['space']='btnStart',
        ['up']='btnUp',
        ['down']='btnDown',
        ['left']='btnLeft',
        ['right']='btnRight',
        ['space']='btnStart',
    }
end

function Controls:update()
    --check for any currently down (pressed) keyboard inputs
    --enforce that a key cannot be down and released at the same time
    for key,input in pairs(self.keyMappings) do
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
    if _k=='return' then love.load() end --easy restart for devs.
    -- if _k=='p' then Player:takeDamage('melee','pure',0,0,999) end
end
--testing----------------------