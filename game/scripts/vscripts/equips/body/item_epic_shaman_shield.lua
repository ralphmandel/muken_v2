item_epic_shaman_shield = class({})
LinkLuaModifier("item_epic_shaman_shield_mod_passive", "equips/body/item_epic_shaman_shield_mod_passive", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function item_epic_shaman_shield:GetIntrinsicModifierName()
		return "item_epic_shaman_shield_mod_passive"
	end

-- SPELL START

-- EFFECTS