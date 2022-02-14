Shadows={}

function Shadows:load()
    self.tiny=love.graphics.newImage('assets/shadow_tiny.png') --11,6
    self.small=love.graphics.newImage('assets/shadow_small.png') --12,6
    self.medium=love.graphics.newImage('assets/shadow_medium.png') --14,6
    self.large=love.graphics.newImage('assets/shadow_large.png') --22,8

    self.tree=love.graphics.newImage('assets/shadow_tree.png') --14,8
    self.tree_wood=love.graphics.newImage('assets/shadow_medium.png') --14,6
    self.tree_planks=love.graphics.newImage('assets/shadow_tree_planks.png') --12,6
    self.rock=love.graphics.newImage('assets/shadow_rock.png') --16,7
    self.rock_ore=love.graphics.newImage('assets/shadow_small.png') --12,6 
    self.rock_metal=love.graphics.newImage('assets/shadow_rock_metal.png') --not elipse
    self.fungi=love.graphics.newImage('assets/shadow_fungi.png') --not elipse
    self.fungi_mushroom=love.graphics.newImage('assets/shadow_fungi_mushroom.png') --not elipse
    self.vine_fiber=love.graphics.newImage('assets/shadow_small.png') --12,6
    self.vine_thread=love.graphics.newImage('assets/shadow_vine_thread.png') --8,5
    self.fish_raw=love.graphics.newImage('assets/shadow_fish_raw.png') --10,5  
    self.fish_cooked=love.graphics.newImage('assets/shadow_fish_raw.png') --10,5

    self.arcane_bowstring=love.graphics.newImage('assets/shadow_tiny.png') --11,6
    self.arcane_orb=love.graphics.newImage('assets/shadow_vial.png') --10,6
    self.arcane_shards=love.graphics.newImage('assets/shadow_tiny.png') --12,6
    self.broken_bow=love.graphics.newImage('assets/shadow_small.png') --12,6
    self.broken_staff=love.graphics.newImage('assets/shadow_broken_staff.png') --not elipse 
    self.vial=love.graphics.newImage('assets/shadow_vial.png') --10,6
    self.potion=love.graphics.newImage('assets/shadow_vial.png') --10,6

    self.weapon_bow_t1=love.graphics.newImage('assets/shadow_weapon.png') --8,5
    self.weapon_bow_t2=love.graphics.newImage('assets/shadow_weapon.png') --8,5
    self.weapon_bow_t3=love.graphics.newImage('assets/shadow_weapon.png') --8,5
    self.weapon_staff_t1=love.graphics.newImage('assets/shadow_weapon.png') --8,5
    self.weapon_staff_t2=love.graphics.newImage('assets/shadow_weapon.png') --8,5
    self.weapon_staff_t3=love.graphics.newImage('assets/shadow_weapon.png') --8,5

    self.armor_head_t1=love.graphics.newImage('assets/shadow_small.png') --12,6
    self.armor_head_t2=love.graphics.newImage('assets/shadow_small.png') --12,6
    self.armor_head_t3=love.graphics.newImage('assets/shadow_small.png') --12,6
    self.armor_chest_t1=love.graphics.newImage('assets/shadow_fish_raw.png') --10,5
    self.armor_chest_t2=love.graphics.newImage('assets/shadow_fish_raw.png') --10,5
    self.armor_chest_t3=love.graphics.newImage('assets/shadow_fish_raw.png') --10,5
    self.armor_legs_t1=love.graphics.newImage('assets/shadow_legs.png')
    self.armor_legs_t2=love.graphics.newImage('assets/shadow_legs.png')
    self.armor_legs_t3=love.graphics.newImage('assets/shadow_legs.png')
end

