strider_4_modifier_shuriken = class({})

function strider_4_modifier_shuriken:IsHidden() return false end
function strider_4_modifier_shuriken:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function strider_4_modifier_shuriken:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

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
		fDistance = self.ability:GetSpecialValueFor("shuriken_range"),
		fStartRadius = 30,
		fEndRadius = 30,
		bProvidesVision = true,
    iVisionRadius = 50,
    iVisionTeamNumber = self.caster:GetTeamNumber()
	}

  self:SetStackCount(self.ability:GetSpecialValueFor("shuriken_amount"))
  self:StartIntervalThink(0.26)
end

function strider_4_modifier_shuriken:OnRefresh(kv)
  if not IsServer() then return end

  local point_init = Vector(kv.init_x, kv.init_y, kv.init_z)
  local point_end = Vector(kv.end_x, kv.end_y, kv.end_z)
  
  self.direction = point_end - point_init
  self.direction.z = self.direction.z + 90
  self.direction = self.direction:Normalized()

  self:SetStackCount(self.ability:GetSpecialValueFor("shuriken_amount"))
  self:StartIntervalThink(self.ability:GetSpecialValueFor("interval"))
end

function strider_4_modifier_shuriken:OnRemoved(kv)
  if not IsServer() then return end

  self.caster:FadeGesture(ACT_DOTA_GENERIC_CHANNEL_1)
  self.ability.disable = 0
end

-- API FUNCTIONS -----------------------------------------------------------

function strider_4_modifier_shuriken:CheckState()
	local state = {
		[MODIFIER_STATE_IGNORING_MOVE_ORDERS] = true,
	}

  if self.ability:GetSpecialValueFor("special_allow_move") == 1 then
    state = {}
  end

  return state
end

function strider_4_modifier_shuriken:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_STATE_CHANGED
	}

	return funcs
end

function strider_4_modifier_shuriken:OnStateChanged(keys)
  if not IsServer() then return end

  if keys.unit ~= self.parent then return end

  if self.parent:IsStunned() or self.parent:IsFrozen()
  or self.parent:IsHexed() or self.parent:IsOutOfGame() then
    self:Destroy()
  end
end

function strider_4_modifier_shuriken:OnIntervalThink()
  if not IsServer() then return end

  local angle = self.ability:GetSpecialValueFor("angle")
  local projectile_direction = RotatePosition(Vector(0,0,0), QAngle(0, math.random(-angle, angle), 0), self.direction)
  self.info.vVelocity = projectile_direction * self.ability:GetSpecialValueFor("shuriken_speed")
  self.info.vSpawnOrigin = self.parent:GetOrigin()

  ProjectileManager:CreateLinearProjectile(self.info)

  self.parent:EmitSound("Hero_Terrorblade.PreAttack")
  self:DecrementStackCount()
  self:StartIntervalThink(self.ability:GetSpecialValueFor("interval"))
end

function strider_4_modifier_shuriken:OnStackCountChanged(old)
  if self:GetStackCount() == 0 and self:GetStackCount() ~= old then self:Destroy() end
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------