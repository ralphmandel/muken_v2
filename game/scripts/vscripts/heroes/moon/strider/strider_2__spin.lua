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

  function strider_2__spin:GetBehavior()
    if self:GetCooldown(self:GetLevel()) == 0 then
      return DOTA_ABILITY_BEHAVIOR_PASSIVE
    end
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET
  end

-- SPELL START

	function strider_2__spin:OnSpellStart()
		local caster = self:GetCaster()

    local spin = caster:FindModifierByName("strider_2_modifier_spin")
    if spin then self.aggro = spin.aggro end
    if self.aggro then self.aggro = self.aggro:entindex() end

    caster:RemoveModifierByName("strider_2_modifier_spin")
    caster:AddModifier(self, "strider_2_modifier_spin", {
      duration = self:GetSpecialValueFor("spin_duration"),
      aggro = self.aggro
    })
	end

-- EFFECTS
