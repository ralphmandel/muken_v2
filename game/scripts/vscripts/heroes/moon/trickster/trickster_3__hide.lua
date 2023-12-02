trickster_3__hide = class({})
LinkLuaModifier("trickster_3_modifier_hide", "heroes/moon/trickster/trickster_3_modifier_hide", LUA_MODIFIER_MOTION_NONE)

-- INIT

-- SPELL START

	function trickster_3__hide:OnSpellStart()
		local caster = self:GetCaster()

    AddModifier(caster, self, "trickster_3_modifier_hide", {duration = self:GetSpecialValueFor("duration")}, true)
	end

-- EFFECTS