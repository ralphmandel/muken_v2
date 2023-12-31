fleaman_5__smoke = class({})
LinkLuaModifier("fleaman_5_modifier_smoke", "heroes/death/fleaman/fleaman_5_modifier_smoke", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("fleaman_5_modifier_aura_effect", "heroes/death/fleaman/fleaman_5_modifier_aura_effect", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("fleaman_5_modifier_shadow", "heroes/death/fleaman/fleaman_5_modifier_shadow", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function fleaman_5__smoke:GetAOERadius()
    return self:GetSpecialValueFor("radius")
  end

-- SPELL START

  function fleaman_5__smoke:OnSpellStart()
		local caster = self:GetCaster()

		CreateModifierThinker(caster, self, "fleaman_5_modifier_smoke", {
      duration = self:GetSpecialValueFor("duration")
    }, self:GetCursorPosition(), caster:GetTeamNumber(), false)
	end

-- EFFECTS