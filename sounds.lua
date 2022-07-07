Sounds={}

--construct and return a new sound effect using one or more .wav files
Sounds.newSound=function(_names,_repeatDelay)
    local sound={sources={}}
    for i,name in pairs(_names) do 
        table.insert(
            sound.sources,
            love.audio.newSource('assets/sfx/'..name..'.wav','static')
        )
    end
    if _repeatDelay then 
        sound.willRepeat=true 
        sound.onCooldown=false 
        sound.cooldownTime=_repeatDelay
    else 
        sound.willRepeat=false 
    end

    --play sources at a given pitch if provided, if sound will be repeated
    --continuously, take into account its repeat delay period.
    function sound:play(_pitch)
        if self.willRepeat and self.onCooldown then return end 
        for i,source in pairs(self.sources) do 
            if _pitch then source:setPitch(_pitch) end
            source:stop()
            source:play() 
        end 
        if self.willRepeat then 
            self.onCooldown=true 
            TimerState:after(
                self.cooldownTime,
                function() self.onCooldown=false end
            )
        end
    end 
    
    function sound:stop() --stop the source if currently playing. 
        for i,source in pairs(self.sources) do source:stop() end 
    end

    return sound 
end

--player sounds
Sounds.footsteps=function() return Sounds.newSound({'footsteps'},0.4) end
Sounds.falling=function() return Sounds.newSound({'falling'}) end --falling into room
Sounds.landing=function() return Sounds.newSound({'landing'}) end --landing in room

--magics
Sounds.protection_deactivate=function() return Sounds.newSound({'protection_deactivate'}) end 
Sounds.protection_activate_magical=function() return Sounds.newSound({'protection_activate_magical'}) end 
Sounds.protection_activate_physical=function() return Sounds.newSound({'protection_activate_physical'}) end 
Sounds.protect_physical=function() return Sounds.newSound({'protect_physical'}) end

--nodes sounds
Sounds.pickaxe=function() return Sounds.newSound({'pickaxe'}) end
Sounds.hatchet=function() return Sounds.newSound({'hatchet'}) end
Sounds.splash=function() return Sounds.newSound({'splash'}) end --fishing hole splashing
Sounds.harvest_vine=function() return Sounds.newSound({'harvest_plant'},0.35) end
Sounds.harvest_fungi=function() return Sounds.newSound({'harvest_plant'},0.4) end
Sounds.vine=function() return Sounds.newSound({'vine'}) end

--weapon sounds
Sounds.charge_staff_t1=function() return Sounds.newSound({'charge_staff_t1'}) end 
Sounds.charge_staff_t2=function() return Sounds.newSound({'charge_staff_t2'}) end 
Sounds.charge_staff_t3=function() return Sounds.newSound({'charge_staff_t3'}) end 

--projectile sounds
Sounds.launch_bow_t0=function() return Sounds.newSound({'launch_stone'}) end
Sounds.launch_staff_t0=Sounds.launch_bow_t0
Sounds.launch_bow_t1=function() return Sounds.newSound({'launch_stone'}) end
Sounds.launch_staff_t1=function() return Sounds.newSound({'staff_t1'}) end
Sounds.launch_bow_t2=function() return Sounds.newSound({'launch_stone'}) end
Sounds.launch_staff_t2=function() return Sounds.newSound({'staff_t2'}) end
Sounds.launch_bow_t3=function() return Sounds.newSound({'launch_stone'}) end
Sounds.launch_staff_t3=function() return Sounds.newSound({'staff_t3'}) end
Sounds.collision_physical=function() 
    return Sounds.newSound({'collision_physical'})
end
