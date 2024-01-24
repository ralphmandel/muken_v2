bloodstained_5_modifier_tears = class({})

function bloodstained_5_modifier_tears:IsHidden() return true end
function bloodstained_5_modifier_tears:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function bloodstained_5_modifier_tears:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

	self.interval = self.ability:GetSpecialValueFor("interval")
	self.blood_duration = self.ability:GetSpecialValueFor("blood_duration")

  self.parent:AddSubStats(self.ability, {critical_chance = self.ability:GetSpecialValueFor("special_critical_chance")})

  self:PlayEfxStart(self.ability:GetAOERadius())
  self:StartIntervalThink(self.interval)
end

function bloodstained_5_modifier_tears:OnRefresh(kv)
end

function bloodstained_5_modifier_tears:OnRemoved()
  if not IsServer() then return end
	
	self:PullBlood()

  self.parent:RemoveSubStats(self.ability, {"critical_chance"})
	self.parent:StopSound("Bloodstained.Mist.Loop")
end

-- API FUNCTIONS -----------------------------------------------------------

function bloodstained_5_modifier_tears:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}

	return funcs
end

function bloodstained_5_modifier_tears:OnTakeDamage(keys)
  if not IsServer() then return end

	if CalcDistanceBetweenEntityOBB(self.parent, keys.unit) <= self.ability:GetAOERadius() then
		self:CreateBlood(keys.unit, keys.damage, keys.unit:GetAbsOrigin())
		self:ApplyHaemorrhage(keys)
	end
end

function bloodstained_5_modifier_tears:OnIntervalThink()
  if not IsServer() then return end

  self:ApplyDrain(self.parent:GetMaxHealth() * self.ability:GetSpecialValueFor("hp_lost") * 0.01)
	self:StartIntervalThink(self.interval)
end

-- UTILS -----------------------------------------------------------

function bloodstained_5_modifier_tears:ApplyDrain(damage)
  local enemies = FindUnitsInRadius(
		self.caster:GetTeamNumber(), self.parent:GetOrigin(), nil, self.ability:GetAOERadius(),
		self.ability:GetAbilityTargetTeam(), self.ability:GetAbilityTargetType(),
		self.ability:GetAbilityTargetFlags(), FIND_ANY_ORDER, false
	)

	local damage_result = ApplyDamage({
		attacker = self.caster, victim = self.parent, ability = self.ability,
		damage = damage, damage_type = self.ability:GetAbilityDamageType(),
		damage_flags = 	DOTA_DAMAGE_FLAG_DONT_DISPLAY_DAMAGE_IF_SOURCE_HIDDEN + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
	})

  self:PopupBleedDamage(damage_result, self.parent)

	for _,enemy in pairs(enemies) do
		damage_result = ApplyDamage({
			attacker = self.caster, victim = enemy, ability = self.ability,
			damage = damage, damage_type = self.ability:GetAbilityDamageType(),
			damage_flags = 	DOTA_DAMAGE_FLAG_DONT_DISPLAY_DAMAGE_IF_SOURCE_HIDDEN + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
		})

    self:PopupBleedDamage(damage_result, enemy)
	end
end

function bloodstained_5_modifier_tears:ApplyHaemorrhage(keys)
	if keys.attacker == nil then return end
	if keys.attacker:IsBaseNPC() == false then return end
	if keys.damage_category ~= DOTA_DAMAGE_CATEGORY_ATTACK then return end
	if keys.damage_type ~= DAMAGE_TYPE_PHYSICAL then return end
  if keys.attacker:GetMainStat("STR").has_crit ~= true then return end

	local point = (keys.attacker:GetAbsOrigin() - keys.unit:GetAbsOrigin()):Normalized()
	self:CreateBlood(keys.unit, keys.damage, keys.unit:GetAbsOrigin() - (point * 175))
	self:CreateBlood(keys.unit, keys.damage, keys.unit:GetAbsOrigin() - (point * 350))
	self:PlayEfxHaemorrhage(keys.attacker, keys.unit)
end

