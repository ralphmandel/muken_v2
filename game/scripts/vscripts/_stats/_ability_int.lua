_ability_int = class ({})
LinkLuaModifier("_modifier_int", "_stats/_modifier_int", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("main_stat_modifier", "_stats/main_stat_modifier", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("sub_stat_modifier", "_stats/sub_stat_modifier", LUA_MODIFIER_MOTION_NONE)

function _ability_int:GetIntrinsicModifierName()
  return "_modifier_int"
end

function _ability_int:OnUpgrade()
  local caster = self:GetCaster()
  caster:FindModifierByName(self:GetIntrinsicModifierName()):UpdateMainBonus()
end

function _ability_int:UpdatePanoramaStat()
  local caster = self:GetCaster()
  if caster:IsHero() == false then return end
  if caster:IsIllusion() then return end
  
  local player = caster:GetPlayerOwner()
  if (not player) then return end

  local modifier = caster:FindModifierByName(self:GetIntrinsicModifierName())

  CustomGameEventManager:Send_ServerToPlayer(player, "update_stat_from_lua", {
    stat = string.upper("int"),
    base = modifier:GetAbility():GetLevel(),
    bonus = modifier.stat_bonus,
    total = modifier:GetAbility():GetLevel() + modifier.stat_bonus
  })
end