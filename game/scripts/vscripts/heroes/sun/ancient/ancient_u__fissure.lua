ancient_u__fissure = class({})
LinkLuaModifier("ancient_u_modifier_passive", "heroes/sun/ancient/ancient_u_modifier_passive", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function ancient_u__fissure:Spawn()
    self.casting = false
    self.current_energy = 0
  end

  function ancient_u__fissure:OnOwnerSpawned()
    --if GetHeroName(self:GetCaster()) == "trickster" then return end

    self:GetCaster():SetMana(self.current_energy)
    self:UpdateParticles()
  end

  function ancient_u__fissure:GetCastRange(vLocation, hTarget)    
    return self:GetManaCost(self:GetLevel()) * self:GetSpecialValueFor("cast_range_mult") * 0.01
  end

  function ancient_u__fissure:GetIntrinsicModifierName()
    return "ancient_u_modifier_passive"
  end

-- SPELL START

  function ancient_u__fissure:OnAbilityPhaseStart()
    local caster = self:GetCaster()
    caster:RemoveModifierByName("ancient_1_modifier_leap")
    self.damage = self:GetCaster():GetMana() * self:GetSpecialValueFor("damage") * 0.01
    self.distance = self:GetCastRange(self:GetCursorPosition(), nil)

    ChangeActivity(caster, "")
    
    self:PlayEfxPre()

    return true
  end

  function ancient_u__fissure:OnAbilityPhaseInterrupted()
    local caster = self:GetCaster()
    ChangeActivity(caster, "et_2021")

    self:StopEfxPre(true)
  end

  function ancient_u__fissure:OnSpellStart()
    local caster = self:GetCaster()
    local caster_position = caster:GetAbsOrigin()
    local target_point = self:GetCursorPosition()

    local effect_delay = self:GetSpecialValueFor("crack_time")
    local crack_width = self:GetSpecialValueFor("crack_width")
    local crack_distance = self.distance or self:GetCastRange(self:GetCursorPosition(), nil)
    local caster_fw = caster:GetForwardVector()
    local crack_ending = caster_position + caster_fw * crack_distance
    local damage = self.damage or caster:GetMana() * self:GetSpecialValueFor("damage") * 0.01

    GridNav:DestroyTreesAroundPoint(target_point, crack_width, false)
    ChangeActivity(caster, "et_2021")
    self:PlayEfxStart(caster_position, crack_ending, effect_delay)
    self:StopEfxPre(false)
    self:UpdateParticles()
      
    Timers:CreateTimer(effect_delay, function()
      local enemies = FindUnitsInLine(
        caster:GetTeamNumber(), caster_position, crack_ending, nil, crack_width,
        self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags()
      )

      for _, enemy in pairs(enemies) do
        enemy:Interrupt()
        FindClearSpaceForUnit(enemy, self:FindNearestPointFromLine(caster_position, caster_fw, enemy:GetAbsOrigin()), false)
        AddModifier(enemy, self, "sub_stat_movespeed_percent_decrease", {value = 100, duration = 1}, true)
        AddModifier(enemy, self, "_modifier_silence", {duration = self:GetSpecialValueFor("special_silence_duration")}, true)

        ApplyDamage({
          victim = enemy, attacker = caster,
          ability = self, damage = damage,
          damage_type = self:GetAbilityDamageType(),
          damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
        })
      end

      self:PlayEfxDestroy()
    end)
  end

  function ancient_u__fissure:FindNearestPointFromLine(caster, dir, affected)
    local castertoaffected = affected - caster
    local len = castertoaffected:Dot(dir)
    local ntgt = Vector(dir.x * len, dir.y * len, caster.z)
    return caster + ntgt
  end

  function ancient_u__fissure:UpdateParticles()
    local caster = self:GetCaster()
    caster:FindModifierByNameAndCaster(self:GetIntrinsicModifierName(), caster):UpdateAmbients()
    self.current_energy = caster:GetMana()
  end

-- EFFECTS

  function ancient_u__fissure:PlayEfxPre()
    local caster = self:GetCaster()
    local particle_cast = "particles/units/heroes/hero_magnataur/magnataur_shockwave_cast.vpcf"
    self.pre_efx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:SetParticleControlEnt(self.pre_efx, 1, caster, PATTACH_POINT_FOLLOW, "attach_attack1", Vector(0,0,0), true)
    self.casting = true

    if IsServer() then caster:EmitSound("Ancient.Final.Pre") end
  end

  function ancient_u__fissure:StopEfxPre(interrupted)
    if self.pre_efx then
      ParticleManager:DestroyParticle(self.pre_efx, interrupted)
      ParticleManager:ReleaseParticleIndex(self.pre_efx)
      self.pre_efx = nil
    end

    self.casting = false
  end

  function ancient_u__fissure:PlayEfxStart(caster_position, crack_ending, effect_delay)
    local caster = self:GetCaster()
    local string = "particles/units/heroes/hero_elder_titan/elder_titan_earth_splitter.vpcf"
    self.pfx_start = ParticleManager:CreateParticle(string, PATTACH_WORLDORIGIN, caster)
    ParticleManager:SetParticleControl(self.pfx_start, 0, caster_position)
    ParticleManager:SetParticleControl(self.pfx_start, 1, crack_ending)
    ParticleManager:SetParticleControl(self.pfx_start, 3, Vector(0, effect_delay, 0))
    EmitSoundOn("Hero_ElderTitan.EarthSplitter.Cast", caster)
  end

  function ancient_u__fissure:PlayEfxDestroy()
    local caster = self:GetCaster()
    if self.pfx_start then ParticleManager:ReleaseParticleIndex(self.pfx_start) end
    EmitSoundOn("Hero_ElderTitan.EarthSplitter.Destroy", caster)
  end