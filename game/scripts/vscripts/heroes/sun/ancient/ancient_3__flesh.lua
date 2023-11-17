ancient_3__flesh = class({})
LinkLuaModifier("ancient_3_modifier_passive", "heroes/sun/ancient/ancient_3_modifier_passive", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_stun", "_modifiers/_modifier_stun", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function ancient_3__flesh:Spawn()
    Timers:CreateTimer(0.2, function()
      if self:IsTrained() == false then
        self:UpgradeAbility(true)
        BaseHero(self:GetCaster()):AddManaExtra(self)
      end
    end)
  end

  function ancient_3__flesh:GetIntrinsicModifierName()
		return "ancient_3_modifier_passive"
	end

-- SPELL START

	function ancient_3__flesh:OnSpellStart()
		local caster = self:GetCaster()
	end

-- EFFECTS