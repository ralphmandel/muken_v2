genuine_u__morning = class({})
LinkLuaModifier("genuine_u_modifier_passive", "heroes/moon/genuine/genuine_u_modifier_passive", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("genuine_u_modifier_morning", "heroes/moon/genuine/genuine_u_modifier_morning", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function genuine_u__morning:Spawn()
    if not IsServer() then return end

    self.kills = 0
  end

  function genuine_u__morning:GetIntrinsicModifierName()
    return "genuine_u_modifier_passive"
  end

  function genuine_u__morning:GetBehavior()
    if self:GetSpecialValueFor("special_passive") == 1 then
      return DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE + DOTA_ABILITY_BEHAVIOR_PASSIVE
    end
    
    return DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE + DOTA_ABILITY_BEHAVIOR_NO_TARGET
  end

-- SPELL START

  function genuine_u__morning:OnAbilityPhaseStart()
    self:GetCaster():FindModifierByName(self:GetIntrinsicModifierName()):PlayEfxBuff()
    return true
  end

  function genuine_u__morning:OnAbilityPhaseInterrupted()
    self:GetCaster():FindModifierByName(self:GetIntrinsicModifierName()):StopEfxBuff()
  end

  function genuine_u__morning:OnSpellStart()
    local caster = self:GetCaster()
    local duration_night = self:GetSpecialValueFor("duration_night")
    local duration_day = self:GetSpecialValueFor("duration_day")
    local dota_time = GameRules:GetDOTATime(false, true)
    local cycle_time = dota_time % 300
    local duration = 0
    local extra_time = 0

    if cycle_time >= 0 and cycle_time <= 150 - duration_day then
      duration = duration_day
    end

    if cycle_time > 150 - duration_day and cycle_time < 150 then
      duration = 150 - cycle_time
      extra_time = (duration_day - duration) * (duration_night / duration_day)
    end

    if cycle_time >= 150 and cycle_time <= 300 - duration_night then
      duration = duration_night
    end

    if cycle_time > 300 - duration_night and cycle_time < 300 then
      duration = 300 - cycle_time
      extra_time = (duration_night - duration) * (duration_day / duration_night)
    end

    caster:AddModifier(self, "genuine_u_modifier_morning", {duration = duration + extra_time})
  end

  function genuine_u__morning:OnHeroDiedNearby(unit, attacker, table)
    local caster = self:GetCaster()
    if caster:HasModifier("genuine_u_modifier_morning") == false then return end
    if attacker == nil then return end
    if attacker:IsBaseNPC() == false then return end
    if caster ~= attacker then return end

    self.kills = self.kills + 1

    caster:FindModifierByName(self:GetIntrinsicModifierName()):SetStackCount(self.kills)
  end

-- EFFECTS