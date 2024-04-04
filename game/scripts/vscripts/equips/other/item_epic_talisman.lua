item_epic_talisman = class({})
LinkLuaModifier("item_epic_talisman_mod_passive", "equips/other/item_epic_talisman_mod_passive", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function item_epic_talisman:GetIntrinsicModifierName()
		return "item_epic_talisman_mod_passive"
	end

-- SPELL START
  
-- EFFECTS