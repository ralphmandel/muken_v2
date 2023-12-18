paladin_1__link = class({})
LinkLuaModifier("paladin_1_modifier_link", "heroes/sun/paladin/paladin_1_modifier_link", LUA_MODIFIER_MOTION_NONE)

-- INIT

-- SPELL START

	function paladin_1__link:OnSpellStart()
		local caster = self:GetCaster()
	end

-- EFFECTS