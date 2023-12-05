trickster_u_modifier_last = class({})

function trickster_u_modifier_last:IsHidden() return true end
function trickster_u_modifier_last:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function trickster_u_modifier_last:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  self.ability_index = kv.ability_index
end

function trickster_u_modifier_last:OnRefresh(kv)
  self.ability_index = kv.ability_index
end

function trickster_u_modifier_last:OnRemoved()
end

-- API FUNCTIONS -----------------------------------------------------------

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------