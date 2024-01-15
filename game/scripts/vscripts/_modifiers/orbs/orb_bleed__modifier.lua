orb_bleed__modifier = class({})

function orb_bleed__modifier:IsHidden() return false end
function orb_bleed__modifier:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function orb_bleed__modifier:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  self.bleed_duration = 1.5
end

function orb_bleed__modifier:OnRefresh(kv)
end

function orb_bleed__modifier:OnRemoved()
end

-- API FUNCTIONS -----------------------------------------------------------

function orb_bleed__modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end

function orb_bleed__modifier:OnAttackLanded(keys)
  if not IsServer() then return end

	if keys.attacker ~= self.parent then return end
  if self.parent:PassivesDisabled() then return end

  keys.target:RemoveModifierByNameAndCaster("orb_bleed_debuff", self.caster)
  
  AddModifier(keys.target, self.ability, "orb_bleed_debuff", {
    duration = self.bleed_duration
  }, false)
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------