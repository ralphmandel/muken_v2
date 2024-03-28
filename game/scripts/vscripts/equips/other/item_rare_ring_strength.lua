item_rare_ring_strength = class({})
LinkLuaModifier("item_rare_ring_strength_mod_passive", "equips/other/item_rare_ring_strength_mod_passive", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function item_rare_ring_strength:GetIntrinsicModifierName()
		return "item_rare_ring_strength_mod_passive"
	end

-- SPELL START
  
-- EFFECTS