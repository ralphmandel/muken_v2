item_epic_nature_boots_mod_aura_effect = class({})

function item_epic_nature_boots_mod_aura_effect:IsHidden() return true end
function item_epic_nature_boots_mod_aura_effect:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function item_epic_nature_boots_mod_aura_effect:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  self.parent:AddAbilityStats(self.ability, {"health_regen"})
end

function item_epic_nature_boots_mod_aura_effect:OnRefresh(kv)
end

function item_epic_nature_boots_mod_aura_effect:OnRemoved()
  if not IsServer() then return end

  self.parent:RemoveSubStats(self.ability, {"health_regen"})
end

-- API FUNCTIONS -----------------------------------------------------------

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------