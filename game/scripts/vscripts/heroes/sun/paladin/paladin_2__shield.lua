paladin_2__shield = class({})
LinkLuaModifier("paladin_2_modifier_shield", "heroes/sun/paladin/paladin_2_modifier_shield", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("paladin_2_modifier_aura_effect", "heroes/sun/paladin/paladin_2_modifier_aura_effect", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("paladin_2_modifier_burn_efx", "heroes/sun/paladin/paladin_2_modifier_burn_efx", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function paladin_2__shield:GetBehavior()
    if self:GetSpecialValueFor("special_cast_range") == 0 then
      return DOTA_ABILITY_BEHAVIOR_NO_TARGET
    end

    if self:GetAOERadius() == 0 then
      return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
    end

    return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AOE
  end

  function paladin_2__shield:GetAOERadius()
    return self:GetSpecialValueFor("special_burn_radius")
  end

-- SPELL START

  function paladin_2__shield:OnAbilityPhaseStart()
    local caster = self:GetCaster()

    if IsServer() then caster:EmitSound("Hero_Dawnbreaker.PreAttack") end

    return true
  end

  function paladin_2__shield:OnAbilityPhaseInterrupted()
    local caster = self:GetCaster()

    if IsServer() then caster:StopSound("Hero_Dawnbreaker.PreAttack") end
  end

	function paladin_2__shield:OnSpellStart()
		local caster = self:GetCaster()
    local target = self:GetCursorTarget() or caster

    AddModifier(target, self, "paladin_2_modifier_shield", {duration = self:GetSpecialValueFor("duration")}, true)
	end

-- EFFECTS