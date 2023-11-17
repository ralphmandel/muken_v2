ancient_5__walk = class({})
LinkLuaModifier("ancient_5_modifier_walk", "heroes/sun/ancient/ancient_5_modifier_walk", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_stun", "_modifiers/_modifier_stun", LUA_MODIFIER_MOTION_NONE)

-- INIT

-- SPELL START

	function ancient_5__walk:OnSpellStart()
		local caster = self:GetCaster()
	end

-- EFFECTS