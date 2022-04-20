ProtectionMagics={}

function ProtectionMagics:load()
    self.sprites={
        protection_physical=love.graphics.newImage('assets/hero/protection_physical.png'),
        protection_magical=love.graphics.newImage('assets/hero/protection_magical.png')
    }
    self.symbolWidth=self.sprites.protection_physical:getWidth()*0.5
    self.symbolHeight=self.sprites.protection_physical:getHeight()*0.5
end

--create and return a protection magic system that simply manages the protection
--magics symbols that float around the player depending on which protection magic
--they're currently using, if either are activated. 
--This system is needed to manage these floating symbols because they must be 
--entities with dynamic draw order, so as to be able to float 'infront' of and
--'behind' the player.
function ProtectionMagics:newProtectionMagicSystem()
    local magics={}

    magics.sprites={
        physical=self.sprites.protection_physical,
        magical=self.sprites.protection_magical
    }
    magics.symbolPositions={0,math.pi*0.5,math.pi,math.pi*1.5}
    magics.currentSymbols={} --stores the current set of floating symbols

    --spawns a set of four floating symbols of either physical or magical type
    --that will float around a given object (like the player)    
    function magics:activate(_type,_obj)
        for i=1,4 do --spawn 4 floating symbols
            local symbol={}
            
            symbol.sprite=self.sprites[_type]
            symbol.tetherObject=_obj --object the symbol will tether to
            symbol.xPos=symbol.tetherObject.xPos
            symbol.yPos=symbol.tetherObject.yPos
            symbol.w=ProtectionMagics.symbolWidth
            symbol.h=ProtectionMagics.symbolHeight
            symbol.xOffset,symbol.yOffset=0,0
            symbol.oscillation=self.symbolPositions[i] --start at different points
            symbol.willDie=false --true when symbol gets deactivated

            function symbol:update()
                --update offsets
                self.oscillation=self.oscillation+dt*3
                self.yOffset=math.cos(self.oscillation)
                self.xOffset=6*math.sin(self.oscillation)

                --update position. Must get the current position at of the collider
                --because otherwise grphical flickering occurs likely due to the symbols
                --and the tetheredObject being very close in terms of yPos's.
                self.xPos=self.tetherObject.collider:getX()+self.xOffset
                self.yPos=self.tetherObject.collider:getY()+self.yOffset

                if self.willDie then return false end --return false to be removed from game
            end

            function symbol:draw()
                love.graphics.draw(
                    self.sprite,
                    self.xPos-self.w+self.xOffset,
                    self.yPos-2.5*self.h+self.yOffset
                )
            end

            function symbol:die() self.willDie=true end 

            table.insert(self.currentSymbols,symbol)
            table.insert(Entities.entitiesTable,symbol)
        end

        Player.state.protectionActivated=true
    end

    --deactivates the current set of symbols and removes them from the game.
    function magics:deactivate()
        for i,symbol in pairs(self.currentSymbols) do symbol:die() end 
        Player.state.protectionActivated=false
    end

    return magics
end