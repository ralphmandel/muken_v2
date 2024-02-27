genuine_3__travel = class({})
LinkLuaModifier("genuine_3_modifier_travel", "heroes/moon/genuine/genuine_3_modifier_travel", LUA_MODIFIER_MOTION_NONE)

-- INIT

-- SPELL START

	function genuine_3__travel:OnSpellStart()
		local caster = self:GetCaster()
	end

-- EFFECTS