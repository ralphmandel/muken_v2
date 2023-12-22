strider_2__spin = class({})
LinkLuaModifier("strider_2_modifier_passive", "heroes/moon/strider/strider_2_modifier_passive", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("strider_2_modifier_spin", "heroes/moon/strider/strider_2_modifier_spin", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function strider_2__spin:GetAOERadius()
    return self:GetSpecialValueFor("radius")	
  end

  function strider_2__spin:GetIntrinsicModifierName()
    return "strider_2_modifier_passive"
  end

-- SPELL START

	function strider_2__spin:OnSpellStart()
		local caster = self:GetCaster()
    local aggro = caster:GetAttackTarget()

    local spin = caster:FindModifierByName("strider_2_modifier_spin")
    if spin then aggro = spin.aggro end
    if aggro then aggro = aggro:entindex() end

    caster:RemoveModifierByName("strider_2_modifier_spin")

    AddModifier(caster, self, "strider_2_modifier_spin", {
      duration = self:GetSpecialValueFor("spin_duration"),
      aggro = aggro
    }, false)	
	end

-- EFFECTS
