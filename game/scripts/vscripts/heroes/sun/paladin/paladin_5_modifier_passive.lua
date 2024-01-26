paladin_5_modifier_passive = class({})

function paladin_5_modifier_passive:IsHidden() return true end
function paladin_5_modifier_passive:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function paladin_5_modifier_passive:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  self.cast = false
end

function paladin_5_modifier_passive:OnRefresh(kv)
end

function paladin_5_modifier_passive:OnRemoved()
end

-- API FUNCTIONS -----------------------------------------------------------

function paladin_5_modifier_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ORDER,
    MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK
	}

	return funcs
end

function paladin_5_modifier_passive:GetModifierAttackRangeBonus()
  return self.ability:GetSpecialValueFor("special_attack_range")
end

function paladin_5_modifier_passive:OnOrder(keys)
  if not IsServer() then return end

	if keys.unit ~= self.parent then return end

	if keys.ability then
		if keys.ability == self:GetAbility() and keys.order_type == 6 then
			self.cast = true
			return
		end
	end
	
	self.cast = false
end

function paladin_5_modifier_passive:GetModifierProcAttack_Feedback(keys)
  if not IsServer() then return end

  if self:ShouldLaunch(keys.target) == false then return end

  self.ability:UseResources(true, false, false, true)
  self.ability:SetCurrentAbilityCharges(self.ability:GetCurrentAbilityCharges() - 1)

  if keys.target:TriggerSpellAbsorb(self) then return end

  self:PlayEfxHit(keys.target)
  self:PlayEfxScreenShake(keys.target)

  if self.ability:GetSpecialValueFor("special_hits") > 0 then
    self.parent:AddModifier(self.ability, "paladin_5_modifier_sonicblow", {target = keys.target:entindex()})
  end

  if keys.target:IsMagicImmune() == false then
    keys.target:AddModifier(self.ability, "_modifier_stun", {
      duration = self.ability:GetSpecialValueFor("special_stun_duration"),
      bResist = 1
    })
  end

  ApplyDamage({
    victim = keys.target, attacker = self.caster,
    damage = self.ability:GetSpecialValueFor("damage"),
    damage_type = self.ability:GetAbilityDamageType(),
    ability = self.ability
  })

  self.parent:ApplyHeal(self.ability:GetSpecialValueFor("heal"), self.ability, false)
end

-- UTILS -----------------------------------------------------------

function paladin_5_modifier_passive:ShouldLaunch(target)
  if target == nil then return end
  if IsValidEntity(target) == false then return end
  if target:IsAlive() == false then return end

	if self.ability:GetAutoCastState() then
    local nResult = UnitFilter(
      target, self.ability:GetAbilityTargetTeam(),
      self.ability:GetAbilityTargetType(),
      self.ability:GetAbilityTargetFlags(),
      self.caster:GetTeamNumber()
    )

    self.cast = (nResult == UF_SUCCESS)
  end

	if self.cast == true and self.parent:IsSilenced() == false and self.ability:IsFullyCastable()
  and self.parent:HasModifier("paladin_5_modifier_sonicblow") == false then
    return true
  end

	return false
end

-- EFFECTS -----------------------------------------------------------

function paladin_5_modifier_passive:PlayEfxHit(target)
  local string = "particles/units/heroes/hero_omniknight/omniknight_shard_hammer_of_purity_target.vpcf"
  local effect = ParticleManager:CreateParticle(string, PATTACH_ABSORIGIN_FOLLOW, target)
  ParticleManager:SetParticleControl(effect, 0, target:GetOrigin())
  ParticleManager:ReleaseParticleIndex(effect)

  local particle_cast = "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_spawn_v2.vpcf"
	local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_WORLDORIGIN, nil)
  ParticleManager:SetParticleControl(effect_cast, 0, target:GetOrigin())

  local particle_cast = "particles/units/heroes/hero_omniknight/omniknight_shard_hammer_of_purity_heal.vpcf"
	local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(effect_cast, 0, self.parent:GetOrigin())

  target:EmitSound("Hero_Omniknight.HammerOfPurity.Crit")
  self.parent:EmitSound("Hero_Centaur.DoubleEdge")
end

function paladin_5_modifier_passive:PlayEfxScreenShake(target)
  local particle_shake = "particles/osiris/poison_alt/osiris_poison_splash_shake.vpcf"
	local effect = ParticleManager:CreateParticle(particle_shake, PATTACH_ABSORIGIN, self.parent)
	ParticleManager:SetParticleControl(effect, 0, self.parent:GetOrigin())
	ParticleManager:SetParticleControl(effect, 1, Vector(35, 0, 0))
  ParticleManager:ReleaseParticleIndex(effect)

	local effect = ParticleManager:CreateParticle(particle_shake, PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControl(effect, 0, target:GetOrigin())
	ParticleManager:SetParticleControl(effect, 1, Vector(35, 0, 0))
  ParticleManager:ReleaseParticleIndex(effect)
end