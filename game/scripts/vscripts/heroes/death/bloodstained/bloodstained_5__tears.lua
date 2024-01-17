bloodstained_5__tears = class({})
LinkLuaModifier("bloodstained_5_modifier_tears", "heroes/death/bloodstained/bloodstained_5_modifier_tears", LUA_MODIFIER_MOTION_NONE)

-- INIT

-- SPELL START

	function bloodstained_5__tears:OnSpellStart()
		local caster = self:GetCaster()
	end

-- EFFECTS