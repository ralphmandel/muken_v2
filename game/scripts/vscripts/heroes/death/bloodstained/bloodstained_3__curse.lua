bloodstained_3__curse = class({})
LinkLuaModifier("bloodstained_3_modifier_curse", "heroes/death/bloodstained/bloodstained_3_modifier_curse", LUA_MODIFIER_MOTION_NONE)

-- INIT

-- SPELL START

  function bloodstained_3__curse:OnSpellStart()
    if not IsServer() then return end

    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    
    if target:TriggerSpellAbsorb(self) then return end

    target:RemoveModifierByNameAndCaster("bloodstained_3_modifier_curse", caster)
    target:AddModifier(self, "bloodstained_3_modifier_curse", {duration = self:GetSpecialValueFor("duration")})

    caster:EmitSound("Hero_ShadowDemon.DemonicPurge.Cast")
    target:EmitSound("Hero_Oracle.FortunesEnd.Attack")
  end

-- EFFECTS