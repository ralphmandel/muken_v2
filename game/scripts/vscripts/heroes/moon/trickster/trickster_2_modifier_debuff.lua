trickster_2_modifier_debuff = class({})

function trickster_2_modifier_debuff:IsHidden() return false end
function trickster_2_modifier_debuff:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function trickster_2_modifier_debuff:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  AddSubStats(self.parent, self.ability, {critical_chance = self.ability:GetSpecialValueFor("critical_chance")}, false)
end

function trickster_2_modifier_debuff:OnRefresh(kv)
  RemoveSubStats(self.parent, self.ability, {"critical_chance"})
  AddSubStats(self.parent, self.ability, {critical_chance = self.ability:GetSpecialValueFor("critical_chance")}, false)
end

function trickster_2_modifier_debuff:OnRemoved()
  RemoveSubStats(self.parent, self.ability, {"critical_chance"})
end

-- API FUNCTIONS -----------------------------------------------------------

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------