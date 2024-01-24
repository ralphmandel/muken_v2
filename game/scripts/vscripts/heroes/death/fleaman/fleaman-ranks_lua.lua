fleaman__precache = class ({})
LinkLuaModifier("fleaman_special_values", "heroes/death/fleaman/fleaman-special_values", LUA_MODIFIER_MOTION_NONE)

function fleaman__precache:GetIntrinsicModifierName()
  return "fleaman_special_values"
end

function fleaman__precache:Spawn()
  if IsServer() then
    if self:IsTrained() == false then
      self:UpgradeAbility(true)
    end
  end
end

function fleaman__precache:Precache(context)
  PrecacheResource( "model", "models/items/slark/hydrakan_latch/mesh/hydrkan_latch_model.vmdl", context )
  PrecacheResource( "model", "models/items/slark/slark_head_immortal/slark_head_immortal.vmdl", context )
  PrecacheResource( "model", "models/items/slark/dplus_shadow_of_the_dark_reef_shoulder/dplus_shadow_of_the_dark_reef_shoulder.vmdl", context )
  PrecacheResource( "model", "models/items/slark/dplus_shadow_of_the_dark_reef_back/dplus_shadow_of_the_dark_reef_back.vmdl", context )
  PrecacheResource( "model", "models/items/slark/dplus_shadow_of_the_dark_reef_arms/dplus_shadow_of_the_dark_reef_arms.vmdl", context )
end