Meters={}

function Meters:load()
    self.health={
        spriteBar=love.graphics.newImage('assets/hud/meters/hud_health.png'),
        xPos=2*WINDOWSCALE_X, yPos=WINDOWSCALE_Y,
        spritePiece=love.graphics.newImage('assets/hud/meters/hud_health_piece.png'),
        filledPieces=50
    }
    self.mana={
        spriteBar=love.graphics.newImage('assets/hud/meters/hud_mana.png'),
        xPos=2*WINDOWSCALE_X, yPos=18*WINDOWSCALE_Y,        
        spritePiece=love.graphics.newImage('assets/hud/meters/hud_mana_piece.png'),
        filledPieces=50
    }
end

function Meters:update() end

function Meters:draw()
    --draw background meter sprites
    love.graphics.draw( 
        self.health.spriteBar,
        self.health.xPos, self.health.yPos,
        nil,WINDOWSCALE_X,WINDOWSCALE_Y
    )
    love.graphics.draw(
        self.mana.spriteBar,
        self.mana.xPos, self.mana.yPos,
        nil,WINDOWSCALE_X,WINDOWSCALE_Y
    )

    --fill meters with health/mana pieces to represent current health/mana
    for i=1,self.health.filledPieces+math.floor(self.health.filledPieces/5) do 
        if i%6~=0 then --skip every 6th piece to separate into segments
            love.graphics.draw(
                self.health.spritePiece,
                self.health.xPos+(5+i)*WINDOWSCALE_X,
                self.health.yPos+6*WINDOWSCALE_Y,
                nil,WINDOWSCALE_X,WINDOWSCALE_Y
            )
        end
    end
    for i=1,self.mana.filledPieces+math.floor(self.mana.filledPieces/5) do 
        if i%6~=0 then --skip every 6th piece to separate into segments
            love.graphics.draw(
                self.mana.spritePiece,
                self.mana.xPos+(5+i)*WINDOWSCALE_X,
                self.mana.yPos+6*WINDOWSCALE_Y,
                nil,WINDOWSCALE_X,WINDOWSCALE_Y
            )
        end
    end
end

--updates the HUD's health and mana meters. Called by Player
function Meters:updateMeterValues()
    --1 piece represents up to 2 health/mana
    self.health.filledPieces=math.ceil(Player.health.current/2)
    self.mana.filledPieces=math.ceil(Player.mana.current/2)
end