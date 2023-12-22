strider_4__shuriken = class({})
LinkLuaModifier("strider_4_modifier_shuriken", "heroes/moon/strider/strider_4_modifier_shuriken", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("strider_4_modifier_turn", "heroes/moon/strider/strider_4_modifier_turn", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function strider_4__shuriken:Spawn()
    self.disable = 0
  end

	function strider_4__shuriken:GetIntrinsicModifierName()
		return "strider_4_modifier_turn"
	end

-- SPELL START

	function strider_4__shuriken:OnAbilityPhaseStart()
		if not self:CheckVectorTargetPosition() then return false end
		self:PlayEfxPhase()

		return true
	end

	function strider_4__shuriken:OnAbilityPhaseInterrupted()
		self.disable = 0
	end

	function strider_4__shuriken:OnSpellStart()
		local caster = self:GetCaster()
		local vect_targets = self:GetVectorTargetPosition()
		local direction = vect_targets.direction
		local init_pos = vect_targets.init_pos
		local end_pos = vect_targets.end_pos
		local origin = caster:GetOrigin()

		FindClearSpaceForUnit(caster, init_pos, true)
		caster:SetForwardVector(direction)

		Timers:CreateTimer(0.2, function()
			caster:MoveToPosition(caster:GetOrigin())
		end)

    ProjectileManager:ProjectileDodge(caster)

		AddModifier(caster, self, "strider_4_modifier_shuriken", {
			init_x = init_pos.x, init_y = init_pos.y, init_z = init_pos.z,
			end_x = end_pos.x, end_y = end_pos.y, end_z = end_pos.z
		}, false)

		if IsServer() then self:PlayEfxStart(origin, direction) end
	end

	function strider_4__shuriken:OnProjectileHit(hTarget, vLocation)
		local caster = self:GetCaster()

		if IsServer() then self:PlayEfxTarget(hTarget) end

    if hTarget:IsMagicImmune() == false then
      AddModifier(hTarget, self,"sub_stat_movespeed_decrease", {
        value = self:GetSpecialValueFor("slow_amount"), duration = self:GetSpecialValueFor("slow_duration")
      }, true)
    end

		ApplyDamage({
			victim = hTarget, attacker = caster, ability = self,
			damage = self:GetSpecialValueFor("damage"),
			damage_type = self:GetAbilityDamageType()
		})

    return true
	end

-- EFFECTS

	function strider_4__shuriken:PlayEfxPhase()
		local caster = self:GetCaster()
		local string = "particles/strider/shuriken/strider_cast_ground.vpcf"
		local particle = ParticleManager:CreateParticle(string, PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(particle, 0, caster:GetOrigin())
		ParticleManager:ReleaseParticleIndex(particle)
	end

	function strider_4__shuriken:PlayEfxStart(origin, direction)
		local caster = self:GetCaster()
		local string_2 = "particles/strider/shuriken/strider_cast_body.vpcf"
		local particle_2 = ParticleManager:CreateParticle(string_2, PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(particle_2, 0, origin)
		ParticleManager:ReleaseParticleIndex(particle_2)

		local string_3 = "particles/econ/events/ti9/blink_dagger_ti9_end.vpcf"
		local particle_3 = ParticleManager:CreateParticle(string_3, PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(particle_3, 0, caster:GetOrigin())
		ParticleManager:ReleaseParticleIndex(particle_3)

		local particle_cast_a = "particles/strider/shuriken/strider_blink_start.vpcf"
		local effect_cast_a = ParticleManager:CreateParticle(particle_cast_a, PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(effect_cast_a, 0, origin)
		-- ParticleManager:SetParticleControlForward( effect_cast_a, 0, direction:Normalized() )
		ParticleManager:ReleaseParticleIndex(effect_cast_a)

		if IsServer() then caster:EmitSound("Hero_Antimage.Blink_out") end
	end

	function strider_4__shuriken:PlayEfxTarget(enemy)
		local particle_cast = "particles/units/heroes/hero_juggernaut/juggernaut_blade_fury_tgt.vpcf"
		local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, enemy)
		ParticleManager:ReleaseParticleIndex(effect_cast)

    if IsServer() then enemy:EmitSound("Hero_Mirana.ProjectileImpact") end
	end