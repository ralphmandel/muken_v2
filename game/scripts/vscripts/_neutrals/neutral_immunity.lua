neutral_immunity = class({})
LinkLuaModifier("neutral_immunity_modifier_passive", "_neutrals/neutral_immunity_modifier_passive", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("neutral_immunity_modifier_buff", "_neutrals/neutral_immunity_modifier_buff", LUA_MODIFIER_MOTION_NONE)

function neutral_immunity:GetAOERadius()
  return self:GetSpecialValueFor("radius")
end

function neutral_immunity:GetIntrinsicModifierName()
  return "neutral_immunity_modifier_passive"
end

function neutral_immunity:OnSpellStart()
  local caster = self:GetCaster()

  local allies = FindUnitsInRadius(
    caster:GetTeamNumber(), caster:GetOrigin(), nil, self:GetAOERadius(),
    self:GetAbilityTargetTeam(), self:GetAbilityTargetType(),
    self:GetAbilityTargetFlags(), FIND_ANY_ORDER, false
  )

	for _,ally in pairs(allies) do
    AddModifier(ally, self, "neutral_immunity_modifier_buff", {duration = self:GetSpecialValueFor("duration")}, true)
	end

  if IsServer() then caster:EmitSound("Hero_Omniknight.GuardianAngel.Cast") end
end