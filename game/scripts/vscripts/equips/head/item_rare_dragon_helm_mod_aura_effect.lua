item_rare_dragon_helm_mod_aura_effect = class({})

function item_rare_dragon_helm_mod_aura_effect:IsHidden() return false end
function item_rare_dragon_helm_mod_aura_effect:IsPurgable() return false end
function item_rare_dragon_helm_mod_aura_effect:GetTexture() return "head/dragon_helm" end

-- CONSTRUCTORS -----------------------------------------------------------

function item_rare_dragon_helm_mod_aura_effect:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  self.parent:AddAbilityStats(self.ability, {"poison_resist", "physical_damage", "magical_damage"})
end

function item_rare_dragon_helm_mod_aura_effect:OnRefresh(kv)
end

function item_rare_dragon_helm_mod_aura_effect:OnRemoved()
  if not IsServer() then return end

  self.parent:RemoveSubStats(self.ability, {"poison_resist", "physical_damage", "magical_damage"})
end

-- API FUNCTIONS -----------------------------------------------------------

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------