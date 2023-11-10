vulture_1__sk1 = class({})
LinkLuaModifier("vulture_1_modifier_sk1", "heroes/death/vulture/vulture_1_modifier_sk1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_stun", "_modifiers/_modifier_stun", LUA_MODIFIER_MOTION_NONE)

-- INIT

-- SPELL START

	function vulture_1__sk1:OnSpellStart()
		local caster = self:GetCaster()
	end

-- EFFECTS