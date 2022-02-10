require 'inventory'

Hud={}

function Hud:load() 
    --health and mana bar
    self.healthbar={
        sprite=love.graphics.newImage('assets/hud_healthbar.png'),
        xPos=2*windowScaleX, yPos=2*windowScaleY
    }
    self.manabar={
        sprite=love.graphics.newImage('assets/hud_manabar.png'),
        xPos=2*windowScaleX, yPos=22*windowScaleY
    }

    --action 'buttons' cluster
    self.actions={}
    self.actions.interact={ --bottom button
        sprite=love.graphics.newImage('assets/hud_interact.png'),
        xPos=0, yPos=0
    }
    self.actions.combat={ --top button
        sprite=love.graphics.newImage('assets/hud_combat.png'),
        xPos=0, yPos=0
    }
    self.actions.fish={ --left button 1
        sprite=love.graphics.newImage('assets/hud_fish.png'),
        xPos=0, yPos=0
    }
    self.actions.potion={ --left button 2
        sprite=love.graphics.newImage('assets/hud_potion.png'),
        xPos=0, yPos=0
    }
    self.actions.protect_physical={ --right button 1
        sprite=love.graphics.newImage('assets/hud_protect_physical.png'),
        xPos=0, yPos=0
    }
    self.actions.protect_magical={ --right button 2
        sprite=love.graphics.newImage('assets/hud_protect_magical.png'),
        xPos=0, yPos=0
    }

    --inventory
    Inventory:load()
end

function Hud:update()
    Inventory:update()
end

function Hud:draw()
    love.graphics.draw( --healthbar
        self.healthbar.sprite,
        self.healthbar.xPos, self.healthbar.yPos,
        nil,windowScaleX,windowScaleY
    )
    love.graphics.draw( --manabar
        self.manabar.sprite,
        self.manabar.xPos, self.manabar.yPos,
        nil,windowScaleX,windowScaleY
    )

    --action buttons
    

    --inventory
    Inventory:draw()
end