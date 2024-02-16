neutral_doom_modifier_debuff = class({})

function neutral_doom_modifier_debuff:IsHidden() return false end
function neutral_doom_modifier_debuff:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function neutral_doom_modifier_debuff:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  self.parent:AddStatusEfx(self.caster, self.ability, "neutral_doom_modifier_debuff_status_efx")
  self.parent:AddSubStats(self.ability, {manacost = self.ability:GetSpecialValueFor("manacost")})

  self.interval = 0.8

  self.damageTable = {
		attacker = self.caster, victim = self.parent, ability = self.ability,
    damage_type = self.ability:GetAbilityDamageType()
	}

  self:PlayEfxStart()
  self:StartIntervalThink(self.interval)
end

function neutral_doom_modifier_debuff:OnRefresh(kv)
end

function neutral_doom_modifier_debuff:OnRemoved()
  if not IsServer() then return end

  self.parent:RemoveStatusEfx(self.caster, self.ability, "neutral_doom_modifier_debuff_status_efx")
  self.parent:RemoveSubStats(self.ability, {"manacost"})

  if IsServer() then self.parent:StopSound("Hero_DoomBringer.Doom") end
end

-- API FUNCTIONS -----------------------------------------------------------

function neutral_doom_modifier_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_PASSIVES_DISABLED] = true,
    [MODIFIER_STATE_MUTED] = true
	}

	return state
end

function neutral_doom_modifier_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH
	}

	return funcs
end

function neutral_doom_modifier_debuff:OnDeath(keys)
	if keys.unit ~= self.caster then return end
  if self.caster:IsHero() then return end
	self:Destroy()
end

function neutral_doom_modifier_debuff:OnIntervalThink()
  if not IsServer() then return end

  local damage = self.ability:GetSpecialValueFor("damage") * self.interval
  self.damageTable.damage = self.damageTable.attacker:GetSpellDamage(damage, self.ability:GetAbilityDamageType())
  ApplyDamage(self.damageTable)
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function neutral_doom_modifier_debuff:GetStatusEffectName()
	return "particles/status_fx/status_effect_doom.vpcf"
end

function neutral_doom_modifier_debuff:StatusEffectPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end

function neutral_doom_modifier_debuff:PlayEfxStart()
	local particle_cast = "particles/units/heroes/hero_doom_bringer/doom_bringer_doom.vpcf"
	local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent)
	self:AddParticle(effect_cast, false, false, MODIFIER_PRIORITY_SUPER_ULTRA, false, false)

	if IsServer() then self.parent:EmitSound("Hero_DoomBringer.Doom") end
end