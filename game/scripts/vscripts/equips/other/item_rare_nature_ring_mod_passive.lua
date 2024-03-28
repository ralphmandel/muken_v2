item_rare_nature_ring_mod_passive = class({})

function item_rare_nature_ring_mod_passive:IsHidden() return false end
function item_rare_nature_ring_mod_passive:IsPurgable() return false end
function item_rare_nature_ring_mod_passive:GetTexture() return "misc/ring_strength" end

-- CONSTRUCTORS -----------------------------------------------------------

function item_rare_nature_ring_mod_passive:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  self.parent:AddAbilityStats(self.ability, {"incoming_heal", "max_health"})
end

function item_rare_nature_ring_mod_passive:OnRefresh(kv)
end

function item_rare_nature_ring_mod_passive:OnRemoved()
  if not IsServer() then return end

  self.parent:RemoveSubStats(self.ability, {"incoming_heal", "max_health"})
end

-- API FUNCTIONS -----------------------------------------------------------

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------