neutral_immunity_modifier_buff = class({})

function neutral_immunity_modifier_buff:IsHidden() return true end
function neutral_immunity_modifier_buff:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function neutral_immunity_modifier_buff:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  AddSubStats(self.parent, self.ability, {magic_resist = self.ability:GetSpecialValueFor("magic_resist")}, false)
  AddModifier(self.parent, self.ability, "_modifier_immunity", {}, false)
end

function neutral_immunity_modifier_buff:OnRefresh(kv)
end

function neutral_immunity_modifier_buff:OnRemoved()
  RemoveAllModifiersByNameAndAbility(self.parent, "_modifier_immunity", self.ability)
  RemoveSubStats(self.parent, self.ability, {"magic_resist"})
end

-- API FUNCTIONS -----------------------------------------------------------

function neutral_immunity_modifier_buff:OnIntervalThink()
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------