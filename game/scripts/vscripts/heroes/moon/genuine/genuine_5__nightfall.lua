genuine_5__nightfall = class({})
LinkLuaModifier("genuine_5_modifier_nightfall", "heroes/moon/genuine/genuine_5_modifier_nightfall", LUA_MODIFIER_MOTION_NONE)

-- INIT

-- SPELL START

	function genuine_5__nightfall:OnSpellStart()
		local caster = self:GetCaster()
	end

-- EFFECTS