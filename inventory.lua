Inventory={}

function Inventory:load() 
    self.inv_yPos=love.graphics.getHeight()-30*WINDOWSCALE_Y --yPos for all segments and icons
    self.inv_middle=love.graphics.newImage('assets/hud/inventory/hud_inv_middle.png') --middle segment sprite
    self.defaultClosed=7*WINDOWSCALE_X --xPos_closed for all segments and icons except endpieces

    self.inventorySegments={} --holds all middle and end inventory segments
    self.inventoryItems={} --holds all item icons/sprites

    self.inventorySegments.endLeft={} --left endpiece segment
    self.inventorySegments.endLeft.sprite=love.graphics.newImage('assets/hud/inventory/hud_inv_endleft.png')
    self.inventorySegments.endLeft.xPos_open=2*WINDOWSCALE_X
    self.inventorySegments.endLeft.xPos_current=2*WINDOWSCALE_X
    self.inventorySegments.endLeft.xPos_closed=2*WINDOWSCALE_X
    self.inventorySegments.endLeft.yPos=self.inv_yPos-WINDOWSCALE_X

    self.inventorySegments.endRight={} --right endpiece segment
    self.inventorySegments.endRight.sprite=love.graphics.newImage('assets/hud/inventory/hud_inv_endright.png')
    self.inventorySegments.endRight.xPos_open=274*WINDOWSCALE_X
    self.inventorySegments.endRight.xPos_current=26*WINDOWSCALE_X
    self.inventorySegments.endRight.xPos_closed=26*WINDOWSCALE_X
    self.inventorySegments.endRight.yPos=self.inv_yPos-WINDOWSCALE_X

    for i=0,13 do --add 14 inventory middle segments
        local middleSegment={}
        middleSegment.sprite=self.inv_middle 
        middleSegment.xPos_open=(7+19*i)*WINDOWSCALE_X 
        middleSegment.xPos_closed=self.defaultClosed
        middleSegment.xPos_current=middleSegment.xPos_closed
        middleSegment.yPos=self.inv_yPos 
        table.insert(self.inventorySegments,middleSegment)
    end
    
    --inventory items/icons
    table.insert(self.inventoryItems, 1, {
        name="chest",
        spriteOpen=love.graphics.newImage('assets/hud/inventory/hud_inv_chest_open.png'), --open sprite
        spriteClosed=love.graphics.newImage('assets/hud/inventory/hud_inv_chest_closed.png'), --closed sprite
        spriteHalf=love.graphics.newImage('assets/hud/inventory/hud_inv_chest_half.png'), --halfway sprite
        sprite=love.graphics.newImage('assets/hud/inventory/hud_inv_chest_closed.png'),
        xPos_open=7*WINDOWSCALE_X, xPos_current=7*WINDOWSCALE_X, 
        xPos_closed=self.defaultClosed
    })
    table.insert(self.inventoryItems, 1, {
        name="arcane_shards",
        sprite=love.graphics.newImage('assets/hud/inventory/hud_inv_arcane_shards.png'),
        xPos_open=26*WINDOWSCALE_X, xPos_closed=self.defaultClosed,
        xPos_current=self.defaultClosed, count=0
    })
    table.insert(self.inventoryItems, 1, {
        name="broken_bow",
        sprite=love.graphics.newImage('assets/hud/inventory/hud_inv_broken_bow.png'),
        xPos_open=45*WINDOWSCALE_X, xPos_closed=self.defaultClosed,
        xPos_current=self.defaultClosed, count=0
    })
    table.insert(self.inventoryItems, 1, {
        name="broken_staff",
        sprite=love.graphics.newImage('assets/hud/inventory/hud_inv_broken_staff.png'),
        xPos_open=64*WINDOWSCALE_X, xPos_closed=self.defaultClosed,
        xPos_current=self.defaultClosed, count=0
    })
    table.insert(self.inventoryItems, 1, {
        name="arcane_orb",
        sprite=love.graphics.newImage('assets/hud/inventory/hud_inv_arcane_orb.png'),
        xPos_open=83*WINDOWSCALE_X, xPos_closed=self.defaultClosed,
        xPos_current=self.defaultClosed, count=0
    })
    table.insert(self.inventoryItems, 1, {
        name="arcane_bowstring",
        sprite=love.graphics.newImage('assets/hud/inventory/hud_inv_arcane_bowstring.png'),
        xPos_open=102*WINDOWSCALE_X, xPos_closed=self.defaultClosed,
        xPos_current=self.defaultClosed, count=0
    })
    table.insert(self.inventoryItems, 1, {
        name="tree_wood",
        sprite=love.graphics.newImage('assets/hud/inventory/hud_inv_wood.png'),
        xPos_open=121*WINDOWSCALE_X, xPos_closed=self.defaultClosed,
        xPos_current=self.defaultClosed, count=0
    })
    table.insert(self.inventoryItems, 1, {
        name="rock_ore",
        sprite=love.graphics.newImage('assets/hud/inventory/hud_inv_ore.png'),
        xPos_open=140*WINDOWSCALE_X, xPos_closed=self.defaultClosed,
        xPos_current=self.defaultClosed, count=0
    })
    table.insert(self.inventoryItems, 1, {
        name="vine_fiber",
        sprite=love.graphics.newImage('assets/hud/inventory/hud_inv_fiber.png'),
        xPos_open=159*WINDOWSCALE_X, xPos_closed=self.defaultClosed,
        xPos_current=self.defaultClosed, count=0
    })
    table.insert(self.inventoryItems, 1, {
        name="fungi_mushroom",
        sprite=love.graphics.newImage('assets/hud/inventory/hud_inv_mushroom.png'),
        xPos_open=178*WINDOWSCALE_X, xPos_closed=self.defaultClosed,
        xPos_current=self.defaultClosed, count=0
    })
    table.insert(self.inventoryItems, 1, {
        name="fish_raw",
        sprite=love.graphics.newImage('assets/hud/inventory/hud_inv_fish_raw.png'),
        xPos_open=197*WINDOWSCALE_X, xPos_closed=self.defaultClosed,
        xPos_current=self.defaultClosed, count=0
    })
    table.insert(self.inventoryItems, 1, {
        name="rock_metal",
        sprite=love.graphics.newImage('assets/hud/inventory/hud_inv_metal.png'),
        xPos_open=216*WINDOWSCALE_X, xPos_closed=self.defaultClosed,
        xPos_current=self.defaultClosed, count=0
    })
    table.insert(self.inventoryItems, 1, {
        name="tree_planks",
        sprite=love.graphics.newImage('assets/hud/inventory/hud_inv_planks.png'),
        xPos_open=235*WINDOWSCALE_X, xPos_closed=self.defaultClosed,
        xPos_current=self.defaultClosed, count=0
    })
    table.insert(self.inventoryItems, 1, {
        name="vine_thread",
        sprite=love.graphics.newImage('assets/hud/inventory/hud_inv_thread.png'),
        xPos_open=254*WINDOWSCALE_X, xPos_closed=self.defaultClosed,
        xPos_current=self.defaultClosed, count=0
    })

    --metatable
    self.state={}
    self.state.open=false
    self.state.closed=true --start out closed
    self.state.transitioning=false --transitioning between open and closed states
    
    self.xVel=1440*WINDOWSCALE_X --speed of inventory segments and icons
    self.MAXNUM=27 --maximum number of open or closed segments and icons
    self.numClosed=self.MAXNUM --number of inventory segments and icons are in their closed position
    self.numOpen=0 --number of inventory segments and icons are in their open position
