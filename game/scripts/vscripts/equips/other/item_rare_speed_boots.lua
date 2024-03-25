item_rare_speed_boots = class({})
LinkLuaModifier("item_rare_speed_boots_mod_passive", "equips/other/item_rare_speed_boots_mod_passive", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function item_rare_speed_boots:GetIntrinsicModifierName()
		return "item_rare_speed_boots_mod_passive"
	end

-- SPELL START

-- EFFECTS