genuine_5__nightfall = class({})

-- INIT

  genuine_5__nightfall.projectiles = {}

  function genuine_5__nightfall:GetCastPoint()
    return self:GetSpecialValueFor("cast_point")
  end

  function genuine_5__nightfall:GetPlaybackRateOverride()
    return self:GetSpecialValueFor("cast_rate")
  end

  function genuine_5__nightfall:GetIntrinsicModifierName()
    return "_modifier_generic_custom_indicator"
  end

-- SPELL START

  function genuine_5__nightfall:OnAbilityPhaseStart()
    self:PlayEfxChannel(self:GetCursorPosition(), self:GetCastPoint() * 100)
    return true
  end

  function genuine_5__nightfall:OnAbilityPhaseInterrupted()
    self:StopEfxChannel()
  end

  function genuine_5__nightfall:CreateArrow(projectile_direction)
    local caster = self:GetCaster()
    local projectile = ProjectileManager:CreateLinearProjectile({
      Source = caster,
      Ability = self,
      vSpawnOrigin = caster:GetAbsOrigin(),
      
      iUnitTargetTeam = self:GetAbilityTargetTeam(),
      iUnitTargetType = self:GetAbilityTargetType(),
      iUnitTargetFlags = self:GetAbilityTargetFlags(),

      EffectName = "particles/genuine/genuine_powershoot/genuine_spell_powershot_ti6.vpcf",
      fDistance = self:GetCastRange(caster:GetAbsOrigin(), nil),
      fStartRadius = self:GetSpecialValueFor("arrow_width"),
      fEndRadius = self:GetSpecialValueFor("arrow_width"),
      vVelocity = projectile_direction * self:GetSpecialValueFor("arrow_speed"),

      bProvidesVision = true,
      iVisionRadius = self:GetSpecialValueFor("vision_radius"),
      iVisionTeamNumber = caster:GetTeamNumber(),
    })

    self.projectiles[projectile] = {}
    self.projectiles[projectile].damage = self:GetSpecialValueFor("damage")
    self.projectiles[projectile].origin = caster:GetAbsOrigin()
    self.projectiles[projectile].max_range = self:GetSpecialValueFor("arrow_range")
    self.projectiles[projectile].extra_range = self:GetSpecialValueFor("special_extra_range")
  end

  function genuine_5__nightfall:OnSpellStart()
    self:StopEfxChannel()

    local caster = self:GetCaster()
    local point = self:GetCursorPosition()
    local projectile_direction = point - caster:GetOrigin()
    projectile_direction.z = 0
    projectile_direction = projectile_direction:Normalized()

    local extra_shoots = self:GetSpecialValueFor("special_extra_shoots")

    if extra_shoots > 0 then
      for i = 0, extra_shoots, 1 do
        local angle = self:GetSpecialValueFor("special_angle")
        angle = (angle * i * (1 / (extra_shoots * 0.5))) - angle

        self:CreateArrow(RotatePosition(Vector(0,0,0), QAngle(0, angle, 0), projectile_direction))
      end
    else
      self:CreateArrow(projectile_direction)
    end
  end

  function genuine_5__nightfall:OnProjectileHitHandle(target, location, handle)
    local caster = self:GetCaster()

    if not target then
      self.projectiles[handle] = nil
      local vision_radius = self:GetSpecialValueFor("vision_radius")
      local vision_duration = self:GetSpecialValueFor("vision_duration")
      AddFOWViewer(caster:GetTeamNumber(), location, vision_radius * 0.5, vision_duration, false)
      return
    end

    target:EmitSound("Hero_Windrunner.PowershotDamage")

    local max_range = self.projectiles[handle].max_range - self.projectiles[handle].extra_range
    local percent = (self.projectiles[handle].origin - target:GetOrigin()):Length2D() / max_range
    if percent > 1 then percent = 1 end

    target:AddModifier(self, "_modifier_stun", {duration = self:GetSpecialValueFor("stun_duration") * percent, bResist = 1})

    ApplyDamage({
      victim = target, attacker = caster,
      ability = self, damage = self.projectiles[handle].damage * percent,
      damage_type = self:GetAbilityDamageType()
    })
  end

  function genuine_5__nightfall:OnProjectileThink(location)
    GridNav:DestroyTreesAroundPoint(location, self:GetSpecialValueFor("tree_width"), false)	
  end