end

function Inventory:update()
    if self.state.transitioning then 
        self:move()
    elseif acceptInput and releasedKey==controls.btnStart then 
        self.state.transitioning=true 
    end
end

function Inventory:draw()
    --draw inventory segments
    for i,segment in pairs(self.inventorySegments) do 
        love.graphics.draw(
            segment.sprite,segment.xPos_current,segment.yPos,
            nil,WINDOWSCALE_X,WINDOWSCALE_Y
        )
    end

    --draw inventory icons
    for i,icon in pairs(self.inventoryItems) do 
        if icon.count==0 then 
            love.graphics.setColor(1,1,1,0.7)
        end
        love.graphics.draw(
            icon.sprite,icon.xPos_current,self.inv_yPos,
            nil,WINDOWSCALE_X,WINDOWSCALE_Y
        )
        love.graphics.setColor(1,1,1,1)
        if icon.count  then --draw item counts
            if icon.count>0 then --don't show counts of 0
                if icon.count>99 then 
                    love.graphics.printf(
                        '99+',
                        icon.xPos_current,self.inv_yPos+16*WINDOWSCALE_Y,
                        18,'right',nil,WINDOWSCALE_X,WINDOWSCALE_Y
                    ) 
                else
                    love.graphics.printf(
                        icon.count,
                        icon.xPos_current,self.inv_yPos+16*WINDOWSCALE_Y,
                        18,'right',nil,WINDOWSCALE_X,WINDOWSCALE_Y
                    ) 
                end
            end
        end
    end
