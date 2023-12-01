trickster_2__dodge = class({})
LinkLuaModifier("trickster_2_modifier_passive", "heroes/moon/trickster/trickster_2_modifier_passive", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("trickster_2_modifier_debuff", "heroes/moon/trickster/trickster_2_modifier_debuff", LUA_MODIFIER_MOTION_NONE)

-- INIT

function trickster_2__dodge:GetIntrinsicModifierName()
  return "trickster_2_modifier_passive"
end

-- SPELL START

-- EFFECTS