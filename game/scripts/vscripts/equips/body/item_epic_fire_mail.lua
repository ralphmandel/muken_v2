item_epic_fire_mail = class({})
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
    return "item_epic_fire_mail_mod_aura"
  end

  function item_epic_fire_mail:GetAbilityTextureName()
    if self:GetToggleState() then return "armor/fire_mail" else return "armor/fire_mail_off" end
  end

-- SPELL START

  function item_epic_fire_mail:OnToggle()
    local caster = self:GetCaster()
    self:StartCooldown(0.5)

    local aura_modifier = caster:FindModifierByName(self:GetIntrinsicModifierName())

    if aura_modifier then
      if self:GetToggleState() then
        aura_modifier:PlayEfxStart()
      else
        aura_modifier:StopEfxStart()
      end
    end
  end

-- EFFECTS