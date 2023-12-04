trickster_1__double = class({})
LinkLuaModifier("trickster_1_modifier_passive", "heroes/moon/trickster/trickster_1_modifier_passive", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("trickster_1_modifier_aspd", "heroes/moon/trickster/trickster_1_modifier_aspd", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function trickster_1__double:Spawn()
    Timers:CreateTimer(0.2, function()
      if self:IsTrained() == false then
        self:UpgradeAbility(true)
        BaseHero(self:GetCaster()):AddManaExtra(self)
      end
    end)
  end

  function trickster_1__double:GetAOERadius()
		return self:GetSpecialValueFor("radius")
	end

  function trickster_1__double:GetIntrinsicModifierName()
		return "trickster_1_modifier_passive"
	end

-- SPELL START

-- EFFECTS