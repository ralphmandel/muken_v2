_modifier__ai = class({})
function _modifier__ai:IsHidden() return true end

-- if enemy:GetTeamNumber() ~= TIER_TEAMS[RARITY_COMMON] and enemy:GetTeamNumber() < TIER_TEAMS[RARITY_RARE] then
-- end

local AI_STATE_IDLE = 0
local AI_STATE_AGGRESSIVE = 1
local AI_STATE_RETURNING = 2
local AI_THINK_INTERVAL = 0.25

function _modifier__ai:OnCreated(kv)
  self.ability = self:GetAbility()

  -- Only do AI on server
  if IsServer() then
    self:SetHasCustomTransmitterData(true)

    self.state = AI_STATE_IDLE
    self.aggroRange = 400
    self.leashRange = 1000
    self.returning_agressive = false

    self.unit = self:GetParent()

    self:ChangeModelColor()

    Timers:CreateTimer((0.2), function()
      self.spawnPos = self.unit:GetOrigin()
      self:ChangeModelScale()
      self.unit:GiveMana(9999)
    end)

    self.stateActions = {
      [AI_STATE_IDLE] = self.IdleThink,
      [AI_STATE_AGGRESSIVE] = self.AggressiveThink,
      [AI_STATE_RETURNING] = self.ReturningThink,
    }

    self:StartIntervalThink(AI_THINK_INTERVAL)
    self:PlayEfxStart()
  end
end

function _modifier__ai:AddCustomTransmitterData()
  return {
    state = self.state
  }
end

function _modifier__ai:HandleCustomTransmitterData(data)
	self.state = data.state
end

function _modifier__ai:OnIntervalThink()
  if not IsServer() then return end

  if self.unit:IsDominated() then
    RemoveAllModifiersByNameAndAbility(self.unit, "sub_stat_movespeed_increase", self.ability)
    return
  end

  self.stateActions[self.state](self)
  self:StartIntervalThink(AI_THINK_INTERVAL)
end

function _modifier__ai:IdleThink()
  RemoveAllModifiersByNameAndAbility(self.unit, "sub_stat_movespeed_increase", self.ability)

  local target = self:FindNewTarget()

  if target then
    self.aggroTarget = target
    self.unit:MoveToTargetToAttack(self.aggroTarget)
    self:SetState(AI_STATE_AGGRESSIVE)
    return
  end

  local aggro = self.unit:GetAggroTarget()

  if aggro then
    self.unit:MoveToPosition(self.spawnPos)
  end
end

function _modifier__ai:CheckTarget(target)
  if target == nil then return false end
  if IsValidEntity(target) == false then return false end
  if not target:IsAlive() then return false end
  if target:IsOutOfGame() or target:IsInvisible() then return false end

  if self.unit:GetAggroTarget() then
    if self.unit:GetAggroTarget() ~= target then
      return false
    end
  end

  return true
end

function _modifier__ai:AggressiveThink()
  if (self.spawnPos - self.unit:GetAbsOrigin()):Length() > self.leashRange then
    self:SetReturning(false)
    return
  end

  if self:CheckTarget(self.aggroTarget) == false then
    local new_target = self:FindNewTarget()
    if new_target then
      self.aggroTarget = new_target
    else
      self:SetReturning(true)
      return
    end
  end

  self.unit:MoveToTargetToAttack(self.aggroTarget)

  local units = FindUnitsInRadius(
    self.unit:GetTeam(), self.unit:GetAbsOrigin(), nil, 800,
    DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE,
    FIND_ANY_ORDER, false
  )

  for _,unit in pairs(units) do
    local ai = unit:FindModifierByName("_modifier__ai")
    if ai then
      if ai.state == AI_STATE_IDLE then
        ai.aggroTarget = self.aggroTarget
        ai.state = AI_STATE_AGGRESSIVE
      end
    end
  end
  
  RemoveAllModifiersByNameAndAbility(self.unit, "sub_stat_movespeed_increase", self.ability)
end

function _modifier__ai:ReturningThink()
  if self.returning_agressive == true then
    local target = self:FindNewTarget()

    if target then
      self.aggroTarget = target
      self.unit:MoveToTargetToAttack(self.aggroTarget)
      self:SetState(AI_STATE_AGGRESSIVE)
      return
    end
  end

  if (self.spawnPos - self.unit:GetAbsOrigin()):Length() < 10 then
    self:SetState(AI_STATE_IDLE)
    return
  end

  self.unit:Purge(false, true, false, true, false)
  self.unit:MoveToPosition(self.spawnPos)

  RemoveAllModifiersByNameAndAbility(self.unit, "sub_stat_movespeed_increase", self.ability)
  AddModifier(self.unit, self.ability, "sub_stat_movespeed_increase", {value = 300}, false)
