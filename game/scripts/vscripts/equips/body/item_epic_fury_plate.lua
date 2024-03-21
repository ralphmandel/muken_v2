item_epic_fury_plate = class({})
LinkLuaModifier("item_epic_fury_plate_mod_passive", "equips/body/item_epic_fury_plate_mod_passive", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function item_epic_fury_plate:GetIntrinsicModifierName()
		return "item_epic_fury_plate_mod_passive"
	end

-- SPELL START

-- EFFECTS