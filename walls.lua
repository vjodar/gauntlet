Walls={} --walls class builds inner room wall layouts and objects

function Walls:load()
    self.wallSprites={}
    self.wallSprites.horizontalLeft=love.graphics.newImage('assets/maps/wall_horizontal_left.png')
    self.wallSprites.horizontalMiddle=love.graphics.newImage('assets/maps/wall_horizontal_middle.png')
    self.wallSprites.horizontalRight=love.graphics.newImage('assets/maps/wall_horizontal_right.png')
    self.wallSprites.verticalTop=love.graphics.newImage('assets/maps/wall_vertical_top.png')
    self.wallSprites.verticalMiddle=love.graphics.newImage('assets/maps/wall_vertical_middle.png')
    self.wallSprites.verticalBottom=love.graphics.newImage('assets/maps/wall_vertical_bottom.png')

    self.layouts={} --table to store all layout generation functions

    self.layouts[1]=function(_room) 
        self:newWall(_room.xPos+112,16+_room.yPos+124,'horizontal',160)
        self:newWall(_room.xPos+64,16+_room.yPos+188,'horizontal',96)
        self:newWall(_room.xPos+224,16+_room.yPos+188,'horizontal',96)
    end 
    self.layouts[2]=function(_room)
        self:newWall(_room.xPos+112,16+_room.yPos+188,'horizontal',160)
        self:newWall(_room.xPos+64,16+_room.yPos+124,'horizontal',96)
        self:newWall(_room.xPos+224,16+_room.yPos+124,'horizontal',96)
    end
    self.layouts[3]=function(_room)
        self:newWall(_room.xPos+219,16+_room.yPos+107,'vertical',100)
        self:newWall(_room.xPos+160,16+_room.yPos+59,'vertical',84)
        self:newWall(_room.xPos+160,16+_room.yPos+171,'vertical',84)
    end
    self.layouts[4]=function(_room)
        self:newWall(_room.xPos+160,16+_room.yPos+107,'vertical',100)
        self:newWall(_room.xPos+219,16+_room.yPos+59,'vertical',84)
        self:newWall(_room.xPos+219,16+_room.yPos+171,'vertical',84)
    end

    self.layouts[5]=function(_room)
        self:newWall(_room.xPos+84,16+_room.yPos+76,'horizontal',80)
        self:newWall(_room.xPos+84,16+_room.yPos+236,'horizontal',80)
        self:newWall(_room.xPos+80,16+_room.yPos+76,'vertical',180)
        self:newWall(_room.xPos+236,16+_room.yPos+92,'horizontal',64)
        self:newWall(_room.xPos+236,16+_room.yPos+220,'horizontal',64)
        self:newWall(_room.xPos+299,16+_room.yPos+92,'vertical',148)
    end
    self.layouts[6]=function(_room)
        self:newWall(_room.xPos+220,16+_room.yPos+76,'horizontal',80)
        self:newWall(_room.xPos+220,16+_room.yPos+236,'horizontal',80)
        self:newWall(_room.xPos+299,16+_room.yPos+76,'vertical',180)
        self:newWall(_room.xPos+84,16+_room.yPos+92,'horizontal',64)
        self:newWall(_room.xPos+84,16+_room.yPos+220,'horizontal',64)
        self:newWall(_room.xPos+80,16+_room.yPos+92,'vertical',148)
    end
    self.layouts[7]=function(_room)
        self:newWall(_room.xPos+96,16+_room.yPos+76,'horizontal',192)
        self:newWall(_room.xPos+92,16+_room.yPos+76,'vertical',68)
        self:newWall(_room.xPos+287,16+_room.yPos+76,'vertical',68)
        self:newWall(_room.xPos+112,16+_room.yPos+236,'horizontal',160)
        self:newWall(_room.xPos+108,16+_room.yPos+204,'vertical',52)
        self:newWall(_room.xPos+271,16+_room.yPos+204,'vertical',52)
    end
    self.layouts[8]=function(_room)
        self:newWall(_room.xPos+96,16+_room.yPos+236,'horizontal',192)
        self:newWall(_room.xPos+92,16+_room.yPos+188,'vertical',68)
        self:newWall(_room.xPos+287,16+_room.yPos+188,'vertical',68)
        self:newWall(_room.xPos+112,16+_room.yPos+76,'horizontal',160)
        self:newWall(_room.xPos+108,16+_room.yPos+76,'vertical',52)
        self:newWall(_room.xPos+271,16+_room.yPos+76,'vertical',52)
    end

    self.layouts[9]=function(_room)
        self:newWall(_room.xPos+32,16+_room.yPos+92,'horizontal',112)
        self:newWall(_room.xPos+240,16+_room.yPos+92,'horizontal',112)
        self:newWall(_room.xPos+96,16+_room.yPos+236,'horizontal',192)
        self:newWall(_room.xPos+143,16+_room.yPos+92,'vertical',68)
        self:newWall(_room.xPos+92,16+_room.yPos+204,'vertical',52)
        self:newWall(_room.xPos+287,16+_room.yPos+204,'vertical',52)
    end
    self.layouts[10]=function(_room)
        self:newWall(_room.xPos+32,16+_room.yPos+92,'horizontal',112)
        self:newWall(_room.xPos+240,16+_room.yPos+92,'horizontal',112)
        self:newWall(_room.xPos+96,16+_room.yPos+236,'horizontal',192)
        self:newWall(_room.xPos+236,16+_room.yPos+92,'vertical',68)
        self:newWall(_room.xPos+92,16+_room.yPos+204,'vertical',52)
        self:newWall(_room.xPos+287,16+_room.yPos+204,'vertical',52)
    end
    self.layouts[11]=function(_room)
        self:newWall(_room.xPos+32,16+_room.yPos+236,'horizontal',112)
        self:newWall(_room.xPos+240,16+_room.yPos+236,'horizontal',112)
        self:newWall(_room.xPos+96,16+_room.yPos+92,'horizontal',192)
        self:newWall(_room.xPos+236,16+_room.yPos+188,'vertical',68)
        self:newWall(_room.xPos+92,16+_room.yPos+92,'vertical',52)
        self:newWall(_room.xPos+287,16+_room.yPos+92,'vertical',52)
    end
    self.layouts[12]=function(_room)
        self:newWall(_room.xPos+32,16+_room.yPos+236,'horizontal',112)
        self:newWall(_room.xPos+240,16+_room.yPos+236,'horizontal',112)
        self:newWall(_room.xPos+96,16+_room.yPos+92,'horizontal',192)
        self:newWall(_room.xPos+143,16+_room.yPos+188,'vertical',68)
        self:newWall(_room.xPos+92,16+_room.yPos+92,'vertical',52)
        self:newWall(_room.xPos+287,16+_room.yPos+92,'vertical',52)
    end
    self.layouts[13]=function(_room) --normal
        self:newWall(_room.xPos+128,16+_room.yPos+124,'horizontal',64)
        self:newWall(_room.xPos+240,16+_room.yPos+76,'horizontal',32)
        self:newWall(_room.xPos+240,16+_room.yPos+236,'horizontal',32)
        self:newWall(_room.xPos+124,16+_room.yPos+44,'vertical',100)
        self:newWall(_room.xPos+124,16+_room.yPos+204,'vertical',100)
        self:newWall(_room.xPos+271,16+_room.yPos+76,'vertical',180)
    end
    self.layouts[14]=function(_room) --mirror
        self:newWall(_room.xPos+192,16+_room.yPos+124,'horizontal',64)
        self:newWall(_room.xPos+112,16+_room.yPos+76,'horizontal',32)
        self:newWall(_room.xPos+112,16+_room.yPos+236,'horizontal',32)
        self:newWall(_room.xPos+255,16+_room.yPos+44,'vertical',100)
        self:newWall(_room.xPos+255,16+_room.yPos+204,'vertical',100)
        self:newWall(_room.xPos+108,16+_room.yPos+76,'vertical',180)
    end
    self.layouts[15]=function(_room) --mirror flipped
        self:newWall(_room.xPos+192,16+_room.yPos+188,'horizontal',64)
        self:newWall(_room.xPos+112,16+_room.yPos+76,'horizontal',32)
        self:newWall(_room.xPos+112,16+_room.yPos+236,'horizontal',32)
        self:newWall(_room.xPos+255,16+_room.yPos+44,'vertical',84)
        self:newWall(_room.xPos+255,16+_room.yPos+188,'vertical',116)
        self:newWall(_room.xPos+108,16+_room.yPos+76,'vertical',180)
    end
    self.layouts[16]=function(_room) -- flipped
        self:newWall(_room.xPos+128,16+_room.yPos+188,'horizontal',64)
        self:newWall(_room.xPos+240,16+_room.yPos+76,'horizontal',32)
        self:newWall(_room.xPos+240,16+_room.yPos+236,'horizontal',32)
        self:newWall(_room.xPos+124,16+_room.yPos+44,'vertical',84)
        self:newWall(_room.xPos+124,16+_room.yPos+188,'vertical',116)
        self:newWall(_room.xPos+271,16+_room.yPos+76,'vertical',180)
    end

    self.layouts[17]=function(_room)
        self:newWall(_room.xPos+32,16+_room.yPos+92,'horizontal',144)
        self:newWall(_room.xPos+272,16+_room.yPos+92,'horizontal',80)
        self:newWall(_room.xPos+256,16+_room.yPos+236,'horizontal',96)
        self:newWall(_room.xPos+123,16+_room.yPos+204,'vertical',100)
    end
    self.layouts[18]=function(_room)
        self:newWall(_room.xPos+32,16+_room.yPos+92,'horizontal',80)
        self:newWall(_room.xPos+208,16+_room.yPos+92,'horizontal',144)
        self:newWall(_room.xPos+32,16+_room.yPos+236,'horizontal',96)
        self:newWall(_room.xPos+256,16+_room.yPos+204,'vertical',100)
    end
    self.layouts[19]=function(_room)
        self:newWall(_room.xPos+32,16+_room.yPos+236,'horizontal',80)
        self:newWall(_room.xPos+208,16+_room.yPos+236,'horizontal',144)
        self:newWall(_room.xPos+32,16+_room.yPos+92,'horizontal',96)
        self:newWall(_room.xPos+256,16+_room.yPos+44,'vertical',84)
    end
    self.layouts[20]=function(_room)
        self:newWall(_room.xPos+272,16+_room.yPos+92,'horizontal',80)
        self:newWall(_room.xPos+32,16+_room.yPos+236,'horizontal',144)
        self:newWall(_room.xPos+256,16+_room.yPos+236,'horizontal',96)
        self:newWall(_room.xPos+123,16+_room.yPos+44,'vertical',84)
    end

    self.layouts[21]=function(_room)
        self:newWall(_room.xPos+128,16+_room.yPos+108,'horizontal',128)
        self:newWall(_room.xPos+128,16+_room.yPos+220,'horizontal',128)
        self:newWall(_room.xPos+255,16+_room.yPos+44,'vertical',84)
        self:newWall(_room.xPos+124,16+_room.yPos+220,'vertical',100)
    end
    self.layouts[22]=function(_room)
        self:newWall(_room.xPos+128,16+_room.yPos+108,'horizontal',128)
        self:newWall(_room.xPos+128,16+_room.yPos+220,'horizontal',128)
        self:newWall(_room.xPos+124,16+_room.yPos+44,'vertical',84)
        self:newWall(_room.xPos+255,16+_room.yPos+220,'vertical',100)
    end
    self.layouts[23]=function(_room)
        self:newWall(_room.xPos+32,16+_room.yPos+93,'horizontal',96)
        self:newWall(_room.xPos+256,16+_room.yPos+236,'horizontal',96)
        self:newWall(_room.xPos+127,16+_room.yPos+93,'vertical',148)
        self:newWall(_room.xPos+252,16+_room.yPos+108,'vertical',148)
    end
    self.layouts[24]=function(_room)
        self:newWall(_room.xPos+32,16+_room.yPos+236,'horizontal',96)
        self:newWall(_room.xPos+256,16+_room.yPos+93,'horizontal',96)
        self:newWall(_room.xPos+127,16+_room.yPos+108,'vertical',148)
        self:newWall(_room.xPos+252,16+_room.yPos+93,'vertical',148)
    end

    self.layouts[25]=function(_room)
        self:newWall(_room.xPos+32,16+_room.yPos+204,'horizontal',112)
        self:newWall(_room.xPos+112,16+_room.yPos+108,'horizontal',160)
        self:newWall(_room.xPos+108,16+_room.yPos+44,'vertical',84)
        self:newWall(_room.xPos+271,16+_room.yPos+108,'vertical',116)
    end
    self.layouts[26]=function(_room)
        self:newWall(_room.xPos+240,16+_room.yPos+204,'horizontal',112)
        self:newWall(_room.xPos+112,16+_room.yPos+108,'horizontal',160)
        self:newWall(_room.xPos+271,16+_room.yPos+44,'vertical',84)
        self:newWall(_room.xPos+108,16+_room.yPos+108,'vertical',116)
    end
    self.layouts[27]=function(_room)
        self:newWall(_room.xPos+240,16+_room.yPos+92,'horizontal',112)
        self:newWall(_room.xPos+112,16+_room.yPos+188,'horizontal',160)
        self:newWall(_room.xPos+271,16+_room.yPos+188,'vertical',116)
        self:newWall(_room.xPos+108,16+_room.yPos+92,'vertical',116)
    end
    self.layouts[28]=function(_room)
        self:newWall(_room.xPos+32,16+_room.yPos+92,'horizontal',112)
        self:newWall(_room.xPos+112,16+_room.yPos+188,'horizontal',160)
        self:newWall(_room.xPos+271,16+_room.yPos+92,'vertical',116)
        self:newWall(_room.xPos+108,16+_room.yPos+188,'vertical',116)
    end
    self.layouts[29]=function(_room)
        self:newWall(_room.xPos+128,16+_room.yPos+92,'horizontal',112)
        self:newWall(_room.xPos+243,16+_room.yPos+236,'horizontal',112)
        self:newWall(_room.xPos+239,16+_room.yPos+92,'vertical',164)
        self:newWall(_room.xPos+124,16+_room.yPos+171,'vertical',132)
    end
    self.layouts[30]=function(_room)
        self:newWall(_room.xPos+144,16+_room.yPos+92,'horizontal',112)
        self:newWall(_room.xPos+29,16+_room.yPos+236,'horizontal',112)
        self:newWall(_room.xPos+140,16+_room.yPos+92,'vertical',164)
        self:newWall(_room.xPos+255,16+_room.yPos+171,'vertical',132)
    end
    self.layouts[31]=function(_room)
        self:newWall(_room.xPos+29,16+_room.yPos+92,'horizontal',112)
        self:newWall(_room.xPos+144,16+_room.yPos+236,'horizontal',112)
        self:newWall(_room.xPos+140,16+_room.yPos+92,'vertical',164)
        self:newWall(_room.xPos+255,16+_room.yPos+44,'vertical',132)
    end
    self.layouts[32]=function(_room)
        self:newWall(_room.xPos+243,16+_room.yPos+92,'horizontal',112)
        self:newWall(_room.xPos+128,16+_room.yPos+236,'horizontal',112)
        self:newWall(_room.xPos+239,16+_room.yPos+92,'vertical',164)
        self:newWall(_room.xPos+124,16+_room.yPos+44,'vertical',132)
    end
    
    self.layouts[33]=function(_room)
        self:newWall(_room.xPos+144,16+_room.yPos+92,'horizontal',112)
        self:newWall(_room.xPos+80,16+_room.yPos+236,'horizontal',48)
        self:newWall(_room.xPos+192,16+_room.yPos+236,'horizontal',112)
        self:newWall(_room.xPos+76,16+_room.yPos+108,'vertical',148)
        self:newWall(_room.xPos+303,16+_room.yPos+156,'vertical',100)
        self:newWall(_room.xPos+255,16+_room.yPos+92,'vertical',52)
    end
    self.layouts[34]=function(_room)
        self:newWall(_room.xPos+128,16+_room.yPos+92,'horizontal',112)
        self:newWall(_room.xPos+256,16+_room.yPos+236,'horizontal',48)
        self:newWall(_room.xPos+80,16+_room.yPos+236,'horizontal',112)
        self:newWall(_room.xPos+303,16+_room.yPos+108,'vertical',148)
        self:newWall(_room.xPos+76,16+_room.yPos+156,'vertical',100)
        self:newWall(_room.xPos+124,16+_room.yPos+92,'vertical',52)
    end
    self.layouts[35]=function(_room)
        self:newWall(_room.xPos+80,16+_room.yPos+76,'horizontal',112)
        self:newWall(_room.xPos+256,16+_room.yPos+76,'horizontal',48)
        self:newWall(_room.xPos+128,16+_room.yPos+220,'horizontal',112)
        self:newWall(_room.xPos+303,16+_room.yPos+76,'vertical',148)
        self:newWall(_room.xPos+76,16+_room.yPos+76,'vertical',100)
        self:newWall(_room.xPos+124,16+_room.yPos+188,'vertical',52)
    end
    self.layouts[36]=function(_room)
        self:newWall(_room.xPos+192,16+_room.yPos+76,'horizontal',112)
        self:newWall(_room.xPos+80,16+_room.yPos+76,'horizontal',48)
        self:newWall(_room.xPos+144,16+_room.yPos+220,'horizontal',112)
        self:newWall(_room.xPos+76,16+_room.yPos+76,'vertical',148)
        self:newWall(_room.xPos+303,16+_room.yPos+76,'vertical',100)
        self:newWall(_room.xPos+255,16+_room.yPos+188,'vertical',52)
    end
    self.layouts[37]=function(_room)
        self:newWall(_room.xPos+144,16+_room.yPos+76,'horizontal',160)
        self:newWall(_room.xPos+96,16+_room.yPos+204,'horizontal',80)
        self:newWall(_room.xPos+192,16+_room.yPos+236,'horizontal',112)
        self:newWall(_room.xPos+92,16+_room.yPos+124,'vertical',100)
        self:newWall(_room.xPos+303,16+_room.yPos+172,'vertical',84)
        self:newWall(_room.xPos+303,16+_room.yPos+76,'vertical',52)
    end
    self.layouts[38]=function(_room)
        self:newWall(_room.xPos+80,16+_room.yPos+76,'horizontal',160)
        self:newWall(_room.xPos+208,16+_room.yPos+204,'horizontal',80)
        self:newWall(_room.xPos+80,16+_room.yPos+236,'horizontal',112)
        self:newWall(_room.xPos+287,16+_room.yPos+124,'vertical',100)
        self:newWall(_room.xPos+76,16+_room.yPos+172,'vertical',84)
        self:newWall(_room.xPos+76,16+_room.yPos+76,'vertical',52)
    end
    self.layouts[39]=function(_room)
        self:newWall(_room.xPos+80,16+_room.yPos+236,'horizontal',160)
        self:newWall(_room.xPos+208,16+_room.yPos+108,'horizontal',80)
        self:newWall(_room.xPos+80,16+_room.yPos+76,'horizontal',112)
        self:newWall(_room.xPos+287,16+_room.yPos+108,'vertical',100)
        self:newWall(_room.xPos+76,16+_room.yPos+76,'vertical',84)
        self:newWall(_room.xPos+76,16+_room.yPos+204,'vertical',52)
    end
    self.layouts[40]=function(_room)
        self:newWall(_room.xPos+144,16+_room.yPos+236,'horizontal',160)
        self:newWall(_room.xPos+96,16+_room.yPos+108,'horizontal',80)
        self:newWall(_room.xPos+192,16+_room.yPos+76,'horizontal',112)
        self:newWall(_room.xPos+92,16+_room.yPos+108,'vertical',100)
        self:newWall(_room.xPos+303,16+_room.yPos+76,'vertical',84)
        self:newWall(_room.xPos+303,16+_room.yPos+204,'vertical',52)
    end

    self.layouts[41]=function(_room)
        self:newWall(_room.xPos+32,16+_room.yPos+92,'horizontal',80)
        self:newWall(_room.xPos+272,16+_room.yPos+236,'horizontal',80)
        self:newWall(_room.xPos+111,16+_room.yPos+92,'vertical',116)
        self:newWall(_room.xPos+268,16+_room.yPos+44,'vertical',68)
        self:newWall(_room.xPos+268,16+_room.yPos+172,'vertical',84)
        self:newWall(_room.xPos+111,16+_room.yPos+252,'vertical',52)
    end
    self.layouts[42]=function(_room)
        self:newWall(_room.xPos+32,16+_room.yPos+220,'horizontal',80)
        self:newWall(_room.xPos+272,16+_room.yPos+76,'horizontal',80)
        self:newWall(_room.xPos+268,16+_room.yPos+76,'vertical',116)
        self:newWall(_room.xPos+111,16+_room.yPos+44,'vertical',52)
        self:newWall(_room.xPos+111,16+_room.yPos+156,'vertical',84)
        self:newWall(_room.xPos+268,16+_room.yPos+236,'vertical',68)
    end
    self.layouts[43]=function(_room)
        self:newWall(_room.xPos+272,16+_room.yPos+220,'horizontal',80)
        self:newWall(_room.xPos+32,16+_room.yPos+76,'horizontal',80)
        self:newWall(_room.xPos+268,16+_room.yPos+124,'vertical',116)
        self:newWall(_room.xPos+111,16+_room.yPos+76,'vertical',84)
        self:newWall(_room.xPos+111,16+_room.yPos+220,'vertical',84)
        self:newWall(_room.xPos+268,16+_room.yPos+44,'vertical',36)
    end
    self.layouts[44]=function(_room)
        self:newWall(_room.xPos+272,16+_room.yPos+76,'horizontal',80)
        self:newWall(_room.xPos+32,16+_room.yPos+220,'horizontal',80)
        self:newWall(_room.xPos+111,16+_room.yPos+124,'vertical',116)
        self:newWall(_room.xPos+268,16+_room.yPos+76,'vertical',84)
        self:newWall(_room.xPos+268,16+_room.yPos+220,'vertical',84)
        self:newWall(_room.xPos+111,16+_room.yPos+44,'vertical',36)
    end
    self.layouts[45]=function(_room)
        self:newWall(_room.xPos+112,16+_room.yPos+92,'horizontal',128)
        self:newWall(_room.xPos+176,16+_room.yPos+204,'horizontal',112)
        self:newWall(_room.xPos+31,16+_room.yPos+204,'horizontal',64)
        self:newWall(_room.xPos+304,16+_room.yPos+92,'horizontal',48)
        self:newWall(_room.xPos+108,16+_room.yPos+44,'vertical',68)
        self:newWall(_room.xPos+287,16+_room.yPos+204,'vertical',84)
    end
    self.layouts[46]=function(_room)
        self:newWall(_room.xPos+144,16+_room.yPos+92,'horizontal',128)
        self:newWall(_room.xPos+96,16+_room.yPos+204,'horizontal',112)
        self:newWall(_room.xPos+288,16+_room.yPos+204,'horizontal',64)
        self:newWall(_room.xPos+32,16+_room.yPos+92,'horizontal',48)
        self:newWall(_room.xPos+271,16+_room.yPos+44,'vertical',68)
        self:newWall(_room.xPos+92,16+_room.yPos+204,'vertical',84)
    end
    self.layouts[47]=function(_room)
        self:newWall(_room.xPos+96,16+_room.yPos+92,'horizontal',112)
        self:newWall(_room.xPos+144,16+_room.yPos+204,'horizontal',128)
        self:newWall(_room.xPos+288,16+_room.yPos+92,'horizontal',64)
        self:newWall(_room.xPos+32,16+_room.yPos+204,'horizontal',48)
        self:newWall(_room.xPos+92,16+_room.yPos+44,'vertical',68)
        self:newWall(_room.xPos+271,16+_room.yPos+204,'vertical',84)
    end
    self.layouts[48]=function(_room)
        self:newWall(_room.xPos+176,16+_room.yPos+92,'horizontal',112)
        self:newWall(_room.xPos+112,16+_room.yPos+204,'horizontal',128)
        self:newWall(_room.xPos+32,16+_room.yPos+92,'horizontal',64)
        self:newWall(_room.xPos+304,16+_room.yPos+204,'horizontal',48)
        self:newWall(_room.xPos+287,16+_room.yPos+28,'vertical',84)
        self:newWall(_room.xPos+108,16+_room.yPos+204,'vertical',84)
    end
    
    self.layouts[49]=function(_room)
        self:newWall(_room.xPos+128,16+_room.yPos+77,'horizontal',128)
        self:newWall(_room.xPos+128,16+_room.yPos+236,'horizontal',128)
        self:newWall(_room.xPos+80,16+_room.yPos+108,'vertical',132)
        self:newWall(_room.xPos+304,16+_room.yPos+108,'vertical',132)
    end
