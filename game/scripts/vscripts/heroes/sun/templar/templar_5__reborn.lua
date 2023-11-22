templar_5__reborn = class({})
LinkLuaModifier("templar_5_modifier_reborn", "heroes/sun/templar/templar_5_modifier_reborn", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_stun", "_modifiers/_modifier_stun", LUA_MODIFIER_MOTION_NONE)

-- INIT

-- SPELL START

	function templar_5__reborn:OnSpellStart()
		local caster = self:GetCaster()
	end

-- EFFECTS