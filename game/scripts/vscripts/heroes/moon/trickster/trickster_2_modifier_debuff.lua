trickster_2_modifier_debuff = class({})

function trickster_2_modifier_debuff:IsHidden() return true end
function trickster_2_modifier_debuff:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function trickster_2_modifier_debuff:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  AddSubStats(self.parent, self.ability, {
    critical_chance = self.ability:GetSpecialValueFor("critical_chance"),
    attack_time = self.ability:GetSpecialValueFor("special_attack_time")
  }, false)
end

function trickster_2_modifier_debuff:OnRefresh(kv)
  RemoveSubStats(self.parent, self.ability, {"critical_chance", "attack_time"})
  AddSubStats(self.parent, self.ability, {
    critical_chance = self.ability:GetSpecialValueFor("critical_chance"),
    attack_time = self.ability:GetSpecialValueFor("special_attack_time")
  }, false)
end

function trickster_2_modifier_debuff:OnRemoved()
  RemoveSubStats(self.parent, self.ability, {"critical_chance", "attack_time"})
end

-- API FUNCTIONS -----------------------------------------------------------

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------