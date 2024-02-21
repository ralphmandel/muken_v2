strider_5__aspd = class({})
LinkLuaModifier("strider_5_modifier_aspd", "heroes/moon/strider/strider_5_modifier_aspd", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("strider_5_modifier_aura_effect", "heroes/moon/strider/strider_5_modifier_aura_effect", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function strider_5__aspd:GetBehavior()
    if self:GetSpecialValueFor("special_purge") == 1 then
      return 137441052676
    end

    return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
  end

  function strider_5__aspd:GetAOERadius()
    return self:GetSpecialValueFor("special_aura_radius")
  end

-- SPELL START

	function strider_5__aspd:OnSpellStart()
		local caster = self:GetCaster()
    caster:AddModifier(self, "strider_5_modifier_aspd", {duration = self:GetSpecialValueFor("duration")})

    if self:GetSpecialValueFor("special_purge") == 1 then
      caster:Purge(false, true, false, true, false)
    end
	end

-- EFFECTS