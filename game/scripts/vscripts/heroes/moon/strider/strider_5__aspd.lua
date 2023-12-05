strider_5__aspd = class({})
LinkLuaModifier("strider_5_modifier_aspd", "heroes/moon/strider/strider_5_modifier_aspd", LUA_MODIFIER_MOTION_NONE)

-- INIT

-- SPELL START

	function strider_5__aspd:OnSpellStart()
		self.caster = self:GetCaster()
		local duration = self:GetSpecialValueFor("duration")
		local aspd_bonus = self:GetSpecialValueFor("aspd_bonus")
		local ms_bonus = self:GetSpecialValueFor("ms_bonus")

		if IsServer() then
			self:PlayEfxStart()
		end

		AddModifier(self.caster, self, "strider_5_modifier_aspd", {duration = duration, aspd_bonus = aspd_bonus, ms_bonus = ms_bonus}, true)
	end

-- EFFECTS

function strider_5__aspd:PlayEfxStart()
	-- RELEASE PARTICLE
	local string = "particles/strider/aspd_buff/strider_aspd_buff.vpcf"
	local particle = ParticleManager:CreateParticle(string, PATTACH_ABSORIGIN_FOLLOW, self.caster)
	ParticleManager:SetParticleControl(particle, 0, self.caster:GetOrigin())
	ParticleManager:ReleaseParticleIndex(particle)

	if IsServer() then self.caster:EmitSound("Strider.aspdbuff") end
end