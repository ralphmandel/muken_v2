item_epic_fire_mail = class({})
LinkLuaModifier("item_epic_fire_mail_mod_passive", "equips/body/item_epic_fire_mail_mod_passive", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("item_epic_fire_mail_mod_aura", "equips/body/item_epic_fire_mail_mod_aura", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("item_epic_fire_mail_mod_aura_effect", "equips/body/item_epic_fire_mail_mod_aura_effect", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function item_epic_fire_mail:OnOwnerSpawned()
    self:OnToggle()
  end

  function item_epic_fire_mail:GetAOERadius()
    return self:GetSpecialValueFor("radius")
  end

  function item_epic_fire_mail:GetIntrinsicModifierName()
    return "item_epic_fire_mail_mod_passive"
  end

-- SPELL START

  function item_epic_fire_mail:OnToggle()
    local caster = self:GetCaster()
    self:StartCooldown(1)

    if self:GetToggleState() then
      caster:AddModifier(self, "item_epic_fire_mail_mod_aura", {})
    else
      caster:RemoveModifierByName("item_epic_fire_mail_mod_aura")
    end
  end

-- EFFECTS