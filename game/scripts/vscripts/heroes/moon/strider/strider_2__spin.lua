strider_2__spin = class({})
LinkLuaModifier("strider_2_modifier_spin", "heroes/moon/strider/strider_2_modifier_spin", LUA_MODIFIER_MOTION_NONE)

-- INIT

-- SPELL START

	function strider_2__spin:OnSpellStart()
		local caster = self:GetCaster()
		local bDuration = self:GetSpecialValueFor("duration")

	-- Add modifier
	AddModifier(caster, self, "strider_2_modifier_spin", {duration = bDuration}, false)
	end

-- EFFECTS
