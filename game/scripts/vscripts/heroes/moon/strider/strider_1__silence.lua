strider_1__silence = class({})
LinkLuaModifier("strider_1_modifier_silence", "heroes/moon/strider/strider_1_modifier_silence", LUA_MODIFIER_MOTION_NONE)

-- INIT

-- SPELL START

	-- function strider_1__silence:OnAbilityPhaseStart()
	-- 	local caster = self:GetCaster()
	-- 	caster:StartGestureWithPlaybackRate(ACT_DOTA_IDLE_RARE, 2)
	-- end

	function strider_1__silence:OnSpellStart()
		local caster = self:GetCaster()
		local self_damage = self:GetSpecialValueFor("self_damage")
		local target = self:GetCursorTarget()
		
		-- local damageTable = {
		-- 	victim = caster,
		-- 	attacker = caster,
		-- 	damage = self_damage,
		-- 	damage_type = DAMAGE_TYPE_PURE,
		-- 	ability = self, --Optional.
		-- }
		-- ApplyDamage(damageTable)
		
		local projectile = {
			Target = target, Source = caster, Ability = self,
      EffectName = "particles/econ/items/phantom_assassin/pa_ti8_immortal_head/pa_ti8_immortal_stifling_dagger.vpcf",
      iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2,
      iMoveSpeed = self:GetSpecialValueFor("proj_speed"),
      bDodgeable = false, bProvidesVision = true, iVisionRadius = 150, iVisionTeamNumber = caster:GetTeamNumber()
		}
		self.proj_dagger = ProjectileManager:CreateTrackingProjectile(projectile)
		-- Play effects

		if IsServer() then 
			self:PlayEffects()
		end
	end

	function strider_1__silence:OnProjectileHitHandle(target, location, handle)
		print("BURICH", self.proj_dagger)
		--ProjectileManager:DestroyTrackingProjectile(self.proj_dagger)

    if (not target) or target:IsInvulnerable() or target:TriggerSpellAbsorb(self) then
      self.proj_id = handle
      return
    end

		AddModifier(target, self, "strider_1_modifier_silence", {duration = self:GetSpecialValueFor("duration")}, true)
		if IsServer() then
			local sound_target = "Hero_PhantomAssassin.Dagger.Target"
			EmitSoundOn( sound_target, target )
		end

	end

-- EFFECTS

function strider_1__silence:PlayEffects()
	local caster = self:GetCaster()
	-- Get Resources
	local particle_cast = "particles/econ/items/lifestealer/ls_ti10_immortal/ls_ti10_immortal_infest_blood_splurt_up.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControl(effect_cast, 0, caster:GetOrigin())
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	local sound_cast_dag = "Hero_BountyHunter.Shuriken"
	EmitSoundOn( sound_cast_dag, caster )
end