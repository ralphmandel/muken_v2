bloodstained_1__rage = class({})
LinkLuaModifier("bloodstained_1_modifier_rage", "heroes/death/bloodstained/bloodstained_1_modifier_rage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("bloodstained_1_modifier_rage_status_efx", "heroes/death/bloodstained/bloodstained_1_modifier_rage_status_efx", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("bloodstained_1_modifier_call", "heroes/death/bloodstained/bloodstained_1_modifier_call", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("bloodstained_1_modifier_call_status_efx", "heroes/death/bloodstained/bloodstained_1_modifier_call_status_efx", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function bloodstained_1__rage:Spawn()
    if not IsServer() then return end

    Timers:CreateTimer(0.2, function()
      if self:IsTrained() == false then
        self:UpgradeAbility(true)
      end
    end)
  end

  function bloodstained_1__rage:OnOwnerSpawned()
    if not IsServer() then return end

    self:SetActivated(true)
  end

  function bloodstained_1__rage:GetAOERadius()
    return self:GetSpecialValueFor("radius")
  end

  function bloodstained_1__rage:GetBehavior()
		if self:GetSpecialValueFor("special_blink") > 0 then return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE end

    return DOTA_ABILITY_BEHAVIOR_NO_TARGET
  end

-- SPELL START

  function bloodstained_1__rage:OnSpellStart()
    if not IsServer() then return end

    local caster = self:GetCaster()
    self:PlayEfxStart()
    
    caster:AddModifier(self, "bloodstained_1_modifier_rage", {duration = self:GetSpecialValueFor("duration")})
    
    if self:GetSpecialValueFor("special_blink") > 0 then
      local origin = caster:GetOrigin()
      FindClearSpaceForUnit(caster, caster:GetCursorPosition(), true)
      self:PlayEfxBlink(origin)
    end
    
    local enemies = FindUnitsInRadius(
      caster:GetTeamNumber(), caster:GetOrigin(), nil, self:GetAOERadius(),
      self:GetAbilityTargetTeam(), self:GetAbilityTargetType(),
      self:GetAbilityTargetFlags(), FIND_ANY_ORDER, false
    )

    for _,enemy in pairs(enemies) do
      if enemy:IsHero() or enemy:IsConsideredHero() then
        enemy:AddModifier(self, "bloodstained_1_modifier_call", {
          duration = self:GetSpecialValueFor("call_duration"), bResist = 1
        })
      end
    end
  end

-- EFFECTS

  function bloodstained_1__rage:PlayEfxStart()
    local caster = self:GetCaster()
    local radius = self:GetAOERadius()

    local particle_cast = "particles/econ/items/axe/axe_ti9_immortal/axe_ti9_call.vpcf"
    local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:SetParticleControl(effect_cast, 2, Vector(radius, radius, radius))
    ParticleManager:SetParticleControlEnt(effect_cast, 1, caster, PATTACH_POINT_FOLLOW, "attach_mouth", Vector(0,0,0), true)
    ParticleManager:ReleaseParticleIndex(effect_cast)

    if IsServer() then
      caster:EmitSound("Hero_PhantomAssassin.CoupDeGrace")
      caster:EmitSound("Bloodstained.fury")
    end
  end

  function bloodstained_1__rage:PlayEfxBlink(origin)
    local caster = self:GetCaster()
    local particle_cast_a = "particles/econ/events/ti6/blink_dagger_start_ti6_lvl2.vpcf"
    local particle_cast_b = "particles/econ/events/ti6/blink_dagger_end_ti6_lvl2.vpcf"

    local effect_cast_a = ParticleManager:CreateParticle(particle_cast_a, PATTACH_ABSORIGIN, caster)
    ParticleManager:SetParticleControl(effect_cast_a, 0, origin)
    ParticleManager:ReleaseParticleIndex(effect_cast_a)

    local effect_cast_b = ParticleManager:CreateParticle(particle_cast_b, PATTACH_ABSORIGIN, caster)
    ParticleManager:SetParticleControl(effect_cast_b, 0, caster:GetOrigin())
    ParticleManager:ReleaseParticleIndex(effect_cast_b)

    if IsServer() then caster:EmitSound("DOTA_Item.Overwhelming_Blink.Activate") end
  end