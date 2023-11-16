lawbreaker_5__blink = class({})

-- INIT

  function lawbreaker_5__blink:GetBehavior()
    if self:GetSpecialValueFor("special_cast_silence") == 1 then
      return 137439497216
    end

    return DOTA_ABILITY_BEHAVIOR_OPTIONAL_POINT + DOTA_ABILITY_BEHAVIOR_DIRECTIONAL + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES
  end

-- SPELL START

	function lawbreaker_5__blink:OnSpellStart()
		local caster = self:GetCaster()
    local origin = caster:GetOrigin()
    local direction = (origin - self:GetCursorPosition()):Normalized()
    local blink_point = origin - (direction * self:GetSpecialValueFor("range"))
    local illusion_duration = self:GetSpecialValueFor("special_illusion_duration")

		ProjectileManager:ProjectileDodge(caster)
    FindClearSpaceForUnit(caster, blink_point, true)

    if caster:IsCommandRestricted() == false then
      caster:MoveToPosition(self:GetCursorPosition())
    end

    if illusion_duration > 0 then
      local illu_array = CreateIllusions(caster, caster, {
        outgoing_damage = -50,
        incoming_damage = 400,
        bounty_base = 0,
        bounty_growth = 0,
        duration = illusion_duration
      }, 1, 64, false, true)

      FindClearSpaceForUnit(illu_array[1], origin, true)
    end

    if IsServer() then self:PlayEfxBlink(origin, caster:GetOrigin()) end
	end

-- EFFECTS

  function lawbreaker_5__blink:PlayEfxBlink(start_point, end_point)
    local caster = self:GetCaster()
    local particle_start = "particles/lawbreaker/blink/lawbreaker_blink_start.vpcf"
    local particle_end = "particles/lawbreaker/blink/lawbreaker_blink_end.vpcf"

    local blink_start_fx = ParticleManager:CreateParticle(particle_start, PATTACH_ABSORIGIN, caster)
    ParticleManager:SetParticleControl(blink_start_fx, 0, start_point)
    ParticleManager:ReleaseParticleIndex(blink_start_fx)

    local blink_end_fx = ParticleManager:CreateParticle(particle_end, PATTACH_ABSORIGIN, caster)
    ParticleManager:SetParticleControl(blink_end_fx, 0, end_point)
    ParticleManager:ReleaseParticleIndex(blink_end_fx)

    if IsServer() then caster:EmitSound("DOTA_Item.Arcane_Blink.Activate") end
  end