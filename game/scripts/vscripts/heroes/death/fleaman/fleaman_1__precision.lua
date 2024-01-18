fleaman_1__precision = class({})
LinkLuaModifier("fleaman_1_modifier_gesture", "heroes/death/fleaman/fleaman_1_modifier_gesture", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("fleaman_1_modifier_precision", "heroes/death/fleaman/fleaman_1_modifier_precision", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("fleaman_1_modifier_precision_stack", "heroes/death/fleaman/fleaman_1_modifier_precision_stack", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("fleaman_1_modifier_precision_status_efx", "heroes/death/fleaman/fleaman_1_modifier_precision_status_efx", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function fleaman_1__precision:Spawn()
    if not IsServer() then return end

    Timers:CreateTimer(0.2, function()
      if self:IsTrained() == false then
        self:UpgradeAbility(true)
      end
    end)
  end

  function fleaman_1__precision:GetBehavior()
    if self:GetSpecialValueFor("special_purge") == 1 then
      return 137441052676
    end

    return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
  end

  function fleaman_1__precision:GetAOERadius()
    return self:GetSpecialValueFor("special_aoe")
  end

  function fleaman_1__precision:GetIntrinsicModifierName()
    return "orb_cold__modifier"
  end

-- SPELL START

  function fleaman_1__precision:OnSpellStart()
    if not IsServer() then return end

    local caster = self:GetCaster()
    caster:RemoveModifierByName("fleaman_1_modifier_gesture")

    if GetHeroName(caster) == "trickster" then
      caster:AttackNoEarlierThan(0.4, 20)
    else
      caster:AttackNoEarlierThan(10, 20)
    end

    caster:FadeGesture(ACT_DOTA_CAST_ABILITY_1)
    caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_1, 2)

    self:StartCooldown(0.4)

    if self:GetSpecialValueFor("special_purge") == 1 then
      caster:Purge(false, true, false, true, false)
    end

    AddModifier(caster, self, "fleaman_1_modifier_precision",  {}, false)

    Timers:CreateTimer(0.35, function()
      if caster:IsAlive() then
        if GetHeroName(caster) ~= "trickster" then
          caster:AttackNoEarlierThan(1, 1)
        end
        AddModifier(caster, self, "fleaman_1_modifier_gesture",  {duration = 0.6}, false)
      end
    end)
  end

-- EFFECTS