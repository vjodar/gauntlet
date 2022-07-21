function love.conf(t)
    t.title="Gauntlet"          --The title of the window the game is in (string)
    t.version="11.4"            --The LOVE version this game was made for (string)
    t.console=true              --Attach a console (boolean, Windows only)
    t.window.width=400          --The window width (number)
    t.window.height=300         --The window height (number)
    t.window.resizable=false
    t.identity="gauntlet"       --name of the save directory folder
    --testing--------------
    -- t.window.vsync=false
    --testing-------------
end
