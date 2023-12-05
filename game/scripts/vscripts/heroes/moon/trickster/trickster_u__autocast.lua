trickster_u__autocast = class({})
LinkLuaModifier("trickster_u_modifier_passive", "heroes/moon/trickster/trickster_u_modifier_passive", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("trickster_u_modifier_autocast", "heroes/moon/trickster/trickster_u_modifier_autocast", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("trickster_u_modifier_last", "heroes/moon/trickster/trickster_u_modifier_last", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("templar_special_values", "heroes/sun/templar/templar-special_values", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function trickster_u__autocast:GetIntrinsicModifierName()
    return "trickster_u_modifier_passive"
  end

  function trickster_u__autocast:CastFilterResultTarget(hTarget)
		local caster = self:GetCaster()

    if hTarget:HasModifier("trickster_u_modifier_last") == false then return UF_FAIL_CUSTOM end

		local result = UnitFilter(
			hTarget, self:GetAbilityTargetTeam(),
			self:GetAbilityTargetType(),
			self:GetAbilityTargetFlags(),
			caster:GetTeamNumber()
		)
		
		return result
	end

	function trickster_u__autocast:GetCustomCastErrorTarget(hTarget)
		if hTarget:HasModifier("trickster_u_modifier_last") == false then return "NO ABILITIES AVAILABLE FOR STEALING" end
	end

-- SPELL START

  function trickster_u__autocast:OnSpellStart()
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()

    if target:TriggerSpellAbsorb(self) then return end
		local modifier = target:FindModifierByName("trickster_u_modifier_last")

    if modifier == nil then
      self:EndCooldown()
      return
    end

    AddModifier(caster, self, "trickster_u_modifier_autocast", {
      duration = self:GetSpecialValueFor("duration"),
      ability_index = modifier.ability_index,
      target_index = target:entindex()
    }, true)
	end

-- EFFECTS