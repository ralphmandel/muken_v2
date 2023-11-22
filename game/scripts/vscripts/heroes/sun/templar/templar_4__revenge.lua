templar_4__revenge = class({})
LinkLuaModifier("templar_4_modifier_revenge", "heroes/sun/templar/templar_4_modifier_revenge", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_stun", "_modifiers/_modifier_stun", LUA_MODIFIER_MOTION_NONE)

-- INIT

-- SPELL START

	function templar_4__revenge:OnSpellStart()
		local caster = self:GetCaster()
	end

-- EFFECTS