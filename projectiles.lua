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

    self.centers={ --used to draw sprites at their center
        bow_t0={x=3,y=3},
        bow_t1={x=10.5,y=3},
        bow_t2={x=10.5,y=3},
        bow_t3={x=10.5,y=3},
        staff_t0={x=3,y=3},
        staff_t1={x=3,y=3},
        staff_t2={x=4,y=4},
        staff_t3={x=6,y=6}
    }

    self.yOffsets={ --used to offset sprites so they are 'above' the ground
        bow_t0=-8,
        bow_t1=-8,
        bow_t2=-8,
        bow_t3=-8,
        staff_t0=-8,
        staff_t1=-22,
        staff_t2=-22,
        staff_t3=-44
    }
end 

--Create and launch a new projectile at a given target entity
function Projectiles:launch(_xPos,_yPos,_type,_target)
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
        self.speed=240 --speed of the projectile

        --how quickly the sprite will lower to the ground after being launched
        --the closer the distance to the target and the more negative the yOffset,
        --the faster it will be lowered to the ground.
        self.lowerRate=-180*(self.yOffset)/(
            ((self.target.xPos-self.xPos)^2+(self.target.yPos-self.yPos)^2)^0.5
        )

        table.insert(Entities.entitiesTable,p) --insert into projectiles table
    end

    function p:update()
        --update position
        self.xPos=self.xPos+self.xVel*dt
        self.yPos=self.yPos+self.yVel*dt
        
        --calculate angle toward the target and set velocities such that
        --projectile will home in on target at a constant speed (self.speed)
        self.angle=math.atan2(
            ((self.target.yPos-self.targetHeight)-self.yPos), --y distance component
            (self.target.xPos-self.xPos)  --x distance component
        )
        self.xVel=math.cos(self.angle)*self.speed
        self.yVel=math.sin(self.angle)*self.speed

        --rotate only if projectile is an arrow
        if self.type=='bow_t1' or self.type=='bow_t2' or self.type=='bow_t3' then 
            self.rotation=self.angle 
        end

        --'lower' sprite by increasing yOffset to -8 if it's <-8
        if self.yOffset<-8 then 
            self.yOffset=self.yOffset+self.lowerRate*dt
        end

        --when projectile reaches target
        if math.abs(self.xPos-self.target.xPos)<self.targetWidth+3 --need +3 here
        and math.abs(self.yPos-self.target.yPos)<self.targetHeight+3 --need +3 here
        then
            --knockback enemy
            self.target.collider:applyLinearImpulse(self.xVel*0.2,self.yVel*0.2)
            return false --remove projectile from game
        end
    end

    function p:draw() 
        love.graphics.draw(
            self.sprite,self.xPos,self.yPos+self.yOffset,
            self.rotation,1,1, --arrows will rotate toward enemy target
            self.xCenter,self.yCenter
        )
        --testing-----------------------------------------------
        love.graphics.rectangle('line',self.xPos,self.yPos,1,1)
        --testing----------------------------------------------
    end

    p:load()
end