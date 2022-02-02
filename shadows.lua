Shadows={}

function Shadows:newShadow(_size)
    local shadow={}

    if _size=='tiny' then 
        shadow.sprite=love.graphics.newImage('assets/shadow_tiny.png')
    elseif _size=='small' then 
        shadow.sprite=love.graphics.newImage('assets/shadow_small.png')
    elseif _size=='medium' then 
        shadow.sprite=love.graphics.newImage('assets/shadow_medium.png')
    elseif _size=='large' then 
        shadow.sprite=love.graphics.newImage('assets/shadow_large.png')
    elseif _size=='rock' then 
        shadow.sprite=love.graphics.newImage('assets/shadow_rock.png')
    elseif _size=='fungi' then 
        shadow.sprite=love.graphics.newImage('assets/shadow_fungi.png')
    elseif _size=='tree' then 
        shadow.sprite=love.graphics.newImage('assets/shadow_tree.png')
    end

    shadow.w=shadow.sprite:getWidth()*0.5
    shadow.h=shadow.sprite:getHeight()*0.5

    function shadow:draw(_xPos,_yPos)
        --draw shadow with 0.5 alpha to make it transparent
        love.graphics.setColor(1,1,1,0.6)

        love.graphics.draw(self.sprite,_xPos-self.w,_yPos-self.h) --draw shadow

        --revert color settings so everything after has full opacity
        love.graphics.setColor(1,1,1,1)
    end

    return shadow 
end