trickster_1_modifier_passive = class({})

function trickster_1_modifier_passive:IsHidden() return true end
function trickster_1_modifier_passive:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function trickster_1_modifier_passive:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  self.cancel = false
  self.gesture_speed = 0
  self.time_added = 0.12
  self.cycle = 0.6
  self.delay_min = 0.2
  self.delay_max = 2
  self.gesture_min = (self.delay_min + self.time_added) / self.cycle
  self.max_interval_delay = self.delay_max - self.delay_min
  self.max_interval_gesture = self.delay_max - self.gesture_min

  --self.time = GameRules:GetGameTime()
  --print("kuboo", GameRules:GetGameTime() - self.time, self.parent:GetAttackAnimationPoint())
  --self.time = GameRules:GetGameTime()

  if IsServer() then self:StartIntervalThink(0.2) end
end

function trickster_1_modifier_passive:OnRefresh(kv)
end

function trickster_1_modifier_passive:OnRemoved()
end

-- API FUNCTIONS -----------------------------------------------------------

function trickster_1_modifier_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_EVENT_ON_ATTACK_START
	}

	return funcs
end

function trickster_1_modifier_passive:OnOrder(keys)
  if keys.unit ~= self.parent then return end
  if self.cancel == false then return end

  if keys.order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION
  or keys.order_type == DOTA_UNIT_ORDER_HOLD_POSITION then
    self.ability:StartCooldown(self.gesture_speed)
    self.cancel = false
  end
end

function trickster_1_modifier_passive:OnAttackStart(keys)
  if keys.attacker ~= self.parent then return end

  self.cancel = true
  self:CheckBonusAS(keys.target)
  self:CheckDoubleAtk(keys.target)
end

-- UTILS -----------------------------------------------------------

function trickster_1_modifier_passive:CheckBonusAS(target)
  local count = 0

  local enemies = FindUnitsInRadius(
    target:GetTeamNumber(), self.parent:GetOrigin(), nil, self.ability:GetSpecialValueFor("radius"),
    DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
    DOTA_UNIT_TARGET_FLAG_NONE, 0, false
  )

  for _, enemy in pairs(enemies) do
    count = count + 1
  end

  if count > 1 or self.parent:PassivesDisabled() then
    self.parent:RemoveModifierByName("trickster_1_modifier_aspd")
  else
    AddModifier(self.parent, self.ability, "trickster_1_modifier_aspd", {}, false)
  end
end

function trickster_1_modifier_passive:CheckDoubleAtk(target)
  if self.ability:IsCooldownReady() == false then return end
  if self.parent:PassivesDisabled() then return end
  if self:HasHit(target) == false then return end
  if not IsServer() then return end

  print("kubo 1")

  if RandomFloat(0, 100) < self.ability:GetSpecialValueFor("chance") then
    print("kubo 2")

    local delay_speed = self:GetDelaySpeed()
    self.gesture_speed = self:GetGestureSpeed(delay_speed)

    self.parent:AttackNoEarlierThan(delay_speed + self.time_added, 20)
    self.parent:FadeGesture(ACT_DOTA_ATTACK)
    self.parent:FadeGesture(ACT_DOTA_ATTACK_EVENT)
    self.parent:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK_EVENT, 1 / self.gesture_speed)

    Timers:CreateTimer((delay_speed * 0.88) + self.time_added, function()
      self.parent:FadeGesture(ACT_DOTA_ATTACK_EVENT)
    end)
  
    Timers:CreateTimer(self.gesture_speed * 0.30, function()
      if self.ability:IsCooldownReady() then
        self:PerformHit(target)
      end
    end)

    Timers:CreateTimer(self.gesture_speed * 0.47, function()
      if self.ability:IsCooldownReady() then
        self:PerformHit(target)
      end
    end)
  end
end

function trickster_1_modifier_passive:GetDelaySpeed()
  local delay_speed = 1 / self.parent:GetAttacksPerSecond(true)

  if delay_speed < self.delay_min then delay_speed = self.delay_min end
  if delay_speed > self.delay_max then delay_speed = self.delay_max end

  return delay_speed
end

function trickster_1_modifier_passive:GetGestureSpeed(delay_speed)
  local current_interval = self.delay_max - delay_speed
  local gesture_speed = self.delay_max - (self.max_interval_gesture * (current_interval / self.max_interval_delay))

  return gesture_speed
end

function trickster_1_modifier_passive:HasHit(target)
  local attacker_missing = RandomFloat(0, 100) < MainStats(self.parent, "STR"):GetMissChance()
  local target_evasion = false

  if MainStats(target, "AGI") then
    local crit = RandomFloat(0, 100) < MainStats(self.parent, "STR"):GetCriticalChance()
    target_evasion = (crit == false and RandomFloat(0, 100) < MainStats(target, "AGI"):GetEvasion())
  end

  return (attacker_missing == false and target_evasion == false)
end

function trickster_1_modifier_passive:PerformHit(target)
  if self.parent:IsAlive() == false then return end
  if self.parent:IsStunned() then return end
  if self.parent:IsHexed() then return end
  if self.parent:IsFrozen() then return end
  if self.parent:IsOutOfGame() then return end
  if self.parent:IsDisarmed() then return end
  if target == nil then return end
  if IsValidEntity(target) == false then return end
  if target:IsAlive() == false then return end
  if target:IsAttackImmune() then return end

  print("kubo 3")

  if IsServer() then target:EmitSound("Hero_Riki.Backstab") end

  if RandomFloat(0, 100) < self.ability:GetSpecialValueFor("special_bleeding_chance") then
    RemoveAllModifiersByNameAndAbility(target, "_modifier_bleeding", self)
    AddModifier(target, self.ability, "_modifier_bleeding", {
      duration = self.ability:GetSpecialValueFor("special_bleeding_duration")
    }, true)
  end

  if self:IsBack(target) then
    AddModifier(self.parent, self.ability, "trickster_1_modifier_bonus_damage", {}, false)
    if self.ability:GetSpecialValueFor("special_bonus_damage") > 0 then
      self:PlayEfxBackAttack(target)
    end
  end

  MainStats(self.parent, "STR"):SetForceCrit(0, nil)
  self.parent:PerformAttack(target, false, true, true, false, false, false, true)
  self.parent:RemoveModifierByName("trickster_1_modifier_bonus_damage")
end

function  trickster_1_modifier_passive:IsBack(target)
  local victim_angle = target:GetAnglesAsVector().y
  local origin_difference = target:GetAbsOrigin() - self.parent:GetAbsOrigin()
  local origin_difference_radian = math.atan2(origin_difference.y, origin_difference.x)
  origin_difference_radian = origin_difference_radian * 180

  local attacker_angle = origin_difference_radian / math.pi
  attacker_angle = attacker_angle + 180.0 + 30.0

  local result_angle = attacker_angle - victim_angle
  result_angle = math.abs(result_angle)

  if result_angle >= (180 - (self.ability:GetSpecialValueFor("back_angle") / 2))
  and result_angle <= (180 + (self.ability:GetSpecialValueFor("back_angle") / 2)) then
    return true
  end

  return false
end

-- EFFECTS -----------------------------------------------------------

function trickster_1_modifier_passive:PlayEfxBackAttack(target)
  local string = "particles/units/heroes/hero_riki/riki_backstab.vpcf"
  local particle = ParticleManager:CreateParticle(string, PATTACH_ABSORIGIN_FOLLOW, target)
  ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
  ParticleManager:ReleaseParticleIndex(particle)
end