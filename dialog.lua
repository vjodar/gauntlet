Dialog={}

--creates and returns a dialog system. Intended to be given to the player or npc.
function Dialog:newDialogSystem()
    local sys={}

    sys.lines={} --holds all text lines  

    function sys:update()
        for i,line in pairs(self.lines) do 
            line.duration=line.duration-dt --reduce duration
            line.alpha=line.alpha-dt --fade out
            if line.duration<0.017 then --remove after duration expires
                table.remove(self.lines,i)
            end
        end
    end

    function sys:draw(_xPos,_yPos)
        for i,line in pairs(self.lines) do 
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

    return sys
end
