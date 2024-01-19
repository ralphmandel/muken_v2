bloodstained_2__bloodsteal = class({})
LinkLuaModifier("bloodstained_2_modifier_passive", "heroes/death/bloodstained/bloodstained_2_modifier_passive", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("bloodstained_2_modifier_passive_status_efx", "heroes/death/bloodstained/bloodstained_2_modifier_passive_status_efx", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function bloodstained_2__bloodsteal:Spawn()
    if not IsServer() then return end

    Timers:CreateTimer(0.2, function()
      if self:IsTrained() == false then
        self:UpgradeAbility(true)
      end
    end)
  end

  function bloodstained_2__bloodsteal:GetIntrinsicModifierName()
    return "bloodstained_2_modifier_passive"
  end

-- SPELL START

-- EFFECTS