item_epic_nature_boots = class({})
LinkLuaModifier("item_epic_nature_boots_mod_passive", "equips/other/item_epic_nature_boots_mod_passive", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("item_epic_nature_boots_mod_aura_effect", "equips/other/item_epic_nature_boots_mod_aura_effect", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function item_epic_nature_boots:GetIntrinsicModifierName()
		return "item_epic_nature_boots_mod_passive"
	end

-- SPELL START
  
-- EFFECTS