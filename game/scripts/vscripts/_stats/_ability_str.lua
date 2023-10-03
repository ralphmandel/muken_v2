_ability_str = class ({})
LinkLuaModifier("_modifier_str", "_stats/_modifier_str", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("main_stat_modifier", "_stats/main_stat_modifier", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("sub_stat_modifier", "_stats/sub_stat_modifier", LUA_MODIFIER_MOTION_NONE)

function _ability_str:GetIntrinsicModifierName()
  return "_modifier_str"
end

function _ability_str:OnUpgrade()
  UpdatePanoramaStat(self:GetCaster(), "str")
end