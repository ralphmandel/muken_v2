vulture_u__sk6 = class({})
LinkLuaModifier("vulture_u_modifier_sk6", "heroes/death/vulture/vulture_u_modifier_sk6", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_stun", "_modifiers/_modifier_stun", LUA_MODIFIER_MOTION_NONE)

-- INIT

-- SPELL START

	function vulture_u__sk6:OnSpellStart()
		local caster = self:GetCaster()
	end

-- EFFECTS