paladin_1_modifier_passive = class({})

function paladin_1_modifier_passive:IsHidden() return true end
function paladin_1_modifier_passive:IsPurgable() return false end

-- AURA -----------------------------------------------------------

function paladin_1_modifier_passive:IsAura() return true end
function paladin_1_modifier_passive:GetAuraDuration() return 0 end
function paladin_1_modifier_passive:GetModifierAura() return "paladin_1_modifier_aura_effect" end
function paladin_1_modifier_passive:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("max_range") end
function paladin_1_modifier_passive:GetAuraSearchTeam() return self:GetAbility():GetAbilityTargetTeam() end
function paladin_1_modifier_passive:GetAuraSearchType() return self:GetAbility():GetAbilityTargetType() end
function paladin_1_modifier_passive:GetAuraSearchFlags() return self:GetAbility():GetAbilityTargetFlags() end
function paladin_1_modifier_passive:GetAuraDuration() return 0 end

-- CONSTRUCTORS -----------------------------------------------------------

function paladin_1_modifier_passive:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()
end

function paladin_1_modifier_passive:OnRefresh(kv)
end

function paladin_1_modifier_passive:OnRemoved()  
end

-- API FUNCTIONS -----------------------------------------------------------

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------