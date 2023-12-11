strider_2__spin = class({})
LinkLuaModifier("strider_2_modifier_spin", "heroes/moon/strider/strider_2_modifier_spin", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function strider_2__spin:GetAOERadius()
    return self:GetSpecialValueFor("radius")	
  end

-- SPELL START

	function strider_2__spin:OnSpellStart()
		local caster = self:GetCaster()

    caster:RemoveModifierByName("strider_2_modifier_spin")
    AddModifier(caster, self, "strider_2_modifier_spin", {duration = self:GetSpecialValueFor("spin_duration")}, false)	
	end

-- EFFECTS
