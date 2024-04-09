item_epic_spectral_armor_mod_passive = class({})

function item_epic_spectral_armor_mod_passive:IsHidden() return false end
function item_epic_spectral_armor_mod_passive:IsPurgable() return false end
function item_epic_spectral_armor_mod_passive:GetTexture() return "armor/spectral_armor" end

-- CONSTRUCTORS -----------------------------------------------------------

function item_epic_spectral_armor_mod_passive:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  self.parent:AddAbilityStats(self.ability, {"magic_resist", "evasion", "curse_resist"})
end

function item_epic_spectral_armor_mod_passive:OnRefresh(kv)
end

function item_epic_spectral_armor_mod_passive:OnRemoved()
  if not IsServer() then return end

  self.parent:RemoveSubStats(self.ability, {"magic_resist", "evasion", "curse_resist"})
end

-- API FUNCTIONS -----------------------------------------------------------

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------