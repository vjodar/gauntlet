TitleScreenState={}

function TitleScreenState:load() 
    self.titleImage=love.graphics.newImage("assets/menu/title.png")
    self.selections=love.graphics.newImage("assets/menu/selections.png")
    self.cursor=love.graphics.newImage("assets/menu/title_cursor.png")

    self._upd=self.updateMain
    self._drw=self.drawMain
end 

function TitleScreenState:update() return self:_upd() end 
function TitleScreenState:draw() self:_drw() end 

function TitleScreenState:updateMain() 
    if acceptInput then 
        ActionButtons:update()
        if Controls.releasedInputs.btnDown then 
            PlayState:startDungeonPhase()
            ActionButtons:setMenuMode(false) 
            return false 
        end
    end
    return true 
end 

function TitleScreenState:drawMain() 
    cam:attach()
        love.graphics.draw(self.titleImage,cam.x-130,cam.y-65)
        love.graphics.draw(self.selections,cam.x-34,cam.y+11)
        love.graphics.draw(self.cursor,cam.x-34,cam.y+11)
        love.graphics.printf("EXIT",cam.x,cam.y+103,160,'right')
        love.graphics.printf("ACCEPT",cam.x,cam.y+123,140,'right')
    cam:detach()
    ActionButtons:draw()
end 
