ProtectionMagics={}

function ProtectionMagics:load()
    self.sprites={
        protection_physical=love.graphics.newImage('assets/hero/protection_physical.png'),
        protection_magical=love.graphics.newImage('assets/hero/protection_magical.png'),
        protection_physical_boss=love.graphics.newImage('assets/enemies/protection_physical_boss.png'),
        protection_magical_boss=love.graphics.newImage('assets/enemies/protection_magical_boss.png'),
    }
    self.functions={}
    self.functions.updateOffsetsPlayer=function(_symbol)        
        _symbol.oscillation=_symbol.oscillation+dt*3
        _symbol.yOffset=math.cos(_symbol.oscillation)
        _symbol.xOffset=6*math.sin(_symbol.oscillation)
    end
    self.functions.updateOffsetsBoss=function(_symbol)        
        _symbol.oscillation=_symbol.oscillation+dt*3
        _symbol.yOffset=math.cos(_symbol.oscillation)
        _symbol.xOffset=14*math.sin(_symbol.oscillation)
    end
end

--create and return a protection magic system that simply manages the protection
--magics symbols that float around the entity depending on which protection magic
--they're currently using, if either are activated. 
--This system is needed to manage these floating symbols because they must be 
--entities with dynamic draw order, so as to be able to float 'infront' of and
--'behind' the entity.
function ProtectionMagics:newProtectionMagicSystem(_entity)
    local magics={}

    magics.entity=_entity --entity the magic system is tethered to
    if magics.entity.name=='boss' then 
        magics.sprites={ --sprites for the player
            physical=self.sprites.protection_physical_boss,
            magical=self.sprites.protection_magical_boss
        }
    else --entity is the player
        magics.sprites={ --sprites for the player
            physical=self.sprites.protection_physical,
            magical=self.sprites.protection_magical
        }
    end
    magics.symbolWidth=magics.sprites.physical:getWidth()*0.5
    magics.symbolHeight=magics.sprites.magical:getHeight()*0.5
    magics.symbolPositions={0,math.pi*0.5,math.pi,math.pi*1.5}
    magics.currentSymbols={} --stores the current set of floating symbols

    --spawns a set of four floating symbols of either physical or magical type
    --that will float around a given object (like the player)    
    function magics:activate(_type)
        for i=1,4 do --spawn floating symbols
            local symbol={}
            
            symbol.sprite=self.sprites[_type]
            symbol.tetherObject=_obj --object the symbol will tether to
            symbol.xPos=self.entity.xPos
            symbol.yPos=self.entity.yPos
            symbol.w=self.symbolWidth
            symbol.h=self.symbolHeight
            symbol.xOffset,symbol.yOffset=0,0
            symbol.oscillation=self.symbolPositions[i] --start at different points
            symbol.willDie=false --true when symbol gets deactivated

            function symbol:update()
                if self.willDie then return false end --return false to be removed from game

                --update offsets
                self:updateOffsets()

                --update position. Must get the current position of the collider
                --because otherwise graphical flickering occurs likely due to the symbols
                --and the entity being very close in terms of yPos's.
                self.xPos=magics.entity.collider:getX()+self.xOffset
                self.yPos=magics.entity.collider:getY()+self.yOffset
            end

            function symbol:draw()
                love.graphics.draw(
                    self.sprite,
                    self.xPos-self.w+self.xOffset,
                    self.yPos-2.5*self.h+self.yOffset
                )
            end
        
            if self.entity.name=='boss' then 
                symbol.updateOffsets=ProtectionMagics.functions.updateOffsetsBoss 
            else 
                symbol.updateOffsets=ProtectionMagics.functions.updateOffsetsPlayer
            end

            function symbol:die() self.willDie=true end 

            table.insert(self.currentSymbols,symbol)
            table.insert(Entities.entitiesTable,symbol)
        end

        self.entity.state.protectionActivated=true
    end

    --deactivates the current set of symbols and removes them from the game.
    function magics:deactivate()
        for i,symbol in pairs(self.currentSymbols) do symbol:die() end 
        self.entity.state.protectionActivated=false
    end

    return magics
end