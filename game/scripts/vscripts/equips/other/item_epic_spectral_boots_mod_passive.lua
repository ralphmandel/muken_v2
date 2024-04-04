item_epic_spectral_boots_mod_passive = class({})

function item_epic_spectral_boots_mod_passive:IsHidden() return false end
function item_epic_spectral_boots_mod_passive:IsPurgable() return false end
function item_epic_spectral_boots_mod_passive:GetTexture() return "boots/spectral_boots" end

-- CONSTRUCTORS -----------------------------------------------------------

function item_epic_spectral_boots_mod_passive:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  self.parent:AddAbilityStats(self.ability, {"int"})
  self.parent:AddAbilityStats(self.ability, {"speed", "curse_resist"})
end

function item_epic_spectral_boots_mod_passive:OnRefresh(kv)
end

function item_epic_spectral_boots_mod_passive:OnRemoved()
  if not IsServer() then return end

  self.parent:RemoveMainStats(self.ability, {"int"})
  self.parent:RemoveSubStats(self.ability, {"speed", "curse_resist"})
end

-- API FUNCTIONS -----------------------------------------------------------

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------