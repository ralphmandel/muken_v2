paladin_3__hammer = class({})
LinkLuaModifier("paladin_3_modifier_hammer", "heroes/sun/paladin/paladin_3_modifier_hammer", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function paladin_3__hammer:GetAOERadius()
    return self:GetSpecialValueFor("radius")
  end

-- SPELL START

	function paladin_3__hammer:OnSpellStart()
		local caster = self:GetCaster()
    local target = self:GetCursorTarget()

    if caster:GetTeamNumber() ~= target:GetTeamNumber() then
      if target:TriggerSpellAbsorb(self) then return end
    end

    local random_mult = RandomInt(self:GetSpecialValueFor("min_mult"), self:GetSpecialValueFor("max_mult"))

    self:PlayEfxHammer(target, self:GetAOERadius())
    AddFOWViewer(caster:GetTeamNumber(), target:GetOrigin(), self:GetAOERadius(), 1, true)

    local units = FindUnitsInRadius(
      caster:GetTeamNumber(), target:GetOrigin(), nil, self:GetAOERadius(),
      self:GetAbilityTargetTeam(), self:GetAbilityTargetType(),
      self:GetAbilityTargetFlags(), 0, false
    )

    for _,unit in pairs(units) do
      local mult = random_mult
      if target == unit then mult = mult + self:GetSpecialValueFor("target_mult") end
      self:PlayEfxMult(unit, mult)

      if unit:GetTeamNumber() == caster:GetTeamNumber() then
        if random_mult ==  self:GetSpecialValueFor("max_mult") then
          unit:ReduceStatus(self:GetSpecialValueFor("special_status_reduction"), STATUS_LIST)
          if self:GetSpecialValueFor("special_purge") == 1 then
            unit:Purge(false, true, false, true, false)
          end
        end

        unit:ApplyHeal(self:GetSpecialValueFor("heal") * mult, self, false)
      else
        if random_mult ==  self:GetSpecialValueFor("max_mult") then
          unit:AddModifier(self, "_modifier_stun", {
            duration = self:GetSpecialValueFor("special_stun_duration"), bResist = 1
          })
        end
        
        if target == unit and unit:IsIllusion() then
          unit:Kill(self, caster)
        else
          ApplyDamage({
            victim = unit, attacker = caster,
            damage = self:GetSpecialValueFor("damage") * mult,
            damage_type = self:GetAbilityDamageType(),
            ability = self
          })
        end
      end
    end
	end

-- EFFECTS

  function paladin_3__hammer:PlayEfxHammer(target, radius)
    local caster = self:GetCaster()

    local particle = "particles/econ/items/omniknight/hammer_ti6_immortal/omniknight_purification_ti6_immortal.vpcf"
    local effect = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, target)
    ParticleManager:SetParticleControl(effect, 1, Vector(radius, radius, radius))
    ParticleManager:ReleaseParticleIndex(effect)

    local particle2 = "particles/econ/items/omniknight/hammer_ti6_immortal/omniknight_purification_immortal_cast.vpcf"
    local effect2 = ParticleManager:CreateParticle(particle2, PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:SetParticleControl(effect2, 0, caster:GetOrigin())
    ParticleManager:SetParticleControl(effect2, 1, target:GetOrigin())

    local particle3 = "particles/econ/items/axe/axe_ti9_immortal/axe_ti9_gold_call.vpcf"
    local effect3 = ParticleManager:CreateParticle(particle3, PATTACH_ABSORIGIN_FOLLOW, target)
    ParticleManager:SetParticleControl(effect3, 0, target:GetOrigin() )
    ParticleManager:SetParticleControl(effect3, 2, Vector(radius, radius, radius))

    target:EmitSound("Hero_Omniknight.Purification.Wingfall")
  end

  function paladin_3__hammer:PlayEfxMult(target, level)
    local particle_cast = "particles/paladin/multi_combo/paladin_multi_combo.vpcf"
    local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_OVERHEAD_FOLLOW, target)
    ParticleManager:SetParticleControl(effect_cast, 1, Vector(level, 1, level))
  end