_modifier_agi = class ({})

function _modifier_agi:IsHidden() return true end
function _modifier_agi:IsPermanent() return true end
function _modifier_agi:IsPurgable() return false end

function _modifier_agi:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  self.main_bonus = 0

  self.const_base_movespeed = self.ability:GetSpecialValueFor("const_base_movespeed")
  self.const_base_attack_time = self.ability:GetSpecialValueFor("const_base_attack_time")
  self.const_base_mana_regen = self.ability:GetSpecialValueFor("const_base_mana_regen")

  self.data = {
    sub_stat_movespeed = {mult = self.ability:GetSpecialValueFor("sub_stat_movespeed"), bonus = 0},
    sub_stat_atk_speed = {mult = self.ability:GetSpecialValueFor("sub_stat_atk_speed"), bonus = 0},
    sub_stat_dodge = {mult = self.ability:GetSpecialValueFor("sub_stat_dodge"), bonus = 0},
    sub_stat_cooldown_reduction = {mult = self.ability:GetSpecialValueFor("sub_stat_cooldown_reduction"), bonus = 0},
    sub_stat_mana_regen = {mult = self.ability:GetSpecialValueFor("sub_stat_mana_regen"), bonus = 0},
    sub_stat_movespeed_increase = {mult = 0, bonus = 0},
    sub_stat_movespeed_decrease = {mult = 0, bonus = 0},
    sub_stat_movespeed_percent_increase = {mult = 0, bonus = 0},
    sub_stat_movespeed_percent_decrease = {mult = 0, bonus = 0},
    sub_stat_attack_time = {mult = 0, bonus = 0}
  }
end

function _modifier_agi:OnRefresh(kv)
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
    MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
  }

  if self:GetParent():IsHero() or self:GetParent():IsConsideredHero() then
    table.insert(funcs, MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT)
  end

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
  if self.parent:HasModifier("ancient_1_modifier_passive") then return 0 end
  return self:GetCalculedData("sub_stat_atk_speed", false)
end

function _modifier_agi:GetModifierBaseAttackTimeConstant()
  if self.parent:IsRangedAttacker() then
    return self.const_base_attack_time + self:GetCalculedData("sub_stat_attack_time", false) + 0.2
  end
  
  return self.const_base_attack_time + self:GetCalculedData("sub_stat_attack_time", false)
end

function _modifier_agi:GetModifierDodgeProjectile(keys)
  local attacker_str = MainStats(keys.attacker, "STR")
  if attacker_str == nil then return end

  local crit = RandomFloat(0, 100) < attacker_str:GetCriticalChance()
  attacker_str.force_crit_chance = nil
  attacker_str.has_crit = crit

  if keys.attacker:HasModifier("ancient_1_modifier_passive") then return 0 end

  local attacker_missing = RandomFloat(0, 100) < attacker_str:GetMissChance()
  local target_dodge = (crit == false and RandomFloat(0, 100) < self:GetDodge())
  if attacker_missing or target_dodge then return 1 end

  return 0
end

function _modifier_agi:OnAttack(keys)
  local attacker_str = MainStats(keys.attacker, "STR")
  if attacker_str == nil then return end

  if keys.target ~= self.parent then return end
  if keys.attacker:GetAttackCapability() ~= DOTA_UNIT_CAP_MELEE_ATTACK
  and keys.no_attack_cooldown == false then return end

  local crit = RandomFloat(0, 100) < attacker_str:GetCriticalChance()
  attacker_str.force_crit_chance = nil
  attacker_str.has_crit = crit

  if keys.attacker:HasModifier("ancient_1_modifier_passive") then
    attacker_str.missing = false
    return
  end

  local attacker_missing = RandomFloat(0, 100) < attacker_str:GetMissChance()
  local target_dodge = (crit == false and RandomFloat(0, 100) < self:GetDodge())
  attacker_str.missing = (attacker_missing or target_dodge)
end

function _modifier_agi:GetModifierPercentageCooldown()
  return self:GetCalculedData("sub_stat_cooldown_reduction", true)
end

function _modifier_agi:GetModifierConstantManaRegen()
  return self.const_base_mana_regen + self:GetCalculedData("sub_stat_mana_regen", false)
end

-- GETTERS --------------------------------------------------------------------------------

function _modifier_agi:GetBonusMS()
  return self:GetCalculedData("sub_stat_movespeed_increase", false) - self:GetCalculedData("sub_stat_movespeed_decrease", false)
end

function _modifier_agi:GetPercentMS()
  return self:GetCalculedData("sub_stat_movespeed_percent_increase", false) - self:GetCalculedData("sub_stat_movespeed_percent_decrease", false)
end

function _modifier_agi:GetDodge()
  return self:GetCalculedData("sub_stat_dodge", true)
end

function _modifier_agi:UpdateMS(property)
  local value = 0
  local mods = self.parent:FindAllModifiersByName(property)
  for _,modifier in pairs(mods) do value = value + modifier.value end

  self.data[property].bonus = value
end

function _modifier_agi:GetCalculedDataStack(property, bScalar)
  local value = self.data[property].mult * (math.floor(self.ability:GetLevel() / 5))
  if bScalar then value = (value * 6) / (1 +  (value * 0.06)) end
  return value + self.data[property].bonus
end

function _modifier_agi:GetCalculedData(property, bScalar)
  local value = self.data[property].mult * (self.ability:GetLevel() + self.main_bonus)
  if bScalar then value = (value * 6) / (1 +  (value * 0.06)) end
  return value + self.data[property].bonus
end

function _modifier_agi:UpdateMainBonus(value)
  self.main_bonus = value
end

function _modifier_agi:UpdateSubBonus(property)
  local value = 0
  local mods = self.parent:FindAllModifiersByName("sub_stat_modifier")
  for _,modifier in pairs(mods) do value = value + modifier.kv[property] end

  self.data["sub_stat_"..property].bonus = value
end