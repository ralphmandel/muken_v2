bloodstained_2__frenzy = class({})
LinkLuaModifier("bloodstained_2_modifier_passive", "heroes/death/bloodstained/bloodstained_2_modifier_passive", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("bloodstained_2_modifier_frenzy", "heroes/death/bloodstained/bloodstained_2_modifier_frenzy", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function bloodstained_2__frenzy:GetIntrinsicModifierName()
    return "bloodstained_2_modifier_passive"
  end

-- SPELL START

-- EFFECTS