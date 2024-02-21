_modifier_agi = class ({})

function _modifier_agi:IsHidden() return true end
function _modifier_agi:IsPermanent() return true end
function _modifier_agi:IsPurgable() return false end

function _modifier_agi:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  self.const_base_movespeed = self.ability:GetSpecialValueFor("const_base_movespeed")
  self.const_base_attack_time = self.ability:GetSpecialValueFor("const_base_attack_time")
  self.const_base_mana_regen = self.ability:GetSpecialValueFor("const_base_mana_regen")

  if IsServer() then
    self:SetHasCustomTransmitterData(true)
    self.stat_bonus = 0

    self.data = {
      sub_stat_attack_speed = {mult = self.ability:GetSpecialValueFor("sub_stat_attack_speed"), bonus = 0},
      sub_stat_cooldown_reduction = {mult = self.ability:GetSpecialValueFor("sub_stat_cooldown_reduction"), bonus = 0},
      sub_stat_mana_regen = {mult = self.ability:GetSpecialValueFor("sub_stat_mana_regen"), bonus = 0},
      sub_stat_evasion = {mult = self.ability:GetSpecialValueFor("sub_stat_evasion"), bonus = 0},
      sub_stat_movespeed = {mult = self.ability:GetSpecialValueFor("sub_stat_movespeed"), bonus = 0},
      sub_stat_poison_resist = {mult = self.ability:GetSpecialValueFor("sub_stat_poison_resist"), bonus = 0},
      sub_stat_thunder_resist = {mult = self.ability:GetSpecialValueFor("sub_stat_thunder_resist"), bonus = 0},
      sub_stat_bleed_resist = {mult = self.ability:GetSpecialValueFor("sub_stat_bleed_resist"), bonus = 0},
      sub_stat_speed = {mult = 0, bonus = 0},
      sub_stat_speed_percent = {mult = 0, bonus = 0},
      sub_stat_slow = {mult = 0, bonus = 0},
      sub_stat_slow_percent = {mult = 0, bonus = 0},
      sub_stat_attack_time = {mult = 0, bonus = 0}
    }
    
    self:LoadData()
  end
end

function _modifier_agi:OnRefresh(kv)
end

function _modifier_agi:AddCustomTransmitterData()
  return {
    stat_bonus = self.stat_bonus,
    stat_data = self.data
  }
end

function _modifier_agi:HandleCustomTransmitterData(data)
	self.stat_bonus = data.stat_bonus
  self.data = data.stat_data
end

-- PROPERTIES --------------------------------------------------------------------------------

function _modifier_agi:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
    MODIFIER_PROPERTY_MOVESPEED_LIMIT,
    MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    MODIFIER_PROPERTY_DODGE_PROJECTILE,
    MODIFIER_EVENT_ON_ATTACK,
    MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
    MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
    MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT
  }

  return funcs
end

function _modifier_agi:GetModifierIgnoreMovespeedLimit()
  return 1
end

function _modifier_agi:GetModifierMoveSpeed_Limit()
  local min = 50
  local max = 2000
  local base = self.const_base_movespeed + self:GetCalculedDataStack("sub_stat_movespeed", false)
  local amount = math.floor((base - min) * (1 + (self:GetPercentMS() * 0.01))) + self:GetBonusMS() + min
  if amount < min then amount = min end
  if amount > max then amount = max end

  return amount
end

function _modifier_agi:GetModifierTurnRate_Percentage()
  return self:GetPercentMS()
end

function _modifier_agi:GetModifierAttackSpeedBonus_Constant()
  return self:GetTotalAttackSpeed() - 100
end

function _modifier_agi:GetModifierBaseAttackTimeConstant()  
  return self:GetBAT()
end

function _modifier_agi:GetModifierDodgeProjectile(keys)
  local attacker_str = keys.attacker:GetMainStat("STR")

  local crit = RandomFloat(0, 100) < attacker_str:GetCriticalChance()
  attacker_str.force_crit_chance = nil
  attacker_str.has_crit = crit

  if keys.attacker:HasModifier("ancient_3_modifier_passive")
  or self.parent:HasModifier("ancient_3_modifier_passive") then
    return 0
  end

  local attacker_missing = RandomFloat(0, 100) < attacker_str:GetMissChance()
  local target_evasion = (crit == false and RandomFloat(0, 100) < self:GetEvasion(true))
  if attacker_missing or target_evasion then
    SendOverheadEventMessage(nil, OVERHEAD_ALERT_MISS, self.parent, 0, self.parent)
    self.proj_miss_attacker = keys.attacker
    return 1
  end

  self.proj_miss_attacker = nil

  return 0
end

