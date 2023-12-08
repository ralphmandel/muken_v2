trickster_5__teleport = class({})
LinkLuaModifier("trickster_5_modifier_teleport", "heroes/moon/trickster/trickster_5_modifier_teleport", LUA_MODIFIER_MOTION_NONE)

-- INIT

-- SPELL START

  function trickster_5__teleport:OnSpellStart()
    local caster = self:GetCaster()
    self.target = self:GetCursorTarget()

    if self.target:TriggerSpellAbsorb(self) then return end

    if self:GetSpecialValueFor("special_blink") == 1
    and CalcDistanceBetweenEntityOBB(caster, self.target) > 150 then
      local direction = (caster:GetOrigin() - self.target:GetOrigin()):Normalized()
      local point = self.target:GetOrigin() + direction * 150

      if IsServer() then self:PlayEfxBlink() end

      AddModifier(caster, self, "_modifier_turn_disabled", {}, false)
      FindClearSpaceForUnit(caster, point, true)
      caster:SetForwardVector((self.target:GetOrigin() - caster:GetOrigin()):Normalized())

      Timers:CreateTimer(0.1, function()
        RemoveAllModifiersByNameAndAbility(caster, "_modifier_turn_disabled", self)
      end)

      if IsServer() then caster:EmitSound("Hero_Antimage.Blink_in") end
    end

    self.rate = self:GetChannelTime() / 1.3

    AddModifier(caster, self, "trickster_5_modifier_teleport", {}, false)
  end

	function trickster_5__teleport:OnChannelFinish(bInterrupted)
		local caster = self:GetCaster()

    RemoveAllModifiersByNameAndAbility(caster, "trickster_5_modifier_teleport", self)

    if bInterrupted then
      self:EndCooldown()
      self:StartCooldown(3.5)
      return
    end

    caster:AttackNoEarlierThan(0.47 * self.rate, 20)
    caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_4_END, 1 / self.rate)

    local point = Vector(RandomInt(-3200, 3200), RandomInt(-3200, 3200), 0)
    local caster_point = point + RandomVector(130)
    local direction = (point - caster_point):Normalized()
    local target_point = point --caster_point + direction * 100

    if IsServer() then self:PlayEfxStart(caster, self.target) end

    FindClearSpaceForUnit(caster, caster_point, true)
    FindClearSpaceForUnit(self.target, target_point, true)

    local trees = GridNav:GetAllTreesAroundPoint(point, 150, true)

    if trees then
      for _,tree in pairs(trees) do
        tree:CutDown(caster:GetTeamNumber())
        tree:CutDownRegrowAfter(15, caster:GetTeamNumber())
      end
    end

    AddModifier(caster, self, "_modifier_turn_disabled", {}, false)
    
    Timers:CreateTimer(0.1, function()
      caster:SetForwardVector((self.target:GetOrigin() - caster:GetOrigin()):Normalized())
      caster:MoveToTargetToAttack(self.target)
      RemoveAllModifiersByNameAndAbility(caster, "_modifier_turn_disabled", self)
    end)

    self.target:Interrupt()

    AddModifier(self.target, self, "_modifier_stun", {
      duration = self:GetSpecialValueFor("special_stun_duration")
    }, true)

		if caster:GetPlayerOwnerID() then CenterCameraOnUnit(caster:GetPlayerOwnerID(), caster) end
		if self.target:GetPlayerOwnerID() then CenterCameraOnUnit(self.target:GetPlayerOwnerID(), self.target) end

    if IsServer() then self:PlayEfxEnd(caster, self.target) end
	end

-- EFFECTS

  function trickster_5__teleport:PlayEfxStart(caster, target)
    local string = "particles/econ/events/spring_2021/blink_dagger_spring_2021_end_godray_godray.vpcf"

    local particle = ParticleManager:CreateParticle(string, PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(particle, 0, caster:GetOrigin())
    ParticleManager:ReleaseParticleIndex(particle)

    local particle_2 = ParticleManager:CreateParticle(string, PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(particle_2, 0, target:GetOrigin())
    ParticleManager:ReleaseParticleIndex(particle_2)

    if IsServer() then EmitSoundOnLocationWithCaster(caster:GetOrigin(), "Trickster.Teleport", caster) end
  end

  function trickster_5__teleport:PlayEfxEnd(caster, target)
    local string = "particles/econ/events/spring_2021/blink_dagger_spring_2021_end_lvl2.vpcf"

    local particle = ParticleManager:CreateParticle(string, PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:SetParticleControl(particle, 0, caster:GetOrigin())
    ParticleManager:ReleaseParticleIndex(particle)

    local particle_2 = ParticleManager:CreateParticle(string, PATTACH_ABSORIGIN_FOLLOW, target)
    ParticleManager:SetParticleControl(particle_2, 0, target:GetOrigin())
    ParticleManager:ReleaseParticleIndex(particle_2)

    if IsServer() then EmitSoundOnLocationWithCaster(target:GetOrigin(), "Trickster.Teleport", caster) end
  end

  function trickster_5__teleport:PlayEfxBlink()
    local caster = self:GetCaster()
    local string = "particles/econ/events/spring_2021/blink_dagger_spring_2021_start_lvl2.vpcf"
    local particle = ParticleManager:CreateParticle(string, PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(particle, 0, caster:GetOrigin())
    ParticleManager:ReleaseParticleIndex(particle)

    if IsServer() then caster:EmitSound("Hero_Antimage.Blink_out") end
  end

  