neutral_burn_aura_modifier_aura_effect = class({})

function neutral_burn_aura_modifier_aura_effect:IsHidden() return true end
function neutral_burn_aura_modifier_aura_effect:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function neutral_burn_aura_modifier_aura_effect:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  local interval = 0.4

  self.damageTable = {
		attacker = self.caster, victim = self.parent, ability = self.ability,
		damage = self.ability:GetSpecialValueFor("damage") * interval,
    damage_type = self.ability:GetAbilityDamageType()
	}

  if IsServer() then self:StartIntervalThink(interval) end
end

function neutral_burn_aura_modifier_aura_effect:OnRefresh(kv)
end

function neutral_burn_aura_modifier_aura_effect:OnRemoved()
end

-- API FUNCTIONS -----------------------------------------------------------

function neutral_burn_aura_modifier_aura_effect:OnIntervalThink()
  ApplyDamage(self.damageTable)  
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------