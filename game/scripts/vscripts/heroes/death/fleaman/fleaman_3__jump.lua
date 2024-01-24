fleaman_3__jump = class({})
LinkLuaModifier("fleaman_3_modifier_jump", "heroes/death/fleaman/fleaman_3_modifier_jump", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("fleaman_3_modifier_effect", "heroes/death/fleaman/fleaman_3_modifier_effect", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function fleaman_3__jump:OnOwnerSpawned()    
    self:SetActivated(true)
  end

-- SPELL START

  function fleaman_3__jump:OnSpellStart()
    local caster = self:GetCaster()

    ProjectileManager:ProjectileDodge(caster)
    caster:RemoveModifierByName("flea_3_modifier_jump")
    AddModifier(caster, self, "fleaman_3_modifier_jump", {}, false)
  end

-- EFFECTS