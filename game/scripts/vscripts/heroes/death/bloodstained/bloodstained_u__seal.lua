bloodstained_u__seal = class({})
LinkLuaModifier("bloodstained_u_modifier_seal", "heroes/death/bloodstained/bloodstained_u_modifier_seal", LUA_MODIFIER_MOTION_NONE)

-- INIT

-- SPELL START

	function bloodstained_u__seal:OnSpellStart()
		local caster = self:GetCaster()
	end

-- EFFECTS