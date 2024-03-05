genuine_3__travel = class({})
LinkLuaModifier("genuine__modifier_starfall", "heroes/moon/genuine/genuine__modifier_starfall", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("genuine_3_modifier_travel", "heroes/moon/genuine/genuine_3_modifier_travel", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("genuine_3_modifier_orb", "heroes/moon/genuine/genuine_3_modifier_orb", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_ban", "_modifiers/_modifier_ban", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function genuine_3__travel:OnOwnerSpawned()
    self:SetBehavior(GENUINE_TRAVEL_DEFAULT)
  end

  function genuine_3__travel:GetBehavior()
    if self:HasBehavior(GENUINE_TRAVEL_ON_ORB * GENUINE_TRAVEL_POINT_CAST) then return DOTA_ABILITY_BEHAVIOR_PASSIVE end
    if self:HasBehavior(GENUINE_TRAVEL_ON_ORB) then return 137474607108 end
    if self:HasBehavior(GENUINE_TRAVEL_SUPER_CAST * GENUINE_TRAVEL_POINT_CAST) then return 2099216 end
    if self:HasBehavior(GENUINE_TRAVEL_SUPER_CAST) then return 2100240 end
    if self:HasBehavior(GENUINE_TRAVEL_POINT_CAST) then
      return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
    end

    return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_DIRECTIONAL + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
  end

  function genuine_3__travel:GetAbilityTextureName()
    if self:HasBehavior(GENUINE_TRAVEL_ON_ORB) then return "genuine_travel_2" end
    
    return "genuine_travel"
  end

  function genuine_3__travel:GetAOERadius()
    return self:GetSpecialValueFor("distance")
  end

  function genuine_3__travel:GetIntrinsicModifierName()
    return "genuine_3_modifier_passive"
  end

-- SPELL START

  function genuine_3__travel:OnSpellStart()
    if self:HasBehavior(GENUINE_TRAVEL_ON_ORB) then self:DestroyOrb(true) return end

    if self:HasBehavior(GENUINE_TRAVEL_DEFAULT) then
      local caster = self:GetCaster()
      ProjectileManager:ProjectileDodge(caster)

      self:CreateOrb(self:GetCursorPosition(), 0, true)
      self:EndCooldown()
      self:SetBehavior(GENUINE_TRAVEL_ON_ORB)
    end
  end

  function genuine_3__travel:OnProjectileThinkHandle(proj)
    local caster = self:GetCaster()
    local location = ProjectileManager:GetLinearProjectileLocation(proj)
    self.projectileData.location = location
    self.projectileData.modifier:GetParent():SetOrigin(location)
    caster:SetOrigin(location)
    self:SetDirection()
  end

  function genuine_3__travel:SetDirection()
    if self.aggro_target == nil then return end
    if IsValidEntity(self.aggro_target) == false then return end
    if self.casting then return end
  
    local caster = self:GetCaster()

    caster:SetAggroTarget(self.aggro_target)
    caster:MoveToTargetToAttack(self.aggro_target)
    caster:SetForwardVector((self.aggro_target:GetOrigin() - caster:GetOrigin()):Normalized())
  end

  function genuine_3__travel:OnProjectileHitHandle(target, location, proj)
    if not target then self:DestroyOrb(true) return true end

    self:PlayEfxHit(target)

    return false
  end

  function genuine_3__travel:CreateOrb(point, travelled_distance, new_orb)
    self:StartCooldown(0.2)

    local caster = self:GetCaster()
    local distance = self:GetSpecialValueFor("distance")
    local origin = caster:GetOrigin()
    local direction = point - origin

    local data = {
      max_distance = distance,
      travelled_distance = travelled_distance,
      direction = direction,
      origin = origin,
      location = origin
    }

    if self:HasBehavior(GENUINE_TRAVEL_POINT_CAST) then
      distance = direction:Length2D()
    end

    direction = Vector(direction.x, direction.y, 0):Normalized()

    if new_orb == false and self.projectileData then
      data.travelled_distance = self.projectileData.travelled_distance + travelled_distance
      data.modifier = self.projectileData.modifier
      data.modifier:PlayEfxSound()
    else
      local modifier_thinker = CreateModifierThinker(
        caster, self, "genuine_3_modifier_orb", {duration = 20},
        origin, caster:GetTeamNumber(), false
      )

      data.modifier = modifier_thinker:FindModifierByName("genuine_3_modifier_orb")
    end

    if distance > distance - data.travelled_distance then
      distance = distance - data.travelled_distance
    end

    self.projectileData = data

    self.projectile = ProjectileManager:CreateLinearProjectile({
      Source = caster,
      Ability = self,
      vSpawnOrigin = origin,
      
      bDeleteOnHit = false,
      
      iUnitTargetTeam = self:GetAbilityTargetTeam(),
      iUnitTargetType = self:GetAbilityTargetType(),
      iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
      
      EffectName = "particles/econ/items/puck/puck_merry_wanderer/puck_illusory_orb_merry_wanderer.vpcf",
      fDistance = distance,
      fStartRadius = self:GetSpecialValueFor("radius"),
      fEndRadius = self:GetSpecialValueFor("radius"),
      vVelocity = direction * self:GetSpecialValueFor("speed"),
  
      bReplaceExisting = false,
      
      bProvidesVision = true,
      iVisionRadius = self:GetSpecialValueFor("vision_radius"),
      iVisionTeamNumber = caster:GetTeamNumber(),
    })
  end

  function genuine_3__travel:DestroyOrb(bInterrupt)
    local caster = self:GetCaster()

    if self.projectile then
      ProjectileManager:DestroyLinearProjectile(self.projectile)
      self.projectile = nil
    end

    if bInterrupt and self.projectileData then
      local travelled_distance = self.projectileData.travelled_distance
      travelled_distance = travelled_distance + (self.projectileData.origin - self.projectileData.location):Length2D()
      local distance_percent = travelled_distance / self.projectileData.max_distance
      local silence_duration = self:GetSpecialValueFor("silence_duration") * distance_percent
      local starfall_damage = self:GetSpecialValueFor("starfall_damage") * distance_percent
      local attack_immunity_duration = self:GetSpecialValueFor("special_attack_immunity") * distance_percent

      local enemies = FindUnitsInRadius(
        caster:GetTeamNumber(), caster:GetOrigin(), nil, self:GetSpecialValueFor("silence_radius"),
        self:GetAbilityTargetTeam(), self:GetAbilityTargetType(),
        self:GetAbilityTargetFlags(), 0, false
      )

      for _,enemy in pairs(enemies) do
        enemy:EmitSound("Hero_Puck.EtherealJaunt")
        enemy:AddModifier(self, "_modifier_silence", {duration = silence_duration, bResist = 1})
      end

      if starfall_damage > 0 then
        local modifier_thinker = CreateModifierThinker(
          caster, self, "genuine__modifier_starfall", {starfall_damage = starfall_damage},
          caster:GetOrigin(), caster:GetTeamNumber(), false
        )
      end

      caster:AddModifier(self, "_modifier_ethereal", {duration = attack_immunity_duration})
      self.projectileData.modifier:Destroy()
      self.projectileData = nil

      caster:StartGesture(ACT_DOTA_TELEPORT_END)
      self:SetBehavior(GENUINE_TRAVEL_DEFAULT)
      self:StartCooldown(self:GetEffectiveCooldown(self:GetLevel()))
    end
  end

  function genuine_3__travel:SetBehavior(behavior)
    local caster = self:GetCaster()
    local special_kv_modifier = caster:FindModifierByName("genuine_special_values")
    if special_kv_modifier then special_kv_modifier:UpdateData("behavior_travel", behavior) end
  end

  function genuine_3__travel:HasBehavior(behavior)
    return self:GetSpecialValueFor("behavior") % behavior == 0
  end

-- EFFECTS

  function genuine_3__travel:PlayEfxHit(target)
    local particle_cast = "particles/units/heroes/hero_puck/puck_orb_damage.vpcf"
    local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, target)
    ParticleManager:ReleaseParticleIndex(effect_cast)

    target:EmitSound("Hero_Puck.IIllusory_Orb_Damage")
  end