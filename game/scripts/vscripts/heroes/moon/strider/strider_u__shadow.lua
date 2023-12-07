strider_u__shadow = class({})
LinkLuaModifier("strider_u_modifier_shadow", "heroes/moon/strider/strider_u_modifier_shadow", LUA_MODIFIER_MOTION_NONE)

-- INIT

-- SPELL START

	function strider_u__shadow:OnAbilityPhaseStart()
		if IsServer() then
			self:PlayEfxStart()
		end
		return true
	end

	function strider_u__shadow:OnSpellStart()
		local caster = self:GetCaster()
		local origin = caster:GetOrigin()
    local point = self:GetCursorPosition()


		self.unit = CreateUnitByName("strider_shadow", point, true, caster, caster, caster:GetTeamNumber())
    FindClearSpaceForUnit(self.unit, point, true)

		AddModifier(self.unit, self, "strider_u_modifier_shadow", {duration = self:GetSpecialValueFor("duration")}, false)

	end

-- EFFECTS

function strider_u__shadow:PlayEfxStart()
	local caster = self:GetCaster()
	local string = "particles/strider/ult/strider_shadow_cast_hands.vpcf"
	local particle = ParticleManager:CreateParticle(string, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(particle, 0, caster:GetOrigin())
	ParticleManager:ReleaseParticleIndex( particle )
end

--particles/strider/ult/strider_shadow_ground.vpcf
--particles/strider/ult/strider_shadow_blur.vpcf
--particles/strider/ult/strider_shadow_status_effect.vpcf
