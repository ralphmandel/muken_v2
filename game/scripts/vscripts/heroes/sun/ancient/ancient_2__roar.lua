ancient_2__roar = class({})
LinkLuaModifier("ancient_2_modifier_roar", "heroes/sun/ancient/ancient_2_modifier_roar", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_stun", "_modifiers/_modifier_stun", LUA_MODIFIER_MOTION_NONE)

-- INIT

-- SPELL START

	function ancient_2__roar:OnSpellStart()
		local caster = self:GetCaster()
	end

-- EFFECTS