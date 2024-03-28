item_rare_power_boots_mod_passive = class({})

function item_rare_power_boots_mod_passive:IsHidden() return false end
function item_rare_power_boots_mod_passive:IsPurgable() return false end
function item_rare_power_boots_mod_passive:GetTexture() return "boots/power_boots" end

-- CONSTRUCTORS -----------------------------------------------------------

function item_rare_power_boots_mod_passive:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  self.parent:AddAbilityStats(self.ability, {"speed"})
  self.ability:SwitchStat(self.ability:GetSpecialValueFor("state"))
end

function item_rare_power_boots_mod_passive:OnRefresh(kv)
end

function item_rare_power_boots_mod_passive:OnRemoved()
  if not IsServer() then return end

  self.parent:RemoveSubStats(self.ability, {"speed"})
  self.ability:SwitchStat(0)
end

-- API FUNCTIONS -----------------------------------------------------------

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------