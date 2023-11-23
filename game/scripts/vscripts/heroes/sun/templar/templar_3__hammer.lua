templar_3__hammer = class({})
LinkLuaModifier("templar_3_modifier_hammer", "heroes/sun/templar/templar_3_modifier_hammer", LUA_MODIFIER_MOTION_NONE)

-- INIT

templar_3__hammer.hits = {}

-- SPELL START

	function templar_3__hammer:OnSpellStart()
    self.hits[self:CreateProj(self:GetCaster(), self:GetCursorTarget(), DOTA_PROJECTILE_ATTACHMENT_ATTACK_2)] = 0
	end

  function templar_3__hammer:OnProjectileHitHandle(target, location, handle)
    if (not target) or target:IsInvulnerable() or target:TriggerSpellAbsorb(self) then
      self.hits[handle] = nil
      return
    end

		local caster = self:GetCaster()
    local percent = 1
    local i = 0

    while i < self.hits[handle] do
      percent = percent * (100 - self:GetSpecialValueFor("reduction")) * 0.01
      i = i + 1
    end

    self.hits[handle] = self.hits[handle] + 1

    if self.hits[handle] < self:GetSpecialValueFor("hits") then
      local enemies = FindUnitsInRadius(
        caster:GetTeamNumber(), location, nil, self:GetSpecialValueFor("bounce_range"),
        self:GetAbilityTargetTeam(), self:GetAbilityTargetType(),
        self:GetAbilityTargetFlags(), FIND_CLOSEST, false
      )
        
      for _,enemy in pairs(enemies) do
        if enemy ~= target and enemy:IsHero() then
          self.hits[self:CreateProj(target, enemy, DOTA_PROJECTILE_ATTACHMENT_HITLOCATION)] = self.hits[handle]
          break
        end
      end
    end

    self.hits[handle] = nil

    AddFOWViewer(caster:GetTeamNumber(), target:GetOrigin(), 150, 1, true)
    AddModifier(target, self, "templar_3_modifier_hammer", {interval = self:GetSpecialValueFor("interval") * percent}, false)

    ApplyDamage({
      victim = target, attacker = caster,
      damage = self:GetSpecialValueFor("damage") * percent,
      damage_type = self:GetAbilityDamageType(),
      ability = self
    })
  end

  function templar_3__hammer:CreateProj(source, target, attach)
    local caster = self:GetCaster()
    if IsServer() then source:EmitSound("Hero_Omniknight.HammerOfPurity.Cast") end

    local projectile = ProjectileManager:CreateTrackingProjectile({
      Target = target, Source = source, Ability = self,
      EffectName = "particles/units/heroes/hero_omniknight/omniknight_hammer_of_purity_projectile.vpcf",
      iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2,
      iMoveSpeed = self:GetSpecialValueFor("proj_speed"),
      bDodgeable = false, bProvidesVision = true, iVisionRadius = 150
    })

    return projectile
  end

-- EFFECTS