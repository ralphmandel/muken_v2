neutral_burn_aura_modifier_aura_effect = class({})

function neutral_burn_aura_modifier_aura_effect:IsHidden() return true end
function neutral_burn_aura_modifier_aura_effect:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function neutral_burn_aura_modifier_aura_effect:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  self.interval = 0.4

  self.damageTable = {
		attacker = self.caster, victim = self.parent, ability = self.ability,
    damage_type = self.ability:GetAbilityDamageType()
	}

  self:StartIntervalThink(self.interval)
end

function neutral_burn_aura_modifier_aura_effect:OnRefresh(kv)
end

function neutral_burn_aura_modifier_aura_effect:OnRemoved()
end

-- API FUNCTIONS -----------------------------------------------------------

function neutral_burn_aura_modifier_aura_effect:OnIntervalThink()
  if not IsServer() then return end

  local damage = self.ability:GetSpecialValueFor("damage") * self.interval
  self.damageTable.damage = self.damageTable.attacker:GetSpellDamage(damage, self.ability:GetAbilityDamageType())
  ApplyDamage(self.damageTable)  
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------