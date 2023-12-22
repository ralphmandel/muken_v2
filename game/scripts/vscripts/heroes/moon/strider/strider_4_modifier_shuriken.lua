strider_4_modifier_shuriken = class({})

function strider_4_modifier_shuriken:IsHidden() return false end
function strider_4_modifier_shuriken:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function strider_4_modifier_shuriken:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  local point_init = Vector(kv.init_x, kv.init_y, kv.init_z)
  local point_end = Vector(kv.end_x, kv.end_y, kv.end_z)
  
  self.direction = point_end - point_init
  self.direction.z = self.direction.z + 90
  self.direction = self.direction:Normalized()
	
	self.caster:StartGestureWithPlaybackRate(ACT_DOTA_GENERIC_CHANNEL_1, 2)

	self.info = {
		Source = self.parent,
		Ability = self.ability,
		iUnitTargetTeam = self.ability:GetAbilityTargetTeam(),
		iUnitTargetType = self.ability:GetAbilityTargetType(),
		iUnitTargetFlags = self.ability:GetAbilityTargetFlags(),
		EffectName = "particles/strider/shuriken/strider_shuriken_base.vpcf",
		bDeleteOnHit = true,
		fDistance = self.ability:GetSpecialValueFor("shuriken_distance"),
		fStartRadius = 30,
		fEndRadius = 30,
		bProvidesVision = false
	}

  if IsServer() then
    self:SetStackCount(self.ability:GetSpecialValueFor("shuriken_amount"))
    self:StartIntervalThink(0.26)
  end
end

function strider_4_modifier_shuriken:OnRefresh(kv)
  local point_init = Vector(kv.init_x, kv.init_y, kv.init_z)
  local point_end = Vector(kv.end_x, kv.end_y, kv.end_z)
  
  self.direction = point_end - point_init
  self.direction.z = self.direction.z + 90
  self.direction = self.direction:Normalized()

  if IsServer() then
    self:SetStackCount(self.ability:GetSpecialValueFor("shuriken_amount"))
    self:StartIntervalThink(self.ability:GetSpecialValueFor("interval"))
  end
end

function strider_4_modifier_shuriken:OnRemoved(kv)
  if IsServer() then self.caster:FadeGesture(ACT_DOTA_GENERIC_CHANNEL_1) end

  self.ability.disable = 0
end

-- API FUNCTIONS -----------------------------------------------------------

function strider_4_modifier_shuriken:DeclareFunctions()
	local funcs = {
    MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_EVENT_ON_STATE_CHANGED
	}

	return funcs
end

function strider_4_modifier_shuriken:GetModifierMoveSpeed_Limit(keys)
  return self:GetAbility():GetSpecialValueFor("ms_limit")
end

function strider_4_modifier_shuriken:OnStateChanged(keys)
  if keys.unit ~= self.parent then return end
  if self.parent:IsStunned() or self.parent:IsFrozen() or self.parent:IsHexed() or self.parent:IsOutOfGame() then
    self:Destroy()
  end
end

function strider_4_modifier_shuriken:OnIntervalThink()
  local angle = self.ability:GetSpecialValueFor("angle")
  local projectile_direction = RotatePosition(Vector(0,0,0), QAngle(0, math.random(-angle, angle), 0), self.direction)
  self.info.vVelocity = projectile_direction * self.ability:GetSpecialValueFor("shuriken_speed")
  self.info.vSpawnOrigin = self.parent:GetOrigin()

  ProjectileManager:CreateLinearProjectile(self.info)

  if IsServer() then
    self.parent:EmitSound("Hero_Terrorblade.PreAttack")
    self:DecrementStackCount()
    self:StartIntervalThink(self.ability:GetSpecialValueFor("interval"))
  end
end

function strider_4_modifier_shuriken:OnStackCountChanged(old)
  if self:GetStackCount() == 0 and self:GetStackCount() ~= old then self:Destroy() end
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------