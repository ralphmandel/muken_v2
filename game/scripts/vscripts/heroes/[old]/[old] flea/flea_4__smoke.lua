flea_4__smoke = class({})
LinkLuaModifier("flea_4_modifier_smoke", "heroes/death/flea/flea_4_modifier_smoke", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("flea_4_modifier_smoke_effect", "heroes/death/flea/flea_4_modifier_smoke_effect", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("flea_4_modifier_shadow", "heroes/death/flea/flea_4_modifier_shadow", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("flea_4_modifier_invisible", "heroes/death/flea/flea_4_modifier_invisible", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_blind", "_modifiers/_modifier_blind", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_blind_stack", "_modifiers/_modifier_blind_stack", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_movespeed_debuff", "_modifiers/_modifier_movespeed_debuff", LUA_MODIFIER_MOTION_NONE)

-- INIT

-- SPELL START

	function flea_4__smoke:GetIntrinsicModifierName()
		return "flea_4_modifier_passive"
	end

	function flea_4__smoke:OnSpellStart()
		local caster = self:GetCaster()
		local duration = self:GetSpecialValueFor("duration")
		local point = self:GetCursorPosition()

		local smoke = CreateModifierThinker(
			caster, self, "flea_4_modifier_smoke", {duration = duration},
			point, caster:GetTeamNumber(), false
		)
	end

	function flea_4__smoke:GetAOERadius()
		return self:GetSpecialValueFor("radius")
	end

-- EFFECTS