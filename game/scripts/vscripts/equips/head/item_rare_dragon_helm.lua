item_rare_dragon_helm = class({})
LinkLuaModifier("item_rare_dragon_helm_mod_passive", "equips/head/item_rare_dragon_helm_mod_passive", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("item_rare_dragon_helm_mod_aura_effect", "equips/head/item_rare_dragon_helm_mod_aura_effect", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function item_rare_dragon_helm:GetIntrinsicModifierName()
		return "item_rare_dragon_helm_mod_passive"
	end

  function item_rare_dragon_helm:GetAOERadius()
		return self:GetSpecialValueFor("radius")
	end

-- SPELL START
  
-- EFFECTS