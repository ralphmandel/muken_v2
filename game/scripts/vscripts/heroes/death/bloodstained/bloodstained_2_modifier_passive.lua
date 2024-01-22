bloodstained_2_modifier_passive = class({})

function bloodstained_2_modifier_passive:IsHidden() return false end
function bloodstained_2_modifier_passive:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function bloodstained_2_modifier_passive:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  self.parent:AddSubStats(self.ability, {incoming_heal = self.ability:GetSpecialValueFor("incoming_heal")})
  self.parent:AddStatusEfx(self.caster, self.ability, "bloodstained_2_modifier_passive_status_efx")

	self:OnIntervalThink()
end

function bloodstained_2_modifier_passive:OnRefresh(kv)
  if not IsServer() then return end

  self.ability.min_hp = self.ability:GetSpecialValueFor("special_min_hp")

  self.parent:RemoveSubStats(self.ability, {"incoming_heal"})
  self.parent:AddSubStats(self.ability, {incoming_heal = self.ability:GetSpecialValueFor("incoming_heal")})
end

function bloodstained_2_modifier_passive:OnRemoved()
  if not IsServer() then return end

  self.parent:RemoveSubStats(self.ability, {"incoming_heal"})
  self.parent:RemoveStatusEfx(self.caster, self.ability, "bloodstained_2_modifier_passive_status_efx")
end

-- API FUNCTIONS -----------------------------------------------------------

function bloodstained_2_modifier_passive:DeclareFunctions()
	local funcs = {
    MODIFIER_PROPERTY_MIN_HEALTH,
    MODIFIER_EVENT_ON_HEAL_RECEIVED,
		MODIFIER_EVENT_ON_ATTACKED,
    MODIFIER_EVENT_ON_TAKEDAMAGE,
    MODIFIER_EVENT_ON_DEATH
	}

	return funcs
end

function bloodstained_2_modifier_passive:GetMinHealth(keys)
  if not IsServer() then return 0 end

  return self.ability.min_hp
end

function bloodstained_2_modifier_passive:OnHealReceived(keys)
  if keys.unit ~= self.parent then return end
  if keys.gain < 1 then return end
  if self.ability:GetSpecialValueFor("special_overhealth") == 0 then return end

  if keys.inflictor == self.ability and self.parent:GetHealthPercent() > 50 then
    self.parent:AddModifier(self.ability, "bloodstained_2_modifier_barrier", {gain = keys.gain})
  end
end

function bloodstained_2_modifier_passive:OnAttacked(keys)
  if not IsServer() then return end

  if self.parent ~= keys.attacker then return end
	if self.parent:PassivesDisabled() then return end

  local base_heal = self.ability:GetSpecialValueFor("base_heal")
  local max_heal = self.ability:GetSpecialValueFor("max_heal")

  local heal = keys.original_damage * self:GetLifestealPercent(self.parent, base_heal, max_heal) * 0.01

  if heal > 0 then
    self.parent:ApplyHeal(heal, self.ability, false)
    self:PlayEfxLifesteal(self.parent, keys.target)
  end
end

function bloodstained_2_modifier_passive:OnTakeDamage(keys)
  if not IsServer() then return end

  if keys.unit ~= self.parent then return end
  if self.parent:HasModifier("bloodstained_2_modifier_death_delay") then return end
  
  local killer = self.parent
  local inflictor = self.ability

  if keys.attacker then
    if keys.attacker:IsBaseNPC() then
      killer = keys.attacker
    end
  end

  if keys.inflictor then
    inflictor = keys.inflictor
  end

  if self.parent:IsAlive() and self.parent:GetHealth() == self.ability.min_hp then
    self.parent:AddModifier(self.ability, "bloodstained_2_modifier_death_delay", {
      killer = killer:GetEntityIndex(), inflictor = inflictor:GetEntityIndex(),
      duration = self.ability:GetSpecialValueFor("special_death_delay")
    })
  end
end

