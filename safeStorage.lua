local ss={}

ss.Serialize=require('libraries/knife.serialize')

function ss.defaultSettings()
    return {
        --display settings
        isFullscreen=false,
        width=800,
        height=600,

        --audio settings
        sound=100,
        music=100,

        --controls settings
        ['w']='dirUp',
        ['s']='dirDown',
        ['a']='dirLeft',
        ['d']='dirRight',
    }
end

--create and store a default settings file. Used when no settings file is
--detected on the system or when the settings file has been tampered with
--and is otherwise invalid.
function ss.resetSettings()
    local data=ss.defaultSettings()
    local serializedData=ss.Serialize(data)
    love.filesystem.write('settings',serializedData)
end

--takes a settings table and writes it to a file named 'settings'
function ss.writeSettings(_settingsTable)
    local data=_settingsTable
    local validatedData=ss.validate(data)
    local serializedData=ss.Serialize(validatedData)
    love.filesystem.write('settings',serializedData)
end

--safely reads a settings file. If no such file can be found or if the user has
--tampered with the file so that it can't be read or run properly, the file will
--be written over with default values.
--if read succeeds: returns the settings table generated from the file 
--if read fails: returns default settings
function ss.readSettings()
    --if settings file can't be found, create one with default values
    if love.filesystem.getInfo('settings')==nil then   
        print('Settings file does not exist; creating file...')
        ss.resetSettings()
        return ss.defaultSettings() 
    end

    --load the file. If file cannot be loaded, rewrite file with default values
    local data=love.filesystem.read('settings')
    if data==nil then 
        print("ERROR: Settings file could not be read; resetting...")
        ss.resetSettings()
        return ss.defaultSettings() 
    end
    
    --convert the file's string contents into an executable script within it's
    --own environment, seperate from any other global functions. If anything goes
    --wrong, such as loadstring returning nil, rewrite file with default values
    local safeLoad=function() setfenv(loadstring(data), {}) end
    if pcall(safeLoad)==false then 
        print("ERROR: Settings file could not be loaded as a string; resetting...")
        ss.resetSettings()
        return ss.defaultSettings()
    end
    local script=setfenv(loadstring(data), {})  --load the file as a script

    --test run the script to see if it produces any errors. If so, rewite setting
    --file with default values. The test run can result in error if the user tried
    --to add any function calls, which when run during the test, will result in an 
    --error due to the script being in a separate environment.
    if pcall(script)==false then 
        print('ERROR: invalid settings file; resetting...')
        ss.resetSettings()
        return ss.defaultSettings() 
    end
    local validatedSettings=ss.validate(script()) --execute script and store 

    ss.writeSettings(validatedSettings) --rewrite file with validated settings
    return validatedSettings
end

--takes the raw settings table created from executing the loadstring generated script.
--Validates it by creating a new table with only the fields needed by the game
--taken by either the raw settings table if it exists, or the default settings.
function ss.validate(_settings)
    if type(_settings)~='table' then 
        print("ERROR: invalid settings type; resetting...")
        return ss.defaultSettings() 
    end

    local raw=_settings                 --raw settings table
    local valid=ss.defaultSettings()    --validated settings table (to be returned)

    for field,_ in pairs(valid) do 
        if raw[field] then valid[field]=raw[field] end 
    end

    return valid
end

return ss
