death_slash_2__sk2 = class({})
LinkLuaModifier("death_slash_2_modifier_sk2", "heroes/death/death_slash/death_slash_2_modifier_sk2", LUA_MODIFIER_MOTION_NONE)

-- INIT

-- SPELL START

	function death_slash_2__sk2:OnSpellStart()
		local caster = self:GetCaster()
	end

-- EFFECTS