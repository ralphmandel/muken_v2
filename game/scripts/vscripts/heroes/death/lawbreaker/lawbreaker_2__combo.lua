lawbreaker_2__combo = class({})
LinkLuaModifier("lawbreaker_2_modifier_passive", "heroes/death/lawbreaker/lawbreaker_2_modifier_passive", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("lawbreaker_2_modifier_delay_reload", "heroes/death/lawbreaker/lawbreaker_2_modifier_delay_reload", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("lawbreaker_2_modifier_reload", "heroes/death/lawbreaker/lawbreaker_2_modifier_reload", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("lawbreaker_2_modifier_combo", "heroes/death/lawbreaker/lawbreaker_2_modifier_combo", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function lawbreaker_2__combo:GetIntrinsicModifierName()
    return "lawbreaker_2_modifier_passive"
  end

  function lawbreaker_2__combo:Spawn()
    self.reloading = false
    self.casting = false
  end

  function lawbreaker_2__combo:OnUpgrade()
    local caster = self:GetCaster()
    self:PlayEfxStart(true)
  end

  function lawbreaker_2__combo:OnOwnerDied()
    local caster = self:GetCaster()
    self:PlayEfxStart(false)
  end

  function lawbreaker_2__combo:OnOwnerSpawned()
    local caster = self:GetCaster()
    self:PlayEfxStart(true)
  end

-- SPELL START

  function lawbreaker_2__combo:OnAbilityPhaseStart()
    local caster = self:GetCaster()
    self.casting = true

    caster:RemoveModifierByName("lawbreaker_2_modifier_delay_reload")
    caster:RemoveModifierByName("lawbreaker_2_modifier_reload")
    if caster:HasModifier("lawbreaker_2_modifier_combo") then self.casting = false end

    return self.casting
  end

  function lawbreaker_2__combo:OnAbilityPhaseInterrupted()
    self.casting = false
  end

	function lawbreaker_2__combo:OnSpellStart()
		local caster = self:GetCaster()
    self.point = self:GetCursorPosition()
    self.casting = false
    caster:RemoveModifierByName("lawbreaker_2_modifier_combo")
    self:SetCurrentAbilityCharges(self:GetCurrentAbilityCharges() + 1)

    AddModifier(caster, self, "lawbreaker_2_modifier_combo", {}, false)
	end

  function lawbreaker_2__combo:OnProjectileThinkHandle(iProjectileHandle)
    local caster = self:GetCaster()
    local loc = ProjectileManager:GetLinearProjectileLocation(iProjectileHandle)
    local trees = GridNav:GetAllTreesAroundPoint(loc, 50, false)

    if trees then
      for _,tree in pairs(trees) do
        if IsServer() then
          EmitSoundOnLocationWithCaster(loc, "Hero_Muerta.DeadShot.Tree", caster)
        end

        tree:CutDown(caster:GetTeamNumber())

        if self:GetSpecialValueFor("special_pierce") == 0 then
          ProjectileManager:DestroyLinearProjectile(iProjectileHandle)
          break
        end
      end        
    end
  end

  function lawbreaker_2__combo:OnProjectileHit(target, loc)
    local caster = self:GetCaster()
    local sound = "Hero_Muerta.Attack"
    local sound_impact = "Hero_Muerta.ProjectileImpact"

    if caster:HasModifier("lawbreaker_u_modifier_form") then
      sound = "Hero_Muerta.PierceTheVeil.Attack"
      sound_impact = "Hero_Muerta.PierceTheVeil.ProjectileImpact"
    end

    if IsServer() and target then
      target:EmitSound(sound)
      target:EmitSound(sound_impact)
    end

    ApplyDamage({
      victim = target, attacker = caster, ability = self,
      damage = self:GetSpecialValueFor("damage"),
      damage_type = self:GetAbilityDamageType()
    })

    if target == nil or self:GetSpecialValueFor("special_pierce") == 1 then return false end

    return true
  end

  function lawbreaker_2__combo:IncrementBullets(fast_reload)
    local caster = self:GetCaster()
    local fast_reload = self:GetSpecialValueFor("fast_reload")

    Timers:CreateTimer(fast_reload / 2, function()
      caster:FadeGesture(ACT_DOTA_TRANSITION)
      if self:GetCurrentAbilityCharges() < self:GetMaxAbilityCharges(self:GetLevel())
      and self.reloading == true then
        caster:AddActivityModifier("aggressive")
        caster:StartGestureWithPlaybackRate(ACT_DOTA_TRANSITION, 0.9 / fast_reload)
      end
    end)

    Timers:CreateTimer(fast_reload - 0.05, function()
      if self.reloading == true then
        if self:GetCurrentAbilityCharges() < self:GetMaxAbilityCharges(self:GetLevel()) then
          self:SetCurrentAbilityCharges(self:GetCurrentAbilityCharges() + 1)
          if IsServer() then caster:EmitSound("Hero_Muerta.PreAttack") end
        else
          caster:RemoveModifierByName("lawbreaker_2_modifier_reload")
        end
      end
    end)
  end

  function lawbreaker_2__combo:DisableGesture()
    local caster = self:GetCaster()
    local fast_reload = self:GetSpecialValueFor("fast_reload")
    caster:FadeGesture(ACT_DOTA_TRANSITION)

    -- Timers:CreateTimer(fast_reload / 2, function()
    --   caster:FadeGesture(ACT_DOTA_TRANSITION)
    -- end)
  end

-- EFFECTS

  function lawbreaker_2__combo:PlayEfxStart(bCreate)
    if self.particle then ParticleManager:DestroyParticle(self.particle, true) end

    if bCreate then
      local caster = self:GetCaster()
      local string = "particles/lawbreaker/shots_count/lawbreaker_shots_overhead.vpcf"
      self.particle = ParticleManager:CreateParticle(string, PATTACH_OVERHEAD_FOLLOW, caster)
      ParticleManager:SetParticleControl(self.particle, 1, Vector(self:GetSpecialValueFor("max_shots"), 0, 0))
      self:AddParticle(self.particle, false, false, -1, false, false)
    end
  end