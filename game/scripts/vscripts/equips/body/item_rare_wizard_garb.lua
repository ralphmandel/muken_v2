item_rare_wizard_garb = class({})
LinkLuaModifier("item_rare_wizard_garb_mod_passive", "equips/body/item_rare_wizard_garb_mod_passive", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function item_rare_wizard_garb:GetIntrinsicModifierName()
		return "item_rare_wizard_garb_mod_passive"
	end

-- SPELL START

-- EFFECTS