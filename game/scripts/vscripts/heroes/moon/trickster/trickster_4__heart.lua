trickster_4__heart = class({})
LinkLuaModifier("trickster_4_modifier_passive", "heroes/moon/trickster/trickster_4_modifier_passive", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("trickster_4_modifier_heart", "heroes/moon/trickster/trickster_4_modifier_heart", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function trickster_4__heart:GetIntrinsicModifierName()
    return "trickster_4_modifier_passive"
  end

-- SPELL START

-- EFFECTS