-- EFFECTS

  function genuine_5__nightfall:CastFilterResultLocation(vLoc)
    if IsClient() then
      if self.custom_indicator then
        self.custom_indicator:Register(vLoc)
      end
    end

    return UF_SUCCESS
  end

  function genuine_5__nightfall:CreateCustomIndicator()
    local caster = self:GetCaster()
    local particle_cast = "particles/generic/finders/directional_finder.vpcf"

    self.effect_indicator = {}

    local extra_shoots = self:GetSpecialValueFor("special_extra_shoots")

    if extra_shoots > 0 then
      for i = 0, extra_shoots, 1 do
        self.effect_indicator[i] = ParticleManager:CreateParticle(particle_cast, PATTACH_CUSTOMORIGIN, caster)
        ParticleManager:SetParticleControl(self.effect_indicator[i], 15, Vector(1, 0, 1))
      end
    else
      self.effect_indicator[0] = ParticleManager:CreateParticle(particle_cast, PATTACH_CUSTOMORIGIN, caster)
      ParticleManager:SetParticleControl(self.effect_indicator[0], 15, Vector(1, 0, 1))
    end

    self:UpdateEndPosition(caster:GetAbsOrigin())
  end

  function genuine_5__nightfall:UpdateCustomIndicator(loc)
    self:UpdateEndPosition(loc)
  end

  function genuine_5__nightfall:DestroyCustomIndicator()
    if self.effect_indicator then
      for i = 0, #self.effect_indicator, 1 do
        if self.effect_indicator[i] then
          ParticleManager:DestroyParticle(self.effect_indicator[i], true)
          ParticleManager:ReleaseParticleIndex(self.effect_indicator[i])
          self.effect_indicator[i] = nil
        end
      end
    end
  end

  function genuine_5__nightfall:UpdateEndPosition(loc)
    local caster = self:GetCaster()
    local origin = caster:GetAbsOrigin()
    local direction = origin - loc
    local distance = self:GetSpecialValueFor("arrow_range")
    local radius = self:GetSpecialValueFor("arrow_width")

    if self.effect_indicator then
      if #self.effect_indicator > 1 then
        local extra_arrows = #self.effect_indicator
        for i = 0, extra_arrows, 1 do
          local angle = self:GetSpecialValueFor("special_angle")
          angle = (angle * i * (1 / (extra_arrows * 0.5))) - angle

          loc = origin - (RotatePosition(Vector(0,0,0), QAngle(0, angle, 0), direction:Normalized()):Normalized() * distance)
          ParticleManager:SetParticleControl(self.effect_indicator[i], 0, origin)
          ParticleManager:SetParticleControl(self.effect_indicator[i], 1, loc)
          ParticleManager:SetParticleControl(self.effect_indicator[i], 2, Vector(radius, radius, radius))
        end
      else
        loc = origin - (direction:Normalized() * distance)
        ParticleManager:SetParticleControl(self.effect_indicator[0], 0, origin)
        ParticleManager:SetParticleControl(self.effect_indicator[0], 1, loc)
        ParticleManager:SetParticleControl(self.effect_indicator[0], 2, Vector(radius, radius, radius))
      end
    end
  end

  function genuine_5__nightfall:PlayEfxChannel(point, time)
    local caster = self:GetCaster()
    local particle_cast = "particles/genuine/genuine_powershoot/genuine_powershot_channel_combo_v2.vpcf"
    local direction = point - caster:GetAbsOrigin()

    if self.effect_cast then ParticleManager:DestroyParticle(self.effect_cast, true) end
    self.effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:SetParticleControl(self.effect_cast, 0, caster:GetOrigin())
    ParticleManager:SetParticleControlForward(self.effect_cast, 0, direction:Normalized())
    ParticleManager:SetParticleControl(self.effect_cast, 1, caster:GetOrigin())
    ParticleManager:SetParticleControlForward(self.effect_cast, 1, direction:Normalized())
    ParticleManager:SetParticleControl(self.effect_cast, 10, Vector(math.floor(time), 0, 0))

    EmitSoundOnLocationForAllies(caster:GetOrigin(), "Ability.PowershotPull.Lyralei", caster)
  end

  function genuine_5__nightfall:StopEfxChannel()
    if self.effect_cast then ParticleManager:DestroyParticle(self.effect_cast, false) end

    local caster = self:GetCaster()
    caster:StopSound("Ability.PowershotPull.Lyralei")
    caster:EmitSound("Ability.Powershot.Alt")
  end