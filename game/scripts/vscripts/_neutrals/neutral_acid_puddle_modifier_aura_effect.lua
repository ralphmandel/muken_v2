neutral_acid_puddle_modifier_aura_effect = class({})

function neutral_acid_puddle_modifier_aura_effect:IsHidden() return true end
function neutral_acid_puddle_modifier_aura_effect:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function neutral_acid_puddle_modifier_aura_effect:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  local interval = 0.5

  self.damageTable = {
		attacker = self.caster, victim = self.parent, ability = self.ability,
		damage = self.ability:GetSpecialValueFor("damage") * interval,
    damage_type = self.ability:GetAbilityDamageType()
	}

  if IsServer() then self:StartIntervalThink(interval) end
end

function neutral_acid_puddle_modifier_aura_effect:OnRefresh(kv)
end

function neutral_acid_puddle_modifier_aura_effect:OnRemoved()
end

-- API FUNCTIONS -----------------------------------------------------------

function neutral_acid_puddle_modifier_aura_effect:OnIntervalThink()
  if IsServer() then self.parent:EmitSound("Hero_Alchemist.AcidSpray.Damage") end

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