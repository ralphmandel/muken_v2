ancient_4__vitality = class({})
LinkLuaModifier("ancient_4_modifier_aura", "heroes/sun/ancient/ancient_4_modifier_aura", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ancient_4_modifier_aura_effect", "heroes/sun/ancient/ancient_4_modifier_aura_effect", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function ancient_4__vitality:OnOwnerSpawned()
    self:OnToggle()
  end

  function ancient_4__vitality:GetAOERadius()
    return self:GetSpecialValueFor("radius")
  end

-- SPELL START

  function ancient_4__vitality:OnToggle()
    local caster = self:GetCaster()
    self:StartCooldown(1)

    if self:GetToggleState() then
      AddModifier(caster, self, "ancient_4_modifier_aura", {}, false)
    else
      caster:RemoveModifierByName("ancient_4_modifier_aura")
    end
  end

-- EFFECTS