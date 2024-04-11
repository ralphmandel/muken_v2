item_epic_mystical_veil = class({})
LinkLuaModifier("item_epic_mystical_veil_mod_passive", "equips/head/item_epic_mystical_veil_mod_passive", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function item_epic_mystical_veil:GetIntrinsicModifierName()
		return "item_epic_mystical_veil_mod_passive"
	end

-- SPELL START

-- EFFECTS