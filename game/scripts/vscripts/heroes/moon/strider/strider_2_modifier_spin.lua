strider_2_modifier_spin = class({})

function strider_2_modifier_spin:IsHidden() return true end
function strider_2_modifier_spin:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function strider_2_modifier_spin:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()
  self.aggro = nil

  if not IsServer() then return end

  if kv.aggro then self.aggro = EntIndexToHScript(kv.aggro) end

  self.radius = self.ability:GetAOERadius()
  self.parent:AddSubStats(self.ability, {critical_damage_stack = self.ability:GetSpecialValueFor("critical_damage_stack")})

  local barrier_mult = self.ability:GetSpecialValueFor("special_barrier_mult") * 0.01
  local average_damage = self.parent:GetAverageTrueAttackDamage(nil) * barrier_mult

  if average_damage > 0 then
    self.parent:RemoveAllModifiersByNameAndAbility("_modifier_barrier", self.ability)
    self.parent:AddModifier(self.ability, "_modifier_bkb", {})

    local barrier_mod = self.parent:AddModifier(self.ability, "_modifier_barrier", {
      duration = self.ability:GetSpecialValueFor("special_barrier_duration"),
      max_universal_barrier = average_damage,
      universal_barrier = average_damage
    })
  
    barrier_mod:SetEndCallback(function(interrupted)
      self.parent:RemoveAllModifiersByNameAndAbility("_modifier_bkb", self.ability)
    end)
  end

  if self.parent:GetHeroName() == "trickster" then
    self.caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_4_END, 1.7)
  else
    self.caster:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_1)
  end

  self:PlayEfxStart()
  self:StartIntervalThink(0.1)
end

function strider_2_modifier_spin:OnRefresh(kv)
end

function strider_2_modifier_spin:OnRemoved()
  if not IsServer() then return end

  self.parent:RemoveSubStats(self.ability, {"critical_damage_stack"})

  if self.aggro then
    if IsValidEntity(self.aggro) then
      self.parent:MoveToTargetToAttack(self.aggro)
    end
  end

  if self.parent:GetHeroName() == "trickster" then
    self.caster:FadeGesture(ACT_DOTA_CAST_ABILITY_4_END)
  else
    self.caster:FadeGesture(ACT_DOTA_OVERRIDE_ABILITY_1)
  end
end

-- API FUNCTIONS -----------------------------------------------------------

function strider_2_modifier_spin:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true
	}

  -- local state = {
	-- 	[MODIFIER_STATE_IGNORING_MOVE_ORDERS] = true,
	-- 	[MODIFIER_STATE_DISARMED] = true
	-- }

  return state
end

function strider_2_modifier_spin:OnIntervalThink()
  if not IsServer() then return end

  local enemies = FindUnitsInRadius(
    self.caster:GetTeamNumber(), self.parent:GetOrigin(), nil, self.radius,
    self.ability:GetAbilityTargetTeam(), self.ability:GetAbilityTargetType(),
    self.ability:GetAbilityTargetFlags(), 0, false
  )

  for _,enemy in pairs(enemies) do
    local bleed_damage = self.ability:GetSpecialValueFor("bleed_damage")

    enemy:RemoveAllModifiersByNameAndAbility("orb_bleed_debuff", self.ability)

    enemy:AddModifier(self.ability, "orb_bleed_debuff", {
      duration = self.ability:GetSpecialValueFor("bleed_duration"),
      bleed_damage = bleed_damage
    })

    local distance_percent = 1 - ((self.parent:GetOrigin() - enemy:GetOrigin()):Length2D() / self.ability:GetAOERadius())

    if enemy:IsMagicImmune() == false then
      local bash = enemy:AddModifier(self.ability, "modifier_knockback", {
        center_x = self.parent:GetAbsOrigin().x + 1,
        center_y = self.parent:GetAbsOrigin().y + 1,
        center_z = self.parent:GetAbsOrigin().z,
        knockback_height = 15,
        duration = self.ability:GetSpecialValueFor("special_bash_duration") * distance_percent,
        knockback_duration = self.ability:GetSpecialValueFor("special_bash_duration") * distance_percent,
        knockback_distance = self.ability:GetAOERadius() * distance_percent * 1.25,
        bResist = 1
      })
  
      if bash then enemy:EmitSound("Hero_Spirit_Breaker.Charge.Impact") end
    end

    self:PlayEfxHit(enemy)
    self.parent:SetForceCrit(100, nil)
    self.parent:PerformAttack(enemy, false, true, true, true, false, false, true)
  end

	self:StartIntervalThink(-1)
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function strider_2_modifier_spin:PlayEfxStart()
	local particle_cast = "particles/strider/spin/strider_bloodchaser.vpcf"
	local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent)
  ParticleManager:SetParticleControl(effect_cast, 1, Vector(self.radius, 0, 0))
	self:AddParticle(effect_cast, false, false, -1, false, false)
	ParticleManager:ReleaseParticleIndex(effect_cast)

	self.parent:EmitSound("DOTA_Item.AbyssalBlade.Activate")
end

function strider_2_modifier_spin:PlayEfxHit(target)
	local particle_cast = "particles/units/heroes/hero_juggernaut/juggernaut_blade_fury_tgt.vpcf"
	local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:ReleaseParticleIndex(effect_cast)
end
