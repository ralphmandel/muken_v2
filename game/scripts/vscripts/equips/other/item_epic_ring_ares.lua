item_epic_ring_ares = class({})
LinkLuaModifier("item_epic_ring_ares_mod_passive", "equips/other/item_epic_ring_ares_mod_passive", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function item_epic_ring_ares:GetIntrinsicModifierName()
		return "item_epic_ring_ares_mod_passive"
	end

-- SPELL START
  
-- EFFECTS