item_epic_spectral_boots = class({})
LinkLuaModifier("item_epic_spectral_boots_mod_passive", "equips/other/item_epic_spectral_boots_mod_passive", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function item_epic_spectral_boots:GetIntrinsicModifierName()
		return "item_epic_spectral_boots_mod_passive"
	end

-- SPELL START
  
-- EFFECTS