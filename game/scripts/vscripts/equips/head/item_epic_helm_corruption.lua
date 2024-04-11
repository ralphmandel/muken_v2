item_epic_helm_corruption = class({})
LinkLuaModifier("item_epic_helm_corruption_mod_passive", "equips/head/item_epic_helm_corruption_mod_passive", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("item_epic_helm_corruption_mod_aura_effect", "equips/head/item_epic_helm_corruption_mod_aura_effect", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function item_epic_helm_corruption:GetIntrinsicModifierName()
		return "item_epic_helm_corruption_mod_passive"
	end

  function item_epic_helm_corruption:GetAOERadius()
		return self:GetSpecialValueFor("radius")
	end

-- SPELL START
  
-- EFFECTS