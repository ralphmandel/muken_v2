trickster_u_modifier_used = class({})

function trickster_u_modifier_used:IsHidden() return true end
function trickster_u_modifier_used:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function trickster_u_modifier_used:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()
end

function trickster_u_modifier_used:OnRefresh(kv)
end

function trickster_u_modifier_used:OnRemoved()
end

-- API FUNCTIONS -----------------------------------------------------------

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------