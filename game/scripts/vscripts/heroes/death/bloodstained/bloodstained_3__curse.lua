bloodstained_3__curse = class({})
LinkLuaModifier("bloodstained_3_modifier_curse", "heroes/death/bloodstained/bloodstained_3_modifier_curse", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("bloodstained__modifier_bloodgain", "heroes/death/bloodstained/bloodstained__modifier_bloodgain", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("bloodstained__modifier_bloodloss", "heroes/death/bloodstained/bloodstained__modifier_bloodloss", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_percent_movespeed_debuff", "_modifiers/_modifier_percent_movespeed_debuff", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function bloodstained_3__curse:OnOwnerSpawned()
    self:SetActivated(true)
  end

-- SPELL START

  function bloodstained_3__curse:OnSpellStart()
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    
    if target:TriggerSpellAbsorb(self) then return end

    target:RemoveModifierByNameAndCaster("bloodstained_3_modifier_curse", caster)
    AddModifier(target, self, "bloodstained_3_modifier_curse", {
      duration = self:GetSpecialValueFor("duration")
    }, true)

    if IsServer() then
      caster:EmitSound("Hero_ShadowDemon.DemonicPurge.Cast")
      target:EmitSound("Hero_Oracle.FortunesEnd.Attack")
    end
  end

-- EFFECTS