item_epic_mystic_pendant_mod_passive = class({})

function item_epic_mystic_pendant_mod_passive:IsHidden() return false end
function item_epic_mystic_pendant_mod_passive:IsPurgable() return false end
function item_epic_mystic_pendant_mod_passive:GetTexture() return "misc/mystic_pendant" end

-- CONSTRUCTORS -----------------------------------------------------------

function item_epic_mystic_pendant_mod_passive:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  self.parent:AddAbilityStats(self.ability, {"mana_regen"})
end

function item_epic_mystic_pendant_mod_passive:OnRefresh(kv)
end

function item_epic_mystic_pendant_mod_passive:OnRemoved()
  if not IsServer() then return end

  self.parent:RemoveSubStats(self.ability, {"mana_regen"})
end

-- API FUNCTIONS -----------------------------------------------------------

function item_epic_mystic_pendant_mod_passive:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE
  }

  return funcs
end

function item_epic_mystic_pendant_mod_passive:GetModifierPercentageCooldown()
  if self.parent:GetMaxMana() == 0 then return 0 end

  local mana_cap = self.ability:GetSpecialValueFor("mana_cap")

  if (self.parent:GetMana() / self.parent:GetMaxMana()) * 100 > mana_cap then
    return self.ability:GetSpecialValueFor("cooldown_reduction")
  end

  return 0
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------