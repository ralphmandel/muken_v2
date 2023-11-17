ancient_u_modifier_passive = class({})

function ancient_u_modifier_passive:IsHidden() return false end
function ancient_u_modifier_passive:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function ancient_u_modifier_passive:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()
end

function ancient_u_modifier_passive:OnRefresh(kv)
end

function ancient_u_modifier_passive:OnRemoved()
end

-- API FUNCTIONS -----------------------------------------------------------

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------