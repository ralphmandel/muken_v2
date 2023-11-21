ancient_5__walk = class({})
LinkLuaModifier("ancient_5_modifier_walk", "heroes/sun/ancient/ancient_5_modifier_walk", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ancient_5_modifier_casting", "heroes/sun/ancient/ancient_5_modifier_casting", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ancient_5_modifier_efx_hands", "heroes/sun/ancient/ancient_5_modifier_efx_hands", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ancient_5_modifier_debuff", "heroes/sun/ancient/ancient_5_modifier_debuff", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function ancient_5__walk:GetCastPoint()
    local channel = self:GetCaster():FindAbilityByName("_channel")
    local channel_time = self:GetSpecialValueFor("cast_point")
    return channel_time * (1 - (channel:GetLevel() * channel:GetSpecialValueFor("channel") * 0.01))
  end

  function ancient_5__walk:GetAOERadius()
    return self:GetSpecialValueFor("radius")
  end

  function ancient_5__walk:OnOwnerSpawned()
    self:SetActivated(true)
  end

-- SPELL START

  function ancient_5__walk:OnAbilityPhaseStart()
    local caster = self:GetCaster()
    local time = self:GetChannelTime()

    if caster:HasModifier("ancient_2_modifier_pre") then
      return false
    end

    caster:RemoveModifierByName("ancient_5_modifier_walk")
    caster:RemoveModifierByName("ancient_5_modifier_casting")
    caster:RemoveModifierByName("ancient_2_modifier_leap")
    AddModifier(caster, self, "ancient_5_modifier_casting", {}, false)

    return true
  end

  function ancient_5__walk:OnAbilityPhaseInterrupted()
    local caster = self:GetCaster()
    caster:RemoveModifierByName("ancient_5_modifier_casting")
  end

  function ancient_5__walk:OnSpellStart()
    local caster = self:GetCaster()

    caster:RemoveModifierByName("ancient_5_modifier_casting")
    AddModifier(caster, self, "ancient_5_modifier_walk", {duration = self:GetSpecialValueFor("duration")}, true)
  end

-- EFFECTS