function Shadows:newShadow(_type)
    local shadow={}

    if _type=='tiny' then shadow.sprite=Shadows.tiny
    elseif _type=='small' then shadow.sprite=Shadows.small
    elseif _type=='medium' then shadow.sprite=Shadows.medium
    elseif _type=='large' then shadow.sprite=Shadows.large

    elseif _type=='rock' then shadow.sprite=Shadows.rock
    elseif _type=='fungi' then  shadow.sprite=Shadows.fungi
    elseif _type=='tree' then shadow.sprite=Shadows.tree
    elseif _type=='tree_wood' then shadow.sprite=Shadows.tree_wood 
    elseif _type=='rock_ore' then shadow.sprite=Shadows.rock_ore
    elseif _type=='fungi_mushroom' then shadow.sprite=Shadows.fungi_mushroom
    elseif _type=='vine_fiber' then shadow.sprite=Shadows.vine_fiber
    elseif _type=='fish_raw' then shadow.sprite=Shadows.fish_raw
    elseif _type=='arcane_bowstring' then shadow.sprite=Shadows.arcane_bowstring
    elseif _type=='arcane_orb' then shadow.sprite=Shadows.arcane_orb
    elseif _type=='arcane_shards' then shadow.sprite=Shadows.arcane_shards
    elseif _type=='broken_bow' then shadow.sprite=Shadows.broken_bow
    elseif _type=='broken_staff' then shadow.sprite=Shadows.broken_staff
    elseif _type=='fish_cooked' then shadow.sprite=Shadows.fish_cooked
    elseif _type=='rock_metal' then shadow.sprite=Shadows.rock_metal
    elseif _type=='tree_planks' then shadow.sprite=Shadows.tree_planks
    elseif _type=='vine_thread' then shadow.sprite=Shadows.vine_thread
    elseif _type=='vial' then shadow.sprite=Shadows.vial
    elseif _type=='potion' then shadow.sprite=Shadows.potion

    elseif _type=='weapon_bow_t1' then shadow.sprite=Shadows.weapon_bow_t1
    elseif _type=='weapon_bow_t2' then shadow.sprite=Shadows.weapon_bow_t2
    elseif _type=='weapon_bow_t3' then shadow.sprite=Shadows.weapon_bow_t3
    elseif _type=='weapon_staff_t1' then shadow.sprite=Shadows.weapon_staff_t1
    elseif _type=='weapon_staff_t2' then shadow.sprite=Shadows.weapon_staff_t2
    elseif _type=='weapon_staff_t3' then shadow.sprite=Shadows.weapon_staff_t3

    elseif _type=='armor_head_t1' then shadow.sprite=Shadows.armor_head_t1 
    elseif _type=='armor_head_t2' then shadow.sprite=Shadows.armor_head_t2 
    elseif _type=='armor_head_t3' then shadow.sprite=Shadows.armor_head_t3
    elseif _type=='armor_chest_t1' then shadow.sprite=Shadows.armor_chest_t1
    elseif _type=='armor_chest_t2' then shadow.sprite=Shadows.armor_chest_t2
    elseif _type=='armor_chest_t3' then shadow.sprite=Shadows.armor_chest_t3
    elseif _type=='armor_legs_t1' then shadow.sprite=Shadows.armor_legs_t1 
    elseif _type=='armor_legs_t2' then shadow.sprite=Shadows.armor_legs_t2
    elseif _type=='armor_legs_t3' then shadow.sprite=Shadows.armor_legs_t3
    end
    
    --offsets the shadow's origin to it's center
    if shadow.sprite==nil then print(_type) end 
    shadow.w=shadow.sprite:getWidth()*0.5
    shadow.h=shadow.sprite:getHeight()*0.5

    function shadow:draw(_xPos,_yPos)
        --draw shadow with 0.5 alpha to make it transparent
        love.graphics.setColor(1,1,1,0.6)

        love.graphics.draw(self.sprite,_xPos-self.w,_yPos-self.h) --draw shadow

        --revert color settings so everything after has full opacity
        love.graphics.setColor(1,1,1,1)
    end

    return shadow 
end