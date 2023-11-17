ancient_4__vitality = class({})
LinkLuaModifier("ancient_4_modifier_vitality", "heroes/sun/ancient/ancient_4_modifier_vitality", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_stun", "_modifiers/_modifier_stun", LUA_MODIFIER_MOTION_NONE)

-- INIT

-- SPELL START

	function ancient_4__vitality:OnSpellStart()
		local caster = self:GetCaster()
	end

-- EFFECTS