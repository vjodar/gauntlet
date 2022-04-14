Projectiles={}

function Projectiles:load()
    self.sprites={}
    self.sprites.bow_t0=love.graphics.newImage('assets/weapon_stone_projectile.png')
    self.sprites.staff_t0=self.sprites.bow_t0 
    self.sprites.bow_t1=love.graphics.newImage('assets/weapon_bow_projectile.png')
    self.sprites.staff_t1=love.graphics.newImage('assets/weapon_staff_t1_projectile.png')
    self.sprites.bow_t2=self.sprites.bow_t1
    self.sprites.staff_t2=love.graphics.newImage('assets/weapon_staff_t2_projectile.png')
    self.sprites.bow_t3=self.sprites.bow_t1
    self.sprites.staff_t3=love.graphics.newImage('assets/weapon_staff_t3_projectile.png')

    self.offsets={
        bow_t0={x=3,y=3},
        bow_t1={x=10.5,y=3.5},
        bow_t2={x=10.5,y=3.5},
        bow_t3={x=10.5,y=3.5},
        staff_t0={x=3,y=3},
        staff_t1={x=3,y=3},
        staff_t2={x=4,y=4},
        staff_t3={x=6,y=6}
    }

    self.targetHitboxesSizes={
        orc_t1={w=9,h=5},
        demon_t1={w=9,h=5},
        skeleton_t1={w=9,h=5},
        orc_t2={w=10,h=6},
        demon_t2={w=11,h=6},
        mage_t2={w=12,h=6},
        orc_t3={w=19,h=8},
        demon_t3={w=19,h=8}
    }
end 

--Create and launch a new projectile at a given target entity
function Projectiles:launch(_xPos,_yPos,_type,_target)
    local p={}

    function p:load()
        self.sprite=Projectiles.sprites[_type]
        self.xPos,self.yPos=_xPos,_yPos 
        self.xOffset=Projectiles.offsets[_type].x
        self.yOffset=Projectiles.offsets[_type].y
        self.target=_target
        self.targetWidth=Projectiles.targetHitboxesSizes[_target.name].w
        self.targetHeight=Projectiles.targetHitboxesSizes[_target.name].h
        self.angle,self.xVel,self.yVel=0,0,0
        self.speed=120 --speed of the projectile

        --insert into entitiesTable for dynamic draw order
        table.insert(Entities.entitiesTable,p)
    end

    function p:update()
        --update position
        self.xPos=self.xPos+self.xVel*dt
        self.yPos=self.yPos+self.yVel*dt
        
        --calculate angle toward the target and set velocities such that
        --projectile will home in on target at a constant speed (self.speed)
        self.angle=math.atan2(
            (self.target.yPos-self.yPos), --y distance component
            (self.target.xPos-self.xPos)  --x distance component
        )
        self.xVel=math.cos(self.angle)*self.speed
        self.yVel=math.sin(self.angle)*self.speed

        --when projectile reaches target
        if math.abs(self.xPos-self.target.xPos)<self.targetWidth
            and math.abs(self.yPos-self.target.yPos)<self.targetHeight
        then
            print('hit the enemy!')
            return false --remove projectile from game
        end
    end

    function p:draw() 
        love.graphics.draw(
            self.sprite,self.xPos,self.yPos,
            self.angle,1,1, --sprite will rotate toward enemy target
            self.xOffset,self.yOffset)
    end

    p:load()
end