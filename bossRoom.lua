BossRoom={}

function BossRoom:load()
    self.sprites={
        lava=love.graphics.newImage('assets/maps/boss_lava.png'),
        floor=love.graphics.newImage('assets/maps/boss_floor.png'),
    }
end

function BossRoom:update()

end

function BossRoom:draw()
    love.graphics.draw(self.sprites.lava,0,0)
    love.graphics.draw(self.sprites.floor,32,32)
end