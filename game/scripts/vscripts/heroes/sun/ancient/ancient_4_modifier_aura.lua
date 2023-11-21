ancient_4_modifier_aura = class({})

function ancient_4_modifier_aura:IsHidden() return true end
function ancient_4_modifier_aura:IsPurgable() return false end

-- AURA -----------------------------------------------------------

function ancient_4_modifier_aura:IsAura() return true end
function ancient_4_modifier_aura:GetModifierAura() return "ancient_4_modifier_aura_effect" end
function ancient_4_modifier_aura:GetAuraRadius() return self:GetAbility():GetAOERadius() end
function ancient_4_modifier_aura:GetAuraSearchTeam() return self:GetAbility():GetAbilityTargetTeam() end
function ancient_4_modifier_aura:GetAuraSearchType() return self:GetAbility():GetAbilityTargetType() end
function ancient_4_modifier_aura:GetAuraSearchFlags() return self:GetAbility():GetAbilityTargetFlags() end
function ancient_4_modifier_aura:GetAuraEntityReject(hEntity) return self:GetCaster():PassivesDisabled() end

-- CONSTRUCTORS -----------------------------------------------------------

function ancient_4_modifier_aura:OnCreated(kv)
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
end

function ancient_4_modifier_aura:OnRefresh(kv)
end

function ancient_4_modifier_aura:OnRemoved()
end

-- API FUNCTIONS -----------------------------------------------------------

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function ancient_4_modifier_aura:GetEffectName()
	return "particles/ancient/flesh/ancient_aura.vpcf"
end

function ancient_4_modifier_aura:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end