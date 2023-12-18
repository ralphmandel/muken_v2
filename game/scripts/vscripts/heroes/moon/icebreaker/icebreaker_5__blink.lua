icebreaker_5__blink = class({})
LinkLuaModifier("icebreaker_5_modifier_passive", "heroes/moon/icebreaker/icebreaker_5_modifier_passive", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("icebreaker__modifier_slow", "heroes/moon/icebreaker/icebreaker__modifier_slow", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("icebreaker__modifier_hypo", "heroes/moon/icebreaker/icebreaker__modifier_hypo", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("icebreaker__modifier_hypo_status_efx", "heroes/moon/icebreaker/icebreaker__modifier_hypo_status_efx", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("icebreaker__modifier_frozen", "heroes/moon/icebreaker/icebreaker__modifier_frozen", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("icebreaker__modifier_frozen_status_efx", "heroes/moon/icebreaker/icebreaker__modifier_frozen_status_efx", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_bat_increased", "_modifiers/_modifier_bat_increased", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_percent_movespeed_debuff", "_modifiers/_modifier_percent_movespeed_debuff", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function icebreaker_5__blink:Spawn()
    Timers:CreateTimer(0.2, function()
      if self:IsTrained() == false then
        self:UpgradeAbility(true)
      end
    end)

    self.kills = 0
    self.turn = 0
  end

  function icebreaker_5__blink:CastFilterResultTarget(hTarget)
		local caster = self:GetCaster()
		if caster == hTarget then return UF_FAIL_CUSTOM end

		if hTarget:GetTeamNumber() ~= caster:GetTeamNumber()
		and hTarget:HasModifier("icebreaker__modifier_frozen") then
			return UF_SUCCESS
		end

		local result = UnitFilter(
			hTarget, self:GetAbilityTargetTeam(),
			self:GetAbilityTargetType(),
			self:GetAbilityTargetFlags(),
			caster:GetTeamNumber()
		)
		
		if result ~= UF_SUCCESS then return result end

		return UF_SUCCESS
	end

	function icebreaker_5__blink:GetCustomCastErrorTarget(hTarget)
		if self:GetCaster() == hTarget then return "#dota_hud_error_cant_cast_on_self" end
	end

  function icebreaker_5__blink:GetIntrinsicModifierName()
    return "icebreaker_5_modifier_passive"
  end

-- SPELL START

  function icebreaker_5__blink:OnAbilityPhaseStart()
		local caster = self:GetCaster()

    ChangeActivity(caster, "ti6")
    caster:StartGesture(ACT_DOTA_CAST_ABILITY_2)

		return true
	end

  function icebreaker_5__blink:OnAbilityPhaseInterrupted()
    local caster = self:GetCaster()
    ChangeActivity(caster, "shinobi_tail")
    caster:FadeGesture(ACT_DOTA_CAST_ABILITY_2)
    self.turn = 0
	end

	function icebreaker_5__blink:OnSpellStart()
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()
		local origin = caster:GetOrigin()
		local point = self:GetCursorPosition()
		local distance = CalcDistanceBetweenEntityOBB(caster, target)

    ChangeActivity(caster, "shinobi_tail")

		if target:GetTeamNumber() ~= caster:GetTeamNumber() then
			if target:TriggerSpellAbsorb(self) then
				self.turn = 0
				return
			end
		end

    local bot_script = caster:FindModifierByName("_general_script")

		if IsServer() then caster:EmitSound("Hero_QueenOfPain.Blink_out") end

		local direction = target:GetForwardVector() * (-1)
		local blink_point = target:GetAbsOrigin() + direction * 130
    FindClearSpaceForUnit(caster, blink_point, true)
		caster:SetForwardVector(-direction)
		ProjectileManager:ProjectileDodge(caster)

		Timers:CreateTimer(0.1, function()
			self.turn = 0
		end)

		self:PlayEfxBlink(direction, origin, target)

		if target:GetTeamNumber() ~= caster:GetTeamNumber() then
      if caster:IsCommandRestricted() == false then
        caster:MoveToTargetToAttack(target)      
      end
      if bot_script then bot_script.attack_target = target end
		end

		if target:HasModifier("icebreaker__modifier_frozen") then
      self:PerformFrostBreak(target)
		end
	end

  function icebreaker_5__blink:PerformFrostBreak(target)
    local caster = self:GetCaster()

    self:PlayEfxBreak(target)
    self:SetCurrentAbilityCharges(self:GetCurrentAbilityCharges() + 1)

    target:RemoveModifierByName("icebreaker__modifier_frozen")

    ApplyDamage({
      victim = target, attacker = caster, ability = self,
      damage = self:GetSpecialValueFor("damage"),
      damage_type = self:GetAbilityDamageType()
    })
  end

-- EFFECTS

  function icebreaker_5__blink:PlayEfxBlink(direction, origin, target)
    local caster = self:GetCaster()
    local particle_cast_a = "particles/econ/events/winter_major_2017/blink_dagger_start_wm07.vpcf" 
    local particle_cast_b = "particles/econ/events/winter_major_2017/blink_dagger_end_wm07.vpcf"

    local effect_cast_a = ParticleManager:CreateParticle(particle_cast_a, PATTACH_ABSORIGIN, caster)
    ParticleManager:SetParticleControl(effect_cast_a, 0, origin)
    ParticleManager:SetParticleControlForward(effect_cast_a, 0, direction:Normalized())
    ParticleManager:SetParticleControl(effect_cast_a, 1, origin + direction)
    ParticleManager:ReleaseParticleIndex(effect_cast_a)

    local effect_cast_b = ParticleManager:CreateParticle(particle_cast_b, PATTACH_ABSORIGIN, caster)
    ParticleManager:SetParticleControl(effect_cast_b, 0, caster:GetOrigin())
    ParticleManager:SetParticleControlForward(effect_cast_b, 0, direction:Normalized())
    ParticleManager:ReleaseParticleIndex(effect_cast_b)

    if IsServer() then caster:EmitSound("Hero_Antimage.Blink_in.Persona") end
  end

  function icebreaker_5__blink:PlayEfxBreak(target)
		local caster = self:GetCaster()
		local particle_cast = "particles/units/heroes/hero_phantom_assassin_persona/pa_persona_crit_impact.vpcf"
		local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControlEnt(effect_cast, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(effect_cast, 1, target:GetAbsOrigin())
		ParticleManager:SetParticleControlTransformForward(effect_cast, 1, target:GetOrigin(), target:GetForwardVector() * (-1))
		ParticleManager:ReleaseParticleIndex(effect_cast)

		if IsServer() then target:EmitSound("Hero_Ancient_Apparition.IceBlastRelease.Cast") end
		if IsServer() then target:EmitSound("Hero_Icebreaker.Break") end
	end