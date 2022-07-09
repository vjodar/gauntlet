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

    function sound:setPitch(_pitch) --set's new base pitch
        for i,source in pairs(self.sources) do source:setPitch(_pitch) end 
    end
    
    return sound 
end

Sounds.blank=function() --returns a blank sound
    local sound={sources={}}
    sound.play=function() end 
    sound.stop=sound.play 
    sound.setPitch=sound.play
    return sound
end

--footsteps
Sounds.footsteps=function() return Sounds.newSound({'footsteps'},0.4) end --player/default
Sounds.footsteps_mage=function() return Sounds.newSound({'footsteps_mage'},0.4) end
Sounds.footsteps_t3=function() return Sounds.newSound({'footsteps_t3','footsteps_bass'},0.4) end
Sounds.footsteps_t4=function() --boss footsteps
    return Sounds.newSound({'footsteps_t3','footsteps_bass','footsteps_bass'},0.6) 
end

--player sounds
Sounds.falling=function() return Sounds.newSound({'falling'}) end --falling into room
Sounds.landing=function() return Sounds.newSound({'landing'}) end --landing in room

--enemy sounds
Sounds.jump=function() return Sounds.newSound({'jump'}) end --t1 lunge
Sounds.bite=function() return Sounds.newSound({'bite','jump'}) end --t2 demon bite
Sounds.charge_demon_t2=function() return Sounds.newSound({'charge_demon_t2'}) end 
Sounds.charge_demon_t3=function() return Sounds.newSound({'charge_demon_t3'}) end 

--magics
Sounds.protection_deactivate=function() return Sounds.newSound({'protection_deactivate'}) end 
Sounds.protection_activate_magical=function() return Sounds.newSound({'protection_activate_magical'}) end 
Sounds.protection_activate_physical=function() return Sounds.newSound({'protection_activate_physical'}) end 
Sounds.protectPhysical=function() return Sounds.newSound({'protect_physical'}) end
Sounds.protectMagical=function() return Sounds.newSound({'protect_magical'}) end

--nodes sounds
Sounds.pickaxe=function() return Sounds.newSound({'pickaxe'}) end
Sounds.hatchet=function() return Sounds.newSound({'hatchet'}) end
Sounds.harpoon=function() return Sounds.newSound({'splash','splash_2'}) end --fishing hole splashing
Sounds.harvest_vine=function() return Sounds.newSound({'harvest_plant'},0.35) end
Sounds.harvest_fungi=function() return Sounds.newSound({'harvest_plant'},0.4) end
Sounds.vine=function() return Sounds.newSound({'vine'}) end
Sounds.furnace=function() return Sounds.newSound({'furnace_1','furnace_2','furnace_3'},0.8) end
Sounds.grill=function() return Sounds.newSound({'grill'},0.6) end
Sounds.sawmill=function() return Sounds.newSound({'sawmill_1','sawmill_2'},1.3) end
Sounds.spinning_wheel=function() return Sounds.newSound({'spinning_wheel'},0.8) end

--item sounds
Sounds.item=function() return Sounds.newSound({'item'}) end

--consumable sounds
Sounds.use_consumable=function() return Sounds.newSound({'use_consumable'}) end
Sounds.consume_fish=function() return Sounds.newSound({'consume_fish'}) end 
Sounds.consume_potion=function() return Sounds.newSound({'consume_potion'}) end 

--door button sounds
Sounds.button=function() return Sounds.newSound({'button'}) end

--room sounds
Sounds.room_reveal=function() return Sounds.newSound({'room_reveal'}) end

--weapon sounds
Sounds.charge_bow_t0=function() return Sounds.blank() end     --t0 weapons have no
Sounds.charge_staff_t0=function() return Sounds.blank() end   --charge sfx
Sounds.charge_bow_t1=function() return Sounds.newSound({'charge_bow'}) end 
Sounds.charge_bow_t2=function() return Sounds.newSound({'charge_bow'}) end 
Sounds.charge_bow_t3=function() return Sounds.newSound({'charge_bow'}) end 
Sounds.charge_staff_t1=function() return Sounds.newSound({'charge_staff_t1'}) end 
Sounds.charge_staff_t2=function() return Sounds.newSound({'charge_staff_t2'}) end 
Sounds.charge_staff_t3=function() return Sounds.newSound({'charge_staff_t3'}) end 

--projectile sounds
Sounds.hit=function() return Sounds.newSound({'collision_physical'}) end
Sounds.launch_bow_t0=function() return Sounds.newSound({'launch_stone'}) end
Sounds.launch_bow_t1=function() return Sounds.newSound({'launch_stone'}) end
Sounds.launch_bow_t2=function() return Sounds.newSound({'launch_stone'}) end
Sounds.launch_bow_t3=function() return Sounds.newSound({'launch_stone'}) end
Sounds.launch_staff_t0=Sounds.launch_bow_t0
Sounds.launch_staff_t1=function() return Sounds.newSound({'staff_t1'}) end
Sounds.launch_staff_t2=function() return Sounds.newSound({'staff_t2'}) end
Sounds.launch_staff_t3=function() return Sounds.newSound({'staff_t3'}) end
Sounds.launch_orc_t2=function() return Sounds.newSound({'launch_stone'}) end
Sounds.launch_orc_t3=function() return Sounds.newSound({'launch_stone'}) end
Sounds.launch_mage_t2=function() return Sounds.newSound({'staff_t1'}) end
Sounds.launch_demon_t3=function() return Sounds.newSound({'staff_t1'}) end

--special attack sounds


--menu sounds
Sounds.menu_open=function() return Sounds.newSound({'menu_open'},1) end
Sounds.menu_close=function() return Sounds.newSound({'menu_close'},1) end
Sounds.failure=function() return Sounds.newSound({'failure'}) end 
