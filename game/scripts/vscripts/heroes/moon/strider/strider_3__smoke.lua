strider_3__smoke = class({})
LinkLuaModifier("strider_3_modifier_smoke", "heroes/moon/strider/strider_3_modifier_smoke", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("strider_3_modifier_aura_effect", "heroes/moon/strider/strider_3_modifier_aura_effect", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function strider_3__smoke:GetAOERadius()
    return self:GetSpecialValueFor("radius")
  end

  function strider_3__smoke:OnAbilityPhaseStart()
    local caster = self:GetCaster()
    caster:EmitSound("Hero_MonkeyKing.Strike.Cast")

    return true
  end

  function strider_3__smoke:OnOwnerDied()
    if self:GetSpecialValueFor("special_cast_on_death") == 1 then
      local caster = self:GetCaster()
      caster:SetCursorPosition(caster:GetOrigin())
      self:OnSpellStart()
    end
  end

-- SPELL START

	function strider_3__smoke:OnSpellStart()
		local caster = self:GetCaster()
    caster:EmitSound("Strider.smoke")

		CreateModifierThinker(caster, self, "strider_3_modifier_smoke", {
      duration = self:GetSpecialValueFor("duration")
    }, caster:GetCursorPosition(), caster:GetTeamNumber(), false)
	end

-- EFFECTS



