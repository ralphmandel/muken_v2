lawbreaker_1__combo = class({})
LinkLuaModifier("lawbreaker_1_modifier_combo", "heroes/death/lawbreaker/lawbreaker_1_modifier_combo", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_stun", "_modifiers/_modifier_stun", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function lawbreaker_1__combo:Spawn()
    Timers:CreateTimer(0.2, function()
      if self:IsTrained() == false then
        self:UpgradeAbility(true)
        BaseHero(self:GetCaster()):AddManaExtra(self)
      end
    end)
  end

-- SPELL START

	function lawbreaker_1__combo:OnSpellStart()
		local caster = self:GetCaster()
	end

-- EFFECTS