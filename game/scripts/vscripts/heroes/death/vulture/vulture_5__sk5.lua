vulture_5__sk5 = class({})
LinkLuaModifier("vulture_5_modifier_sk5", "heroes/death/vulture/vulture_5_modifier_sk5", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_stun", "_modifiers/_modifier_stun", LUA_MODIFIER_MOTION_NONE)

-- INIT

-- SPELL START

	function vulture_5__sk5:OnSpellStart()
		local caster = self:GetCaster()
	end

-- EFFECTS