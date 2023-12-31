trickster_1_modifier_aspd = class({})

function trickster_1_modifier_aspd:IsHidden() return false end
function trickster_1_modifier_aspd:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function trickster_1_modifier_aspd:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  AddSubStats(self.parent, self.ability, {
    attack_speed = self.ability:GetSpecialValueFor("attack_speed")
  }, false)

  if IsServer() then self:StartIntervalThink(0.1) end
end

function trickster_1_modifier_aspd:OnRefresh(kv)
  RemoveSubStats(self.parent, self.ability, {"attack_speed"})
  AddSubStats(self.parent, self.ability, {
    attack_speed = self.ability:GetSpecialValueFor("attack_speed")
  }, false)
end

function trickster_1_modifier_aspd:OnRemoved()
  RemoveSubStats(self.parent, self.ability, {"attack_speed"})
end

-- API FUNCTIONS -----------------------------------------------------------

function trickster_1_modifier_aspd:OnIntervalThink()
  if self.parent:IsAttacking() == false then self:Destroy() end

  if IsServer() then self:StartIntervalThink(0.1) end
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------