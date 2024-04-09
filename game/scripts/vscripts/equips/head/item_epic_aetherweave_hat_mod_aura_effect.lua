item_epic_aetherweave_hat_mod_aura_effect = class({})

function item_epic_aetherweave_hat_mod_aura_effect:IsHidden() return false end
function item_epic_aetherweave_hat_mod_aura_effect:IsPurgable() return false end
function item_epic_aetherweave_hat_mod_aura_effect:GetTexture() return "head/aetherweave_hat" end

-- CONSTRUCTORS -----------------------------------------------------------

function item_epic_aetherweave_hat_mod_aura_effect:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  self.parent:AddAbilityStats(self.ability, {"stone_resist", "poison_resist", "cold_resist"})
end

function item_epic_aetherweave_hat_mod_aura_effect:OnRefresh(kv)
end

function item_epic_aetherweave_hat_mod_aura_effect:OnRemoved()
  if not IsServer() then return end

  self.parent:RemoveSubStats(self.ability, {"stone_resist", "poison_resist", "cold_resist"})
end

-- API FUNCTIONS -----------------------------------------------------------

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------