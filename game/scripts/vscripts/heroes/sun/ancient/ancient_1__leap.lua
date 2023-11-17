ancient_1__leap = class({})
LinkLuaModifier("ancient_1_modifier_leap", "heroes/sun/ancient/ancient_1_modifier_leap", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_stun", "_modifiers/_modifier_stun", LUA_MODIFIER_MOTION_NONE)

-- INIT

-- SPELL START

	function ancient_1__leap:OnSpellStart()
		local caster = self:GetCaster()
	end

-- EFFECTS