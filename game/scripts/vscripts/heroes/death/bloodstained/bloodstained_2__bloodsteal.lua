bloodstained_2__bloodsteal = class({})
LinkLuaModifier("bloodstained_2_modifier_bloodsteal", "heroes/death/bloodstained/bloodstained_2_modifier_bloodsteal", LUA_MODIFIER_MOTION_NONE)

-- INIT

-- SPELL START

	function bloodstained_2__bloodsteal:OnSpellStart()
		local caster = self:GetCaster()
	end

-- EFFECTS