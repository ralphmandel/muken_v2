dasdingo_2__tree = class({})
LinkLuaModifier("dasdingo_2_modifier_passive", "heroes/nature/dasdingo/dasdingo_2_modifier_passive", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("dasdingo_2_modifier_aura", "heroes/nature/dasdingo/dasdingo_2_modifier_aura", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("dasdingo_2_modifier_aura_effect", "heroes/nature/dasdingo/dasdingo_2_modifier_aura_effect", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_root", "_modifiers/_modifier_root", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_truesight", "_modifiers/_modifier_truesight", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function dasdingo_2__tree:GetAOERadius()
    return self:GetSpecialValueFor("radius")
  end

  function dasdingo_2__tree:GetIntrinsicModifierName()
    return "dasdingo_2_modifier_passive"
  end

-- SPELL START

  function dasdingo_2__tree:OnAbilityPhaseStart()
    local caster = self:GetCaster()
    local loc = self:GetCursorPosition()
    local trees = GridNav:GetAllTreesAroundPoint(loc, 25, false)
    self.tree = nil

    if trees then
      for _, tree in pairs(trees) do
        self.tree = tree
        return true
      end
    end

    return false
  end

  function dasdingo_2__tree:OnSpellStart()
    if self.tree == nil then return end
    if IsValidEntity(self.tree) == false then return end

    local caster = self:GetCaster()
    caster:FindModifierByName(self:GetIntrinsicModifierName()):StartIntervalThink(self:GetSpecialValueFor("root_interval"))

    CreateModifierThinker(caster, self, "dasdingo_2_modifier_aura", {
      duration = self:GetSpecialValueFor("duration")
    }, self.tree:GetAbsOrigin(), caster:GetTeamNumber(), false)
  end

-- EFFECTS