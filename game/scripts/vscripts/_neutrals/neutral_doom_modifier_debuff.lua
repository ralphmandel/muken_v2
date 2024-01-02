neutral_doom_modifier_debuff = class({})

function neutral_doom_modifier_debuff:IsHidden() return false end
function neutral_doom_modifier_debuff:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function neutral_doom_modifier_debuff:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  AddStatusEfx(self.ability, "neutral_doom_modifier_debuff_status_efx", self.caster, self.parent)
  AddSubStats(self.parent, self.ability, {manacost = self.ability:GetSpecialValueFor("manacost")}, false)

  local interval = 0.8

  self.damageTable = {
		attacker = self.caster, victim = self.parent, ability = self.ability,
		damage = self.ability:GetSpecialValueFor("damage") * interval,
    damage_type = self.ability:GetAbilityDamageType()
	}

  if IsServer() then
    self:PlayEfxStart()
    self:StartIntervalThink(interval)
  end
end

function neutral_doom_modifier_debuff:OnRefresh(kv)
end

function neutral_doom_modifier_debuff:OnRemoved()
  RemoveStatusEfx(self.ability, "neutral_doom_modifier_debuff_status_efx", self.caster, self.parent)
  RemoveSubStats(self.parent, self.ability, {"manacost"})

  if IsServer() then self.parent:StopSound("Hero_DoomBringer.Doom") end
end

-- API FUNCTIONS -----------------------------------------------------------

function neutral_doom_modifier_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_PASSIVES_DISABLED] = true,
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
	self:Destroy()
end

function neutral_doom_modifier_debuff:OnIntervalThink()
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