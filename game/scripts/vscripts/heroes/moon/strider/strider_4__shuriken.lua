strider_4__shuriken = class({})
LinkLuaModifier("strider_4_modifier_shuriken", "heroes/moon/strider/strider_4_modifier_shuriken", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("strider_4_modifier_turn", "heroes/moon/strider/strider_4_modifier_turn", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function strider_4__shuriken:Spawn()
    self.disable = 0
    self.projectiles = {}
    self.direction = Vector(0, 0, 0)
		self.init_pos = Vector(0, 0, 0)
		self.end_pos = Vector(0, 0, 0)
  end

	function strider_4__shuriken:GetIntrinsicModifierName()
		return "strider_4_modifier_turn"
	end

-- SPELL START

	function strider_4__shuriken:OnAbilityPhaseStart()
    local caster = self:GetCaster()

    if caster:IsHero() == false then
      self:PlayEfxPhase()
      return true
    end

		if not self:CheckVectorTargetPosition() then return false end
		self:PlayEfxPhase()

		return true
	end

	function strider_4__shuriken:OnAbilityPhaseInterrupted()
		self.disable = 0
	end

	function strider_4__shuriken:OnSpellStart()
		local caster = self:GetCaster()
		local vect_targets = self:GetVectorTargetPosition()
    
    if caster:IsIllusion() == false then
      self.direction = vect_targets.direction
      self.init_pos = vect_targets.init_pos
      self.end_pos = vect_targets.end_pos
    end

		FindClearSpaceForUnit(caster, self.init_pos, true)
		caster:SetForwardVector(self.direction)

		Timers:CreateTimer(0.1, function()
      if caster then
        if IsValidEntity(caster) then
          caster:MoveToPosition(caster:GetOrigin())
        end
      end
		end)

    ProjectileManager:ProjectileDodge(caster)

    caster:AddModifier(self, "strider_4_modifier_shuriken", {
      init_x = self.init_pos.x, init_y = self.init_pos.y, init_z = self.init_pos.z,
			end_x = self.end_pos.x, end_y = self.end_pos.y, end_z = self.end_pos.z
    })

		self:PlayEfxStart(caster:GetOrigin(), self.direction)
	end

  function strider_4__shuriken:CreateShuriken(projectile_direction)
    local caster = self:GetCaster()
    local vVelocity = projectile_direction * self:GetSpecialValueFor("shuriken_speed")
    local bonus_range = RandomInt(-100, 100)

    caster:EmitSound("Hero_Terrorblade.PreAttack")

    local proj = ProjectileManager:CreateLinearProjectile({
      Source = caster,
      Ability = self,
      vSpawnOrigin = caster:GetOrigin(),
      iUnitTargetTeam = self:GetAbilityTargetTeam(),
      iUnitTargetType = self:GetAbilityTargetType(),
      iUnitTargetFlags = self:GetAbilityTargetFlags(),
      EffectName = "",
      bDeleteOnHit = true,
      fDistance = self:GetSpecialValueFor("shuriken_range") + bonus_range,
      vVelocity = vVelocity,
      fStartRadius = 40,
      fEndRadius = 40,
      bProvidesVision = true,
      iVisionRadius = 50,
      iVisionTeamNumber = caster:GetTeamNumber()
    })

    self.projectiles[proj] = {
      source_loc = caster:GetOrigin(),
      direction = projectile_direction,
      distance = self:GetSpecialValueFor("finder_range") + bonus_range,
      lifetime = self:GetSpecialValueFor("special_lifetime"),
      pfx = self:PlayEfxShuriken(caster:GetOrigin(), vVelocity),
      returning = 0
    }
  end

  function strider_4__shuriken:OnProjectileThinkHandle(id)
    if self.projectiles[id] == nil then return end

    local caster = self:GetCaster()
    local vLocation = ProjectileManager:GetLinearProjectileLocation(id)

    if (vLocation - self.projectiles[id].source_loc):Length2D() < self.projectiles[id].distance then return end
    if self.projectiles[id].lifetime == 0 then return end

    if self.projectiles[id].start_time == nil then
      local vVelocity = self.projectiles[id].direction * 1
      self.projectiles[id].start_time = GameRules:GetGameTime()
      ProjectileManager:UpdateLinearProjectileDirection(id, vVelocity, 9999)

      if self.projectiles[id].pfx then
        ParticleManager:DestroyParticle(self.projectiles[id].pfx, true)
        self.projectiles[id].pfx = self:PlayEfxShuriken(vLocation, vVelocity)
      end
    else
      if GameRules:GetGameTime() - self.projectiles[id].start_time >= self.projectiles[id].lifetime
      and self.projectiles[id].returning == 0 then
        local direction = caster:GetOrigin() - vLocation
        local new_pos = caster:GetOrigin() + (direction:Normalized() * 150)

        direction = new_pos - vLocation
        local distance = direction:Length2D() + 150
        direction.z = direction.z + 90
        local vVelocity = direction:Normalized() * (distance + 1000)
        
        ProjectileManager:UpdateLinearProjectileDirection(id, vVelocity, distance)
        self.projectiles[id].returning = 1

        if self.projectiles[id].pfx then
          ParticleManager:DestroyParticle(self.projectiles[id].pfx, true)
          self.projectiles[id].pfx = self:PlayEfxShuriken(vLocation, vVelocity)
          EmitSoundOnLocationWithCaster(vLocation, "Hero_Terrorblade.PreAttack", caster)
        end
      end
    end
  end

	function strider_4__shuriken:OnProjectileHitHandle(hTarget, vLocation, id)
		if not hTarget then self:RemoveProj(id) return end
    if self:GetSpecialValueFor("special_pierce") == 0 then self:RemoveProj(id) end

    local caster = self:GetCaster()

		self:PlayEfxTarget(hTarget)

    if hTarget:IsMagicImmune() == false then
      hTarget:AddModifier(self, "_modifier_stun", {
        duration = self:GetSpecialValueFor("special_stun_duration"), bResist = 1
      })
    end

		ApplyDamage({
			victim = hTarget, attacker = caster, ability = self,
			damage = self:GetSpecialValueFor("damage"),
			damage_type = self:GetAbilityDamageType()
		})

    return self:GetSpecialValueFor("special_pierce") == 0
	end

  function strider_4__shuriken:RemoveProj(id)
    if self.projectiles[id] then
      if self.projectiles[id].pfx then
        ParticleManager:DestroyParticle(self.projectiles[id].pfx, false)
      end
    end

    self.projectiles[id] = nil
  end

-- EFFECTS

	function strider_4__shuriken:PlayEfxPhase()
		local caster = self:GetCaster()
		local string = "particles/strider/shuriken/strider_cast_ground.vpcf"
		local particle = ParticleManager:CreateParticle(string, PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(particle, 0, caster:GetOrigin())
		ParticleManager:ReleaseParticleIndex(particle)
	end

	function strider_4__shuriken:PlayEfxStart(origin, direction)
		local caster = self:GetCaster()
		local string_2 = "particles/strider/shuriken/strider_cast_body.vpcf"
		local particle_2 = ParticleManager:CreateParticle(string_2, PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(particle_2, 0, origin)
		ParticleManager:ReleaseParticleIndex(particle_2)

		local string_3 = "particles/econ/events/ti9/blink_dagger_ti9_end.vpcf"
		local particle_3 = ParticleManager:CreateParticle(string_3, PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(particle_3, 0, caster:GetOrigin())
		ParticleManager:ReleaseParticleIndex(particle_3)

		local particle_cast_a = "particles/strider/shuriken/strider_blink_start.vpcf"
		local effect_cast_a = ParticleManager:CreateParticle(particle_cast_a, PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(effect_cast_a, 0, origin)
		-- ParticleManager:SetParticleControlForward( effect_cast_a, 0, direction:Normalized() )
		ParticleManager:ReleaseParticleIndex(effect_cast_a)

		caster:EmitSound("Hero_Antimage.Blink_out")
	end

	function strider_4__shuriken:PlayEfxTarget(enemy)
		local particle_cast = "particles/units/heroes/hero_juggernaut/juggernaut_blade_fury_tgt.vpcf"
		local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, enemy)
		ParticleManager:ReleaseParticleIndex(effect_cast)

    enemy:EmitSound("Hero_Mirana.ProjectileImpact")
	end

  function strider_4__shuriken:PlayEfxShuriken(source_loc, vVelocity)
    local particle_name = "particles/strider/shuriken/strider_shuriken_base.vpcf"
    local pfx = ParticleManager:CreateParticle(particle_name, PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(pfx, 0, source_loc)
    ParticleManager:SetParticleControl(pfx, 1, vVelocity)

    return pfx
	end