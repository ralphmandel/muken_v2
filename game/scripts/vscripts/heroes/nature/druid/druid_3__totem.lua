druid_3__totem = class({})
LinkLuaModifier("druid_3_modifier_totem", "heroes/nature/druid/druid_3_modifier_totem", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("druid_3_modifier_flame", "heroes/nature/druid/druid_3_modifier_flame", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_stun", "_modifiers/_modifier_stun", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_movespeed_debuff", "_modifiers/_modifier_movespeed_debuff", LUA_MODIFIER_MOTION_NONE)

-- INIT

-- SPELL START

  function druid_3__totem:OnSpellStart()
		local caster = self:GetCaster()
		local point = self:GetCursorPosition()
		local totem = CreateUnitByName("druid_totem", point, true, caster, caster, caster:GetTeamNumber())

		totem:CreatureLevelUp(self:GetSpecialValueFor("rank"))
		totem:SetControllableByPlayer(caster:GetPlayerOwnerID(), true)
    AddModifier(totem, self, "druid_3_modifier_totem", {duration = self:GetSpecialValueFor("duration")}, true)

    if IsServer() then caster:EmitSound("Hero_Juggernaut.HealingWard.Cast") end
  end

  function druid_3__totem:GetAOERadius()
    return self:GetSpecialValueFor("radius")
  end

  function druid_3__totem:GetCastPoint()
    if IsMetamorphosis("druid_4__form", self:GetCaster()) == 1 then return 0.5 end
    return 0.3
  end

-- EFFECTS