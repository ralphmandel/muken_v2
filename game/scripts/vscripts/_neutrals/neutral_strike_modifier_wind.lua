neutral_strike_modifier_wind = class({})

function neutral_strike_modifier_wind:IsHidden() return false end
function neutral_strike_modifier_wind:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function neutral_strike_modifier_wind:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end
  
  self.parent:AttackNoEarlierThan(1, 20)

  self.parent:AddSubStats(self.ability, {evasion = self.ability:GetSpecialValueFor("evasion")})
  self.parent:AddModifier(self.ability, "sub_stat_movespeed_increase", {
    value = self.ability:GetSpecialValueFor("ms")
  })

  self.parent:EmitSound("Ability.Windrun")
end

function neutral_strike_modifier_wind:OnRefresh(kv)
end

function neutral_strike_modifier_wind:OnRemoved()
  if not IsServer() then return end

  self.parent:RemoveAllModifiersByNameAndAbility("sub_stat_movespeed_increase", self.ability)
  self.parent:RemoveSubStats(self.ability, {"evasion"})
  self.parent:StopSound("Ability.Windrun")
end

-- API FUNCTIONS -----------------------------------------------------------

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function neutral_strike_modifier_wind:GetEffectName()
	return "particles/units/heroes/hero_windrunner/windrunner_windrun.vpcf"
end

function neutral_strike_modifier_wind:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end