end

function Walls:newWall(_xPos,_yPos,_type,_length)
    local wall={}

    wall.xPos=_xPos
    wall.yPos=_yPos
    wall.type=_type
    wall.sprites={}

    if wall.type=='horizontal' then
        wall.sprites.left=self.wallSprites.horizontalLeft
        wall.sprites.right=self.wallSprites.horizontalRight
        wall.sprites.middle=self.wallSprites.horizontalMiddle
        wall.w=_length
        wall.h=20
        wall.numMiddleSegments=(wall.w-32) / 16
    elseif wall.type=='vertical' then
        wall.sprites.top=self.wallSprites.verticalTop
        wall.sprites.bottom=self.wallSprites.verticalBottom 
        wall.sprites.middle=self.wallSprites.verticalMiddle
        wall.w=5
        wall.h=_length
        wall.numMiddleSegments=(wall.h-36) / 16
    end

    --create physical collider
    wall.collider=world:newRectangleCollider(wall.xPos,wall.yPos,wall.w,wall.h-16)
    wall.collider:setType('static')
    wall.collider:setCollisionClass('innerWall')

    function wall:update() end

    function wall:draw() 
        if wall.type=='horizontal' then 
            love.graphics.draw(wall.sprites.left,wall.xPos,wall.yPos,nil,1,1,0,16)
            for i=1,wall.numMiddleSegments do 
                love.graphics.draw(wall.sprites.middle,wall.xPos+(16*i),wall.yPos,nil,1,1,0,16)
            end
            love.graphics.draw(wall.sprites.right,wall.xPos+wall.w-16,wall.yPos,nil,1,1,0,16)
        else -- wall.type==vertical
            love.graphics.draw(wall.sprites.top,wall.xPos,wall.yPos,nil,1,1,0,16)
            for i=1,wall.numMiddleSegments do 
                love.graphics.draw(wall.sprites.middle,wall.xPos,wall.yPos+(16*i)+4,nil,1,1,0,16)
            end
            love.graphics.draw(wall.sprites.bottom,wall.xPos,wall.yPos+wall.h-16,nil,1,1,0,16)
        end
    end

    --insert into entitiesTable to have dynamic draw order
    table.insert(Entities.entitiesTable,wall)
end