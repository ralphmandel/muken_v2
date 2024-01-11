neutral_doom_modifier_pre = class({})

function neutral_doom_modifier_pre:IsHidden() return true end
function neutral_doom_modifier_pre:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function neutral_doom_modifier_pre:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()
end

function neutral_doom_modifier_pre:OnRefresh(kv)
end

function neutral_doom_modifier_pre:OnRemoved()
end

-- API FUNCTIONS -----------------------------------------------------------

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------