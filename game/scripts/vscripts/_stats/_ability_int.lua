_ability_int = class ({})
LinkLuaModifier("_modifier_int", "_stats/_modifier_int", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("main_stat_modifier", "_stats/main_stat_modifier", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("sub_stat_modifier", "_stats/sub_stat_modifier", LUA_MODIFIER_MOTION_NONE)

function _ability_int:GetIntrinsicModifierName()
  return "_modifier_int"
end

function _ability_int:OnUpgrade()
  if IsServer() then UpdatePanoramaStat(self:GetCaster(), "int") end
end