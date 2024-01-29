templar__precache = class ({})
LinkLuaModifier("templar_special_values", "heroes/sun/templar/templar-special_values", LUA_MODIFIER_MOTION_NONE)

function templar__precache:GetIntrinsicModifierName()
  return "templar_special_values"
end

function templar__precache:Spawn()
  if IsServer() then
    if self:IsTrained() == false then
      self:UpgradeAbility(true)
    end
  end
end

function templar__precache:Precache(context)
  PrecacheResource("model", "models/items/omniknight/light_hammer/mesh/light_hammer_model.vmdl", context)
  PrecacheResource("model", "models/heroes/omniknight/head.vmdl", context)
  PrecacheResource("model", "models/items/omniknight/light_helmet/light_helmet.vmdl", context)
  PrecacheResource("model", "models/items/omniknight/the_unbroken_knight_back/the_unbroken_knight_back.vmdl", context)
  PrecacheResource("model", "models/items/omniknight/omni_fall20_immortal_shoulders/omni_fall20_immortal_shoulders.vmdl", context)
  PrecacheResource("model", "models/items/omniknight/omni_2021_immortal_arms/omni_2021_immortal_arms.vmdl", context)

  PrecacheResource("particle", "particles/econ/items/omniknight/hammer_ti6_immortal/omniknight_hammer_ambient.vpcf", context)
  PrecacheResource("particle", "particles/econ/items/omniknight/omni_ti8_head/omni_ti8_head_ambient.vpcf", context)
  PrecacheResource("particle", "particles/econ/items/omniknight/omniknight_fall20_immortal/omniknight_fall20_immortal_shoulder_ambient.vpcf", context)
  PrecacheResource("particle", "particles/econ/items/omniknight/omni_2021_immortal/omni_2021_immortal_arms_ambient.vpcf", context)
end