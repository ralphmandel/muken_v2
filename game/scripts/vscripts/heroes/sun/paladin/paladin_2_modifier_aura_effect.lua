paladin_2_modifier_aura_effect = class({})

function paladin_2_modifier_aura_effect:IsHidden() return true end
function paladin_2_modifier_aura_effect:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function paladin_2_modifier_aura_effect:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  self.interval = self.ability:GetSpecialValueFor("special_burn_tick")
  self.parent:AddModifier(self.ability, "paladin_2_modifier_burn_efx", {})

  self:StartIntervalThink(self.interval)
end

function paladin_2_modifier_aura_effect:OnRefresh(kv)
end

function paladin_2_modifier_aura_effect:OnRemoved()
  if not IsServer() then return end

  self.parent:RemoveModifierByName("paladin_2_modifier_burn_efx")
end

-- API FUNCTIONS -----------------------------------------------------------

-- UTILS -----------------------------------------------------------

function paladin_2_modifier_aura_effect:OnIntervalThink()
  if not IsServer() then return end

  ApplyDamage({
    victim = self.parent, attacker = self.caster, ability = self.ability,
    damage = self.ability:GetSpecialValueFor("special_burn_damage") * self.interval,
    damage_type = self.ability:GetAbilityDamageType(),
  })

	self:StartIntervalThink(self.interval)
end

-- EFFECTS -----------------------------------------------------------