function bloodstained_5_modifier_tears:CreateBlood(target, damage, origin)
	local point = origin + RandomVector(RandomInt(0, 75))

	local blood_thinker = CreateModifierThinker(
		self.caster, self.ability, "bloodstained_5_modifier_blood",
		{duration = self.blood_duration, damage = damage},
		point, self.parent:GetTeamNumber(), false
	)

	self:PlayEfxStartBlood(blood_thinker, point, damage)
end

function bloodstained_5_modifier_tears:PullBlood()
	local total_blood = 0
	local thinkers = Entities:FindAllByClassname("npc_dota_thinker")

	for _,blood in pairs(thinkers) do
		local mod = blood:FindModifierByName("bloodstained_5_modifier_blood")
		if mod and blood:GetOwner() == self.caster then 
			total_blood = total_blood + mod.damage
			self:PlayEfxPull(blood)
			blood:Destroy()
		end
	end

	if total_blood >= 1 then
    self.parent:ReduceStatus(total_blood * self.ability:GetSpecialValueFor("special_status_reduction") * 0.01, STATUS_LIST)
		self.parent:ApplyHeal(total_blood, self.ability, false)
		self:PlayEfxHeal()
	end
end

-- EFFECTS -----------------------------------------------------------

function bloodstained_5_modifier_tears:PlayEfxStart(radius)
	local string_2 = "particles/bloodstained/mist/blood_mist_aoe.vpcf"
	local particle_2 = ParticleManager:CreateParticle(string_2, PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(particle_2, 0, self.parent:GetOrigin())
	ParticleManager:SetParticleControl(particle_2, 1, Vector(radius, radius, radius))
	self:AddParticle(particle_2, false, false, -1, false, false)

  self.parent:EmitSound("Bloodstained.Mist.Loop")
end

function bloodstained_5_modifier_tears:PlayEfxStartBlood(blood_thinker, point, damage)
	local blood_mod = blood_thinker:FindModifierByNameAndCaster("bloodstained_5_modifier_blood", self.caster)
	local blood_percent = self.ability:GetSpecialValueFor("blood_percent") * 0.01
	local amount = math.floor(damage * blood_percent * 0.6)

	if blood_mod then
		local particle_cast = "particles/bloodstained/bloodstained_x2_blood.vpcf"
		blood_mod.effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, blood_thinker)
		ParticleManager:SetParticleControl(blood_mod.effect_cast, 1, point)
		ParticleManager:SetParticleControl(blood_mod.effect_cast, 5, Vector(amount, amount, point.z))

		blood_mod:AddParticle(blood_mod.effect_cast, false, false, -1, false, false)
	end
end

function bloodstained_5_modifier_tears:PlayEfxPull(blood)
	local particle_cast = "particles/units/heroes/hero_undying/undying_soul_rip_damage.vpcf"
	local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(effect_cast, 0, self.parent:GetOrigin())
	ParticleManager:SetParticleControl(effect_cast, 1, blood:GetOrigin())
	ParticleManager:SetParticleControl(effect_cast, 2, self.parent:GetOrigin())
end

function bloodstained_5_modifier_tears:PlayEfxHeal()
	local particle_cast = "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodbath.vpcf"
	local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent)

	local particle_cast_2 = "particles/osiris/poison_alt/osiris_poison_splash_shake.vpcf"
	local effect = ParticleManager:CreateParticle(particle_cast_2, PATTACH_ABSORIGIN, self.parent)
	ParticleManager:SetParticleControl(effect, 0, self.parent:GetOrigin())
	ParticleManager:SetParticleControl(effect, 1, Vector(500, 0, 0))

	self.parent:EmitSound("Hero_Undying.SoulRip.Cast")
end

function bloodstained_5_modifier_tears:PlayEfxHaemorrhage(attacker, target)
	local particle_cast = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf"
	local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControlEnt(effect_cast, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(effect_cast, 1, target:GetAbsOrigin())
	ParticleManager:SetParticleControlOrientation(effect_cast, 1, attacker:GetForwardVector() * (-1), attacker:GetRightVector(), attacker:GetUpVector())
	ParticleManager:ReleaseParticleIndex(effect_cast)

	target:EmitSound("Hero_PhantomAssassin.CoupDeGrace.Arcana")
end