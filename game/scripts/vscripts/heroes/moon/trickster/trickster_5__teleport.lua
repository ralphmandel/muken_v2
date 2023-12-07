trickster_5__teleport = class({})
LinkLuaModifier("trickster_5_modifier_teleport", "heroes/moon/trickster/trickster_5_modifier_teleport", LUA_MODIFIER_MOTION_NONE)

-- INIT

-- SPELL START

  function trickster_5__teleport:OnSpellStart()
    local caster = self:GetCaster()
    self.target = self:GetCursorTarget()

    if self.target:TriggerSpellAbsorb(self) then return end

    self.rate = self:GetChannelTime() / 1.3

    caster:FadeGesture(ACT_DOTA_ATTACK_EVENT)
    caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_4, 1 / self.rate)
    AddModifier(caster, self, "_modifier_restrict", {}, false)

    if IsServer() then caster:EmitSound("Hero_Wisp.Relocate.Arc") end
  end

	function trickster_5__teleport:OnChannelFinish(bInterrupted)
		local caster = self:GetCaster()
    local point = Vector(RandomInt(-3200, 3200), RandomInt(-3200, 3200), 0)

    caster:FadeGesture(ACT_DOTA_CAST_ABILITY_4)
    RemoveAllModifiersByNameAndAbility(caster, "_modifier_restrict", self)
    if IsServer() then caster:StopSound("Hero_Wisp.Relocate.Arc") end

    if bInterrupted then
      self:EndCooldown()
      self:StartCooldown(3.5)
      return
    end

    if IsServer() then self:PlayEfxStart(caster, self.target, point) end

    caster:AttackNoEarlierThan(0.47 * self.rate, 20)
    caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_4_END, 1 / self.rate)

    local caster_point = point + RandomVector(130)
    local direction = (point - caster_point):Normalized()
    local target_point = point --caster_point + direction * 100

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

		if caster:GetPlayerOwnerID() then CenterCameraOnUnit(caster:GetPlayerOwnerID(), caster) end
		if self.target:GetPlayerOwnerID() then CenterCameraOnUnit(self.target:GetPlayerOwnerID(), self.target) end

    if IsServer() then self:PlayEfxEnd(caster, self.target, point) end
	end

-- EFFECTS

  function trickster_5__teleport:PlayEfxStart(caster, target, point)
    local string = "particles/econ/events/spring_2021/blink_dagger_spring_2021_end_godray_godray.vpcf"

    local particle = ParticleManager:CreateParticle(string, PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(particle, 0, caster:GetOrigin())
    ParticleManager:ReleaseParticleIndex(particle)

    local particle_2 = ParticleManager:CreateParticle(string, PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(particle_2, 0, target:GetOrigin())
    ParticleManager:ReleaseParticleIndex(particle_2)

    if IsServer() then EmitSoundOnLocationWithCaster(point, "Trickster.Teleport", caster) end
  end

  function trickster_5__teleport:PlayEfxEnd(caster, target, point)
    local string = "particles/econ/events/spring_2021/blink_dagger_spring_2021_end_lvl2.vpcf"

    local particle = ParticleManager:CreateParticle(string, PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:SetParticleControl(particle, 0, caster:GetOrigin())
    ParticleManager:ReleaseParticleIndex(particle)

    local particle_2 = ParticleManager:CreateParticle(string, PATTACH_ABSORIGIN_FOLLOW, target)
    ParticleManager:SetParticleControl(particle_2, 0, target:GetOrigin())
    ParticleManager:ReleaseParticleIndex(particle_2)

    if IsServer() then EmitSoundOnLocationWithCaster(point, "Trickster.Teleport", caster) end
  end