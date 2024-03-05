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
    local duration = self:GetSpecialValueFor("duration_night")

    if GameRules:IsDaytime() then duration = self:GetSpecialValueFor("duration_day") end

    caster:AddModifier(self, "genuine_u_modifier_morning", {duration = duration})
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