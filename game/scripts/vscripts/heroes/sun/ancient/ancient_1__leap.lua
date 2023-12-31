ancient_1__leap = class({})
LinkLuaModifier("ancient_1_modifier_charges", "heroes/sun/ancient/ancient_1_modifier_charges", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ancient_1_modifier_refresh", "heroes/sun/ancient/ancient_1_modifier_refresh", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ancient_1_modifier_leap", "heroes/sun/ancient/ancient_1_modifier_leap", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ancient_1_modifier_jump", "heroes/sun/ancient/ancient_1_modifier_jump", LUA_MODIFIER_MOTION_HORIZONTAL)

-- INIT

  function ancient_1__leap:Spawn()
    self.aggro_target = nil
  end

  function ancient_1__leap:GetIntrinsicModifierName()
    return "ancient_1_modifier_charges"
  end

  function ancient_1__leap:GetAOERadius()
    return self:GetSpecialValueFor("radius")
  end

  function ancient_1__leap:GetBehavior()
    if self:GetCastRange(nil, nil) > 0 then
      return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES
    end

    return DOTA_ABILITY_BEHAVIOR_NO_TARGET
  end

  function ancient_1__leap:GetCastRange(vLocation, hTarget)
    return self:GetSpecialValueFor("jump_distance")
  end

-- SPELL START

  function ancient_1__leap:OnAbilityPhaseStart()
    local caster = self:GetCaster()
    self.point = self:GetCursorPosition()
    self.distance = (caster:GetOrigin() - self.point):Length2D()
    self.duration = self.distance / (((self:GetCastRange(nil, nil) - 100) / (self:GetCurrentAbilityCharges() * 0.5)) * 2.2)
    self.height = self.distance * 0.5
    self.interruption = false

    if caster:HasModifier("ancient_1_modifier_leap") then return false end

    if self:GetCastRange(nil, nil) > 0 then
      caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_1, 1)
      if self.duration < 0.4 then
        Timers:CreateTimer((self.duration), function()
          if self.interruption == false then
            caster:FadeGesture(ACT_DOTA_CAST_ABILITY_1)
            caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_5, 1)
            if IsServer() then caster:EmitSound("Hero_ElderTitan.PreAttack") end
          end
        end)
      end
  
      if self.duration >= 0.5 then
        Timers:CreateTimer((0.2), function()
          if self.interruption == false then
            if IsServer() then caster:EmitSound("Ancient.Jump") end
          end
        end)
      end
    else
      if caster:HasModifier("ancient_2_modifier_pre") then
        return false
      end
      
      caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_5, 1)
      if IsServer() then caster:EmitSound("Hero_ElderTitan.PreAttack") end
    end

    return true
  end

  function ancient_1__leap:OnAbilityPhaseInterrupted()
    local caster = self:GetCaster()
    caster:FadeGesture(ACT_DOTA_CAST_ABILITY_1)
    caster:FadeGesture(ACT_DOTA_CAST_ABILITY_5)
    self.interruption = true
  end

  function ancient_1__leap:OnSpellStart()
    local caster = self:GetCaster()
    caster:Stop()

    caster:RemoveModifierByName("ancient_1_modifier_jump")
    caster:RemoveModifierByName("ancient_1_modifier_leap")

    self:SetCurrentAbilityCharges(self:GetCurrentAbilityCharges() + 1)

    if self:GetCastRange(nil, nil) > 0 then
      AddModifier(caster, self, "ancient_1_modifier_refresh", {
        duration = self:GetAbilityChargeRestoreTime(self:GetLevel()) * self:GetCurrentAbilityCharges(),
        stack = self:GetCurrentAbilityCharges()
      }, false)
      
      AddModifier(caster, self, "ancient_1_modifier_jump", {}, false)
    else
      AddModifier(caster, self, "ancient_1_modifier_leap", {}, false)
    end
  end

-- EFFECTS