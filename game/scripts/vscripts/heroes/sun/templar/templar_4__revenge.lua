templar_4__revenge = class({})
LinkLuaModifier("templar_4_modifier_revenge", "heroes/sun/templar/templar_4_modifier_revenge", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("templar_4_modifier_buff", "heroes/sun/templar/templar_4_modifier_buff", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("templar_4_modifier_curse", "heroes/sun/templar/templar_4_modifier_curse", LUA_MODIFIER_MOTION_NONE)

-- INIT

-- SPELL START

	function templar_4__revenge:OnSpellStart()
		local caster = self:GetCaster()
    local target = self:GetCursorTarget()

    AddModifier(target, self, "templar_4_modifier_buff", {duration = self:GetSpecialValueFor("duration")}, true)
	end

-- EFFECTS