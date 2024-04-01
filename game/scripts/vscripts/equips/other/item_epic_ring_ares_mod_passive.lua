item_epic_ring_ares_mod_passive = class({})

function item_epic_ring_ares_mod_passive:IsHidden() return false end
function item_epic_ring_ares_mod_passive:IsPurgable() return false end
function item_epic_ring_ares_mod_passive:GetTexture() return "misc/ring_ares" end

-- CONSTRUCTORS -----------------------------------------------------------

function item_epic_ring_ares_mod_passive:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  self.parent:AddAbilityStats(self.ability, {"str"})
  self.parent:AddAbilityStats(self.ability, {"armor"})
end

function item_epic_ring_ares_mod_passive:OnRefresh(kv)
end

function item_epic_ring_ares_mod_passive:OnRemoved()
  if not IsServer() then return end

  self.parent:RemoveMainStats(self.ability, {"str"})
  self.parent:RemoveSubStats(self.ability, {"armor"})
end

-- API FUNCTIONS -----------------------------------------------------------

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------