_ability_vit = class ({})
LinkLuaModifier("_modifier_vit", "_stats/_modifier_vit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("main_stat_modifier", "_stats/main_stat_modifier", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("sub_stat_modifier", "_stats/sub_stat_modifier", LUA_MODIFIER_MOTION_NONE)

function _ability_vit:GetIntrinsicModifierName()
  return "_modifier_vit"
end

function _ability_vit:OnUpgrade()
  if IsServer() then UpdatePanoramaStat(self:GetCaster(), "vit") end
end