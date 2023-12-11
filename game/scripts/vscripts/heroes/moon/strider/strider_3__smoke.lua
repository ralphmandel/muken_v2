strider_3__smoke = class({})
LinkLuaModifier("strider_3_modifier_smoke", "heroes/moon/strider/strider_3_modifier_smoke", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("strider_3_modifier_aura_effect", "heroes/moon/strider/strider_3_modifier_aura_effect", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function strider_3__smoke:GetAOERadius()
    return self:GetSpecialValueFor("radius")
  end

  function strider_3__smoke:OnAbilityPhaseStart()
    local caster = self:GetCaster()
    if IsServer() then caster:EmitSound("Hero_MonkeyKing.Strike.Cast") end

    return true
  end

-- SPELL START

	function strider_3__smoke:OnSpellStart()
		local caster = self:GetCaster()

		CreateModifierThinker(caster, self, "strider_3_modifier_smoke", {
      duration = self:GetSpecialValueFor("duration")
    }, self:GetCursorPosition(), caster:GetTeamNumber(), false)

    if IsServer() then caster:EmitSound("Strider.smoke") end
	end

-- EFFECTS



