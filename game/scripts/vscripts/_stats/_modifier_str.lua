_modifier_str = class ({})

function _modifier_str:IsHidden() return true end
function _modifier_str:IsPermanent() return true end
function _modifier_str:IsPurgable() return false end

function _modifier_str:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()
  self.force_crit_damage = nil
  self.force_crit_chance = nil
  self.has_crit = false
  self.missing = false

  self.main_bonus = 0

  self.const_critical_damage = self.ability:GetSpecialValueFor("const_critical_damage")

  self.data = {
    sub_stat_attack_damage = {mult = self.ability:GetSpecialValueFor("sub_stat_attack_damage"), bonus = 0},
    sub_stat_physical_damage = {mult = self.ability:GetSpecialValueFor("sub_stat_physical_damage"), bonus = 0},
    sub_stat_critical_chance = {mult = self.ability:GetSpecialValueFor("sub_stat_critical_chance"), bonus = 0},
    sub_stat_armor = {mult = self.ability:GetSpecialValueFor("sub_stat_armor"), bonus = 0},
    sub_stat_critical_damage = {mult = 0, bonus = 0},
    sub_stat_miss_chance = {mult = 0, bonus = 0}
  }

  self:LoadData()
end

function _modifier_str:OnRefresh(kv)
end

-- PROPERTIES --------------------------------------------------------------------------------

function _modifier_str:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    MODIFIER_PROPERTY_MISS_PERCENTAGE,
    MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    MODIFIER_EVENT_ON_TAKEDAMAGE
  }

  return funcs
end

function _modifier_str:GetModifierBaseAttack_BonusDamage()
  return self:GetCalculedData("sub_stat_attack_damage", false)
end

function _modifier_str:GetModifierSpellAmplify_Percentage(keys)
  if keys.damage_category == DOTA_DAMAGE_CATEGORY_ATTACK then return 0 end
  if keys.damage_flags == 31 then return 0 end
  if keys.damage_type ~= DAMAGE_TYPE_PHYSICAL then return 0 end

  return self:GetCalculedDataStack("sub_stat_physical_damage", false)
end

function _modifier_str:GetModifierPhysicalArmorBonus()
  return self:GetCalculedData("sub_stat_armor", false)
end

function _modifier_str:GetModifierMiss_Percentage(keys)
  if self.missing == true then
    self.missing = false
    return 100
  end
  return 0
end

function _modifier_str:GetModifierTotalDamageOutgoing_Percentage(keys)
  if keys.damage_flags ~= 1024 then
    if keys.damage_category ~= DOTA_DAMAGE_CATEGORY_ATTACK then return 0 end

    if keys.damage_flags ~= 31 then
      if self.has_crit == true then
        local crit_damage = self:GetCriticalDamage()
        self.force_crit_damage = nil
        return crit_damage - 100
      end
    end
  end

  if keys.damage_flags ~= 31 then
    if self.has_crit == true then
      local crit_damage = self:GetCriticalDamage()
      self.force_crit_damage = nil
      return crit_damage - 100
    end
  end

  return 0
end

function _modifier_str:OnTakeDamage(keys)
  if keys.attacker == nil then return end
  if keys.attacker:IsBaseNPC() == false then return end
  if keys.attacker ~= self.parent then return end
  if self.has_crit == false then return end

  if keys.damage_category == DOTA_DAMAGE_CATEGORY_ATTACK or keys.damage_flags == 1024 then
    self:PopupSpellCrit(keys.damage, keys.unit, DAMAGE_TYPE_PHYSICAL)
  end
end

-- SETTERS/GETTERS --------------------------------------------------------------------------------

function _modifier_str:GetData(property)
  return self.data[property].bonus
end

function _modifier_str:SetForceCrit(chance, damage)
  self.force_crit_chance = chance
  self.force_crit_damage = damage
end

function _modifier_str:GetMissChance()
  return self:GetCalculedData("sub_stat_miss_chance", false)
end

function _modifier_str:GetPhysicalDamageAmp()
  return self:GetCalculedDataStack("sub_stat_physical_damage", false) + 100
end

function _modifier_str:GetCriticalChance()
  if self.force_crit_chance then return self.force_crit_chance end
  return self:GetCalculedData("sub_stat_critical_chance", true)
end

function _modifier_str:GetCriticalDamage()
  if self.force_crit_damage then return self.force_crit_damage end
  return self.const_critical_damage + self:GetCalculedData("sub_stat_critical_damage", false)
end

function _modifier_str:GetCalculedDataStack(property, bScalar)
  local value = self.data[property].mult * (math.floor(self.ability:GetLevel() / 5))
  value = value + self.data[property].bonus
  if bScalar then value = (value * 6) / (1 +  (value * 0.06)) end
  return value
end

function _modifier_str:GetCalculedData(property, bScalar)
  local value = self.data[property].mult * (self.ability:GetLevel() + self.main_bonus)
  value = value + self.data[property].bonus
  if bScalar then value = (value * 6) / (1 +  (value * 0.06)) end
  return value
end

function _modifier_str:UpdateMainBonus(value)
  self.main_bonus = value
end

function _modifier_str:UpdateSubBonus(property)
  local value = 0
  local mods = self.parent:FindAllModifiersByName("sub_stat_modifier")
  for _,modifier in pairs(mods) do value = value + modifier.kv[property] end

  self.data["sub_stat_"..property].bonus = value
end

function _modifier_str:LoadData()
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

-- EFFECTS --------------------------------------------------------------------------------

function _modifier_str:PopupSpellCrit(damage, target, damage_type)
  SendOverheadEventMessage(nil, OVERHEAD_ALERT_CRITICAL, target, math.floor(damage), target)
  if IsServer() then target:EmitSound("Item_Desolator.Target") end
end