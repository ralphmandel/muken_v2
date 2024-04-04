item_epic_talisman_mod_passive = class({})

function item_epic_talisman_mod_passive:IsHidden() return false end
function item_epic_talisman_mod_passive:IsPurgable() return false end
function item_epic_talisman_mod_passive:GetTexture() return "misc/talisman" end

-- CONSTRUCTORS -----------------------------------------------------------

function item_epic_talisman_mod_passive:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  self.parent:AddAbilityStats(self.ability, {"luck"})
end

function item_epic_talisman_mod_passive:OnRefresh(kv)
end

function item_epic_talisman_mod_passive:OnRemoved()
  if not IsServer() then return end

  self.parent:RemoveSubStats(self.ability, {"luck"})
end

-- API FUNCTIONS -----------------------------------------------------------

function item_epic_talisman_mod_passive:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_AVOID_DAMAGE
  }

  return funcs
end

function item_epic_talisman_mod_passive:GetModifierAvoidDamage()
  if RandomFloat(0, 100) < self.ability:GetSpecialValueFor("chance") then
    return 1
  end

  return 0
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------