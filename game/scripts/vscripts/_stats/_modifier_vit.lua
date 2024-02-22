_modifier_vit = class ({})

function _modifier_vit:IsHidden() return true end
function _modifier_vit:IsPermanent() return true end
function _modifier_vit:IsPurgable() return false end

function _modifier_vit:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if IsServer() then
    self:SetHasCustomTransmitterData(true)
    self.stat_bonus = 0

    self.data = {
      sub_stat_max_health = {mult = self.ability:GetSpecialValueFor("sub_stat_max_health"), bonus = 0},
      sub_stat_health_regen = {mult = self.ability:GetSpecialValueFor("sub_stat_health_regen"), bonus = 0},
      sub_stat_incoming_buff = {mult = self.ability:GetSpecialValueFor("sub_stat_incoming_buff"), bonus = 0},
      sub_stat_status_resist = {mult = self.ability:GetSpecialValueFor("sub_stat_status_resist"), bonus = 0},
      sub_stat_incoming_heal = {mult = self.ability:GetSpecialValueFor("sub_stat_incoming_heal"), bonus = 0},
      sub_stat_curse_resist = {mult = self.ability:GetSpecialValueFor("sub_stat_curse_resist"), bonus = 0},
      sub_stat_status_resist_stack = {mult = 0, bonus = 0},
      sub_stat_max_health_percent = {mult = 0, bonus = 0}
    }
  
    self:LoadData()    
  end
end

function _modifier_vit:OnRefresh(kv)
end

function _modifier_vit:AddCustomTransmitterData()
  return {
    stat_bonus = self.stat_bonus,
    stat_data = self.data
  }
end

function _modifier_vit:HandleCustomTransmitterData(data)
	self.stat_bonus = data.stat_bonus
  self.data = data.stat_data
end

-- PROPERTIES --------------------------------------------------------------------------------

function _modifier_vit:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
    MODIFIER_PROPERTY_HEALTH_BONUS,
    MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
    MODIFIER_PROPERTY_STATUS_RESISTANCE,
    MODIFIER_EVENT_ON_HEAL_RECEIVED,
  }

  return funcs
end

function _modifier_vit:GetModifierExtraHealthBonus()
  if self:GetParent():IsHero() == false then
    return self:GetBonusHP(1000)
  end

  return 0
end

function _modifier_vit:GetModifierHealthBonus()
  if self:GetParent():IsHero() then
    return self:GetBonusHP(5000)
  end

  return 0
end

function _modifier_vit:GetModifierConstantHealthRegen()
  return self:GetCalculedData("sub_stat_health_regen", false)
end

function _modifier_vit:GetModifierHealAmplify_PercentageTarget()
  return self:GetCalculedDataStack("sub_stat_incoming_heal", false)
end

function _modifier_vit:GetModifierStatusResistance()
  return self:GetCalculedData("sub_stat_status_resist", true)
end

function _modifier_vit:OnHealReceived(keys)
  if keys.unit ~= self.parent then return end
  if keys.inflictor == nil then return end
  if keys.gain < 1 then return end

  SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, keys.unit, keys.gain, keys.unit)

  if keys.inflictor:GetAbilityName() == "bloodstained_2__bloodsteal"
  or keys.inflictor:GetAbilityName() == "bloodstained_4__bloodloss" then
    return
  end

  if IsServer() then self.parent:EmitSound("Effect.Heal") end
end

-- GETTERS --------------------------------------------------------------------------------

function _modifier_vit:GetData(property)
  return self.data[property].bonus
end

function _modifier_vit:GetIncomingHeal()
  return self:GetCalculedDataStack("sub_stat_incoming_heal", false)
end

function _modifier_vit:GetIncomingBuff()
  return self:GetCalculedData("sub_stat_incoming_buff", false) * 0.01
end

function _modifier_vit:GetCurseResist()
  return self:GetCalculedData("sub_stat_curse_resist", false)
end

function _modifier_vit:GetBonusHP(base_hp)
  local bonus_hp = self:GetCalculedData("sub_stat_max_health", false)
  local hp_percent = self:GetCalculedData("sub_stat_max_health_percent", false)
  if hp_percent < -90 then hp_percent = -90 end

  if self.parent:IsHero() == false then base_hp = self.parent:GetBaseMaxHealth() end

  local total = bonus_hp + ((base_hp + bonus_hp) * hp_percent * 0.01)
  if base_hp + total < 100 then total = 100 - base_hp end

  return total
end

function _modifier_vit:GetStatusResist(bPercent)
  local base = self:GetCalculedData("sub_stat_status_resist", bPercent)
  if bPercent == false then return base end

  if self.parent:IsHero() then return self:GetCaster():GetStatusResistance() end
  local base = base + ((100 - base) * self:GetCalculedData("sub_stat_status_resist_stack", false) * 0.01)
  if base < 0 then base = 0 end
  if base > 100 then base = 100 end

  return base * 0.01
end

function _modifier_vit:GetCalculedDataStack(property, bScalar)
  local value = self.data[property].mult * (math.floor((self.ability:GetLevel() + self.stat_bonus) / 5))
  value = value + self.data[property].bonus
  if bScalar then value = (value * 6) / (1 +  (value * 0.06)) end
  return value
end

function _modifier_vit:GetCalculedData(property, bScalar)
  local value = self.data[property].mult * (self.ability:GetLevel() + self.stat_bonus)
  value = value + self.data[property].bonus
  if bScalar then value = (value * 6) / (1 +  (value * 0.06)) end
  return value
end

function _modifier_vit:UpdateMainBonus()
  if self.parent == nil then return end
  if IsValidEntity(self.parent) == false then return end

  local value = 0
  local mods = self.parent:FindAllModifiersByName("main_stat_modifier")
  if mods then
    for _,modifier in pairs(mods) do
      if modifier.kv["vit"] then
        value = value + modifier.kv["vit"]
      end
    end
  end

  self.stat_bonus = value
  self:SendBuffRefreshToClients()
  for property, table in pairs(self.data) do
    self:OnStatUpated(property)
  end
end

function _modifier_vit:UpdateSubBonus(property)
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

function _modifier_vit:OnStatUpated(property)
  if property == "sub_stat_status_resist" or property == "sub_stat_status_resist_stack" then
    for _, status_name in pairs(STATUS_LIST) do
      local status_modifier = self.parent:FindModifierByName(status_name)
      if status_modifier then status_modifier:UpdateStatusBar() end      
    end
  end

  if self.parent:IsHero() == false then return end
  local special_kv_modifier = self.parent:FindModifierByName(GetHeroName(self.parent).."_special_values")
  if special_kv_modifier == nil then return end

  if property == "sub_stat_incoming_buff" then
    special_kv_modifier:UpdateData("buff_amp", self:GetIncomingBuff())
  end
end

function _modifier_vit:LoadData()
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