trickster_5__teleport = class({})
LinkLuaModifier("trickster_5_modifier_teleport", "heroes/moon/trickster/trickster_5_modifier_teleport", LUA_MODIFIER_MOTION_NONE)

-- INIT

-- SPELL START

	function trickster_5__teleport:OnSpellStart()
		local caster = self:GetCaster()
	end

-- EFFECTS