end

function _modifier__ai:FindNewTarget()
  local enemies = FindUnitsInRadius(
    self.unit:GetTeam(), self.spot_origin, nil, self.aggroRange,
    DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL,
    DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, 
    FIND_ANY_ORDER, false
  )

	for _,enemy in pairs(enemies) do
    if enemy:GetTeamNumber() ~= TIER_TEAMS[RARITY_COMMON] and enemy:GetTeamNumber() < TIER_TEAMS[RARITY_RARE] then
      if enemy:IsIllusion() == false then return enemy end
    end
	end
end

function _modifier__ai:SetReturning(aggressive)
  self.unit:MoveToPosition(self.spawnPos)
  self.returning_agressive = aggressive
  self:SetState(AI_STATE_RETURNING)
end

function _modifier__ai:SetState(new_state)
  self.state = new_state
  self:SendBuffRefreshToClients()
end

-----------------------------------------------------------

function _modifier__ai:CheckState()
	local state = {}

    if self.state == AI_STATE_IDLE then
      state = {[MODIFIER_STATE_MAGIC_IMMUNE] = true}
    end

	return state
end

function _modifier__ai:DeclareFunctions()
	local funcs = {
    MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
    MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
    MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
    MODIFIER_PROPERTY_PRE_ATTACK,

    MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
	}

	return funcs
end

function _modifier__ai:GetAbsoluteNoDamagePhysical(keys)
  if self.state == AI_STATE_IDLE then return 1 end
  return 0
end

function _modifier__ai:GetAbsoluteNoDamageMagical(keys)
  if self.state == AI_STATE_IDLE then return 1 end
  return 0
end

function _modifier__ai:GetAbsoluteNoDamagePure(keys)
  if self.state == AI_STATE_IDLE then return 1 end
  return 0
end

function _modifier__ai:GetModifierPreAttack(keys)
  if not IsServer() then return end

	if keys.attacker ~= self.unit then return 0 end
  local sound = ""
  
  if self.unit:GetUnitName() == "neutral_epic_igneo" then sound = "Hero_WarlockGolem.PreAttack" end
  if self.unit:GetUnitName() == "neutral_epic_great_igneo" then sound = "Hero_WarlockGolem.PreAttack" end

	self.unit:EmitSound(sound)
end


function _modifier__ai:OnAttack(keys)
  if not IsServer() then return end

	if keys.attacker ~= self.unit then return end
  local sound = ""

  if self.unit:GetUnitName() == "neutral_common_great_gargoyle" then sound = "Hero_LoneDruid.Attack" end
  if self.unit:GetUnitName() == "neutral_common_gargoyle" then sound = "Hero_LoneDruid.Attack" end
  if self.unit:GetUnitName() == "neutral_common_drake" then sound = "Hero_DragonKnight.ElderDragonShoot3.Attack" end
  if self.unit:GetUnitName() == "neutral_rare_mage" then sound = "Hero_Ancient_Apparition.Attack" end
  if self.unit:GetUnitName() == "neutral_legendary_spider" then sound = "hero_viper.attack" end

	self.unit:EmitSound(sound)
end

function _modifier__ai:OnAttackLanded(keys)
  if not IsServer() then return end

	if keys.attacker ~= self.unit then return end
  local sound = ""

  if self.unit:GetUnitName() == "neutral_common_chameleon_a" then sound = "Hero_Meepo.Attack" end
  if self.unit:GetUnitName() == "neutral_common_chameleon_b" then sound = "Hero_Meepo.Attack" end
  if self.unit:GetUnitName() == "neutral_common_crocodilian_a" then sound = "Hero_Slardar.Attack" end
  if self.unit:GetUnitName() == "neutral_common_crocodilian_b" then sound = "Hero_Slardar.Attack" end
  if self.unit:GetUnitName() == "neutral_common_great_gargoyle" then sound = "Hero_LoneDruid.ProjectileImpact" end
  if self.unit:GetUnitName() == "neutral_common_gargoyle" then sound = "Hero_LoneDruid.ProjectileImpact" end
  if self.unit:GetUnitName() == "neutral_common_drake" then sound = "Hero_DragonKnight.ProjectileImpact" end
  if self.unit:GetUnitName() == "neutral_common_skeleton" then sound = "Hero_SkeletonKing.Attack" end
  if self.unit:GetUnitName() == "neutral_rare_crocodile" then sound = "Hero_Slardar.Attack" end
  if self.unit:GetUnitName() == "neutral_rare_frostbitten" then sound = "Hero_DarkSeer.Attack" end
  if self.unit:GetUnitName() == "neutral_rare_skydragon" then sound = "Hero_Magnataur.Attack" end
  if self.unit:GetUnitName() == "neutral_rare_dragon" then sound = "Hero_Magnataur.Attack" end
  if self.unit:GetUnitName() == "neutral_rare_mage" then sound = "Hero_Ancient_Apparition.ProjectileImpact" end
  if self.unit:GetUnitName() == "neutral_epic_igneo" then sound = "Hero_Undying_Golem.Attack" end
  if self.unit:GetUnitName() == "neutral_epic_great_igneo" then sound = "Hero_Undying_Golem.Attack" end
  if self.unit:GetUnitName() == "neutral_epic_lamp" then sound = "Hero_Spirit_Breaker.Attack" end
  if self.unit:GetUnitName() == "neutral_legendary_great_lamp" then sound = "Hero_Spirit_Breaker.Attack" end
  if self.unit:GetUnitName() == "neutral_legendary_iron_golem" then sound = "Krieger.Attack" end
  if self.unit:GetUnitName() == "neutral_legendary_gorillaz" then sound = "Hero_LoneDruid.TrueForm.Attack" end
  if self.unit:GetUnitName() == "neutral_legendary_spider" then sound = "hero_viper.projectileImpact" end

	keys.target:EmitSound(sound)
