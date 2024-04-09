item_epic_ruby_helm_mod_passive = class({})

function item_epic_ruby_helm_mod_passive:IsHidden() return false end
function item_epic_ruby_helm_mod_passive:IsPurgable() return false end
function item_epic_ruby_helm_mod_passive:GetTexture() return "head/ruby_helm" end

-- CONSTRUCTORS -----------------------------------------------------------

function item_epic_ruby_helm_mod_passive:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  self.parent:AddAbilityStats(self.ability, {"max_health", "mana_regen"})

end

function item_epic_ruby_helm_mod_passive:OnRefresh(kv)
end

function item_epic_ruby_helm_mod_passive:OnRemoved()
  if not IsServer() then return end

  self.parent:RemoveSubStats(self.ability, {"max_health", "mana_regen"})
end

-- API FUNCTIONS -----------------------------------------------------------

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------