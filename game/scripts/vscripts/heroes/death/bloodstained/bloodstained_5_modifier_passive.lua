bloodstained_5_modifier_passive = class({})

function bloodstained_5_modifier_passive:IsHidden() return false end
function bloodstained_5_modifier_passive:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function bloodstained_5_modifier_passive:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  AddStatusEfx(self.ability, "bloodstained_5_modifier_passive_status_efx", self.caster, self.parent)

	if IsServer() then self:OnIntervalThink() end
end

function bloodstained_5_modifier_passive:OnRefresh(kv)
end

function bloodstained_5_modifier_passive:OnRemoved()
  RemoveStatusEfx(self.ability, "bloodstained_5_modifier_passive_status_efx", self.caster, self.parent)
end

-- API FUNCTIONS -----------------------------------------------------------

function bloodstained_5_modifier_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACKED,
    MODIFIER_EVENT_ON_DEATH
	}

	return funcs
end

function bloodstained_5_modifier_passive:OnAttacked(keys)
	if keys.attacker:GetTeamNumber() ~= self.parent:GetTeamNumber() then return end
	if self.parent:PassivesDisabled() then return end
	if self.parent:GetTeamNumber() == keys.target:GetTeamNumber() then return end

  local heal = keys.original_damage * self:GetLifestealPercent(keys.attacker) * 0.01

  if keys.attacker == self.parent then
    self.parent:Heal(heal, self.ability)
    self:PlayEfxLifesteal(keys.attacker, keys.target)
  else
    heal = heal * self.ability:GetSpecialValueFor("special_lifesteal_allies") * 0.01
    if heal > 0 then
      keys.attacker:Heal(heal, self.ability)
      self:PlayEfxLifesteal(keys.attacker, keys.target)
    end
  end
end

function bloodstained_5_modifier_passive:OnDeath(keys)
  if keys.attacker == nil then return end
	if keys.attacker:IsBaseNPC() == false then return end
  if keys.unit:GetTeamNumber() == self.parent:GetTeamNumber() then return end
	if keys.unit:IsIllusion() then return end
  if keys.unit:IsHero() == false and keys.unit:IsConsideredHero() == false then return end

  local target_hp = self.ability:GetSpecialValueFor("special_target_hp")
  local self_hp_hero = self.ability:GetSpecialValueFor("special_self_hp_hero")
  local self_hp_creep = self.ability:GetSpecialValueFor("special_self_hp_creep")

  if target_hp > 0 then
    if keys.attacker == self.parent then
      self.parent:Heal(keys.unit:GetMaxHealth() * target_hp * 0.01, self.ability)
      self:PlayEfxHeal()
    end
  end

  if CalcDistanceBetweenEntityOBB(self.parent, keys.unit) < self.ability:GetAOERadius() then
    self:PlayEfxPull(keys.unit)
    self:PlayEfxHeal()

    if keys.unit:IsHero() then
      self.parent:Heal(self.parent:GetMaxHealth() * self_hp_hero * 0.01, self.ability)
    else
      self.parent:Heal(self.parent:GetMaxHealth() * self_hp_creep * 0.01, self.ability)
    end
  end
end

function bloodstained_5_modifier_passive:OnIntervalThink()
	if IsServer() then
		self:SetStackCount(math.floor(self:GetLifestealPercent(self.parent)))
		self:StartIntervalThink(FrameTime())
	end
end

-- UTILS -----------------------------------------------------------

function bloodstained_5_modifier_passive:GetLifestealPercent(target)
	local base_heal = self.ability:GetSpecialValueFor("base_heal")
	local max_heal = self.ability:GetSpecialValueFor("max_heal")
	local deficit_percent =  1 - (target:GetHealth() / target:GetMaxHealth())

	return ((max_heal - base_heal) * deficit_percent) + base_heal
end

-- EFFECTS -----------------------------------------------------------

function bloodstained_5_modifier_passive:GetStatusEffectName()
  return "particles/bloodstained/status_efx/status_effect_bloodstained.vpcf"
end

function bloodstained_5_modifier_passive:StatusEffectPriority()
return MODIFIER_PRIORITY_NORMAL
end

function bloodstained_5_modifier_passive:GetEffectName()
	return "particles/bioshadow/bioshadow_drain.vpcf"
end

function bloodstained_5_modifier_passive:GetEffectAttachType()
	return PATTACH_POINT_FOLLOW
end

function bloodstained_5_modifier_passive:PlayEfxLifesteal(attacker, target)
	local particle_cast = "particles/units/heroes/hero_bloodseeker/bloodseeker_rupture_nuke.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControlEnt(effect_cast, 1, target, PATTACH_ABSORIGIN_FOLLOW, "", Vector(0,0,0), true)

	local particle_cast2 = "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodbath.vpcf"
    local effect_cast2 = ParticleManager:CreateParticle(particle_cast2, PATTACH_ABSORIGIN_FOLLOW, attacker)
	ParticleManager:ReleaseParticleIndex(effect_cast2)

	if IsServer() then attacker:EmitSound("Bloodstained.Lifesteal") end
end

function bloodstained_5_modifier_passive:PlayEfxPull(target)
	local particle_cast = "particles/units/heroes/hero_undying/undying_soul_rip_damage.vpcf"
	local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(effect_cast, 0, self.parent:GetOrigin())
	ParticleManager:SetParticleControl(effect_cast, 1, target:GetOrigin())
	ParticleManager:SetParticleControl(effect_cast, 2, self.parent:GetOrigin())

  if IsServer() then self.parent:EmitSound("Hero_Undying.SoulRip.Cast") end
end

function bloodstained_5_modifier_passive:PlayEfxHeal()
	local particle_cast = "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodbath.vpcf"
	local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent)

	local particle_cast_2 = "particles/osiris/poison_alt/osiris_poison_splash_shake.vpcf"
	local effect = ParticleManager:CreateParticle(particle_cast_2, PATTACH_ABSORIGIN, self.parent)
	ParticleManager:SetParticleControl(effect, 0, self.parent:GetOrigin())
	ParticleManager:SetParticleControl(effect, 1, Vector(500, 0, 0))
end