strider_5__aspd = class({})
LinkLuaModifier("strider_5_modifier_aspd", "heroes/moon/strider/strider_5_modifier_aspd", LUA_MODIFIER_MOTION_NONE)

-- INIT

-- SPELL START

	function strider_5__aspd:OnSpellStart()
		local caster = self:GetCaster()

		AddModifier(caster, self, "strider_5_modifier_aspd", {duration = self:GetSpecialValueFor("duration")}, true)
	end

-- EFFECTS