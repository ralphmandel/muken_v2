paladin_5__smite = class({})
LinkLuaModifier("paladin_5_modifier_smite", "heroes/sun/paladin/paladin_5_modifier_smite", LUA_MODIFIER_MOTION_NONE)

-- INIT

-- SPELL START

	function paladin_5__smite:OnSpellStart()
		local caster = self:GetCaster()
	end

-- EFFECTS