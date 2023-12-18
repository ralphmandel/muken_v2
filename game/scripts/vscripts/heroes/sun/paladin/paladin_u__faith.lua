paladin_u__faith = class({})
LinkLuaModifier("paladin_u_modifier_faith", "heroes/sun/paladin/paladin_u_modifier_faith", LUA_MODIFIER_MOTION_NONE)

-- INIT

-- SPELL START

	function paladin_u__faith:OnSpellStart()
		local caster = self:GetCaster()
	end

-- EFFECTS