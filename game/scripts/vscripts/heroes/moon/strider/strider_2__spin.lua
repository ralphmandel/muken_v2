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

  function strider_2__spin:OnAbilityPhaseInterrupted()
    local caster = self:GetCaster()

    local ult = caster:FindAbilityByName("strider_u__shadow")
    if ult:IsTrained() then
      for index, time in pairs(ult.shadows) do
        local shadow = EntIndexToHScript(index)
        shadow:Interrupt()
      end
    end
  end

	function strider_2__spin:OnSpellStart()
		local caster = self:GetCaster()

    local spin = caster:FindModifierByName("strider_2_modifier_spin")

    if spin then
      if spin.aggro then
        if IsValidEntity(spin.aggro) then
          self.aggro = spin.aggro
        end
      end
    end

    local aggro_index = nil

    if self.aggro then
      if IsValidEntity(self.aggro) then
        aggro_index = self.aggro:GetEntityIndex()
      end
    end

    caster:RemoveModifierByName("strider_2_modifier_spin")
    caster:AddModifier(self, "strider_2_modifier_spin", {
      duration = self:GetSpecialValueFor("spin_duration"),
      aggro = aggro_index
    })
	end

-- EFFECTS
