paladin_1__link = class({})
LinkLuaModifier("paladin_1_modifier_passive", "heroes/sun/paladin/paladin_1_modifier_passive", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("paladin_1_modifier_aura_effect", "heroes/sun/paladin/paladin_1_modifier_aura_effect", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("paladin_1_modifier_link", "heroes/sun/paladin/paladin_1_modifier_link", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function paladin_1__link:CastFilterResultTarget(hTarget)
    if not IsServer() then return end

    local caster = self:GetCaster()
    if caster == hTarget then return UF_FAIL_CUSTOM end

    local result = UnitFilter(
      hTarget, self:GetAbilityTargetTeam(),
      self:GetAbilityTargetType(),
      self:GetAbilityTargetFlags(),
      caster:GetTeamNumber()
    )
    
    if result ~= UF_SUCCESS then return result end

    return UF_SUCCESS
  end

  function paladin_1__link:GetCustomCastErrorTarget(hTarget)
    if self:GetCaster() == hTarget then return "#dota_hud_error_cant_cast_on_self" end
  end

  function paladin_1__link:GetIntrinsicModifierName()
    return "paladin_1_modifier_passive"
  end

-- SPELL START

	function paladin_1__link:OnSpellStart()
		local caster = self:GetCaster()
    local target = self:GetCursorTarget()

    target:RemoveModifierByName("paladin_1_modifier_link")
    target:AddModifier(self, "paladin_1_modifier_link", {
      duration = self:GetSpecialValueFor("duration"), bResist = 1
    })
  end

-- EFFECTS