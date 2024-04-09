item_epic_etherweaver_cap_mod_aura_effect = class({})

function item_epic_etherweaver_cap_mod_aura_effect:IsHidden() return false end
function item_epic_etherweaver_cap_mod_aura_effect:IsPurgable() return false end
function item_epic_etherweaver_cap_mod_aura_effect:GetTexture() return "head/etherweaver_cap" end

-- CONSTRUCTORS -----------------------------------------------------------

function item_epic_etherweaver_cap_mod_aura_effect:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  self.parent:AddAbilityStats(self.ability, {"bleed_resist", "sleep_resist", "thunder_resist"})
end

function item_epic_etherweaver_cap_mod_aura_effect:OnRefresh(kv)
end

function item_epic_etherweaver_cap_mod_aura_effect:OnRemoved()
  if not IsServer() then return end

  self.parent:RemoveSubStats(self.ability, {"bleed_resist", "sleep_resist", "thunder_resist"})
end

-- API FUNCTIONS -----------------------------------------------------------

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------