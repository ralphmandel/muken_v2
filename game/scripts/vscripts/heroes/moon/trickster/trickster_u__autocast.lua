trickster_u__autocast = class({})
LinkLuaModifier("trickster_u_modifier_autocast", "heroes/moon/trickster/trickster_u_modifier_autocast", LUA_MODIFIER_MOTION_NONE)

-- INIT

-- SPELL START

	function trickster_u__autocast:OnSpellStart()
		local caster = self:GetCaster()
	end

-- EFFECTS