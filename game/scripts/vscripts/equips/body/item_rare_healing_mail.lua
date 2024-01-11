item_rare_healing_mail = class({})
LinkLuaModifier("item_rare_healing_mail_mod_passive", "equips/body/item_rare_healing_mail_mod_passive", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function item_rare_healing_mail:GetIntrinsicModifierName()
		return "item_rare_healing_mail_mod_passive"
	end

-- SPELL START

-- EFFECTS