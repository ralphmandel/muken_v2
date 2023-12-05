strider_2__spin = class({})
LinkLuaModifier("strider_2_modifier_spin", "heroes/moon/strider/strider_2_modifier_spin", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("strider_2_modifier_bleeding", "heroes/moon/strider/strider_2_modifier_bleeding", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("strider_2_modifier_spin_efx", "heroes/moon/strider/strider_2_modifier_spin_efx", LUA_MODIFIER_MOTION_NONE)


-- INIT

-- SPELL START

	function strider_2__spin:OnSpellStart()
		local caster = self:GetCaster()
		local duration = self:GetSpecialValueFor("duration")

	-- Add modifier
	AddModifier(caster, self, "strider_2_modifier_spin", {duration = duration}, false)

	
	end

-- EFFECTS
