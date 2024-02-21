strider_1__silence = class({})
LinkLuaModifier("strider_1_modifier_silence", "heroes/moon/strider/strider_1_modifier_silence", LUA_MODIFIER_MOTION_NONE)

-- INIT

-- SPELL START

	function strider_1__silence:OnAbilityPhaseStart()
		local caster = self:GetCaster()
		caster:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK_EVENT, 1)
    
		return true
	end

	function strider_1__silence:OnAbilityPhaseInterrupted()
		local caster = self:GetCaster()
		caster:FadeGesture(ACT_DOTA_IDLE_RARE)
	end

	function strider_1__silence:OnSpellStart()
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()

		Timers:CreateTimer(0.7, function()
      if caster then
        if IsValidEntity(caster) then
          caster:FadeGesture(ACT_DOTA_OVERRIDE_ABILITY_4)
        end
      end
		end)

    self:PlayEfxStart()
		
		ProjectileManager:CreateTrackingProjectile({
			Target = target,
      Source = caster,
      Ability = self,
      EffectName = "particles/shadowmancer/dagger/shadowmancer_stifling_dagger_arcana_combined.vpcf",
      iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2,
      iMoveSpeed = self:GetSpecialValueFor("proj_speed"),
      bDodgeable = false,
      bProvidesVision = true,
      iVisionRadius = 150,
      iVisionTeamNumber = caster:GetTeamNumber(),
      ExtraData = {
        health_cost = self:GetHealthCost(self:GetLevel())
      }
		})
	end

	function strider_1__silence:OnProjectileHit_ExtraData(hTarget, vLocation, table)
    if (not hTarget) or hTarget:IsInvulnerable() or hTarget:TriggerSpellAbsorb(self) then return end
    
    hTarget:RemoveModifierByName("strider_1_modifier_silence")

    hTarget:AddModifier(self, "strider_1_modifier_silence", {
      duration = self:GetSpecialValueFor("duration"),
      health_cost = table.health_cost,  
      bResist = 1
    })
	end

-- EFFECTS

function strider_1__silence:PlayEfxStart()
	local caster = self:GetCaster()
	local particle_cast = "particles/econ/items/lifestealer/ls_ti10_immortal/ls_ti10_immortal_infest_blood_splurt_up.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControl(effect_cast, 0, caster:GetOrigin())
	ParticleManager:ReleaseParticleIndex(effect_cast)

	caster:EmitSound("Hero_BountyHunter.Shuriken")
end