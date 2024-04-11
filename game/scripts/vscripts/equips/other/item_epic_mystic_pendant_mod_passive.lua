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
    MODIFIER_PROPERTY_MANACOST_PERCENTAGE
  }

  return funcs
end

function item_epic_mystic_pendant_mod_passive:GetModifierPercentageManacost()
  if self.parent:GetMana() == self.parent:GetMaxMana() then
    return self.ability:GetSpecialValueFor("manacost")
  end

  return 0
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------