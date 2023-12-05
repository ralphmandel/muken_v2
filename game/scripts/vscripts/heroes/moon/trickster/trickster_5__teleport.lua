trickster_5__teleport = class({})
LinkLuaModifier("trickster_5_modifier_teleport", "heroes/moon/trickster/trickster_5_modifier_teleport", LUA_MODIFIER_MOTION_NONE)

-- INIT

-- SPELL START

  function trickster_5__teleport:OnAbilityPhaseStart()
    local caster = self:GetCaster()
    caster:FadeGesture(ACT_DOTA_ATTACK_EVENT)
    if IsServer() then caster:EmitSound("Hero_Wisp.Relocate.Arc") end

    return true
  end

  function trickster_5__teleport:OnAbilityPhaseInterrupted()
    local caster = self:GetCaster()
    if IsServer() then caster:StopSound("Hero_Wisp.Relocate.Arc") end
  end

	function trickster_5__teleport:OnSpellStart()
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()
    local point = Vector(RandomInt(-3200, 3200), RandomInt(-3200, 3200), 0)

    if IsServer() then caster:StopSound("Hero_Wisp.Relocate.Arc") end

    if target:TriggerSpellAbsorb(self) then return end

    if IsServer() then self:PlayEfxStart(caster, target, point) end

    caster:AttackNoEarlierThan(0.47, 20)
    caster:StartGesture(ACT_DOTA_CAST_ABILITY_4_END)

    local caster_point = point + RandomVector(50)
    local direction = (point - caster_point):Normalized()
    local target_point = caster_point + (point - caster_point):Normalized() * 100

    FindClearSpaceForUnit(caster, caster_point, true)
    FindClearSpaceForUnit(target, target_point, true)

    local trees = GridNav:GetAllTreesAroundPoint(point, 150, true)

    if trees then
      for _,tree in pairs(trees) do
        tree:CutDown(caster:GetTeamNumber())
        tree:CutDownRegrowAfter(15, caster:GetTeamNumber())
      end
    end

    caster:SetForwardVector(direction)
    target:Interrupt()

		if caster:GetPlayerOwnerID() then CenterCameraOnUnit(caster:GetPlayerOwnerID(), caster) end
		if target:GetPlayerOwnerID() then CenterCameraOnUnit(target:GetPlayerOwnerID(), target) end

    if IsServer() then self:PlayEfxEnd(caster, target, point) end
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