end

function Inventory:move()
    if self.state.open then --inventory will close
        for i,segment in pairs(self.inventorySegments) do 
            --only iterate over segments which still need to move
            if segment.xPos_current~=segment.xPos_closed then 
                segment.xPos_current=segment.xPos_current-self.xVel*dt --move segment
                if segment.xPos_current<=segment.xPos_closed then 
                    segment.xPos_current=segment.xPos_closed 
                    self.numClosed=self.numClosed+1
                    self.numOpen=self.numOpen-1
                end
            end
        end

        for i,icon in pairs(self.inventoryItems) do 
            --only iterate over icons which still need to move
            if icon.xPos_current~=icon.xPos_closed then 
                icon.xPos_current=icon.xPos_current-self.xVel*dt --move icon
                if icon.xPos_current<=icon.xPos_closed then 
                    icon.xPos_current=icon.xPos_closed 
                    self.numClosed=self.numClosed+1
                    self.numOpen=self.numOpen-1
                end
            end
            if icon.name=='chest' then icon.sprite=icon.spriteHalf end --chest is halfway open
        end
        
        if self.numClosed==self.MAXNUM then --all segments are in their closed position
            self.state.open=false 
            self.state.closed=true
            self.state.transitioning=false 
            for i,icon in pairs(self.inventoryItems) do --close the chest
                if icon.name=='chest' then icon.sprite=icon.spriteClosed return end 
            end
        end

    elseif self.state.closed then --inventory will open
        for i,segment in pairs(self.inventorySegments) do 
            --only iterate over segments that still need to move
            if segment.xPos_current~=segment.xPos_open then 
                segment.xPos_current=segment.xPos_current+self.xVel*dt --move segment
                if segment.xPos_current>=segment.xPos_open then 
                    segment.xPos_current=segment.xPos_open 
                    self.numOpen=self.numOpen+1
                    self.numClosed=self.numClosed-1
                end
            end
        end
        
        for i,icon in pairs(self.inventoryItems) do 
            --only iterate over segments that still need to move
            if icon.xPos_current~=icon.xPos_open then 
                icon.xPos_current=icon.xPos_current+self.xVel*dt --move icon
                if icon.xPos_current>=icon.xPos_open then 
                    icon.xPos_current=icon.xPos_open 
                    self.numOpen=self.numOpen+1
                    self.numClosed=self.numClosed-1
                end
            end
            if icon.name=='chest' then icon.sprite=icon.spriteHalf end --chest is halfway open
        end

        if self.numOpen==self.MAXNUM then --all segments are in their open position
            self.state.closed=false 
            self.state.open=true 
            self.state.transitioning=false
            for i,icon in pairs(self.inventoryItems) do --open the chest
                if icon.name=='chest' then icon.sprite=icon.spriteOpen return end 
            end
        end
    end
end

--opens the inventory only when already closed. 
--Used by craftingMenuState to open inventory when they are crafting.
function Inventory:open()
    if self.state.closed==true then self.state.transitioning=true end 
end

--increments the count of a given item in inventoryItems table
function Inventory:addItem(_item,_amount)
    for i,item in pairs(self.inventoryItems) do 
        if item.name==_item then item.count=item.count+_amount end 
    end
end

--decreases the count of a given item in inventoryItems table
function Inventory:removeItem(_item,_amount)    
    for i,item in pairs(self.inventoryItems) do 
        if item.name==_item then item.count=item.count-_amount end 
    end
end