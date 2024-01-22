orb_bleed__modifier = class({})

function orb_bleed__modifier:IsHidden() return false end
function orb_bleed__modifier:IsPurgable() return false end
function orb_bleed__modifier:RemoveOnDeath() return false end

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

  local modifiers = keys.target:FindAllModifiersByName("orb_bleed_debuff")
  for _, modifier in pairs(modifiers) do
    if modifier:GetAbility() == self.ability then
      modifier:OnRefresh({duration = self.bleed_duration})
      return
    end
  end

  keys.target:AddModifier(self.ability, "orb_bleed_debuff", {duration = self.bleed_duration})
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function orb_bleed__modifier:GetEffectName()
	return "particles/bloodstained/frenzy/bloodstained_hands_v2.vpcf"
end

function orb_bleed__modifier:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end