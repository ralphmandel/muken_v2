vulture_2__trail = class({})
LinkLuaModifier("vulture_2_modifier_trail", "heroes/death/vulture/vulture_2_modifier_trail", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_stun", "_modifiers/_modifier_stun", LUA_MODIFIER_MOTION_NONE)

-- INIT

-- SPELL START

	function vulture_2__trail:OnSpellStart()
		local caster = self:GetCaster()
		local ability = self
		AddModifier(caster, self, "vulture_2_modifier_tree", 
		{duration = ability:GetSpecialValueFor("duration"), 
		slow = ability:GetSpecialValueFor("slow"),
		radius = ability:GetSpecialValueFor("radius")
		}, true)
	end

-- EFFECTS