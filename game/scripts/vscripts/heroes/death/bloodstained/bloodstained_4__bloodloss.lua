bloodstained_4__bloodloss = class({})
LinkLuaModifier("bloodstained_4_modifier_bloodloss", "heroes/death/bloodstained/bloodstained_4_modifier_bloodloss", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function bloodstained_4__bloodloss:GetIntrinsicModifierName()
    return "orb_bleed__modifier"
  end

-- SPELL START

-- EFFECTS