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
    local table = {duration = self:GetSpecialValueFor("duration")}

    local spectral_boots = caster:FindItemInInventory("item_epic_spectral_boots")
    if spectral_boots then
      if spectral_boots:IsActivated() then
        table.phase = 1
        table.speed_percent = spectral_boots:GetSpecialValueFor("speed_percent")
        table.invi_delay = spectral_boots:GetSpecialValueFor("invi_delay")
      end
    end

    caster:AddModifier(self, "item_epic_spectral_armor_mod_buff", table)
  end

-- EFFECTS