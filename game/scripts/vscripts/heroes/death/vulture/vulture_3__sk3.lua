vulture_3__sk3 = class({})
LinkLuaModifier("vulture_3_modifier_sk3", "heroes/death/vulture/vulture_3_modifier_sk3", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_stun", "_modifiers/_modifier_stun", LUA_MODIFIER_MOTION_NONE)

-- INIT

-- SPELL START

	function vulture_3__sk3:OnSpellStart()
		local caster = self:GetCaster()
	end

-- EFFECTS