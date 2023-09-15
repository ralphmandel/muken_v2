hunter_1__shot = class({})

-- INIT

-- SPELL START

  function hunter_1__shot:OnAbilityPhaseStart()
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()

    ChangeActivity(caster, "dreamleague")
    caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_4, 2)
    
    if IsServer() then caster:EmitSound("Ability.MKG_AssassinateLoad") end

    return true
  end

  function hunter_1__shot:OnAbilityPhaseInterrupted()
		local caster = self:GetCaster()
    ChangeActivity(caster, "MGC")
    caster:FadeGesture(ACT_DOTA_CAST_ABILITY_4)
	end

	function hunter_1__shot:OnSpellStart()
		local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    local bDodgeable = true
    local kill_chance = (100 - target:GetHealthPercent()) * self:GetSpecialValueFor("kill_chance")
    local kill = false

    ChangeActivity(caster, "MGC")

    if RandomFloat(0, 100) < kill_chance then
      bDodgeable = false
      kill = true
    end

    ProjectileManager:CreateTrackingProjectile({
      Target = target,
      Source = caster,
      Ability = self,	
      
      EffectName = "particles/econ/items/sniper/sniper_charlie/sniper_assassinate_charlie.vpcf",
      iMoveSpeed = 4000,
      bDodgeable = true,
      ExtraData = { kill = kill }
    })

    if IsServer() then
      caster:EmitSound("Ability.Assassinate")
      target:EmitSound("Hero_Sniper.AssassinateProjectile")
    end
	end

  function hunter_1__shot:OnProjectileHit_ExtraData(target, vLocation, extradata)
    if (not target) or target:IsInvulnerable() or target:TriggerSpellAbsorb(self) then return end
		local caster = self:GetCaster()

    if IsServer() then target:EmitSound("Hero_Sniper.AssassinateDamage") end

    if extradata.kill == 1 then
      self:PlayEfxKill(caster)
      target:Kill(self, caster)
      self:EndCooldown()
      self:StartCooldown(self:GetEffectiveCooldown(self:GetLevel()) * self:GetSpecialValueFor("cd_mult"))
      return
    end

    ApplyDamage({
      victim = target, attacker = caster,
      damage = self:GetSpecialValueFor("damage"),
      damage_type = self:GetAbilityDamageType(),
      ability = self
    })
  
    target:Interrupt()
  end

-- EFFECTS

  function hunter_1__shot:PlayEfxKill(target)
    local caster = self:GetCaster()
    local particle_cast = "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_counter.vpcf"
    local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_OVERHEAD_FOLLOW, caster)
    ParticleManager:SetParticleControl(effect_cast, 0, caster:GetOrigin())

    if IsServer() then target:EmitSound("Item.BlackPowder") end
  end