function bloodstained_2_modifier_passive:OnDeath(keys)
  if not IsServer() then return end

  if keys.attacker == nil then return end
	if keys.attacker:IsBaseNPC() == false then return end
  if keys.attacker ~= self.parent then end
  if self.parent:PassivesDisabled() then return end

  if CalcDistanceBetweenEntityOBB(self.parent, keys.unit) < self.ability:GetAOERadius() then
    local kill_heal = self.ability:GetSpecialValueFor("special_kill_heal")
    self.parent:ApplyHeal(self.parent:GetMaxHealth() * kill_heal * 0.01, self.ability, false)
    self:PlayEfxPull(keys.unit)
    self:PlayEfxHeal()
  end
end

function bloodstained_2_modifier_passive:OnIntervalThink()
  if not IsServer() then return end

  local base_heal = self.ability:GetSpecialValueFor("base_heal")
  local max_heal = self.ability:GetSpecialValueFor("max_heal")

  self:SetStackCount(math.floor(self:GetLifestealPercent(self.parent, base_heal, max_heal)))
  self:StartIntervalThink(0.25)
end

-- function bloodstained_2_modifier_passive:OnAttackLanded(keys)
--   if not IsServer() then return end

--   if self.parent ~= keys.attacker then return end
-- 	if self.parent:PassivesDisabled() then return end

--   local cleave_damage = self.ability:GetSpecialValueFor("special_cleave_damage")

--   DoCleaveAttack(
--     self.parent, keys.target, self.ability, keys.damage * cleave_damage * 0.01, 100, 400, 500,
--     "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave_gods_strength_crit.vpcf"
--   )
-- end

-- UTILS -----------------------------------------------------------

function bloodstained_2_modifier_passive:GetLifestealPercent(target, base_heal, max_heal)
  if base_heal > max_heal then return base_heal end

	local deficit_percent =  1 - (target:GetHealth() / target:GetMaxHealth())
	return ((max_heal - base_heal) * deficit_percent) + base_heal
end

-- EFFECTS -----------------------------------------------------------

function bloodstained_2_modifier_passive:GetStatusEffectName()
  return "particles/bloodstained/status_efx/status_effect_bloodstained.vpcf"
end

function bloodstained_2_modifier_passive:StatusEffectPriority()
return MODIFIER_PRIORITY_NORMAL
end

function bloodstained_2_modifier_passive:GetEffectName()
	return "particles/bioshadow/bioshadow_drain.vpcf"
end

function bloodstained_2_modifier_passive:GetEffectAttachType()
	return PATTACH_POINT_FOLLOW
end

function bloodstained_2_modifier_passive:PlayEfxLifesteal(attacker, target)
	local particle_cast = "particles/units/heroes/hero_bloodseeker/bloodseeker_rupture_nuke.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControlEnt(effect_cast, 1, target, PATTACH_ABSORIGIN_FOLLOW, "", Vector(0,0,0), true)

	local particle_cast2 = "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodbath.vpcf"
  local effect_cast2 = ParticleManager:CreateParticle(particle_cast2, PATTACH_ABSORIGIN_FOLLOW, attacker)
	ParticleManager:ReleaseParticleIndex(effect_cast2)

	attacker:EmitSound("Bloodstained.Lifesteal")
end

function bloodstained_2_modifier_passive:PlayEfxPull(target)
	local particle_cast = "particles/units/heroes/hero_undying/undying_soul_rip_damage.vpcf"
	local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(effect_cast, 0, self.parent:GetOrigin())
	ParticleManager:SetParticleControl(effect_cast, 1, target:GetOrigin())
	ParticleManager:SetParticleControl(effect_cast, 2, self.parent:GetOrigin())

  target:EmitSound("Hero_Undying.Decay.Cast")
end

function bloodstained_2_modifier_passive:PlayEfxHeal()
	local particle_cast = "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodbath.vpcf"
	local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent)

	local particle_cast_2 = "particles/osiris/poison_alt/osiris_poison_splash_shake.vpcf"
	local effect = ParticleManager:CreateParticle(particle_cast_2, PATTACH_ABSORIGIN, self.parent)
	ParticleManager:SetParticleControl(effect, 0, self.parent:GetOrigin())
	ParticleManager:SetParticleControl(effect, 1, Vector(500, 0, 0))
end