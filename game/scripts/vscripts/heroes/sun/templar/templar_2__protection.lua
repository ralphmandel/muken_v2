templar_2__protection = class({})
LinkLuaModifier("templar_2_modifier_protection", "heroes/sun/templar/templar_2_modifier_protection", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function templar_2__protection:CastFilterResultTarget(hTarget)
    local caster = self:GetCaster()
    if caster == hTarget then return UF_FAIL_CUSTOM end

    local result = UnitFilter(
      hTarget, self:GetAbilityTargetTeam(),
      self:GetAbilityTargetType(),
      self:GetAbilityTargetFlags(),
      caster:GetTeamNumber()
    )
    
    return result
  end

  function templar_2__protection:GetCustomCastErrorTarget(hTarget)
    if self:GetCaster() == hTarget then return "#dota_hud_error_cant_cast_on_self" end
  end

-- SPELL START

  function templar_2__protection:OnSpellStart()
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()

    target:RemoveModifierByNameAndCaster("templar_2_modifier_protection", caster)
    AddModifier(target, self, "templar_2_modifier_protection", {duration = self:GetSpecialValueFor("duration")}, true)
  end

-- EFFECTS