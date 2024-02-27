genuine__precache = class ({})
LinkLuaModifier("genuine_special_values", "heroes/moon/genuine/genuine-special_values", LUA_MODIFIER_MOTION_NONE)

function genuine__precache:GetIntrinsicModifierName()
  return "genuine_special_values"
end

function genuine__precache:Spawn()
  if IsServer() then
    if self:IsTrained() == false then
      self:UpgradeAbility(true)
    end
  end
end

function genuine__precache:Precache(context)
  PrecacheResource("model", "models/items/drow/secret_witch_head/secret_witch_head.vmdl", context)
  PrecacheResource("model", "models/items/drow/secret_witch_legs/secret_witch_legs.vmdl", context)
  PrecacheResource("model", "models/items/drow/secret_witch_arms/secret_witch_arms.vmdl", context)
  PrecacheResource("model", "models/items/drow/secret_witch_shoulder/secret_witch_shoulder.vmdl", context)
  PrecacheResource("model", "models/items/drow/secret_witch_misc/secret_witch_misc.vmdl", context)
  PrecacheResource("model", "models/items/drow/ti6_immortal_cape/mesh/drow_ti6_immortal_cape.vmdl", context)
  PrecacheResource("model", "models/items/drow/drow_ti9_immortal_weapon/drow_ti9_immortal_weapon.vmdl", context)

  PrecacheResource("particle", "particles/genuine/shoulder_efx/genuine_back_ambient.vpcf", context)
  PrecacheResource("particle", "particles/genuine/bow_efx/genuine_bow_ambient.vpcf", context)
  PrecacheResource("particle", "particles/genuine/base_attack/genuine_base_attack.vpcf", context)
end