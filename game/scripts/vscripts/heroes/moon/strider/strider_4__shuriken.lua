strider_4__shuriken = class({})
LinkLuaModifier("strider_4_modifier_shuriken", "heroes/moon/strider/strider_4_modifier_shuriken", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("strider_4_modifier_turn", "heroes/moon/strider/strider_4_modifier_turn", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("strider_4_modifier_shuriken_slow", "heroes/moon/strider/strider_4_modifier_shuriken_slow", LUA_MODIFIER_MOTION_NONE)

-- INIT
	function strider_4__shuriken:GetIntrinsicModifierName()
		return "strider_4_modifier_turn"
	end

	function strider_4__shuriken:Spawn()
		self.disable = 0
	end

-- SPELL START

	function strider_4__shuriken:OnAbilityPhaseStart()
		if not self:CheckVectorTargetPosition() then return false end
		if IsServer() then
			self:PlayEfxStart()
		end
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
			self.disable = 0
			
		end)
		AddModifier(caster, self, "strider_4_modifier_shuriken_slow", {
			duration = 0.5,
			init_x = init_pos.x,
			init_y = init_pos.y,
			init_z = init_pos.z,
			end_x = end_pos.x,
			end_y = end_pos.y,
			end_z = end_pos.z,
			
		}, false)

		ProjectileManager:ProjectileDodge(caster)

		if IsServer() then
			self:PlayEfx_2(origin, direction)
		end
		
	end

	function strider_4__shuriken:OnProjectileHit(hTarget, vLocation)
		print("TESTE PROJETIL")
		local caster = self:GetCaster()
		AddModifier(hTarget, self,"sub_stat_movespeed_decrease",{value = self:GetSpecialValueFor("slow_amount"), duration = self:GetSpecialValueFor("slow_duration")}, true)

		if IsServer() then
			self:PlayEfxTarget(hTarget)
		end

		local damageTable = {
			victim = hTarget,
			attacker = caster,
			damage = self:GetSpecialValueFor("damage"),
			damage_type = self:GetAbilityDamageType(),
			ability = self, --Optional.
		}

		ApplyDamage(damageTable)
	end

-- EFFECTS

	function strider_4__shuriken:PlayEfxStart()
		local caster = self:GetCaster()
		local string = "particles/strider/shuriken/strider_cast_ground.vpcf"
		local particle = ParticleManager:CreateParticle(string, PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(particle, 0, caster:GetOrigin())
		ParticleManager:ReleaseParticleIndex( particle )
	end

	function strider_4__shuriken:PlayEfx_2(origin, direction)
	
		local caster = self:GetCaster()
		local string_2 = "particles/strider/shuriken/strider_cast_body.vpcf"
		local particle_2 = ParticleManager:CreateParticle(string_2, PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(particle_2, 0, origin)
		ParticleManager:ReleaseParticleIndex( particle_2 )

		local string_3 = "particles/econ/events/ti9/blink_dagger_ti9_end.vpcf"
		local particle_3 = ParticleManager:CreateParticle(string_3, PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(particle_3, 0, caster:GetOrigin())
		ParticleManager:ReleaseParticleIndex( particle_3 )

		local particle_cast_a = "particles/strider/shuriken/strider_blink_start.vpcf"
		local effect_cast_a = ParticleManager:CreateParticle( particle_cast_a, PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl( effect_cast_a, 0, origin )
		-- ParticleManager:SetParticleControlForward( effect_cast_a, 0, direction:Normalized() )
		ParticleManager:ReleaseParticleIndex( effect_cast_a )

		caster:EmitSound("Hero_Antimage.Blink_out")
	end

	function strider_4__shuriken:PlayEfxTarget(enemy)
		local particle_cast = "particles/units/heroes/hero_juggernaut/juggernaut_blade_fury_tgt.vpcf"
		local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, enemy )
		ParticleManager:ReleaseParticleIndex( effect_cast )

		local sound_cast_dag = "Hero_Mirana.ProjectileImpact"
		EmitSoundOn( sound_cast_dag, enemy )
	end