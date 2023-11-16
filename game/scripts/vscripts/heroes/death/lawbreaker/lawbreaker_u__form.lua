lawbreaker_u__form = class({})
LinkLuaModifier("lawbreaker_u_modifier_form", "heroes/death/lawbreaker/lawbreaker_u_modifier_form", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_break", "_modifiers/_modifier_break", LUA_MODIFIER_MOTION_NONE)

-- INIT

-- SPELL START

	function lawbreaker_u__form:OnSpellStart()
		local caster = self:GetCaster()

    RemoveAllModifiersByNameAndAbility(caster, "lawbreaker_u_modifier_form", self)
    AddModifier(caster, self, "lawbreaker_u_modifier_form", {duration = self:GetSpecialValueFor("duration")}, true)
	end

  function lawbreaker_u__form:OnProjectileHit(hTarget, vLocation)
    if hTarget == nil then return end
    local caster = self:GetCaster()
    caster:PerformAttack(hTarget, false, true, true, true, false, false, false)
  end

-- EFFECTS