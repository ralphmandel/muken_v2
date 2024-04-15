item_epic_spectral_mask = class({})
LinkLuaModifier("item_epic_spectral_mask_mod_passive", "equips/head/item_epic_spectral_mask_mod_passive", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function item_epic_spectral_mask:GetIntrinsicModifierName()
		return "item_epic_spectral_mask_mod_passive"
	end

-- SPELL START

-- EFFECTS