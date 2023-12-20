paladin_4_modifier_aura_effect = class({})

function paladin_4_modifier_aura_effect:IsHidden() return false end
function paladin_4_modifier_aura_effect:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function paladin_4_modifier_aura_effect:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  self.interval = self.ability:GetSpecialValueFor("interval")

  if IsServer() then self:StartIntervalThink(self.interval) end
end

function paladin_4_modifier_aura_effect:OnRefresh(kv)
end

function paladin_4_modifier_aura_effect:OnRemoved(bDeath)
  if self.parent:IsAlive() == false and self.parent:IsIllusion() == false then
    self:PlayEfxHeal()

    if self.parent:IsHero() then
      self.caster:Heal(self.caster:GetMaxHealth() * self.ability:GetSpecialValueFor("special_heal_hero") * 0.01, self.ability)
    else
      self.caster:Heal(self.caster:GetMaxHealth() * self.ability:GetSpecialValueFor("special_heal_unit") * 0.01, self.ability)
    end
  end
end

-- API FUNCTIONS -----------------------------------------------------------

function paladin_4_modifier_aura_effect:CheckState()
	local state = {
		[MODIFIER_STATE_SILENCED] = true,
    [MODIFIER_STATE_DISARMED] = true,
	}

  --if self:GetParent():IsMagicImmune() then state = {} end

	return state
end

function paladin_4_modifier_aura_effect:OnIntervalThink()
  self:PlayEfxHit()

  local damage = ApplyDamage({
    victim = self.parent, attacker = self.caster,
    damage = self.caster:GetMaxHealth() * self.ability:GetSpecialValueFor("damage_percent") * self.interval * 0.01,
    damage_type = self.ability:GetAbilityDamageType(),
    ability = self.ability, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
  })

  ReduceMana(self.parent, self.ability, damage * self.ability:GetSpecialValueFor("special_manaloss") * 0.01, true)

  if IsServer() then self:StartIntervalThink(self.interval) end
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function paladin_4_modifier_aura_effect:PlayEfxHit()
	local particle_target = "particles/units/heroes/hero_omniknight/omniknight_purification_hit.vpcf"
	local effect_target = ParticleManager:CreateParticle(particle_target, PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControlEnt(effect_target, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetOrigin(), true)
	ParticleManager:SetParticleControlEnt(effect_target, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetOrigin(), true)
	ParticleManager:ReleaseParticleIndex(effect_target)

  if IsServer() then self.parent:EmitSound("Paladin.Magnus.Hit") end
end

function paladin_4_modifier_aura_effect:PlayEfxHeal()
  local particle = "particles/units/heroes/hero_omniknight/omniknight_purification.vpcf"
  local effect = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, self.caster)
	ParticleManager:SetParticleControl(effect, 1, Vector(125, 125, 125))
  ParticleManager:ReleaseParticleIndex(effect)

  if IsServer() then self.caster:EmitSound("Hero_Omniknight.Purification") end
end