_ability_agi = class ({})
LinkLuaModifier("_modifier_agi", "_stats/_modifier_agi", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("main_stat_modifier", "_stats/main_stat_modifier", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("sub_stat_modifier", "_stats/sub_stat_modifier", LUA_MODIFIER_MOTION_NONE)

function _ability_agi:GetIntrinsicModifierName()
  return "_modifier_agi"
end

function _ability_agi:OnUpgrade()
  if IsServer() then UpdatePanoramaStat(self:GetCaster(), "agi") end
end