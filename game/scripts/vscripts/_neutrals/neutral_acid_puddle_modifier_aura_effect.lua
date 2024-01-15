neutral_acid_puddle_modifier_aura_effect = class({})

function neutral_acid_puddle_modifier_aura_effect:IsHidden() return true end
function neutral_acid_puddle_modifier_aura_effect:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function neutral_acid_puddle_modifier_aura_effect:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  local interval = 0.5

  self.damageTable = {
		attacker = self.caster, victim = self.parent, ability = self.ability,
		damage = self.ability:GetSpecialValueFor("damage") * interval,
    damage_type = self.ability:GetAbilityDamageType()
	}

  self:StartIntervalThink(interval)
end

function neutral_acid_puddle_modifier_aura_effect:OnRefresh(kv)
end

function neutral_acid_puddle_modifier_aura_effect:OnRemoved()
end

-- API FUNCTIONS -----------------------------------------------------------

function neutral_acid_puddle_modifier_aura_effect:OnIntervalThink()
  if not IsServer() then return end

  self.parent:EmitSound("Hero_Alchemist.AcidSpray.Damage")
  ApplyDamage(self.damageTable)
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function neutral_acid_puddle_modifier_aura_effect:GetEffectName()
	return "particles/units/heroes/hero_alchemist/alchemist_acid_spray_debuff.vpcf"
end

function neutral_acid_puddle_modifier_aura_effect:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end