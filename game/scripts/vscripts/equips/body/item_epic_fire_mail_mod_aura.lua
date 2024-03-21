item_epic_fire_mail_mod_aura = class({})

function item_epic_fire_mail_mod_aura:IsHidden() return true end
function item_epic_fire_mail_mod_aura:IsPurgable() return false end

-- AURA -----------------------------------------------------------

function item_epic_fire_mail_mod_aura:IsAura() return true end
function item_epic_fire_mail_mod_aura:GetModifierAura() return "item_epic_fire_mail_mod_aura_effect" end
function item_epic_fire_mail_mod_aura:GetAuraRadius() return self.ability:GetAOERadius() end
function item_epic_fire_mail_mod_aura:GetAuraSearchTeam() return self.ability:GetAbilityTargetTeam() end
function item_epic_fire_mail_mod_aura:GetAuraSearchType() return self.ability:GetAbilityTargetType() end
function item_epic_fire_mail_mod_aura:GetAuraSearchFlags() return self.ability:GetAbilityTargetFlags() end
function item_epic_fire_mail_mod_aura:GetAuraEntityReject(hEntity) return self.caster:IsMuted() end

-- CONSTRUCTORS -----------------------------------------------------------

function item_epic_fire_mail_mod_aura:OnCreated(kv)
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

  if not IsServer() then return end

  self.parent:EmitSound("FireMail.Start")
end

function item_epic_fire_mail_mod_aura:OnRefresh(kv)
end

function item_epic_fire_mail_mod_aura:OnRemoved()
end

-- API FUNCTIONS -----------------------------------------------------------

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function item_epic_fire_mail_mod_aura:GetEffectName()
	return "particles/econ/events/fall_2022/radiance/radiance_owner_fall2022.vpcf"
end

function item_epic_fire_mail_mod_aura:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end