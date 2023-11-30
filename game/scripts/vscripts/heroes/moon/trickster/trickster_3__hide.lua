trickster_3__hide = class({})
LinkLuaModifier("trickster_3_modifier_hide", "heroes/moon/trickster/trickster_3_modifier_hide", LUA_MODIFIER_MOTION_NONE)

-- INIT

-- SPELL START

	function trickster_3__hide:OnSpellStart()
		local caster = self:GetCaster()
	end

-- EFFECTS