Dialog={}

--creates and returns a dialog system. Intended to be given to the player or npc.
function Dialog:newDialogSystem()
    local sys={}

    sys.lines={} --holds all text lines
    sys.damages={}
    sys.damageTypes={
        physical=fonts.gray,        
        magical=fonts.blue,        
        pure=fonts.red    
    }

    function sys:update()
        for i,line in pairs(self.lines) do --update text lines
            line.duration=line.duration-dt --reduce duration
            line.alpha=line.alpha-dt --fade out
            if line.duration<=0 then --remove after duration expires
                table.remove(self.lines,i)
            end
        end

        for i,dmg in pairs(self.damages) do --update damage values
            dmg.xPos=dmg.xPos+dmg.xVel*dt
            dmg.yPos=dmg.yPos+dmg.yVel*dt
            dmg.yVel=dmg.yVel+dt*500 --apply gravity
            if dmg.yPos>10 then table.remove(self.damages,i) end 
        end
    end

    function sys:draw(_xPos,_yPos)
        for i,line in pairs(self.lines) do --draw text lines
            love.graphics.setColor(1,1,1,line.alpha)
            --print line, new lines spawn at the lowest position,
            --pushing older lines to the top
            love.graphics.printf( 
                line.text,_xPos-200,
                _yPos-20-(10*i),
                400,'center'
            )
        end
        love.graphics.setColor(1,1,1,1)

        for i,dmg in pairs(self.damages) do --draw damage numbers
            love.graphics.setFont(self.damageTypes[dmg.type])
            love.graphics.print(
                dmg.value,_xPos+dmg.xPos+dmg.xOffset,_yPos-10+dmg.yPos+dmg.yOffset
            )
        end
        love.graphics.setFont(fonts.yellow) --reset to default yellow font
    end

    --adds a text line to the dialog system
    function sys:say(_line)
        local line={
            text=_line,
            duration=3, --line lasts 3s total
            alpha=2.8 --alpha higher than 1 to begin fade after 1.8s
        }

        table.insert(self.lines,1,line) --insert new lines at start of table

        --can only have up to 5 lines at a time. If more lines are added, delete oldest
        if #self.lines>5 then table.remove(self.lines,#self.lines) end
    end

    --adds damage values to dialog system
    --these will fly up and out of entity
    function sys:damage(_val,_type)
        local dmg={
            value=_val,
            type=_type,
            xPos=0,yPos=0,
            xOffset=8*love.math.random()-4,
            yOffset=10*love.math.random()-5,
            xVel=2*30*love.math.random()-30,
            yVel=-120-40*love.math.random()
        }

        table.insert(self.damages,1,dmg) --insert into start of damages table
    end

    return sys
end
