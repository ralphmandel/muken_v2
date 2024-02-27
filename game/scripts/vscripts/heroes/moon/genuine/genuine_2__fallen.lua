genuine_2__fallen = class({})
LinkLuaModifier("genuine_2_modifier_fallen", "heroes/moon/genuine/genuine_2_modifier_fallen", LUA_MODIFIER_MOTION_NONE)

-- INIT

  genuine_2__fallen.spawn_origin = {}

-- SPELL START

  function genuine_2__fallen:OnSpellStart()
    local caster = self:GetCaster()
    local point = self:GetCursorPosition()
    local direction = point - caster:GetOrigin()
    direction.z = 0
    direction = direction:Normalized()

    local effect_name = "particles/econ/items/drow/drow_ti6_gold/drow_ti6_silence_gold_wave.vpcf"

    if self:GetSpecialValueFor("special_wide") == 1 then
      effect_name = "particles/econ/items/drow/drow_ti6_gold/drow_ti6_silence_gold_wave_wide.vpcf"
    end

    local projectile = ProjectileManager:CreateLinearProjectile({
      Source = caster,
      Ability = self,
      vSpawnOrigin = caster:GetAbsOrigin(),
      
      bDeleteOnHit = false,
      
      iUnitTargetTeam = self:GetAbilityTargetTeam(),
      iUnitTargetFlags = self:GetAbilityTargetFlags(),
      iUnitTargetType = self:GetAbilityTargetType(),
      
      EffectName = effect_name,
      fDistance = self:GetSpecialValueFor("distance"),
      fStartRadius = self:GetSpecialValueFor("radius"),
      fEndRadius = self:GetSpecialValueFor("radius"),
      vVelocity = direction * self:GetSpecialValueFor("speed"),

      bProvidesVision = true,
      iVisionRadius = self:GetSpecialValueFor("radius"),
      iVisionTeamNumber = caster:GetTeamNumber()
    })

    self.spawn_origin[projectile] = caster:GetAbsOrigin()

    caster:EmitSound("Hero_DrowRanger.Silence")
  end

  function genuine_2__fallen:OnProjectileThinkHandle(iProjectileHandle)
    local caster = self:GetCaster()
    local radius = ProjectileManager:GetLinearProjectileRadius(iProjectileHandle)
    local loc = ProjectileManager:GetLinearProjectileLocation(iProjectileHandle)
    local trees = GridNav:GetAllTreesAroundPoint(loc, radius, true)

    if trees then
      for _,tree in pairs(trees) do
        tree:CutDown(caster:GetTeamNumber())
      end
    end
  end

  function genuine_2__fallen:OnProjectileHitHandle(hTarget, vLocation, iProjectileHandle)
    -- local distance_percent = 1 - ((self.spawn_origin[iProjectileHandle] - vLocation):Length2D() / self:GetSpecialValueFor("distance"))
    -- if distance_percent < 0 then distance_percent = 0 end

    -- local min = 0.5
    -- local fear_duration = ((self:GetSpecialValueFor("fear_duration") - min) * distance_percent) + min
    
    if not hTarget then self.spawn_origin[iProjectileHandle] = nil return end

    local caster = self:GetCaster()
    if hTarget == caster then return end

    if caster:GetTeamNumber() == hTarget:GetTeamNumber() then
      hTarget:ReduceStatus(self:GetSpecialValueFor("special_status_reduction"), STATUS_LIST)
      
      if self:GetSpecialValueFor("special_purge") == 1 then
        hTarget:Purge(false, true, false, true, false)
      end
      return
    end

    local origin = caster:GetOrigin()
    local curse_percent = caster:GetDebuffPower(self:GetSpecialValueFor("special_curse_percent"), hTarget)
    hTarget:IncrementStatus("status_bar_curse", self, caster, curse_percent)

    local truesight = hTarget:AddModifier(self, "_modifier_truesight", {})

    local fear = hTarget:AddModifier(self, "_modifier_fear", {
      duration = self:GetSpecialValueFor("fear_duration"), bResist = 1,
      special = 1, x = origin.x, y = origin.y, z = origin.z
    })

    fear:SetEndCallback(function(Interrupted)
      if truesight then
        if truesight:IsNull() == false then
          truesight:Destroy()
        end
      end
    end)
  end

-- EFFECTS