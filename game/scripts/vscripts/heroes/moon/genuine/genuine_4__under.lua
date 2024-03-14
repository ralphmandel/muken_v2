genuine_4__under = class({})
LinkLuaModifier("genuine_4_modifier_under", "heroes/moon/genuine/genuine_4_modifier_under", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function genuine_4__under:CastFilterResultTarget(hTarget)
    local result = UnitFilter(
      hTarget, DOTA_UNIT_TARGET_TEAM_ENEMY,
      DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
      DOTA_UNIT_TARGET_FLAG_NONE,
      self:GetCaster():GetTeamNumber()
    )
    
    if result == UF_SUCCESS and hTarget:GetMaxMana() == 0 then return UF_FAIL_CUSTOM end

    return result
  end

  function genuine_4__under:GetCustomCastErrorTarget(hTarget)
    return "TARGET HAS NO MANA"
  end

-- SPELL START

  function genuine_4__under:OnAbilityPhaseStart()
    local caster = self:GetCaster()
    caster:ChangeActivity("")

    local particle_cast = "particles/genuine/ult_caster/genuine_ult_caster.vpcf"
    local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:ReleaseParticleIndex(effect_cast)

    return true
  end

  function genuine_4__under:OnAbilityPhaseInterrupted()
    local caster = self:GetCaster()
    caster:ChangeActivity("ti6")
  end

  function genuine_4__under:OnSpellStart()
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()

    caster:ChangeActivity("ti6")

    if target:TriggerSpellAbsorb(self) then return end

    self:PlayEfxStart(caster, target)

    if target:IsIllusion() then
      target:Kill(self, nil)
      return
    end

    local lifesteal = target:GetMaxHealth() * self:GetSpecialValueFor("special_lifesteal") * 0.01
    local magical_barrier = self:GetSpecialValueFor("magical_barrier") * 0.01
    local universal_barrier = self:GetSpecialValueFor("special_universal_barrier") * 0.01
    local manasteal = target:GetMaxMana() * self:GetSpecialValueFor("manasteal") * 0.01
    manasteal = caster:ApplyMana(manasteal, self, false, target, true)

    if lifesteal > 0 then
      target:ModifyHealth(target:GetHealth() - lifesteal, self, false, 0)
      caster:ModifyHealth(caster:GetHealth() + lifesteal, self, false, 0)
      self:PlayEfxLifesteal()
    end

    caster:AddModifier(self, "_modifier_barrier", {
      duration = self:GetSpecialValueFor("barrier_duration"),
      max_magical_barrier = magical_barrier * manasteal,
      magical_barrier = magical_barrier * manasteal,
      max_universal_barrier = universal_barrier * manasteal,
      universal_barrier = universal_barrier * manasteal,
    })
  end

-- EFFECTS

  function genuine_4__under:PlayEfxStart(caster, target)
    local particle_cast = "particles/units/heroes/hero_terrorblade/terrorblade_sunder.vpcf"
    local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, target)
    ParticleManager:SetParticleControlEnt(effect_cast, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
    ParticleManager:SetParticleControlEnt(effect_cast, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
    ParticleManager:SetParticleControl(effect_cast, 60, Vector(125, 0, 175))
    ParticleManager:SetParticleControl(effect_cast, 61, Vector(1, 0, 0))
    ParticleManager:ReleaseParticleIndex(effect_cast)

    target:EmitSound("Hero_Terrorblade.DemonZeal.Cast")
  end

  function genuine_4__under:PlayEfxLifesteal()
    local caster = self:GetCaster()
    local particle = "particles/items3_fx/octarine_core_lifesteal.vpcf"
    local effect = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN, caster)
    ParticleManager:SetParticleControl(effect, 0, caster:GetOrigin())
    ParticleManager:ReleaseParticleIndex(effect)
  end