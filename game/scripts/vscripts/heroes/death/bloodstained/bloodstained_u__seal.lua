bloodstained_u__seal = class({})
LinkLuaModifier("bloodstained_u_modifier_seal", "heroes/death/bloodstained/bloodstained_u_modifier_seal", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("bloodstained_u_modifier_aura_effect", "heroes/death/bloodstained/bloodstained_u_modifier_aura_effect", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("bloodstained_u_modifier_copy", "heroes/death/bloodstained/bloodstained_u_modifier_copy", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function bloodstained_u__seal:GetIntrinsicModifierName()
    return "_modifier_generic_custom_indicator"
  end

-- SPELL START

  function bloodstained_u__seal:OnSpellStart()
    local caster = self:GetCaster()

    CreateModifierThinker(
      caster, self, "bloodstained_u_modifier_seal",
      {duration = self:GetSpecialValueFor("duration")},
      self:GetCursorPosition(), caster:GetTeamNumber(), false
    )
  end

  function bloodstained_u__seal:OnHeroDiedNearby(unit, attacker, table)
    local caster = self:GetCaster()
    if unit:GetTeamNumber() ~= caster:GetTeamNumber() then
      local illusions = unit:GetBloodIllusions()
      if illusions then
        for _,illusion in pairs(illusions) do
          illusion:ForceKill(false)
        end
      end
    end
  end

-- EFFECTS

-- CUSTOM INDICATOR

  function bloodstained_u__seal:CastFilterResultLocation(vLoc)
    if IsClient() then
      if self.custom_indicator then
        self.custom_indicator:Register(vLoc)
      end
    end

    return UF_SUCCESS
  end

  function bloodstained_u__seal:CreateCustomIndicator()
    local particle_cast = "particles/bloodstained/seal_finder_aoe.vpcf"
    local radius = self:GetSpecialValueFor("radius")

    self.effect_indicator = ParticleManager:CreateParticle(particle_cast, PATTACH_CUSTOMORIGIN, self:GetCaster())
    ParticleManager:SetParticleControl(self.effect_indicator, 1, Vector( radius, radius, radius ))
  end

  function bloodstained_u__seal:UpdateCustomIndicator(loc)
    ParticleManager:SetParticleControl(self.effect_indicator, 0, loc)
  end

  function bloodstained_u__seal:DestroyCustomIndicator()
    ParticleManager:DestroyParticle(self.effect_indicator, false)
    ParticleManager:ReleaseParticleIndex(self.effect_indicator)
  end