strider_u_modifier_shadow = class({})

function strider_u_modifier_shadow:IsHidden() return false end
function strider_u_modifier_shadow:IsPurgable() return false end

TARGET_STATE_NULL = 0
TARGET_STATE_VISIBLE = 1
TARGET_STATE_MISSING = 2

SHADOW_STATE_IDLE = 0
SHADOW_STATE_ATTACKING = 1
SHADOW_STATE_CHASING = 2

-- CONSTRUCTORS -----------------------------------------------------------

function strider_u_modifier_shadow:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  self.parent:SetHealth(self.parent:GetMaxHealth())
  self.parent:AddStatusEfx(self.caster, self.ability, "strider_u_modifier_shadow_status_efx")
  self.entindex = kv.entindex
  self.modifiers = {}

  self.state = SHADOW_STATE_IDLE
  self.time = GameRules:GetGameTime()
  self:PlayEfxStart()
  self:OnIntervalThink()
end

function strider_u_modifier_shadow:OnRefresh(kv)
end

function strider_u_modifier_shadow:OnRemoved()
  if not IsServer() then return end

  for _, modifier in pairs(self.modifiers) do
    if modifier:IsNull() == false then
      modifier:Destroy()
    end
  end
  
  self.ability.shadows[self.entindex] = nil

  self.ability:SetActivated(#self.ability.shadows < self.ability:GetSpecialValueFor("max_shadows"))
  self.parent:RemoveStatusEfx(self.caster, self.ability, "strider_u_modifier_shadow_status_efx")
end

-- API FUNCTIONS -----------------------------------------------------------

function strider_u_modifier_shadow:CheckState()
	local state = {
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true
	}

	return state
end

function strider_u_modifier_shadow:DeclareFunctions()
	local funcs = {
    MODIFIER_PROPERTY_FIXED_DAY_VISION,
    MODIFIER_PROPERTY_FIXED_NIGHT_VISION,
    MODIFIER_EVENT_ON_MODIFIER_ADDED,
    MODIFIER_EVENT_ON_ABILITY_START
	}

	return funcs
end

function strider_u_modifier_shadow:GetFixedDayVision(keys)
  return self.ability:GetSpecialValueFor("vision_range")
end

function strider_u_modifier_shadow:GetFixedNightVision(keys)
  return self.ability:GetSpecialValueFor("vision_range")
end

function strider_u_modifier_shadow:OnModifierAdded(keys)
  if keys.added_buff:GetCaster() == self.parent then
    table.insert(self.modifiers, keys.added_buff)
  end
end

function strider_u_modifier_shadow:OnAbilityStart(keys)
  if self.state == SHADOW_STATE_IDLE then return end
  if keys.unit:IsIllusion() then return end
  if keys.unit ~= self.caster then return end

  local ability_name = keys.ability:GetAbilityName()
  local ability = self.parent:FindAbilityByName(ability_name)
  if ability:IsTrained() == false then return end

  if ability_name == "strider_1__silence" then
    if self:CheckTarget() == TARGET_STATE_VISIBLE then
      local cast_range = ability:GetCastRange(self.parent:GetOrigin(), nil)
      local distance_diff = CalcDistanceBetweenEntityOBB(self.parent, self.target)

      if cast_range > distance_diff then
        self.parent:CastAbilityOnTarget(self.target, ability, self.parent:GetPlayerOwnerID())
      end
    end
  end

  if ability_name == "strider_2__spin" then
    self.parent:CastAbilityNoTarget(ability, self.parent:GetPlayerOwnerID())
  end

  if ability_name == "strider_3__smoke" then
    self.parent:CastAbilityOnPosition(self.parent:GetOrigin(), ability, self.parent:GetPlayerOwnerID())
  end

  if ability_name == "strider_4__shuriken" then
    local cast_range = ability:GetCastRange(self.parent:GetOrigin(), nil)
    ability.end_pos = self.target:GetOrigin()
    ability.direction = ability.end_pos - self.parent:GetOrigin()
    ability.init_pos = ability.end_pos + (ability.direction:Normalized() * -300)

    if (ability.init_pos - ability.end_pos):Length2D() > cast_range then
      ability.init_pos = self.parent:GetOrigin() + (ability.direction:Normalized() * -cast_range)
    end

    self.parent:CastAbilityOnPosition(self.parent:GetOrigin(), ability, self.parent:GetPlayerOwnerID())
  end
end

function strider_u_modifier_shadow:OnIntervalThink()
  if not IsServer() then return end

  if self.state == SHADOW_STATE_IDLE then
    self:FindTarget(DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC)
  end

  if self.state == SHADOW_STATE_ATTACKING then
    local target_state = self:CheckTarget()

    if target_state == TARGET_STATE_NULL then
      self.state = SHADOW_STATE_IDLE
    end

    if target_state == TARGET_STATE_MISSING then
      self.state = SHADOW_STATE_CHASING
      self.time = GameRules:GetGameTime()
    end

    if target_state == TARGET_STATE_VISIBLE then
      if self.target:IsHero() == false then
        self:FindTarget(DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO)
      end
    end
  end

  if self.state == SHADOW_STATE_CHASING then
    local target_state = self:CheckTarget()

    if target_state == TARGET_STATE_NULL then
      self.state = SHADOW_STATE_IDLE
    end

    if target_state == TARGET_STATE_MISSING then
      if GameRules:GetGameTime() - self.time > 5 then
        self.state = SHADOW_STATE_IDLE
      end
    end

    if target_state == TARGET_STATE_VISIBLE then
      self.state = SHADOW_STATE_ATTACKING
    end
  end

  self:StartIntervalThink(0.5)
end

-- UTILS -----------------------------------------------------------

function strider_u_modifier_shadow:CheckTarget()
  if self.target == nil then return TARGET_STATE_NULL end
  if IsValidEntity(self.target) == false then return TARGET_STATE_NULL end
  if self.target:IsAlive() == false then return TARGET_STATE_NULL end
  if self.parent:CanEntityBeSeenByMyTeam(self.target) == false then return TARGET_STATE_MISSING end

  return TARGET_STATE_VISIBLE
end

function strider_u_modifier_shadow:FindTarget(target_type)
	local enemies = FindUnitsInRadius(
		self.parent:GetTeamNumber(), self.parent:GetOrigin(), nil,
    self.ability:GetSpecialValueFor("vision_range"), DOTA_UNIT_TARGET_TEAM_ENEMY,
    target_type, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS,
    FIND_CLOSEST, false
	)

	for _,enemy in pairs(enemies) do
    if self.parent:CanEntityBeSeenByMyTeam(enemy) then
      self.target = enemy
      self.parent:SetForceAttackTarget(self.target)
      self.parent:MoveToTargetToAttack(self.target)
      self.state = SHADOW_STATE_ATTACKING
      return
    end
	end
end

-- EFFECTS -----------------------------------------------------------

function strider_u_modifier_shadow:GetStatusEffectName()
	return "particles/strider/ult/strider_shadow_status_effect.vpcf"
end

function strider_u_modifier_shadow:StatusEffectPriority()
	return 99999999
end

function strider_u_modifier_shadow:GetEffectName()
	return "particles/econ/items/phantom_assassin/pa_crimson_witness_2021/pa_crimson_witness_blur_ambient.vpcf"
end

function strider_u_modifier_shadow:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function strider_u_modifier_shadow:PlayEfxStart()
	local string = "particles/econ/items/phantom_assassin/pa_crimson_witness_2021/pa_crimson_witness_blur_start.vpcf"
	local particle = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN, self.parent)
	ParticleManager:SetParticleControl(particle, 0, self.parent:GetOrigin())
	ParticleManager:ReleaseParticleIndex(particle)

	local string_2 = "particles/strider/ult/strider_shadow_ground.vpcf"
	local particle_2 = ParticleManager:CreateParticle(string, PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(particle_2, 0, self.parent:GetOrigin())
  self:AddParticle(particle_2, false, false, -1, false, false)

	self.parent:EmitSound("Hero_Invoker.ForgeSpirit")
end

-- function strider_u_modifier_shadow:PlayEfxStart()
-- 	local string = "particles/shadowmancer/shadowmancer_arcana_ambient.vpcf"
-- 	local particle = ParticleManager:CreateParticle(string, PATTACH_POINT_FOLLOW, self.parent)
-- 	self:AddParticle(particle, false, false, -1, false, false)
-- 	ParticleManager:ReleaseParticleIndex(particle)
-- end

-- function strider_u_modifier_shadow:PlayEffects()
-- 	local string = "particles/strider/ult/strider_shadow_blur.vpcf"
-- 	local particle = ParticleManager:CreateParticle(string, PATTACH_ABSORIGIN_FOLLOW, self.parent)
-- 	ParticleManager:SetParticleControl(particle, 0, self.parent:GetOrigin())
-- 	self:AddParticle(particle, false, false, -1, false, false)
-- 	ParticleManager:ReleaseParticleIndex( particle )
-- end