paladin_1_modifier_aura_effect = class({})

function paladin_1_modifier_aura_effect:IsHidden() return true end
function paladin_1_modifier_aura_effect:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function paladin_1_modifier_aura_effect:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()
end

function paladin_1_modifier_aura_effect:OnRefresh(kv)
end

function paladin_1_modifier_aura_effect:OnRemoved()
  self.parent:RemoveModifierByName("paladin_1_modifier_link")
end

-- API FUNCTIONS -----------------------------------------------------------

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------