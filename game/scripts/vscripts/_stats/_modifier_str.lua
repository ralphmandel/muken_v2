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

  self.const_critical_damage = self.ability:GetSpecialValueFor("const_critical_damage")
  self.const_critical_chance = self.ability:GetSpecialValueFor("const_critical_chance")

  if IsServer() then
    self:SetHasCustomTransmitterData(true)
    self.stat_bonus = 0

    self.data = {
      sub_stat_attack_damage = {mult = self.ability:GetSpecialValueFor("sub_stat_attack_damage"), bonus = 0},
      sub_stat_physical_damage = {mult = self.ability:GetSpecialValueFor("sub_stat_physical_damage"), bonus = 0},
      sub_stat_armor = {mult = self.ability:GetSpecialValueFor("sub_stat_armor"), bonus = 0},
      sub_stat_critical_damage = {mult = self.ability:GetSpecialValueFor("sub_stat_critical_damage"), bonus = 0},
      sub_stat_stone_resist = {mult = self.ability:GetSpecialValueFor("sub_stat_stone_resist"), bonus = 0},
      sub_stat_bleed_resist = {mult = self.ability:GetSpecialValueFor("sub_stat_bleed_resist"), bonus = 0},
      sub_stat_sleep_resist = {mult = self.ability:GetSpecialValueFor("sub_stat_sleep_resist"), bonus = 0},
      sub_stat_critical_damage_stack = {mult = 0, bonus = 0},
      sub_stat_critical_chance = {mult = 0, bonus = 0},
      sub_stat_miss_chance = {mult = 0, bonus = 0},
      sub_stat_physical_block = {mult = 0, bonus = 0},
    }

    self:LoadData()
  end
end

function _modifier_str:OnRefresh(kv)
end

function _modifier_str:AddCustomTransmitterData()
  return {
    stat_bonus = self.stat_bonus,
    stat_data = self.data
  }
end

function _modifier_str:HandleCustomTransmitterData(data)
	self.stat_bonus = data.stat_bonus
  self.data = data.stat_data
end

-- PROPERTIES --------------------------------------------------------------------------------

function _modifier_str:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
    --MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    MODIFIER_PROPERTY_MISS_PERCENTAGE,
    MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
    MODIFIER_PROPERTY_PHYSICALDAMAGEOUTGOING_PERCENTAGE,
    MODIFIER_EVENT_ON_TAKEDAMAGE
  }

  return funcs
end

function _modifier_str:GetModifierBaseAttack_BonusDamage()
  return self:GetCalculedData("sub_stat_attack_damage", false)
end

-- function _modifier_str:GetModifierSpellAmplify_Percentage(keys)
--   if keys.damage_category == DOTA_DAMAGE_CATEGORY_ATTACK then return 0 end
--   if keys.damage_flags == 31 then return 0 end
--   if keys.damage_type ~= DAMAGE_TYPE_PHYSICAL then return 0 end

--   return self:GetCalculedData("sub_stat_physical_damage", false)
-- end

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

function _modifier_str:GetModifierPhysical_ConstantBlock(keys)
  local block = self:GetCalculedData("sub_stat_physical_block", false)
  if block > keys.damage then block = keys.damage end

  if block > 0 and self.parent:IsBlockDisabled() == false then self:StartGenericEfxBlock(keys) end

  return block
end

function _modifier_str:GetModifierPhysicalDamageOutgoing_Percentage(keys)
  if keys.damage_category == DOTA_DAMAGE_CATEGORY_ATTACK then
    if keys.damage_flags ~= DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
    and keys.damage_flags ~= 31 and keys.damage_flags ~= 1040 and self.has_crit == true then
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

  if self.has_crit == true and keys.damage_category == DOTA_DAMAGE_CATEGORY_ATTACK then
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
  return self:GetCalculedData("sub_stat_physical_damage", false) + 100
end

function _modifier_str:GetStoneResist()
  return self:GetCalculedData("sub_stat_stone_resist", false)
end

function _modifier_str:GetBleedResist()
  return self:GetCalculedData("sub_stat_bleed_resist", false)
end

function _modifier_str:GetSleepResist()
  return self:GetCalculedData("sub_stat_sleep_resist", false)
end

function _modifier_str:GetCriticalChance()
  local chance = self.parent:GetLuck(self.const_critical_chance) + self:GetCalculedData("sub_stat_critical_chance", false)
  if self.force_crit_chance then chance = self.force_crit_chance end
  if chance < 0 then chance = 0 end
  if chance > 100 then chance = 100 end

  return chance
end

function _modifier_str:GetCriticalDamage()
  if self.force_crit_damage then return self.force_crit_damage end

  local base = self.const_critical_damage + (self:GetCalculedDataStack("sub_stat_critical_damage", true) * 3)
  local stack = self:GetCalculedData("sub_stat_critical_damage_stack", false)

  return base + stack
end

function _modifier_str:GetCalculedDataStack(property, bScalar)
  local value = self.data[property].mult * (math.floor((self.ability:GetLevel() + self.stat_bonus) / 5))
  value = value + self.data[property].bonus
  if bScalar then value = (value * 6) / (1 +  (value * 0.06)) end
  return value
end

function _modifier_str:GetCalculedData(property, bScalar)
  local value = self.data[property].mult * (self.ability:GetLevel() + self.stat_bonus)
  value = value + self.data[property].bonus
  if bScalar then value = (value * 6) / (1 +  (value * 0.06)) end
  return value
end

function _modifier_str:UpdateMainBonus()
  if self.parent == nil then return end
  if IsValidEntity(self.parent) == false then return end

  local value = 0
  local mods = self.parent:FindAllModifiersByName("main_stat_modifier")
  if mods then
    for _,modifier in pairs(mods) do
      if modifier.kv["str"] then
        value = value + modifier.kv["str"]
      end
    end
  end

  self.stat_bonus = value
  self:SendBuffRefreshToClients()
  self.ability:UpdatePanoramaStat()

  for property, table in pairs(self.data) do
    self:OnStatUpated(property)
  end
end

function _modifier_str:UpdateSubBonus(property)
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
  self:OnStatUpated(property)
end

function _modifier_str:OnStatUpated(property)
  if self.parent:IsHero() == false then return end
  local special_kv_modifier = self.parent:FindModifierByName(self.parent:GetHeroName().."_special_values")
  local base_hero_mod = self.parent:GetBaseHeroModifier()
  if special_kv_modifier == nil or base_hero_mod == nil then return end

  if property == "sub_stat_physical_damage" then
    special_kv_modifier:UpdateData("physical_damage", self:GetPhysicalDamageAmp())
    base_hero_mod:UpdateData("physical_damage", self:GetPhysicalDamageAmp())
  end
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