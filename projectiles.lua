Projectiles={}

function Projectiles:load()
    self.sprites={}
    self.sprites.bow_t0=love.graphics.newImage('assets/projectiles/weapon_stone_projectile.png')
    self.sprites.staff_t0=self.sprites.bow_t0 
    self.sprites.bow_t1=love.graphics.newImage('assets/projectiles/weapon_bow_projectile.png')
    self.sprites.staff_t1=love.graphics.newImage('assets/projectiles/weapon_staff_t1_projectile.png')
    self.sprites.bow_t2=self.sprites.bow_t1
    self.sprites.staff_t2=love.graphics.newImage('assets/projectiles/weapon_staff_t2_projectile.png')
    self.sprites.bow_t3=self.sprites.bow_t1
    self.sprites.staff_t3=love.graphics.newImage('assets/projectiles/weapon_staff_t3_projectile.png')
    self.sprites.demon_t3=love.graphics.newImage('assets/projectiles/demon_t3_projectile.png')
    self.sprites.orc_t3=self.sprites.bow_t1
    self.sprites.mage_t2=love.graphics.newImage('assets/projectiles/mage_t2_projectile.png')
    self.sprites.orc_t2=love.graphics.newImage('assets/projectiles/orc_t2_projectile.png')

    self.centers={ --used to draw sprites at their center
        bow_t0={x=3,y=3},
        bow_t1={x=10.5,y=3},
        bow_t2={x=10.5,y=3},
        bow_t3={x=10.5,y=3},
        staff_t0={x=3,y=3},
        staff_t1={x=3,y=3},
        staff_t2={x=4,y=4},
        staff_t3={x=6,y=6},
        demon_t3={x=5,y=5},
        orc_t3={x=10.5,y=3},
        orc_t2={x=10.5,y=2.5},
        mage_t2={x=4,y=4},
    }

    self.yOffsets={ --used to offset sprites so they are 'above' the ground
        bow_t0=-8,
        bow_t1=-8,
        bow_t2=-8,
        bow_t3=-8,
        staff_t0=-8,
        staff_t1=-22,
        staff_t2=-22,
        staff_t3=-44,
        demon_t3=-11,
        orc_t3=-15,
        orc_t2=-6,
        mage_t2=-17,
    }

    self.knockbackValues={
        bow_t0=10,
        bow_t1=15,
        bow_t2=20,
        bow_t3=30,
        staff_t0=10,
        staff_t1=15,
        staff_t2=20,
        staff_t3=30,        
        demon_t3=60,
        orc_t3=60,
        orc_t2=30,
        mage_t2=30,
    }

    self.damageValues={
        bow_t0=5,
        bow_t1=10,
        bow_t2=20,
        bow_t3=30,
        staff_t0=5,
        staff_t1=10,
        staff_t2=20,
        staff_t3=30,
        demon_t3=30,
        orc_t3=30,
        orc_t2=15,
        mage_t2=15,
    }

    self.projectileSpeeds={
        bow_t0=200,
        bow_t1=240,
        bow_t2=240,
        bow_t3=240,
        staff_t0=200,
        staff_t1=240,
        staff_t2=240,
        staff_t3=240,
        demon_t3=240,
        orc_t3=240,
        orc_t2=120,
        mage_t2=200,
    }

    self.damageTypes={
        bow_t0='physical',
        bow_t1='physical',
        bow_t2='physical',
        bow_t3='physical',
        staff_t0='physical',
        staff_t1='magical',
        staff_t2='magical',
        staff_t3='magical',
        demon_t3='magical',
        orc_t3='physical',
        orc_t2='physical',
        mage_t2='magical',
    }
end 

--Create and launch a new projectile at a given target entity
function Projectiles:launch(_xPos,_yPos,_type,_target,_damageBonus)
    local p={}

    function p:load()
        self.type=_type
        self.sprite=Projectiles.sprites[_type]
        self.xPos,self.yPos=_xPos,_yPos
        self.xCenter=Projectiles.centers[_type].x
        self.yCenter=Projectiles.centers[_type].y
        self.yOffset=Projectiles.yOffsets[_type]
        self.target=_target
        self.targetWidth=self.target.shadow.w
        self.targetHeight=self.target.shadow.h
        self.angle,self.xVel,self.yVel=0,0,0
        self.rotation=nil --used to rotate arrows to target
        self.speed=Projectiles.projectileSpeeds[_type] --speed of the projectile
        self.knockback=Projectiles.knockbackValues[_type]
        self.damage=Projectiles.damageValues[_type]
        self.damageType=Projectiles.damageTypes[_type]
        self.damageBonus=_damageBonus or 0

        --how quickly the sprite will lower to the ground after being launched
        --the closer the distance to the target and the more negative the yOffset,
        --the faster it will be lowered to the ground.
        --Only applies to staff projectiles, since they start high up.
        self.lowerRate=-180*(self.yOffset)/(
            ((self.target.xPos-self.xPos)^2+(self.target.yPos-self.yPos)^2)^0.5
        )

        self.shadow=Shadows:newShadow('projectile_'.._type) --shadow (NOT FOLLOWING STANDARDS!)

        table.insert(Entities.entitiesTable,p) --insert into projectiles table
    end

    function p:update()
        --if enemy has died while projectile is still traveling, destory projectile
        if self.target.health.current==0 then return false end 
        
        --calculate angle toward the target and set velocities such that
        --projectile will home in on target at a constant speed (self.speed)
        self.angle=math.atan2(
            (self.target.yPos-self.yPos), --y distance component
            (self.target.xPos-self.xPos)  --x distance component
        )
        self.xVel=math.cos(self.angle)*self.speed
        self.yVel=math.sin(self.angle)*self.speed

        --update position
        self.xPos=self.xPos+self.xVel*dt
        self.yPos=self.yPos+self.yVel*dt

        --rotate only if projectile is an arrow or spear
        if self.type=='bow_t1' 
        or self.type=='bow_t2' 
        or self.type=='bow_t3' 
        or self.type=='orc_t3' 
        or self.type=='orc_t2' 
        then 
            self.rotation=self.angle 
        end

        --'lower' sprite by increasing yOffset to -8 if it's <-8
        if self.yOffset<-8 then 
            self.yOffset=self.yOffset+self.lowerRate*dt
        end

        --when projectile reaches target
        if math.abs(self.xPos-self.target.xPos)<=self.targetWidth
        and math.abs(self.yPos-self.target.yPos)<=self.targetHeight
        then
            self.target:takeDamage( --damage and knockback target
                'projectile',self.damageType,self.knockback,self.angle,
                self.damage+self.damageBonus --add damage bonus
            )
            return false --remove projectile from game
        end
    end

    function p:draw() 
        self.shadow:draw(self.xPos,self.yPos,self.rotation)
        love.graphics.draw(
            self.sprite,self.xPos,self.yPos+self.yOffset,
            self.rotation,1,1, --arrows will rotate toward enemy target
            self.xCenter,self.yCenter
        )
    end

    p:load()
end