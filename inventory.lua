Inventory={}

function Inventory:load() 
    self.inv_yPos=love.graphics.getHeight()-30*windowScaleY --yPos for all segments and icons
    self.inv_middle=love.graphics.newImage('assets/hud_inv_middle.png') --middle segment sprite
    self.defaultClosed=7*windowScaleX --xPos_closed for all segments and icons except endpieces

    self.inventorySegments={} --holds all middle and end inventory segments
    self.inventoryIcons={} --holds all item icons/sprites

    self.inventorySegments.endLeft={} --left endpiece segment
    self.inventorySegments.endLeft.sprite=love.graphics.newImage('assets/hud_inv_endleft.png')
    self.inventorySegments.endLeft.xPos_open=2*windowScaleX
    self.inventorySegments.endLeft.xPos_current=2*windowScaleX
    self.inventorySegments.endLeft.xPos_closed=2*windowScaleX
    self.inventorySegments.endLeft.yPos=self.inv_yPos-windowScaleX

    self.inventorySegments.endRight={} --right endpiece segment
    self.inventorySegments.endRight.sprite=love.graphics.newImage('assets/hud_inv_endright.png')
    self.inventorySegments.endRight.xPos_open=273*windowScaleX
    self.inventorySegments.endRight.xPos_current=273*windowScaleX
    self.inventorySegments.endRight.xPos_closed=26*windowScaleX
    self.inventorySegments.endRight.yPos=self.inv_yPos-windowScaleX

    for i=0,13 do --add 14 inventory middle segments
        local middleSegment={}
        middleSegment.sprite=self.inv_middle 
        middleSegment.xPos_open=(7+19*i)*windowScaleX 
        middleSegment.xPos_closed=self.defaultClosed
        middleSegment.xPos_current=middleSegment.xPos_open
        middleSegment.yPos=self.inv_yPos 
        table.insert(self.inventorySegments,middleSegment)
    end
    
    --inventory icons
    table.insert(self.inventoryIcons, 1, {
        name="chest",
        sprite=love.graphics.newImage('assets/hud_inv_chest.png'),
        xPos_open=7*windowScaleX, xPos_current=7*windowScaleX, 
        xPos_closed=self.defaultClosed
    })
    table.insert(self.inventoryIcons, 1, {
        name="arcane_shards",
        sprite=love.graphics.newImage('assets/hud_inv_arcane_shards.png'),
        xPos_open=26*windowScaleX, xPos_current=26*windowScaleX,
        xPos_closed=self.defaultClosed, count=0
    })
    table.insert(self.inventoryIcons, 1, {
        name="broken_bow",
        sprite=love.graphics.newImage('assets/hud_inv_broken_bow.png'),
        xPos_open=45*windowScaleX, xPos_current=45*windowScaleX,
        xPos_closed=self.defaultClosed, count=0
    })
    table.insert(self.inventoryIcons, 1, {
        name="broken_staff",
        sprite=love.graphics.newImage('assets/hud_inv_broken_staff.png'),
        xPos_open=64*windowScaleX, xPos_current=64*windowScaleX,
        xPos_closed=self.defaultClosed, count=0
    })
    table.insert(self.inventoryIcons, 1, {
        name="arcane_orb",
        sprite=love.graphics.newImage('assets/hud_inv_arcane_orb.png'),
        xPos_open=83*windowScaleX, xPos_current=83*windowScaleX,
        xPos_closed=self.defaultClosed, count=0
    })
    table.insert(self.inventoryIcons, 1, {
        name="arcane_bowstring",
        sprite=love.graphics.newImage('assets/hud_inv_arcane_bowstring.png'),
        xPos_open=102*windowScaleX, xPos_current=102*windowScaleX,
        xPos_closed=self.defaultClosed, count=0
    })
    table.insert(self.inventoryIcons, 1, {
        name="tree_wood",
        sprite=love.graphics.newImage('assets/hud_inv_wood.png'),
        xPos_open=121*windowScaleX, xPos_current=121*windowScaleX,
        xPos_closed=self.defaultClosed, count=0
    })
    table.insert(self.inventoryIcons, 1, {
        name="rock_ore",
        sprite=love.graphics.newImage('assets/hud_inv_ore.png'),
        xPos_open=140*windowScaleX, xPos_current=140*windowScaleX,
        xPos_closed=self.defaultClosed, count=0
    })
    table.insert(self.inventoryIcons, 1, {
        name="vine_fiber",
        sprite=love.graphics.newImage('assets/hud_inv_fiber.png'),
        xPos_open=159*windowScaleX, xPos_current=159*windowScaleX,
        xPos_closed=self.defaultClosed, count=0
    })
    table.insert(self.inventoryIcons, 1, {
        name="fungi_mushroom",
        sprite=love.graphics.newImage('assets/hud_inv_mushroom.png'),
        xPos_open=178*windowScaleX, xPos_current=178*windowScaleX,
        xPos_closed=self.defaultClosed, count=0
    })
    table.insert(self.inventoryIcons, 1, {
        name="fish_raw",
        sprite=love.graphics.newImage('assets/hud_inv_fish_raw.png'),
        xPos_open=197*windowScaleX, xPos_current=197*windowScaleX,
        xPos_closed=self.defaultClosed, count=0
    })
    table.insert(self.inventoryIcons, 1, {
        name="rock_metal",
        sprite=love.graphics.newImage('assets/hud_inv_metal.png'),
        xPos_open=216*windowScaleX, xPos_current=216*windowScaleX,
        xPos_closed=self.defaultClosed, count=0
    })
    table.insert(self.inventoryIcons, 1, {
        name="tree_planks",
        sprite=love.graphics.newImage('assets/hud_inv_planks.png'),
        xPos_open=235*windowScaleX, xPos_current=235*windowScaleX,
        xPos_closed=self.defaultClosed, count=0
    })
    table.insert(self.inventoryIcons, 1, {
        name="vine_thread",
        sprite=love.graphics.newImage('assets/hud_inv_thread.png'),
        xPos_open=254*windowScaleX, xPos_current=254*windowScaleX,
        xPos_closed=self.defaultClosed, count=0
    })

    --metatable
    self.state={}
    self.state.open=true
    self.state.closed=false
    self.state.transitioning=false --transitioning between open and closed states
    
    self.xVel=10*windowScaleX --speed of inventory segments and icons
    self.numClosed=0 --number of inventory segments and icons are in their closed position
    self.numOpen=27 --number of inventory segments and icons are in their open position
