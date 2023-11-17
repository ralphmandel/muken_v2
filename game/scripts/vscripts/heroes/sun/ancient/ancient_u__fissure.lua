ancient_u__fissure = class({})
LinkLuaModifier("ancient_u_modifier_passive", "heroes/sun/ancient/ancient_u_modifier_passive", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_stun", "_modifiers/_modifier_stun", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function ancient_u__fissure:GetIntrinsicModifierName()
    return "ancient_u_modifier_passive"
  end

-- SPELL START

	function ancient_u__fissure:OnSpellStart()
		local caster = self:GetCaster()
	end

-- EFFECTS