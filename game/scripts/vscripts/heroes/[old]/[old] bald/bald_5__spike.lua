bald_5__spike = class({})
LinkLuaModifier("bald_5_modifier_passive", "heroes/sun/bald/bald_5_modifier_passive", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("bald_5_modifier_goo", "heroes/sun/bald/bald_5_modifier_goo", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("bald_5_modifier_call", "heroes/sun/bald/bald_5_modifier_call", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("bald_5_modifier_call_status_efx", "heroes/sun/bald/bald_5_modifier_call_status_efx", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_movespeed_debuff", "_modifiers/_modifier_movespeed_debuff", LUA_MODIFIER_MOTION_NONE)

-- INIT

-- SPELL START

  function bald_5__spike:GetIntrinsicModifierName()
    return "bald_5_modifier_passive"
  end

-- EFFECTS