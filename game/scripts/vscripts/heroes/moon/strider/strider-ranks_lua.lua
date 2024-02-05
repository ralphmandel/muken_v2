strider__precache = class ({})
LinkLuaModifier("strider_special_values", "heroes/moon/strider/strider-special_values", LUA_MODIFIER_MOTION_NONE)

function strider__precache:GetIntrinsicModifierName()
  return "strider_special_values"
end

function strider__precache:Spawn()
  if IsServer() then
    if self:IsTrained() == false then
      self:UpgradeAbility(true)
    end
  end
end

function strider__precache:Precache(context)
  PrecacheResource("model", "models/items/juggernaut/jugg_year_beast_slayer_head/jugg_year_beast_slayer_head.vmdl", context)
  PrecacheResource("model", "models/items/juggernaut/jugg_year_beast_slayer_back/jugg_year_beast_slayer_back.vmdl", context)
  PrecacheResource("model", "models/items/juggernaut/jugg_year_beast_slayer_arms/jugg_year_beast_slayer_arms.vmdl", context)
  PrecacheResource("model", "models/items/juggernaut/jugg_year_beast_slayer_legs/jugg_year_beast_slayer_legs.vmdl", context)
  PrecacheResource("model", "models/items/juggernaut/generic_wep_jadesword.vmdl", context)

  PrecacheResource("particle", "particles/econ/items/juggernaut/jugg_slayer/jugg_slayer_head_ambient.vpcf", context)
  PrecacheResource("particle", "particles/econ/items/juggernaut/jugg_slayer/jugg_slayer_back_ambient.vpcf", context)
  PrecacheResource("particle", "particles/econ/items/juggernaut/jugg_slayer/jugg_slayer_arms_ambient.vpcf", context)
  PrecacheResource("particle", "particles/econ/items/juggernaut/jugg_slayer/jugg_slayer_legs_ambient.vpcf", context)
  PrecacheResource("particle", "particles/econ/items/juggernaut/jugg_sword_jade/jugg_weapon_glow_variation_jade.vpcf", context)
end