bloodstained_3__curse = class({})
LinkLuaModifier("bloodstained_3_modifier_curse", "heroes/death/bloodstained/bloodstained_3_modifier_curse", LUA_MODIFIER_MOTION_NONE)

-- INIT

-- SPELL START

	function bloodstained_3__curse:OnSpellStart()
		local caster = self:GetCaster()
	end

-- EFFECTS