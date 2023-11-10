lawbreaker_4__rain = class({})
LinkLuaModifier("lawbreaker_4_modifier_rain", "heroes/death/lawbreaker/lawbreaker_4_modifier_rain", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_stun", "_modifiers/_modifier_stun", LUA_MODIFIER_MOTION_NONE)

-- INIT

-- SPELL START

	function lawbreaker_4__rain:OnSpellStart()
		local caster = self:GetCaster()
	end

-- EFFECTS