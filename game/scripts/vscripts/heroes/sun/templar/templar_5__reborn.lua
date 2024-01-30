templar_5__reborn = class({})
LinkLuaModifier("templar_5_modifier_passive", "heroes/sun/templar/templar_5_modifier_passive", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function templar_5__reborn:GetCastPoint()
    return self:GetSpecialValueFor("cast_point")
  end

  function templar_5__reborn:GetIntrinsicModifierName()
    return "templar_5_modifier_passive"
  end

  function templar_5__reborn:CastFilterResultLocation(vLocation)
    local caster = self:GetCaster()

    if not IsServer() then return UF_SUCCESS end

    local allies = FindUnitsInRadius(
      caster:GetTeamNumber(), vLocation, nil, 200,
      self:GetAbilityTargetTeam(), self:GetAbilityTargetType(),
      self:GetAbilityTargetFlags(), 0, false
    )

    for _,ally in pairs(allies) do
      if ally:IsAlive() == false and ally:IsReincarnating() == false 
      and ally:GetTimeUntilRespawn() > self:GetCastPoint() then
        return UF_SUCCESS
      end
    end

    return UF_FAIL_CUSTOM
  end

  function templar_5__reborn:GetCustomCastErrorLocation(vLocation)
    return "NO DEAD ALLIED HEROES FOUND"
  end

-- SPELL START

  function templar_5__reborn:OnAbilityPhaseStart()
    local caster = self:GetCaster()

    local allies = FindUnitsInRadius(
      caster:GetTeamNumber(), self:GetCursorPosition(), nil, 210,
      self:GetAbilityTargetTeam(), self:GetAbilityTargetType(),
      self:GetAbilityTargetFlags(), FIND_CLOSEST, false
    )

    for _,ally in pairs(allies) do
      if ally:IsAlive() == false and ally:IsReincarnating() == false 
      and ally:GetTimeUntilRespawn() > self:GetCastPoint() then
        self.target = ally
        
        caster:StopSound("Druid.Channel")
        caster:EmitSound("Druid.Channel")
        return true
      end
    end

    return false
  end

  function templar_5__reborn:OnAbilityPhaseInterrupted()
    self:GetCaster():StopSound("Druid.Channel")
  end

  function templar_5__reborn:OnSpellStart()
    if self.target:IsAlive() then
      self:GetCaster():StopSound("Druid.Channel")
      return
    end
    
    self.target:RespawnHero(false, false)
    self.target:SetHealth(self.target:GetMaxHealth() * self:GetSpecialValueFor("percent") * 0.01)

    if self.target:HasModifier("ancient_3_modifier_passive") == false then
      self.target:SetMana(self.target:GetMaxMana() * self:GetSpecialValueFor("percent") * 0.01)
    end

    if self:GetSpecialValueFor("special_refresh") == 1 then
      for i = 0, 6, 1 do
        local ability = self.target:GetAbilityByIndex(i)
        if ability then ability:EndCooldown() end
      end
    end

    self.target:AddModifier(self, "_modifier_avoid_damage", {
      duration = self:GetSpecialValueFor("special_no_damage"), bResist = 1
    })
    
    FindClearSpaceForUnit(self.target, self:GetCursorPosition(), false)

    self:PlayEfxStart(self:GetCursorPosition())
  end

-- EFFECTS

  function templar_5__reborn:PlayEfxStart(loc)
    local caster = self:GetCaster()
    local particle_reborn = "particles/items_fx/aegis_respawn_timer.vpcf"
    local efx_reborn = ParticleManager:CreateParticle(particle_reborn, PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(efx_reborn, 0, loc)
    ParticleManager:SetParticleControl(efx_reborn, 1, Vector(0, 0, 0))

    caster:StopSound("Druid.Channel")
    self.target:EmitSound("Aegis.Expire")
  end