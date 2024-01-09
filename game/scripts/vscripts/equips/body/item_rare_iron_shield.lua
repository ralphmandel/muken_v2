item_rare_iron_shield = class({})
LinkLuaModifier("item_rare_iron_shield_mod_passive", "equips/body/item_rare_iron_shield_mod_passive", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function item_rare_iron_shield:GetIntrinsicModifierName()
		return "item_rare_iron_shield_mod_passive"
	end

-- SPELL START

-- EFFECTS