Sounds={}

function Sounds:load()
    self.data={ --sound data used to create sources
        footsteps=love.sound.newSoundData("assets/sfx/footsteps.wav"),
        footsteps_mage=love.sound.newSoundData("assets/sfx/footsteps_mage.wav"),
        footsteps_t3=love.sound.newSoundData("assets/sfx/footsteps_t3.wav"),
        footsteps_bass=love.sound.newSoundData("assets/sfx/footsteps_bass.wav"),
        falling=love.sound.newSoundData("assets/sfx/falling.wav"),
        landing=love.sound.newSoundData("assets/sfx/landing.wav"),
        jump=love.sound.newSoundData("assets/sfx/jump.wav"),
        bite=love.sound.newSoundData("assets/sfx/bite.wav"),
        charge_demon_t2=love.sound.newSoundData("assets/sfx/charge_demon_t2.wav"),
        charge_demon_t3=love.sound.newSoundData("assets/sfx/charge_demon_t3.wav"),
        protection_deactivate=love.sound.newSoundData("assets/sfx/protection_deactivate.wav"),
        protection_activate_magical=love.sound.newSoundData("assets/sfx/protection_activate_magical.wav"),
        protection_activate_physical=love.sound.newSoundData("assets/sfx/protection_activate_physical.wav"),
        protect_physical=love.sound.newSoundData("assets/sfx/protect_physical.wav"),
        protect_magical=love.sound.newSoundData("assets/sfx/protect_magical.wav"),
        pickaxe=love.sound.newSoundData("assets/sfx/pickaxe.wav"),
        hatchet=love.sound.newSoundData("assets/sfx/hatchet.wav"),
        splash_1=love.sound.newSoundData("assets/sfx/splash_1.wav"),
        splash_2=love.sound.newSoundData("assets/sfx/splash_2.wav"),
        harvest_plant=love.sound.newSoundData("assets/sfx/harvest_plant.wav"),
        vine=love.sound.newSoundData("assets/sfx/vine.wav"),
        furnace_1=love.sound.newSoundData("assets/sfx/furnace_1.wav"),
        furnace_2=love.sound.newSoundData("assets/sfx/furnace_2.wav"),
        furnace_3=love.sound.newSoundData("assets/sfx/furnace_3.wav"),
        grill=love.sound.newSoundData("assets/sfx/grill.wav"),
        sawmill_1=love.sound.newSoundData("assets/sfx/sawmill_1.wav"),
        sawmill_2=love.sound.newSoundData("assets/sfx/sawmill_2.wav"),
        spinning_wheel=love.sound.newSoundData("assets/sfx/spinning_wheel.wav"),
        item=love.sound.newSoundData("assets/sfx/item.wav"),
        use_consumable=love.sound.newSoundData("assets/sfx/use_consumable.wav"),
        consume_fish=love.sound.newSoundData("assets/sfx/consume_fish.wav"),
        consume_potion=love.sound.newSoundData("assets/sfx/consume_potion.wav"),
        button=love.sound.newSoundData("assets/sfx/button.wav"),
        room_reveal=love.sound.newSoundData("assets/sfx/room_reveal.wav"),
        charge_bow=love.sound.newSoundData("assets/sfx/charge_bow.wav"),
        charge_staff_t1=love.sound.newSoundData("assets/sfx/charge_staff_t1.wav"),
        charge_staff_t2=love.sound.newSoundData("assets/sfx/charge_staff_t2.wav"),
        charge_staff_t3=love.sound.newSoundData("assets/sfx/charge_staff_t3.wav"),
        collision_physical=love.sound.newSoundData("assets/sfx/collision_physical.wav"),
        launch_stone=love.sound.newSoundData("assets/sfx/launch_stone.wav"),
        staff_t1=love.sound.newSoundData("assets/sfx/staff_t1.wav"),
        staff_t2=love.sound.newSoundData("assets/sfx/staff_t2.wav"),
        staff_t3=love.sound.newSoundData("assets/sfx/staff_t3.wav"),
        mage_t2=love.sound.newSoundData("assets/sfx/mage_t2.wav"),
        demon_t3=love.sound.newSoundData("assets/sfx/demon_t3.wav"),
        tornado=love.sound.newSoundData("assets/sfx/tornado.wav"),
        flames=love.sound.newSoundData("assets/sfx/flames.wav"),
        fire_circle=love.sound.newSoundData("assets/sfx/fire_circle.wav"),
        charge_fireball=love.sound.newSoundData("assets/sfx/charge_fireball.wav"),
        launch_fireball=love.sound.newSoundData("assets/sfx/launch_fireball.wav"),
        disabling_fireball=love.sound.newSoundData("assets/sfx/disabling_fireball.wav"),
        charge_fissure=love.sound.newSoundData("assets/sfx/charge_fissure.wav"),
        launch_fissure_1=love.sound.newSoundData("assets/sfx/launch_fissure_1.wav"),
        launch_fissure_2=love.sound.newSoundData("assets/sfx/launch_fissure_2.wav"),
        lava_bubble=love.sound.newSoundData("assets/sfx/lava_bubble.wav"),
        fissure_travel=love.sound.newSoundData("assets/sfx/fissure_travel.wav"),
        menu_open=love.sound.newSoundData("assets/sfx/menu_open.wav"),
        menu_close=love.sound.newSoundData("assets/sfx/menu_close.wav"),
        menu_move=love.sound.newSoundData("assets/sfx/menu_move.wav"),
        failure=love.sound.newSoundData("assets/sfx/failure.wav"),
        game_over=love.sound.newSoundData("assets/sfx/game_over.wav"),
    }

    self.seeds={ --used to open and modify sounds in ChipTone
        menu_move="eNpjYvg5-y-rAMsZmyMMjgz_6xkYGurdGZkZmBmEmP_XA_lGxgwMIMEzPhC6k5GBwco_zg6kFFkcRu8RgdBM69iNjCcyMBxggICG-v_2EJoZxoALHHFoBjP22qexgWh0HfwWkyVA9IzI7D9gcQiUnxHJQE8AAGNsNl0.",
        menu_open="eNpjYuB790GegcXI-H89CDIwNNS7MzIzeDEGMoH5RsYMDCDBMz4QupORgcHKP84OpBRZHEbvEYHQTOvYjYwnMjAcYICAhvr_9hCaGcaACxxxaAYz9tqnsYFodB38FpMlQPSMyOw_YHEIlJ8RyUBPAAC7NTec",
        menu_close="eNpjYuB790GegeWMDWPD__r_9QwMDfXujMwMXoyBTGC-kTEDA0jwjA-E7mRkYLDyj7MDKUUWh9F7RCA00zp2I-OJDAwHGCCgof6_PYRmhjHgAkccmsGMvfZpbCAaXQe_xWQJED0jMvsPWBwC5WdEMtATAABWfTdC",
        game_over="eNpjYuB790GekSXVTut--T8GIGioZ2DYwtDGsF_4f_3WYhZrF4igvCNMkoHByj_ObkYkhH_GB5VOU4OqW8duZDyRgeEAAwQ01P-3h9DMMAZc4IhDM5ix1z6NDWYHsgJ-i8kSIHpGZPYfsDgEykPcQDcAAMOUNLU.",
    }
