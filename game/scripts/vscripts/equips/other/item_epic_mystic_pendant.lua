item_epic_mystic_pendant = class({})
LinkLuaModifier("item_epic_mystic_pendant_mod_passive", "equips/other/item_epic_mystic_pendant_mod_passive", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function item_epic_mystic_pendant:GetIntrinsicModifierName()
		return "item_epic_mystic_pendant_mod_passive"
	end

-- SPELL START
  
-- EFFECTS