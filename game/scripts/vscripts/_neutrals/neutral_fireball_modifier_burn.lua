neutral_fireball_modifier_burn = class({})

function neutral_fireball_modifier_burn:IsHidden() return false end
function neutral_fireball_modifier_burn:IsPurgable() return true end

-- CONSTRUCTORS -----------------------------------------------------------

function neutral_fireball_modifier_burn:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

 local interval = 0.5

	self.damageTable = {
    victim = self.parent,
    attacker = self.caster,
    damage = self.ability:GetSpecialValueFor("flame_damage") * interval,
    damage_type = self.ability:GetAbilityDamageType(),
    ability = self.ability
  }

  self.parent:EmitSound("Hero_Huskar.Burning_Spear")
  self:StartIntervalThink(interval)
end

function neutral_fireball_modifier_burn:OnRefresh(kv)
end

function neutral_fireball_modifier_burn:OnRemoved()
end

-- API FUNCTIONS -----------------------------------------------------------

function neutral_fireball_modifier_burn:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH
	}

	return funcs
end

function neutral_fireball_modifier_burn:OnDeath(keys)
	if keys.unit ~= self.caster then return end
  if self.caster:IsHero() then return end
	self:Destroy()
end

function neutral_fireball_modifier_burn:OnIntervalThink()
  if not IsServer() then return end

  ApplyDamage(self.damageTable)
end 

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function neutral_fireball_modifier_burn:GetEffectName()
	return "particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf"
end

function neutral_fireball_modifier_burn:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end