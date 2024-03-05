_ability_str = class ({})
LinkLuaModifier("_modifier_str", "_stats/_modifier_str", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("main_stat_modifier", "_stats/main_stat_modifier", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("sub_stat_modifier", "_stats/sub_stat_modifier", LUA_MODIFIER_MOTION_NONE)

function _ability_str:GetIntrinsicModifierName()
  return "_modifier_str"
end

function _ability_str:OnUpgrade()
  local caster = self:GetCaster()
  caster:FindModifierByName(self:GetIntrinsicModifierName()):UpdateMainBonus()
end

function _ability_str:UpdatePanoramaStat()
  local caster = self:GetCaster()
  if caster:IsHero() == false then return end
  if caster:IsIllusion() then return end
  
  local player = caster:GetPlayerOwner()
  if (not player) then return end

  local modifier = caster:FindModifierByName(self:GetIntrinsicModifierName())

  CustomGameEventManager:Send_ServerToPlayer(player, "update_stat_from_lua", {
    stat = string.upper("str"),
    base = modifier:GetAbility():GetLevel(),
    bonus = modifier.stat_bonus,
    total = modifier:GetAbility():GetLevel() + modifier.stat_bonus
  })
end