trickster_4__heart = class({})
LinkLuaModifier("trickster_4_modifier_heart", "heroes/moon/trickster/trickster_4_modifier_heart", LUA_MODIFIER_MOTION_NONE)

-- INIT

-- SPELL START

	function trickster_4__heart:OnSpellStart()
		local caster = self:GetCaster()
	end

-- EFFECTS