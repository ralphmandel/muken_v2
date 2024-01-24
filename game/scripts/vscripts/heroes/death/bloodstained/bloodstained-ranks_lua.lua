bloodstained__precache = class ({})
LinkLuaModifier("bloodstained_special_values", "heroes/death/bloodstained/bloodstained-special_values", LUA_MODIFIER_MOTION_NONE)

function bloodstained__precache:GetIntrinsicModifierName()
  return "bloodstained_special_values"
end

function bloodstained__precache:Spawn()
  if IsServer() then
    if self:IsTrained() == false then
      self:UpgradeAbility(true)
    end
  end
end

function bloodstained__precache:Precache(context)
  PrecacheResource( "model", "models/items/shadow_demon/mantle_of_the_shadow_demon_belt/mantle_of_the_shadow_demon_belt.vmdl", context )
  PrecacheResource( "model", "models/items/shadow_demon/sd_crown_of_the_nightworld_tail/sd_crown_of_the_nightworld_tail.vmdl", context )
  PrecacheResource( "model", "models/items/shadow_demon/ti7_immortal_back/sd_ti7_immortal_back.vmdl", context )
  PrecacheResource( "model", "models/items/shadow_demon/sd_crown_of_the_nightworld_armor/sd_crown_of_the_nightworld_armor.vmdl", context )
  PrecacheResource( "particle", "particles/econ/items/shadow_demon/sd_ti7_shadow_poison/sd_ti7_immortal_ambient.vpcf", context )
  PrecacheResource( "particle", "particles/econ/items/shadow_demon/sd_crown_nightworld/sd_crown_nightworld_armor.vpcf", context )
end