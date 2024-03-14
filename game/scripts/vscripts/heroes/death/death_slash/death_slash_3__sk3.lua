death_slash_3__sk3 = class({})
LinkLuaModifier("death_slash_3_modifier_sk3", "heroes/death/death_slash/death_slash_3_modifier_sk3", LUA_MODIFIER_MOTION_NONE)

-- INIT

-- SPELL START

	function death_slash_3__sk3:OnSpellStart()
		local caster = self:GetCaster()
	end

-- EFFECTS