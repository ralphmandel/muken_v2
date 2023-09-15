ancient_1__smash = class({})
LinkLuaModifier("ancient_1_modifier_passive", "heroes/sun/ancient/ancient_1_modifier_passive", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_bat_increased", "_modifiers/_modifier_bat_increased", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_stun", "_modifiers/_modifier_stun", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_no_block", "_modifiers/_modifier_no_block", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function ancient_1__smash:Spawn()
    Timers:CreateTimer(0.2, function()
      if self:IsTrained() == false then
        self:UpgradeAbility(true)
        BaseStats(self:GetCaster()):AddManaExtra(self)
      end
    end)
  end

  function ancient_1__smash:GetIntrinsicModifierName()
    return "ancient_1_modifier_passive"
  end

-- SPELL START

-- EFFECTS