end

--construct and return a new sound effect using one or more .wav files
Sounds.newSound=function(_names,_repeatDelay)
    local sound={sources={}}
    for i,name in pairs(_names) do 
        table.insert(
            sound.sources,
            love.audio.newSource(Sounds.data[name],'static')
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

    function sound:setPitch(_pitch) --sets new base pitch
        for i,source in pairs(self.sources) do source:setPitch(_pitch) end 
    end

    function sound:setVolume(_vol) --sets new volume
        for i,source in pairs(self.sources) do source:setVolume(_vol) end
    end

    sound:setVolume(Settings.currentSettings.audio.sound*0.01) --set volume of sound
    
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
Sounds.game_over=function() return Sounds.newSound({'game_over'}) end

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
Sounds.harpoon=function() return Sounds.newSound({'splash_1','splash_2'}) end --fishing hole splashing
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
Sounds.launch_mage_t2=function() return Sounds.newSound({'mage_t2'}) end
Sounds.launch_demon_t3=function() return Sounds.newSound({'demon_t3'}) end

--special attack sounds
Sounds.tornado=function() return Sounds.newSound({'tornado'},0.2) end
Sounds.flames=function() return Sounds.newSound({'flames'},0.85) end
Sounds.fire_circle=function() return Sounds.newSound({'fire_circle'}) end 
Sounds.flame_pillar=function() 
    return Sounds.newSound({'flames'},love.math.random(60,80)*0.01) 
end
Sounds.charge_fireball=function() return Sounds.newSound({'charge_fireball'},2) end
Sounds.launch_fireball=function() return Sounds.newSound({'launch_fireball'}) end 
Sounds.disabling_fireball=function() return Sounds.newSound({'disabling_fireball'}) end 
Sounds.charge_fissure=function() return Sounds.newSound({'charge_fissure'},2) end
Sounds.launch_fissure=function() return Sounds.newSound({'launch_fissure_1','launch_fissure_2'}) end 
Sounds.lava_bubble=function() 
    return Sounds.newSound({'lava_bubble'},love.math.random(3,6)*0.1) 
end 
Sounds.fissure_travel=function() return Sounds.newSound({'fissure_travel'},0.1) end 

--menu sounds
Sounds.menu_open=function() return Sounds.newSound({'menu_open'}) end
Sounds.menu_close=function() return Sounds.newSound({'menu_close'}) end
Sounds.menu_move=function() return Sounds.newSound({'menu_move'}) end
Sounds.failure=function() return Sounds.newSound({'failure'}) end 
