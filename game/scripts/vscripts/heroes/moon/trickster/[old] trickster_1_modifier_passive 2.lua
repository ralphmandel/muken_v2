trickster_1_modifier_passive = class({})

function trickster_1_modifier_passive:IsHidden() return true end
function trickster_1_modifier_passive:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function trickster_1_modifier_passive:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()
  self.bonus_enabled = false
  self.passives_disabled = false

  --self.time = GameRules:GetGameTime()

  if IsServer() then self:StartIntervalThink(0.2) end
end

function trickster_1_modifier_passive:OnRefresh(kv)
  if self.bonus_enabled == true and self.parent:PassivesDisabled() == false then
    AddModifier(self.parent, self.ability, "trickster_1_modifier_aspd", {}, false)
  end
end

function trickster_1_modifier_passive:OnRemoved()
  self.parent:RemoveModifierByName("trickster_1_modifier_aspd")
end

-- API FUNCTIONS -----------------------------------------------------------

function trickster_1_modifier_passive:DeclareFunctions()
	local funcs = {
    MODIFIER_EVENT_ON_STATE_CHANGED,
		MODIFIER_EVENT_ON_ATTACK_START
	}

	return funcs
end

function trickster_1_modifier_passive:OnStateChanged(keys)
  if keys.unit ~= self.parent then return end

  if self.passives_disabled == false and self.parent:PassivesDisabled() then
    self.passives_disabled = true

    if self.bonus_enabled == false then
      self.parent:RemoveModifierByName("trickster_1_modifier_aspd")
    end
  end

  if self.passives_disabled == true and self.parent:PassivesDisabled() == false then
    self.passives_disabled = false      

    if self.bonus_enabled == true then
      AddModifier(self.parent, self.ability, "trickster_1_modifier_aspd", {}, false)
    end
  end
end

function trickster_1_modifier_passive:OnAttackStart(keys)
  --print("kuboo", GameRules:GetGameTime() - self.time, self.parent:GetAttackAnimationPoint())
  --self.time = GameRules:GetGameTime()
  if keys.attacker ~= self.parent then return end
  if self.parent:PassivesDisabled() then return end
  if not IsServer() then return end

  if self:HasHit(keys.target) == true and RandomFloat(0, 100) < self.ability:GetSpecialValueFor("chance") then
    local speed = self.parent:GetAttacksPerSecond()
    self.parent:AttackNoEarlierThan((1 / speed) + 0.12, 20)
    self.parent:FadeGesture(ACT_DOTA_ATTACK)
    self.parent:FadeGesture(ACT_DOTA_ATTACK_EVENT)
    self.parent:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK_EVENT, speed)

    Timers:CreateTimer((1 / speed), function()
      self.parent:FadeGesture(ACT_DOTA_ATTACK_EVENT)
    end)
  
    Timers:CreateTimer((1 / speed) * 0.25, function()
      self:PerformHit(keys.target)
    end)

    Timers:CreateTimer((1 / speed) * 0.39, function()
      self:PerformHit(keys.target)
    end)
  end
end

function trickster_1_modifier_passive:OnIntervalThink()
  local bonus_enabled = true
  local targets_near = {}

  local enemies = FindUnitsInRadius(
    self.caster:GetTeamNumber(), self.parent:GetOrigin(), nil, self.ability:GetAOERadius(),
    self.ability:GetAbilityTargetTeam(), self.ability:GetAbilityTargetType(),
    self.ability:GetAbilityTargetFlags(), 0, false
  )

  for _, enemy in pairs(enemies) do
    local team_number = enemy:GetTeamNumber()
    
    if targets_near[team_number] then
      bonus_enabled = false
      break
    end

    targets_near[team_number] = true
  end

  if self.bonus_enabled == true then
    if bonus_enabled == false then
      self.parent:RemoveModifierByName("trickster_1_modifier_aspd")
    end
  else
    if bonus_enabled == true and self.parent:PassivesDisabled() == false then
      AddModifier(self.parent, self.ability, "trickster_1_modifier_aspd", {}, false)
    end
  end

  self.bonus_enabled = bonus_enabled

  if IsServer() then self:StartIntervalThink(0.2) end
end

-- UTILS -----------------------------------------------------------

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
  if target == nil then return end
  if IsValidEntity(target) == false then return end
  if target:IsAlive() == false then return end

  MainStats(self.parent, "STR"):SetForceCrit(0, nil)
  self.parent:PerformAttack(target, false, true, true, false, false, false, true)
end

-- EFFECTS -----------------------------------------------------------