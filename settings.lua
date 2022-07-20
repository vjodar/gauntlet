local settings={}

settings.safeStorage=require 'safeStorage'
settings.currentSettings=settings.safeStorage.readSettings() --'global' current settings

--resizes display, enters/exits fullscreen, rescales game assets appropriately
--sets volume levels for sound effects and music
--set control bindings
--all settings taken from currentSettings which is read and loaded from  
--'settings' file. After settings are applied, 'settings' file is rewritten
function settings:applyCurrentSettings()

    self:validateCurrentSettings() --first ensure settings are valid

    self:applyDisplaySettings() 
    --audio settings don't need to be applied; sounds generated 
    --read settings.currentSettings.sound/music directly
    self:applyControlsSettings()

    --finally save currentSettings to 'settings' file
    settings.safeStorage.writeSettings(self.currentSettings)
end

--validates the current settings to make sure they are valid values
--(useful for when the user changes settings directly from settings file)
function settings:validateCurrentSettings()
    --DISPLAY
    local currentDisplay=self.currentSettings.display
    --ensure resolution cap isn't being bypassed (i.e. by setting resolution
    --in one monitor, then applying settings in another.)
    --also ensure resolution isn't below 400x300 and is always 4x3 ratio
    local _,desktopH=love.window.getDesktopDimensions()
    local maxHeight=math.floor(desktopH/300)*300 
    currentDisplay.height=math.floor(currentDisplay.height/300)*300
    currentDisplay.height=math.max(300,currentDisplay.height)
    currentDisplay.height=math.min(maxHeight,currentDisplay.height)
    currentDisplay.width=currentDisplay.height*(4/3)

    --AUDIO
    local currentAudio=self.currentSettings.audio 
    --ensure audio values are integer values in range (0,100)
    currentAudio.sound=math.max(0,currentAudio.sound)
    currentAudio.sound=math.min(100,currentAudio.sound)
    currentAudio.sound=math.floor(currentAudio.sound)
    currentAudio.music=math.max(0,currentAudio.music)
    currentAudio.music=math.min(100,currentAudio.music)
    currentAudio.music=math.floor(currentAudio.music)

    --CONTROLS
    local currentControls=self.currentSettings.controls
    local defaults=self.safeStorage.defaultSettings()
    --ensure all control mappings are strings. If not, revert to default
    for input,key in pairs(currentControls.keyMappings) do 
        if type(key)~='string' then key=defaults.controls.keyMappings[input] end
    end
    for input,btn in pairs(currentControls.btnMappings) do 
        if type(btn)~='string' then btn=defaults.controls.btnMappings[input] end
    end
end

function settings:applyDisplaySettings()
    local _,_,flags=love.window.getMode() --gets index of current window
    love.window.setMode(
        self.currentSettings.display.width,self.currentSettings.display.height,
        {
            display=flags.display,
            fullscreen=self.currentSettings.display.isFullscreen,
            fullscreentype='exclusive',
        }
    )
    
    --resizing and rescaling game to match new display settings.
    WINDOW_WIDTH=love.graphics.getWidth()
    WINDOW_HEIGHT=love.graphics.getHeight()
    WINDOWSCALE_X=WINDOW_WIDTH/400 --1x scale per 400px width
    WINDOWSCALE_Y=WINDOW_HEIGHT/300 --1x scale per 300px width
    if cam~=nil then cam:zoomTo((WINDOWSCALE_X*0.5)+(WINDOWSCALE_Y*0.5)) end
end

function settings:applyControlsSettings()
    --set keyboard bindinds
    for input,key in pairs(Controls.keyMappings) do 
        Controls.keyMappings[input]=self.currentSettings.controls.keyMappings[input]
    end
    
    --set joystick bindings
    -- for input,btn in pairs(Controls.btnMappings) do 
    --     Controls.btnMappings[input]=self.currentSettings.controls.btnMappings[input]
    -- end
end

return settings 
