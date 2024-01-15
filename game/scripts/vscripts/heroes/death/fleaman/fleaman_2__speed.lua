fleaman_2__speed = class({})
LinkLuaModifier("fleaman_2_modifier_passive", "heroes/death/fleaman/fleaman_2_modifier_passive", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("fleaman_2_modifier_speed_stack", "heroes/death/fleaman/fleaman_2_modifier_speed_stack", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("fleaman_2_modifier_charge", "heroes/death/fleaman/fleaman_2_modifier_charge", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function fleaman_2__speed:GetIntrinsicModifierName()
    return "fleaman_2_modifier_passive"
  end

-- SPELL START

-- EFFECTS