end

function _modifier__ai:GetAttackSound(keys)
  return ""
end

function _modifier__ai:ChangeModelScale()
  if self.unit:GetUnitName() == "neutral_common_chameleon_a" then self.unit:SetModelScale(0.9) end
  if self.unit:GetUnitName() == "neutral_common_chameleon_b" then self.unit:SetModelScale(1) end
  if self.unit:GetUnitName() == "neutral_common_crocodilian_a" then self.unit:SetModelScale(1.3) end
  if self.unit:GetUnitName() == "neutral_common_crocodilian_b" then self.unit:SetModelScale(1.3) end
  if self.unit:GetUnitName() == "neutral_common_great_gargoyle" then self.unit:SetModelScale(1) end
  if self.unit:GetUnitName() == "neutral_common_gargoyle" then self.unit:SetModelScale(0.8) end
  if self.unit:GetUnitName() == "neutral_common_skeleton" then self.unit:SetModelScale(1.4) end
  if self.unit:GetUnitName() == "neutral_rare_crocodile" then self.unit:SetModelScale(1.4) end
  if self.unit:GetUnitName() == "neutral_rare_frostbitten" then self.unit:SetModelScale(1.1) end
  if self.unit:GetUnitName() == "neutral_rare_skydragon" then self.unit:SetModelScale(1) end
  if self.unit:GetUnitName() == "neutral_rare_dragon" then self.unit:SetModelScale(0.9) end
  if self.unit:GetUnitName() == "neutral_rare_mage" then self.unit:SetModelScale(1.5) end
  if self.unit:GetUnitName() == "neutral_epic_lamp" then self.unit:SetModelScale(1.4) end
  if self.unit:GetUnitName() == "neutral_legendary_great_lamp" then self.unit:SetModelScale(1.5) end
  if self.unit:GetUnitName() == "neutral_legendary_iron_golem" then self.unit:SetModelScale(1.2) end
  if self.unit:GetUnitName() == "neutral_legendary_gorillaz" then self.unit:SetModelScale(1.2) end
  if self.unit:GetUnitName() == "neutral_legendary_spider" then self.unit:SetModelScale(1) end
end

function _modifier__ai:ChangeModelColor()
  if self.unit:GetUnitName() == "neutral_common_drake" then self.unit:SetMaterialGroup("3") end
end

function _modifier__ai:PlayEfxStart()
	local string = nil
  if self.unit:GetTeamNumber() == TIER_TEAMS[RARITY_RARE] then string = "particles/neutral_auras/rare/aura_rare_lvl3.vpcf" end
  if self.unit:GetTeamNumber() == TIER_TEAMS[RARITY_EPIC] then string = "particles/neutral_auras/epic/aura_epic_lvl3.vpcf" end
  if self.unit:GetTeamNumber() == TIER_TEAMS[RARITY_LEGENDARY] then string = "particles/neutral_auras/legendary/aura_legendary_lvl3.vpcf" end

  if string then
    local particle = ParticleManager:CreateParticle(string, PATTACH_ABSORIGIN_FOLLOW, self.unit)
    ParticleManager:SetParticleControl(particle, 0, self.unit:GetOrigin())
    ParticleManager:SetParticleControl(particle, 1, self.unit:GetAbsOrigin())
    self:AddParticle(particle, false, false, -1, false, false)
  end
end