Meters={}

function Meters:load()
    self.health={
        spriteBar=love.graphics.newImage('assets/hud/meters/hud_health.png'),
        xPos=2*WINDOWSCALE_X, yPos=WINDOWSCALE_Y,
        spritePiece=love.graphics.newImage('assets/hud/meters/hud_health_piece.png'),
        filledPieces=math.ceil(Player.health.current/2), --how many actual pieces
        filledPiecesShown=math.ceil(Player.health.current/2), --how many pieces are shown
        timer=0 --to tween health pieces over time
    }
    self.mana={
        spriteBar=love.graphics.newImage('assets/hud/meters/hud_mana.png'),
        xPos=2*WINDOWSCALE_X, yPos=18*WINDOWSCALE_Y,        
        spritePiece=love.graphics.newImage('assets/hud/meters/hud_mana_piece.png'),
        filledPieces=math.ceil(Player.mana.current/2), --how many actual pieces
        filledPiecesShown=math.ceil(Player.mana.current/2), --how many pieces are shown
        timer=0 --to tween mana pieces over time
    }
    self.meterMovementRate=0.02 --rate in sec at which meters inc/dec by 1 piece 
end

function Meters:update() 
    --tween health/mana pieces when max~=current
    if self.health.filledPieces>self.health.filledPiecesShown then 
        self.health.timer=self.health.timer+dt
        if self.health.timer>self.meterMovementRate then --increase health by 1 piece          
            self.health.filledPiecesShown=self.health.filledPiecesShown+1
            self.health.timer=0 --reset timer
        end
    elseif self.health.filledPieces<self.health.filledPiecesShown then 
        self.health.timer=self.health.timer+dt
        if self.health.timer>self.meterMovementRate then --decrease health by 1 piece         
            self.health.filledPiecesShown=self.health.filledPiecesShown-1
            self.health.timer=0 --reset timer
        end
    end
    if self.mana.filledPieces>self.mana.filledPiecesShown then 
        self.mana.timer=self.mana.timer+dt
        if self.mana.timer>self.meterMovementRate then --increase mana by 1 piece          
            self.mana.filledPiecesShown=self.mana.filledPiecesShown+1
            self.mana.timer=0 --reset timer
        end
    elseif self.mana.filledPieces<self.mana.filledPiecesShown then 
        self.mana.timer=self.mana.timer+dt
        if self.mana.timer>self.meterMovementRate then --decrease mana by 1 piece         
            self.mana.filledPiecesShown=self.mana.filledPiecesShown-1
            self.mana.timer=0 --reset timer
        end
    end
end

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
    for i=1,self.health.filledPiecesShown+math.floor(self.health.filledPiecesShown/5) do 
        if i%6~=0 then --skip every 6th piece to separate into segments
            love.graphics.draw(
                self.health.spritePiece,
                self.health.xPos+(5+i)*WINDOWSCALE_X,
                self.health.yPos+6*WINDOWSCALE_Y,
                nil,WINDOWSCALE_X,WINDOWSCALE_Y
            )
        end
    end
    for i=1,self.mana.filledPiecesShown+math.floor(self.mana.filledPiecesShown/5) do 
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