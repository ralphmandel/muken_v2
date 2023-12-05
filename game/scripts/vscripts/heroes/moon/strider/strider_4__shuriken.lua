strider_4__shuriken = class({})
LinkLuaModifier("strider_4_modifier_shuriken", "heroes/moon/strider/strider_4_modifier_shuriken", LUA_MODIFIER_MOTION_NONE)

-- INIT

-- SPELL START

	function strider_4__shuriken:OnAbilityPhaseStart()
		if not self:CheckVectorTargetPosition() then return false end
		if IsServer() then
			self:PlayEfx_2()
		end
		return true
	end

	function strider_4__shuriken:OnSpellStart()
		local caster = self:GetCaster()
		local vect_targets = self:GetVectorTargetPosition()
		local direction = vect_targets.direction
		local init_pos = vect_targets.init_pos
		local end_pos = vect_targets.end_pos

		if IsServer() then
			self:PlayEfxStart(caster)
		end
	end

-- EFFECTS

	function strider_4__shuriken:PlayEfxStart(caster)
		local string = "particles/strider/shuriken/strider_cast_ground.vpcf"
		local particle = ParticleManager:CreateParticle(string, PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(particle, 0, caster:GetOrigin())
		EmitSoundOn("Hero_Antimage.Blink_out", caster)
		ParticleManager:ReleaseParticleIndex( particle )
	end

	function strider_4__shuriken:PlayEfx_2()
		local string_2 = "particles/strider/shuriken/strider_cast_body_smoke.vpcf"
		local particle_2 = ParticleManager:CreateParticle(string_2, PATTACH_ABSORIGIN_FOLLOW, self.caster)
		ParticleManager:SetParticleControl(particle_2, 0, self.caster:GetOrigin())
		ParticleManager:ReleaseParticleIndex( particle_2 )
	end

