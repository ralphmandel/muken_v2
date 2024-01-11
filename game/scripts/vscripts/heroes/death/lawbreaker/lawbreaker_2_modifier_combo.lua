lawbreaker_2_modifier_combo = class({})

function lawbreaker_2_modifier_combo:IsHidden() return true end
function lawbreaker_2_modifier_combo:IsPurgable() return true end

-- CONSTRUCTORS -----------------------------------------------------------

function lawbreaker_2_modifier_combo:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()
  self.gesture = {[1] = ACT_DOTA_ATTACK, [2] = ACT_DOTA_ATTACK2}
  self.spawn_shot = {[1] = -35, [2] = 35}
  self.type = 1

  self.bot_script = self.parent:FindModifierByName("_general_script")
  self.speed_mult = self.ability:GetSpecialValueFor("speed_mult")

  --AddSubStats(self.parent, self.ability, {attack_speed = self.speed_mult * 100}, false)

  AddModifier(self.parent, self.ability, "sub_stat_movespeed_percent_decrease", {
    value = self.ability:GetSpecialValueFor("slow_percent")
  }, false)
  
  if IsServer() then
    self:StartIntervalThink(1 / self.speed_mult)
  end
end

function lawbreaker_2_modifier_combo:OnRefresh(kv)
end

function lawbreaker_2_modifier_combo:OnRemoved()
  --RemoveSubStats(self.parent, self.ability, {"attack_speed"})
  RemoveAllModifiersByNameAndAbility(self.parent, "sub_stat_movespeed_percent_decrease", self.ability)
end

-- API FUNCTIONS -----------------------------------------------------------

function lawbreaker_2_modifier_combo:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DISABLE_TURNING,
    MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
    MODIFIER_EVENT_ON_STATE_CHANGED,
    MODIFIER_EVENT_ON_ORDER
	}

	return funcs
end

function lawbreaker_2_modifier_combo:GetModifierDisableTurning()
  return 1
end

function lawbreaker_2_modifier_combo:GetModifierAttackRangeBonus()
  return self:GetAbility():GetSpecialValueFor("attack_range")
end

function lawbreaker_2_modifier_combo:OnStateChanged(keys)
	if keys.unit ~= self.parent then return end
	if self.parent:IsStunned() or self.parent:IsHexed()
  or self.parent:IsFrozen() or self.parent:IsDisarmed() then
		self:Destroy()
	end
end

function lawbreaker_2_modifier_combo:OnOrder(keys)
	if keys.unit ~= self.parent then return end
  if self.bot_script ~= nil then return end

	if keys.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET then
    Timers:CreateTimer(FrameTime(), function()
      --if self.parent:IsCommandRestricted() == false then
        self.parent:MoveToNPC(keys.target)
      --end
    end)
	end
end

function lawbreaker_2_modifier_combo:OnIntervalThink()
  if self.ability:GetCurrentAbilityCharges() <= 0 then self:Destroy() return end

  local front = self.parent:GetForwardVector():Normalized()
  local point = self.parent:GetOrigin() + front * self.ability:GetSpecialValueFor("attack_range")
  local direction = point - self.parent:GetOrigin()
	direction.z = 0
	direction = direction:Normalized()

  self.parent:FadeGesture(self.gesture[self.type])
  if self.type == 1 then self.type = 2 else self.type = 1 end
  self.parent:StartGestureWithPlaybackRate(self.gesture[self.type], 1 / self.speed_mult)

  local cross = CrossVectors(self.parent:GetOrigin() - point, Vector(0, 0, 1)):Normalized() * self.spawn_shot[self.type]
  local spawn_origin = self.parent:GetOrigin() + cross

  if self.bot_script then
    local vDest = self:CalcPosition(self.bot_script.attack_target)
    if vDest then self.parent:MoveToPosition(vDest) end
  end

  ProjectileManager:CreateLinearProjectile({
    Source = self.parent,
    Ability = self.ability,
    vSpawnOrigin = spawn_origin,
    
    bDeleteOnHit = true,
    
    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE,
    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
    
    EffectName = "particles/lawbreaker/lawbreaker_skill2_bullets.vpcf",
    fDistance = self.ability:GetSpecialValueFor("attack_range"),
    fStartRadius = 50,
    fEndRadius = 50,
    vVelocity = direction * self.parent:GetProjectileSpeed(),

    bProvidesVision = true,
    iVisionRadius = 50,
    iVisionTeamNumber = self.parent:GetTeamNumber()
  })

  if IsServer() then
    self.parent:EmitSound("Hero_Snapfire.ExplosiveShellsBuff.Attack")
    self.ability:SetCurrentAbilityCharges(self.ability:GetCurrentAbilityCharges() - 1)
    self:StartIntervalThink(1 / self.speed_mult)
  end
end

-- UTILS -----------------------------------------------------------

function lawbreaker_2_modifier_combo:GetAS()  
  return self.parent:GetMainStat("AGI"):GetTotalAttackSpeed() / 100 * self.parent:GetBaseAttackTime()
end

function lawbreaker_2_modifier_combo:CalcPosition(target)
  if target == nil then return end
  if IsValidEntity(target) == false then return end
  if self.parent:CanEntityBeSeenByMyTeam(target) == false then return end
  if self.parent:IsCommandRestricted() then return end

  local direction = target:GetOrigin() - self.parent:GetOrigin()
  local angle = VectorToAngles(direction)
  local angle_diff = AngleDiff(self.parent:GetAngles().y, angle.y)
  local distance_diff = CalcDistanceBetweenEntityOBB(target, self.parent)
  local attack_range = self.ability:GetSpecialValueFor("attack_range") - 100
  local vDest = target:GetOrigin()

  if distance_diff <= attack_range then
    if angle_diff >= -5 and angle_diff <= 5 then return end
    direction = self.parent:GetForwardVector():Normalized()

    if distance_diff > 150 and angle_diff > -75 and angle_diff < 75 then
      local pos_mult = distance_diff * (math.sin(math.rad(angle_diff)))
      vDest = self.parent:GetOrigin() + CrossVectors(direction, Vector(0, 0, 1)):Normalized() * pos_mult
    else
      vDest = target:GetOrigin() - direction * 200
    end
  end

  return vDest
end

-- EFFECTS -----------------------------------------------------------