death_slash_1__slash = class({})
LinkLuaModifier("death_slash_1_modifier_slash", "heroes/death/death_slash/death_slash_1_modifier_slash", LUA_MODIFIER_MOTION_NONE)

-- INIT

-- SPELL START

	function death_slash_1__slash:OnSpellStart()
		local caster = self:GetCaster()
	end

-- EFFECTS