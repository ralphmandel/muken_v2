_ability_agi = class ({})
LinkLuaModifier("_modifier_agi", "_stats/_modifier_agi", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("main_stat_modifier", "_stats/main_stat_modifier", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("sub_stat_modifier", "_stats/sub_stat_modifier", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("sub_stat_movespeed_decrease", "_stats/sub_stat_movespeed_decrease", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("sub_stat_movespeed_increase", "_stats/sub_stat_movespeed_increase", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("sub_stat_movespeed_percent_decrease", "_stats/sub_stat_movespeed_percent_decrease", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("sub_stat_movespeed_percent_increase", "_stats/sub_stat_movespeed_percent_increase", LUA_MODIFIER_MOTION_NONE)

function _ability_agi:GetIntrinsicModifierName()
  return "_modifier_agi"
end

function _ability_agi:OnUpgrade()
  if IsServer() then UpdatePanoramaStat(self:GetCaster(), "agi") end
end