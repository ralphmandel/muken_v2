lawbreaker_u_modifier_form = class({})

function lawbreaker_u_modifier_form:IsHidden() return false end
function lawbreaker_u_modifier_form:IsPurgable() return false end
function lawbreaker_u_modifier_form:GetPriority() return MODIFIER_PRIORITY_ULTRA end

-- CONSTRUCTORS -----------------------------------------------------------

function lawbreaker_u_modifier_form:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()
  self.transforming = 1
  self.interval = 0.5

  self.ability:SetActivated(false)
  self.ability:EndCooldown()

  local enemies = FindUnitsInRadius(
    self.parent:GetTeamNumber(), self.parent:GetOrigin(), nil, -1,
    self.ability:GetAbilityTargetTeam(), self.ability:GetAbilityTargetType(),
    self.ability:GetAbilityTargetFlags(), FIND_ANY_ORDER, false
  )

  for _,enemy in pairs(enemies) do
    AddModifier(enemy, self.ability, "_modifier_break", {duration = self:GetDuration()}, false)
  end

  AddModifier(self.parent, self.ability, "sub_stat_modifier", {
    status_resist_stack = self.ability:GetSpecialValueFor("special_status_resist")
  }, false)

  self.damageTable = {
    victim = nil, attacker = self.caster, ability = self.ability,
    damage = self.ability:GetSpecialValueFor("special_burn_damage") * self.interval,
    damage_type = self.ability:GetAbilityDamageType()
  }

  if IsServer() then
    self:StartIntervalThink(self.ability:GetSpecialValueFor("transform_duration"))
    self:PlayEfxStart()
  end
end

function lawbreaker_u_modifier_form:OnRefresh(kv)
end

function lawbreaker_u_modifier_form:OnRemoved()
  RemoveSubStats(self.parent, self.ability, {"status_resist_stack"})

  self.parent:FadeGesture(ACT_DOTA_GENERIC_CHANNEL_1)
  self.ability:SetActivated(true)
  self.ability:StartCooldown(self.ability:GetEffectiveCooldown(self.ability:GetLevel()))
  self:PlayEfxEnd()
end

-- API FUNCTIONS -----------------------------------------------------------

function lawbreaker_u_modifier_form:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = false,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}

  if self.transforming == 1 then
		table.insert(state, MODIFIER_STATE_STUNNED, true)
	end

  if self:GetAbility():GetSpecialValueFor("special_fly") == 1 then
		table.insert(state, MODIFIER_STATE_FORCED_FLYING_VISION, true)
	end

	return state
end

function lawbreaker_u_modifier_form:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_PROJECTILE_NAME,
		MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
    MODIFIER_EVENT_ON_RESPAWN
	}

	return funcs
end

function lawbreaker_u_modifier_form:GetModifierModelChange()
	return "models/heroes/muerta/muerta_ult.vmdl"
end

function lawbreaker_u_modifier_form:GetModifierModelScale()
	return self:GetAbility():GetSpecialValueFor("model_scale")
end

function lawbreaker_u_modifier_form:GetModifierProjectileName()
	return "particles/units/heroes/hero_muerta/muerta_ultimate_projectile.vpcf"
end

function lawbreaker_u_modifier_form:GetAttackSound()
	return "Hero_Muerta.PierceTheVeil.Attack"
end

-- function lawbreaker_u_modifier_form:OnRespawn(keys)
--   if keys.unit:GetTeamNumber() == self.parent:GetTeamNumber() then return end
--   AddModifier(keys.unit, self.ability, "_modifier_break", {duration = self:GetRemainingTime()}, false)
-- end

function lawbreaker_u_modifier_form:OnIntervalThink()
  self.transforming = 0

  if self.damageTable.damage > 0 then
    local enemies = FindUnitsInRadius(
      self.parent:GetTeamNumber(), self.parent:GetOrigin(), nil, -1,
      self.ability:GetAbilityTargetTeam(), self.ability:GetAbilityTargetType(),
      self.ability:GetAbilityTargetFlags(), FIND_ANY_ORDER, false
    )
  
    for _,enemy in pairs(enemies) do
      self.damageTable.victim = enemy
      ApplyDamage(self.damageTable)
    end
  end

  if IsServer() then self:StartIntervalThink(self.interval) end
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function lawbreaker_u_modifier_form:GetEffectName()
	return "particles/units/heroes/hero_muerta/muerta_ultimate_form_ethereal.vpcf"
end

function lawbreaker_u_modifier_form:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function lawbreaker_u_modifier_form:PlayEfxStart()
	local particle_cast = "particles/units/heroes/hero_muerta/muerta_ultimate_form_screen_effect.vpcf"
	local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(effect_cast, 1, Vector(1,0,0))
	self:AddParticle(effect_cast, false, false, -1, false, false)

  if IsServer() then self.parent:EmitSound("Hero_Muerta.PierceTheVeil.Cast") end
end

function lawbreaker_u_modifier_form:PlayEfxEnd()
	local particle_cast = "particles/units/heroes/hero_muerta/muerta_ultimate_form_finish.vpcf"
	local sound_cast = "Hero_Muerta.PierceTheVeil.End"
	local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:ReleaseParticleIndex(effect_cast)

  if IsServer() then self.parent:EmitSound("Hero_Muerta.PierceTheVeil.End") end
end

function lawbreaker_u_modifier_form:PlayEfxHit()
	local particle_cast = "particles/units/heroes/hero_muerta/muerta_gunslinger.vpcf"
	local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW,self.parent)
	ParticleManager:ReleaseParticleIndex(effect_cast)
end