item_rare_cloak_evasion = class({})
LinkLuaModifier("item_rare_cloak_evasion_mod_passive", "equips/body/item_rare_cloak_evasion_mod_passive", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function item_rare_cloak_evasion:GetIntrinsicModifierName()
		return "item_rare_cloak_evasion_mod_passive"
	end

-- SPELL START

-- EFFECTS