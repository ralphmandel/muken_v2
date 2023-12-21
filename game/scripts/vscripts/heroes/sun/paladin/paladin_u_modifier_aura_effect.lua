paladin_u_modifier_aura_effect = class({})

function paladin_u_modifier_aura_effect:IsHidden() return false end
function paladin_u_modifier_aura_effect:IsPurgable() return false end
function paladin_u_modifier_aura_effect:RemoveOnDeath() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function paladin_u_modifier_aura_effect:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()
end

function paladin_u_modifier_aura_effect:OnRefresh(kv)
end

function paladin_u_modifier_aura_effect:OnRemoved()
end

-- API FUNCTIONS -----------------------------------------------------------

function paladin_u_modifier_aura_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}

	return funcs
end

function paladin_u_modifier_aura_effect:GetModifierIncomingDamage_Percentage(keys)
  return -self.ability:GetSpecialValueFor("holy_reduction")
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function paladin_u_modifier_aura_effect:GetEffectName()
	return "particles/paladin/aura_faith/aura_faith.vpcf"
end

function paladin_u_modifier_aura_effect:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end