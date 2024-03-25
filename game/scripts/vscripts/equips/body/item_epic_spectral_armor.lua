item_epic_spectral_armor = class({})
LinkLuaModifier("item_epic_spectral_armor_mod_passive", "equips/body/item_epic_spectral_armor_mod_passive", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("item_epic_spectral_armor_mod_buff", "equips/body/item_epic_spectral_armor_mod_buff", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function item_epic_spectral_armor:GetIntrinsicModifierName()
		return "item_epic_spectral_armor_mod_passive"
	end

-- SPELL START

  function item_epic_spectral_armor:OnSpellStart()
    local caster = self:GetCaster()

    caster:AddModifier(self, "item_epic_spectral_armor_mod_buff", {duration = self:GetSpecialValueFor("duration")})
  end

-- EFFECTS