trickster_2__dodge = class({})
LinkLuaModifier("trickster_2_modifier_dodge", "heroes/moon/trickster/trickster_2_modifier_dodge", LUA_MODIFIER_MOTION_NONE)

-- INIT

-- SPELL START

	function trickster_2__dodge:OnSpellStart()
		local caster = self:GetCaster()
    caster:StartGesture(ACT_DOTA_ATTACK_EVENT)
	end

-- EFFECTS