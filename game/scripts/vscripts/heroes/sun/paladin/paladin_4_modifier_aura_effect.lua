paladin_4_modifier_aura_effect = class({})

function paladin_4_modifier_aura_effect:IsHidden() return true end
function paladin_4_modifier_aura_effect:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function paladin_4_modifier_aura_effect:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  self.interval = self.ability:GetSpecialValueFor("interval")
  self:StartIntervalThink(self.interval)
end

function paladin_4_modifier_aura_effect:OnRefresh(kv)
end

function paladin_4_modifier_aura_effect:OnRemoved(bDeath)
  if not IsServer() then return end

  local heal_hero = self.ability:GetSpecialValueFor("special_heal_hero")
  local heal_unit = self.ability:GetSpecialValueFor("special_heal_unit")

  if self.parent:IsAlive() == false and self.parent:IsIllusion() == false then
    if self.parent:IsHero() then
      self.caster:ApplyHeal(self.caster:GetMaxHealth() * heal_hero * 0.01, self.ability, false)
      if heal_hero > 0 then self:PlayEfxHeal() end
    else
      self.caster:ApplyHeal(self.caster:GetMaxHealth() * heal_unit * 0.01, self.ability, false)
      if heal_unit > 0 then self:PlayEfxHeal() end
    end
  end
end

-- API FUNCTIONS -----------------------------------------------------------

function paladin_4_modifier_aura_effect:CheckState()
	local state = {
		[MODIFIER_STATE_SILENCED] = true
	}

	return state
end

function paladin_4_modifier_aura_effect:OnIntervalThink()
  if not IsServer() then return end

  self:PlayEfxHit()

  local damage = ApplyDamage({
    victim = self.parent, attacker = self.caster,
    damage = self.caster:GetMaxHealth() * self.ability:GetSpecialValueFor("damage_percent") * self.interval * 0.01,
    damage_type = self.ability:GetAbilityDamageType(),
    ability = self.ability, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
  })

  self.parent:ApplyMana(damage * self.ability:GetSpecialValueFor("special_manaloss") * 0.01, self.ability, false, nil, true)
  self:StartIntervalThink(self.interval) 
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function paladin_4_modifier_aura_effect:PlayEfxHit()
	local particle_target = "particles/units/heroes/hero_omniknight/omniknight_purification_hit.vpcf"
	local effect_target = ParticleManager:CreateParticle(particle_target, PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControlEnt(effect_target, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetOrigin(), true)
	ParticleManager:SetParticleControlEnt(effect_target, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetOrigin(), true)
	ParticleManager:ReleaseParticleIndex(effect_target)

  self.parent:EmitSound("Paladin.Magnus.Hit")
end

function paladin_4_modifier_aura_effect:PlayEfxHeal()
  local particle = "particles/units/heroes/hero_omniknight/omniknight_purification.vpcf"
  local effect = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, self.caster)
	ParticleManager:SetParticleControl(effect, 1, Vector(125, 125, 125))
  ParticleManager:ReleaseParticleIndex(effect)

  self.caster:EmitSound("Hero_Omniknight.Purification")
end