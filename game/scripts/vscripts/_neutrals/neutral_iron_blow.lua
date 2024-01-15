neutral_iron_blow = class({})
LinkLuaModifier("neutral_iron_blow_modifier_passive", "_neutrals/neutral_iron_blow_modifier_passive", LUA_MODIFIER_MOTION_NONE)

function neutral_iron_blow:Spawn()
  if not IsServer() then return end

  Timers:CreateTimer((0.2), function()
    if IsServer() then
      self:SetLevel(self:GetMaxLevel())
    end
  end)
end

function neutral_iron_blow:GetIntrinsicModifierName()
	return "neutral_iron_blow_modifier_passive"
end

function neutral_iron_blow:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function neutral_iron_blow:OnAbilityPhaseStart()
  if not IsServer() then return true end

  local caster = self:GetCaster()
	caster:EmitSound("Hero_MonkeyKing.Strike.Cast")

  return true
end

function neutral_iron_blow:OnAbilityPhaseInterrupted()
  if not IsServer() then return end

  local caster = self:GetCaster()
	caster:StopSound("Hero_MonkeyKing.Strike.Cast")
end

function neutral_iron_blow:OnSpellStart()
  if not IsServer() then return end

  local caster = self:GetCaster()
  local damage = caster:GetHealthDeficit() * self:GetSpecialValueFor("damage") * 0.01

  self:PlayEfxStart()
  self:PlayEfxScreenShake(caster)

	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(), caster:GetOrigin(), nil, self:GetAOERadius(),
		self:GetAbilityTargetTeam(), self:GetAbilityTargetType(),
		self:GetAbilityTargetFlags(), FIND_ANY_ORDER, false
	)

	for _,enemy in pairs(enemies) do
    if caster:IsHero() == true
    or (enemy:GetTeamNumber() ~= TIER_TEAMS[RARITY_COMMON] and enemy:GetTeamNumber() < TIER_TEAMS[RARITY_RARE]) then      
      self:PlayEfxScreenShake(enemy)

      ApplyDamage({
        attacker = caster, victim = enemy,
        ability = self, damage = damage,
        damage_type = self:GetAbilityDamageType(),
      })
    end
  end
end

function neutral_iron_blow:PlayEfxStart()
  local caster = self:GetCaster()
	local particle_cast = "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_aftershock.vpcf"
	local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(effect_cast, 1, Vector(self:GetAOERadius(), self:GetAOERadius(), self:GetAOERadius()))
	ParticleManager:ReleaseParticleIndex(effect_cast)

  if IsServer() then caster:EmitSound("Hero_MonkeyKing.Strike.Impact") end
end

function neutral_iron_blow:PlayEfxScreenShake(target)
  local particle_shake = "particles/osiris/poison_alt/osiris_poison_splash_shake.vpcf"
	local effect = ParticleManager:CreateParticle(particle_shake, PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControl(effect, 0, target:GetOrigin())
	ParticleManager:SetParticleControl(effect, 1, Vector(35, 0, 0))
  ParticleManager:ReleaseParticleIndex(effect)
end