end

function Inventory:update()
    if self.state.transitioning then 
        self:move()
    elseif releasedKey=='space' and acceptInput then 
        self.state.transitioning=true 
    end
end

function Inventory:draw()
    --draw inventory segments
    for i,segment in pairs(self.inventorySegments) do 
        love.graphics.draw(
            segment.sprite,segment.xPos_current,segment.yPos,
            nil,windowScaleX,windowScaleY
        )
    end

    --draw inventory icons
    for i,icon in pairs(self.inventoryIcons) do 
        if icon.count==0 then 
            love.graphics.setColor(1,1,1,0.7)
        end
        love.graphics.draw(
            icon.sprite,icon.xPos_current,self.inv_yPos,
            nil,windowScaleX,windowScaleY
        )
        love.graphics.setColor(1,1,1,1)
    end
end

function Inventory:move()
    if self.state.open then --inventory will close
        for i,segment in pairs(self.inventorySegments) do 
            --only iterate over segments which still need to move
            if segment.xPos_current~=segment.xPos_closed then 
                segment.xPos_current=segment.xPos_current-self.xVel --move segment
                if segment.xPos_current<=segment.xPos_closed then 
                    segment.xPos_current=segment.xPos_closed 
                    self.numClosed=self.numClosed+1
                    self.numOpen=self.numOpen-1
                end
            end
        end

        for i,icon in pairs(self.inventoryIcons) do 
            --only iterate over icons which still need to move
            if icon.xPos_current~=icon.xPos_closed then 
                icon.xPos_current=icon.xPos_current-self.xVel --move icon
                if icon.xPos_current<=icon.xPos_closed then 
                    icon.xPos_current=icon.xPos_closed 
                    self.numClosed=self.numClosed+1
                    self.numOpen=self.numOpen-1
                end
            end
        end
        
        if self.numClosed==27 then --all segments are in their closed position
            self.state.open=false 
            self.state.closed=true
            self.state.transitioning=false 
        end

    elseif self.state.closed then --inventory will open
        for i,segment in pairs(self.inventorySegments) do 
            --only iterate over segments that still need to move
            if segment.xPos_current~=segment.xPos_open then 
                segment.xPos_current=segment.xPos_current+self.xVel --move segment
                if segment.xPos_current>=segment.xPos_open then 
                    segment.xPos_current=segment.xPos_open 
                    self.numOpen=self.numOpen+1
                    self.numClosed=self.numClosed-1
                end
            end
        end

        for i,icon in pairs(self.inventoryIcons) do 
            --only iterate over segments that still need to move
            if icon.xPos_current~=icon.xPos_open then 
                icon.xPos_current=icon.xPos_current+self.xVel --move icon
                if icon.xPos_current>=icon.xPos_open then 
                    icon.xPos_current=icon.xPos_open 
                    self.numOpen=self.numOpen+1
                    self.numClosed=self.numClosed-1
                end
            end
        end

        if self.numOpen==27 then --all segments are in their open position
            self.state.closed=false 
            self.state.open=true 
            self.state.transitioning=false 
        end
    end
end