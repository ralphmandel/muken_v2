paladin_4__magnus = class({})
LinkLuaModifier("paladin_4_modifier_magnus", "heroes/sun/paladin/paladin_4_modifier_magnus", LUA_MODIFIER_MOTION_NONE)

-- INIT

-- SPELL START

	function paladin_4__magnus:OnSpellStart()
		local caster = self:GetCaster()
	end

-- EFFECTS