ancient_2__roar = class({})
LinkLuaModifier("ancient_2_modifier_pre", "heroes/sun/ancient/ancient_2_modifier_pre", LUA_MODIFIER_MOTION_NONE)

-- INIT

-- SPELL START

  function ancient_2__roar:OnAbilityPhaseStart()
    local caster = self:GetCaster()
    AddModifier(caster, self, "ancient_2_modifier_pre", {}, false)
    return true
  end

  function ancient_2__roar:OnAbilityPhaseInterrupted()
    local caster = self:GetCaster()
    caster:RemoveModifierByName("ancient_2_modifier_pre")
  end

	function ancient_2__roar:OnSpellStart()
		local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    local cast_range = self:GetCastRange(caster:GetOrigin(), nil)
    local damage = self:GetSpecialValueFor("damage")

    local loc_start = caster:GetOrigin()
    local direction = (loc_start - target:GetOrigin()):Normalized()
    local loc_end = loc_start - direction * cast_range
    local strike = false

    caster:RemoveModifierByName("ancient_2_modifier_pre")

    if IsServer() then self:PlayEfxStart(loc_start, loc_end) end

    local enemies = FindUnitsInLine(
      caster:GetTeamNumber(), loc_start, loc_end, nil, self:GetSpecialValueFor("width"),
      self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags()
    )

    for _, enemy in pairs(enemies) do
      if IsServer() then enemy:EmitSound("Hero_PrimalBeast.Uproar.Projectile.Split") end
      strike = true

      local knockback_mult = 2500
      local distance_percent = 1 - ((caster:GetOrigin() - enemy:GetOrigin()):Length2D() / cast_range)
      if distance_percent < 0.2 then distance_percent = 0.2 end
      if distance_percent > 1 then distance_percent = 1 end

      local damage_result = ApplyDamage({
        victim = enemy, attacker = caster,
        ability = self, damage = damage,
        damage_type = self:GetAbilityDamageType()
      })
    
      if enemy then
        if IsValidEntity(enemy) then
          AddModifier(enemy, self, "modifier_knockback", {
            center_x = caster:GetAbsOrigin().x + 1,
            center_y = caster:GetAbsOrigin().y + 1,
            center_z = caster:GetAbsOrigin().z,
            knockback_height = 0,
            duration = (damage_result * distance_percent) / knockback_mult,
            knockback_duration = (damage_result * distance_percent) / knockback_mult,
            knockback_distance = (damage_result * distance_percent * cast_range) / (knockback_mult * 0.8)
          }, true)          
        end
      end
    end

    if strike == true then PlayEfxAncientStun(caster, damage, true) end
	end

-- EFFECTS

  function ancient_2__roar:PlayEfxStart(loc_start, loc_end)
    local caster = self:GetCaster()

    local particle_cast = "particles/units/heroes/hero_beastmaster/beastmaster_primal_roar.vpcf"
    local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:SetParticleControlEnt(effect_cast, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
    ParticleManager:SetParticleControl(effect_cast, 1, loc_end)
    ParticleManager:ReleaseParticleIndex(effect_cast)

    if IsServer() then caster:EmitSound("Hero_PrimalBeast.Uproar.Scepter") end
  end