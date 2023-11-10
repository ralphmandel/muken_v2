lawbreaker_2__dual = class({})
LinkLuaModifier("lawbreaker_2_modifier_dual", "heroes/death/lawbreaker/lawbreaker_2_modifier_dual", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_stun", "_modifiers/_modifier_stun", LUA_MODIFIER_MOTION_NONE)

-- INIT

-- SPELL START

	function lawbreaker_2__dual:OnSpellStart()
		local caster = self:GetCaster()
	end

-- EFFECTS