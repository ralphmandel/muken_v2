item_rare_speed_boots_mod_passive = class({})

function item_rare_speed_boots_mod_passive:IsHidden() return false end
function item_rare_speed_boots_mod_passive:IsPurgable() return false end
function item_rare_speed_boots_mod_passive:GetTexture() return "boots/speed_boots" end

-- CONSTRUCTORS -----------------------------------------------------------

function item_rare_speed_boots_mod_passive:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  self.parent:AddAbilityStats(self.ability, {"speed", "slow_percent"})
end

function item_rare_speed_boots_mod_passive:OnRefresh(kv)
end

function item_rare_speed_boots_mod_passive:OnRemoved()
  if not IsServer() then return end

  self.parent:RemoveSubStats(self.ability, {"speed", "slow_percent"})
end

-- API FUNCTIONS -----------------------------------------------------------

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------