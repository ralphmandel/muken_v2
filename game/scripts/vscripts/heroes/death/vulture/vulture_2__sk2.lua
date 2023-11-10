vulture_2__sk2 = class({})
LinkLuaModifier("vulture_2_modifier_sk2", "heroes/death/vulture/vulture_2_modifier_sk2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_stun", "_modifiers/_modifier_stun", LUA_MODIFIER_MOTION_NONE)

-- INIT

-- SPELL START

	function vulture_2__sk2:OnSpellStart()
		local caster = self:GetCaster()
	end

-- EFFECTS