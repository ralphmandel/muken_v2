paladin__precache = class ({})
LinkLuaModifier("paladin_special_values", "heroes/sun/paladin/paladin-special_values", LUA_MODIFIER_MOTION_NONE)

function paladin__precache:GetIntrinsicModifierName()
  return "paladin_special_values"
end

function paladin__precache:Spawn()
  if IsServer() then
    if self:IsTrained() == false then
      self:UpgradeAbility(true)
    end
  end
end

function paladin__precache:Precache(context)
  PrecacheResource("model", "models/items/dawnbreaker/judgement_of_light_armor/judgement_of_light_armor.vmdl", context)
  PrecacheResource("model", "models/items/dawnbreaker/judgement_of_light_arms/judgement_of_light_arms.vmdl", context)
  PrecacheResource("model", "models/items/dawnbreaker/judgement_of_light_head/judgement_of_light_head.vmdl", context)
  PrecacheResource("model", "models/items/dawnbreaker/judgment_of_light_weapon/judgment_of_light_weapon.vmdl", context)
  PrecacheResource("particle", "particles/econ/items/dawnbreaker/dawnbreaker_judgement_of_light/dawnbreaker_judgement_of_light_armor_ambient.vpcf", context)
end