function _modifier_agi:OnAttack(keys)
  local attacker_str = keys.attacker:GetMainStat("STR")
  if attacker_str == nil then return end

  if keys.target ~= self.parent then return end
  if keys.attacker:GetAttackCapability() ~= DOTA_UNIT_CAP_MELEE_ATTACK
  and keys.no_attack_cooldown == false then return end

  local crit = RandomFloat(0, 100) < attacker_str:GetCriticalChance()
  attacker_str.force_crit_chance = nil
  attacker_str.has_crit = crit

  if keys.attacker:HasModifier("ancient_3_modifier_passive")
  or self.parent:HasModifier("ancient_3_modifier_passive") then
    attacker_str.missing = false
    return
  end

  local attacker_missing = RandomFloat(0, 100) < attacker_str:GetMissChance()
  local target_evasion = (crit == false and RandomFloat(0, 100) < self:GetEvasion(true))
  attacker_str.missing = (attacker_missing or target_evasion)
end

function _modifier_agi:GetModifierPercentageCooldown()
  return self:GetCalculedData("sub_stat_cooldown_reduction", true)
end

function _modifier_agi:GetModifierConstantManaRegen()
  if self.parent:HasModifier("ancient_u_modifier_passive") then return 0 end
  
  return self.const_base_mana_regen + self:GetCalculedData("sub_stat_mana_regen", false)
end

-- GETTERS --------------------------------------------------------------------------------

function _modifier_agi:GetData(property)
  return self.data[property].bonus
end

function _modifier_agi:GetCooldownReduction()
  return self:GetCalculedData("sub_stat_cooldown_reduction", false)
end

function _modifier_agi:GetPoisonResist()
  return self:GetCalculedData("sub_stat_poison_resist", false)
end

function _modifier_agi:GetThunderResist()
  return self:GetCalculedData("sub_stat_thunder_resist", false)
end

function _modifier_agi:GetBleedResist()
  return self:GetCalculedData("sub_stat_bleed_resist", false)
end

function _modifier_agi:GetBonusMS()
  local result = self:GetCalculedData("sub_stat_speed", false)

  if self.parent:HasModifier("_modifier_unslowable") == false then
    result = result - self:GetCalculedData("sub_stat_slow", false)
  end

  return result
end

function _modifier_agi:GetPercentMS()
  local result = self:GetCalculedData("sub_stat_speed_percent", false)

  if self.parent:HasModifier("_modifier_unslowable") == false then
    result = result - self:GetCalculedData("sub_stat_slow_percent", false)
  end

  return result
end

function _modifier_agi:GetTotalAttackSpeed()
  if self.parent:HasModifier("ancient_3_modifier_passive") then return 100 end
  return self:GetCalculedData("sub_stat_attack_speed", false) + 100
end

function _modifier_agi:GetBAT()
  if self.parent:IsRangedAttacker() then
    return self.const_base_attack_time + self:GetCalculedData("sub_stat_attack_time", false) + 0.2
  end
  
  return self.const_base_attack_time + self:GetCalculedData("sub_stat_attack_time", false)
end

function _modifier_agi:GetEvasion(bPercent)
  local evasion = self:GetCalculedData("sub_stat_evasion", bPercent)

  if bPercent then
    if evasion < 0 then evasion = 0 end
    if evasion > 100 then evasion = 100 end
  end

  return evasion
end

function _modifier_agi:GetCalculedDataStack(property, bScalar)
  local value = self.data[property].mult * (math.floor((self.ability:GetLevel() + self.stat_bonus) / 5))
  value = value + self.data[property].bonus
  if bScalar then value = (value * 6) / (1 +  (value * 0.06)) end
  return value
end

function _modifier_agi:GetCalculedData(property, bScalar)
  local value = self.data[property].mult * (self.ability:GetLevel() + self.stat_bonus)
  value = value + self.data[property].bonus
  if bScalar then value = (value * 6) / (1 +  (value * 0.06)) end
  return value
end

function _modifier_agi:UpdateMainBonus(value)
  self.stat_bonus = value
  
  self:SendBuffRefreshToClients()
  
  for property, table in pairs(self.data) do
    --self:OnStatUpated(property)
  end
end

function _modifier_agi:UpdateSubBonus(property)
  if self.parent == nil then return end
  if IsValidEntity(self.parent) == false then return end

  local value = 0
  local mods = self.parent:FindAllModifiersByName("sub_stat_modifier")
  if mods then
    for _,modifier in pairs(mods) do
      if modifier.kv[property] then
        value = value + modifier.kv[property]
      end
    end
  end

  self.data["sub_stat_"..property].bonus = value
  self:SendBuffRefreshToClients()
end

function _modifier_agi:LoadData()
  if self.parent:IsIllusion() then
    for _, hero in pairs(HeroList:GetAllHeroes()) do
      if hero:IsIllusion() == false and hero:GetUnitName() == self.parent:GetUnitName() then
        local mod = hero:FindModifierByName(self:GetName())
        for property, table in pairs(self.data) do
          self.data[property].bonus = mod:GetData(property)
        end

        self.ability:SetLevel(mod:GetAbility():GetLevel())
        return
      end
    end
  else
    for property, table in pairs(self.data) do
      self.data[property].bonus = 0
    end
  end
end