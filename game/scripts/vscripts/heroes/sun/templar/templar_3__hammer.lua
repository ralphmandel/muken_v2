templar_3__hammer = class({})
LinkLuaModifier("templar_3_modifier_hammer", "heroes/sun/templar/templar_3_modifier_hammer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_stun", "_modifiers/_modifier_stun", LUA_MODIFIER_MOTION_NONE)

-- INIT

-- SPELL START

	function templar_3__hammer:OnSpellStart()
		local caster = self:GetCaster()
	end

-- EFFECTS