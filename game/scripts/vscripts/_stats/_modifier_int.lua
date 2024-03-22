_modifier_int = class ({})

function _modifier_int:IsHidden() return true end
function _modifier_int:IsPermanent() return true end
function _modifier_int:IsPurgable() return false end

function _modifier_int:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()
  self.crit_popup = {}

  if IsServer() then
    self:SetHasCustomTransmitterData(true)
    self.stat_bonus = 0

    self.data = {
      sub_stat_max_mana = {mult = self.ability:GetSpecialValueFor("sub_stat_max_mana"), bonus = 0},
      sub_stat_magical_damage = {mult = self.ability:GetSpecialValueFor("sub_stat_magical_damage"), bonus = 0},
      sub_stat_holy_damage = {mult = self.ability:GetSpecialValueFor("sub_stat_holy_damage"), bonus = 0},
      sub_stat_debuff_amp = {mult = self.ability:GetSpecialValueFor("sub_stat_debuff_amp"), bonus = 0},
      sub_stat_summon_power = {mult = self.ability:GetSpecialValueFor("sub_stat_summon_power"), bonus = 0},
      sub_stat_heal_power = {mult = self.ability:GetSpecialValueFor("sub_stat_heal_power"), bonus = 0},
      sub_stat_magic_resist = {mult = self.ability:GetSpecialValueFor("sub_stat_magic_resist"), bonus = 0},
      sub_stat_luck = {mult = self.ability:GetSpecialValueFor("sub_stat_luck"), bonus = 0},
      sub_stat_cold_resist = {mult = self.ability:GetSpecialValueFor("sub_stat_cold_resist"), bonus = 0},
      sub_stat_sleep_resist = {mult = self.ability:GetSpecialValueFor("sub_stat_sleep_resist"), bonus = 0},
      sub_stat_thunder_resist = {mult = self.ability:GetSpecialValueFor("sub_stat_thunder_resist"), bonus = 0},
      sub_stat_max_mana_percent = {mult = 0, bonus = 0},
      sub_stat_manacost = {mult = 0, bonus = 0},
      sub_stat_magical_block = {mult = 0, bonus = 0},
    }

    self:LoadData()
  end
end

function _modifier_int:OnRefresh(kv)
end

function _modifier_int:AddCustomTransmitterData()
  return {
    stat_bonus = self.stat_bonus,
    stat_data = self.data
  }
end

function _modifier_int:HandleCustomTransmitterData(data)
	self.stat_bonus = data.stat_bonus
  self.data = data.stat_data
end

-- PROPERTIES --------------------------------------------------------------------------------

function _modifier_int:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_EXTRA_MANA_BONUS,
    MODIFIER_PROPERTY_MANA_BONUS,
    MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
    MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
    MODIFIER_PROPERTY_MAGICAL_CONSTANT_BLOCK,
    MODIFIER_EVENT_ON_TAKEDAMAGE
  }

  return funcs
end

function _modifier_int:GetModifierExtraManaBonus()
  if self.parent:IsHero() == false then
    return self:GetBonusMP(500)
  end

  return 0
end

function _modifier_int:GetModifierManaBonus()
  if self.parent:IsHero() then
    return self:GetBonusMP(1000)
  end

  return 0
end

function _modifier_int:GetModifierPercentageManacost(keys)
  return self:GetCalculedData("sub_stat_manacost", false)
end

function _modifier_int:GetModifierSpellAmplify_Percentage(keys)
  if not IsServer() then return 0 end

  if keys.damage_category == DOTA_DAMAGE_CATEGORY_ATTACK then return 0 end
  if keys.damage_flags == 31 or keys.damage_flags == 1040 then return 0 end
  if self.force_spell_crit_damage == nil then return 0 end

  local result = self.force_spell_crit_damage
  self.force_spell_crit_damage = nil
  self.crit_popup[keys.record] = true

  return result
end

function _modifier_int:GetModifierMagicalResistanceBonus()
  return self:GetCalculedData("sub_stat_magic_resist", true)
end

function _modifier_int:GetModifierMagical_ConstantBlock(keys)
  local block = self:GetCalculedData("sub_stat_magical_block", false)
  if block > keys.damage then block = keys.damage end

  if block > 0 and self.parent:IsBlockDisabled() == false then self:StartGenericEfxBlock(keys) end

  return block
end

function _modifier_int:OnTakeDamage(keys)
  if keys.damage_category == DOTA_DAMAGE_CATEGORY_ATTACK then return end
  if keys.unit ~= self.parent then return end

  if keys.damage_type == DAMAGE_TYPE_MAGICAL then
    local efx = OVERHEAD_ALERT_BONUS_SPELL_DAMAGE

    if keys.attacker then
      if keys.attacker:IsBaseNPC() == true then
        local int = keys.attacker:GetMainStat("INT")
        if int then
          if int.crit_popup[keys.record] then
            int.crit_popup[keys.record] = nil
            self:PopupSpellCrit(keys.damage, keys.unit)
            return
          end
        end
      end
    end

    if keys.inflictor then
      if keys.inflictor:GetClassname() == "ability_lua" then
        if keys.inflictor:GetAbilityName() == "hunter_2__aim" then
          efx = OVERHEAD_ALERT_BONUS_POISON_DAMAGE
        end
      end
    end

    SendOverheadEventMessage(nil, efx, self.parent, keys.damage, self.parent)
  end

  if keys.damage_type == DAMAGE_TYPE_PURE then
    if keys.damage_flags == DOTA_DAMAGE_FLAG_DONT_DISPLAY_DAMAGE_IF_SOURCE_HIDDEN + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION then
      --self:PopupBleedDamage(math.floor(keys.damage), self.parent)
    else
      self:PopupHolyDamage(math.floor(keys.damage), Vector(255, 225, 175), self.parent)
    end
  end
end

-- GETTERS --------------------------------------------------------------------------------

function _modifier_int:GetData(property)
  return self.data[property].bonus
end

function _modifier_int:SetForceSpellCrit(damage)
  self.force_spell_crit_damage = damage
end

function _modifier_int:GetMagicalDamageAmp()
  return self:GetCalculedData("sub_stat_magical_damage", false) + 100
end

function _modifier_int:GetHolyDamageAmp()
  return self:GetCalculedData("sub_stat_holy_damage", false) + 100
end

function _modifier_int:GetHealPower()
  return self:GetCalculedData("sub_stat_heal_power", false) * 0.01
end

function _modifier_int:GetDebuffAmp()
  return self:GetCalculedData("sub_stat_debuff_amp", false) * 0.01
end

function _modifier_int:GetMagicalResist()
  return self:GetCalculedData("sub_stat_magic_resist", false)
end

function _modifier_int:GetSummonPower()
  return self:GetCalculedData("sub_stat_summon_power", false)
end

function _modifier_int:GetLuck()
  return self:GetCalculedDataStack("sub_stat_luck", false) * 0.01
end

function _modifier_int:GetColdResist()
  return self:GetCalculedData("sub_stat_cold_resist", false)
end

function _modifier_int:GetSleepResist()
  return self:GetCalculedData("sub_stat_sleep_resist", false)
end

function _modifier_int:GetThunderResist()
  return self:GetCalculedData("sub_stat_thunder_resist", false)
end

function _modifier_int:GetBonusMP(base_mp)
  local ancient_extra_mp = 0

  if self.parent:HasModifier("ancient_3_modifier_passive") then
    if self.parent:HasModifier("ancient_u_modifier_passive") == false then
      return 0
    else
      ancient_extra_mp = base_mp
    end
  end
  
  local bonus_hp = self:GetCalculedData("sub_stat_max_mana", false)
  local hp_percent = self:GetCalculedData("sub_stat_max_mana_percent", false)

  if hp_percent < -90 then hp_percent = -90 end

  local total = bonus_hp + ((base_mp + bonus_hp) * hp_percent * 0.01)
  if base_mp + total < 100 then total = 100 - base_mp end

  return total + ancient_extra_mp
end

function _modifier_int:GetCalculedDataStack(property, bScalar)
  local value = self.data[property].mult * (math.floor((self.ability:GetLevel() + self.stat_bonus) / 5))
  value = value + self.data[property].bonus
  if bScalar then value = (value * 6) / (1 +  (value * 0.06)) end
  return value
end

function _modifier_int:GetCalculedData(property, bScalar)
  local value = self.data[property].mult * (self.ability:GetLevel() + self.stat_bonus)
  value = value + self.data[property].bonus
  if bScalar then value = (value * 6) / (1 +  (value * 0.06)) end
  return value
end

function _modifier_int:UpdateMainBonus()
  if self.parent == nil then return end
  if IsValidEntity(self.parent) == false then return end

  local value = 0
  local mods = self.parent:FindAllModifiersByName("main_stat_modifier")
  if mods then
    for _,modifier in pairs(mods) do
      if modifier.kv["int"] then
        value = value + modifier.kv["int"]
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

function _modifier_int:UpdateSubBonus(property)
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

function _modifier_int:OnStatUpated(property)
  local special_kv_modifier = self.parent:FindModifierByName(self.parent:GetHeroName().."_special_values")
  local base_hero_mod = self.parent:FindModifierByName("base_hero_mod")
  if special_kv_modifier == nil or base_hero_mod == nil then return end

  if property == "sub_stat_debuff_amp" then
    special_kv_modifier:UpdateData("debuff_amp", self:GetDebuffAmp())
    base_hero_mod:UpdateData("debuff_amp", self:GetDebuffAmp())
  end

  if property == "sub_stat_luck" then
    special_kv_modifier:UpdateData("luck", self:GetLuck())
    base_hero_mod:UpdateData("luck", self:GetLuck())
  end

  if property == "sub_stat_magical_damage" then
    special_kv_modifier:UpdateData("magical_damage", self:GetMagicalDamageAmp())
    base_hero_mod:UpdateData("magical_damage", self:GetMagicalDamageAmp())
  end

  if property == "sub_stat_holy_damage" then
    special_kv_modifier:UpdateData("holy_damage", self:GetHolyDamageAmp())
    base_hero_mod:UpdateData("holy_damage", self:GetHolyDamageAmp())
  end

  if property == "sub_stat_heal_power" then
    special_kv_modifier:UpdateData("heal_power", self:GetHealPower())
    base_hero_mod:UpdateData("heal_power", self:GetHealPower())
  end
end

function _modifier_int:LoadData()
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

function _modifier_int:PopupBleedDamage(damage, target)
  if damage <= 0 then return end
  local digits = 1 + #tostring(damage)

  local pidx = ParticleManager:CreateParticle("particles/bocuse/bocuse_msg.vpcf", PATTACH_OVERHEAD_FOLLOW, target)
  ParticleManager:SetParticleControl(pidx, 3, Vector(0, damage, 3))
  ParticleManager:SetParticleControl(pidx, 4, Vector(1, digits, 0))
end

function _modifier_int:PopupHolyDamage(damage, color, target)
  if damage < 1 then return end

  local digits = 1
  if damage < 10 then digits = 2 end
  if damage > 9 and damage < 100 then digits = 3 end
  if damage > 99 and damage < 1000 then digits = 4 end
  if damage > 999 then digits = 5 end

  local pidx = ParticleManager:CreateParticle("particles/msg_fx/msg_crit.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
  ParticleManager:SetParticleControl(pidx, 1, Vector(0, damage, 4))
  ParticleManager:SetParticleControl(pidx, 2, Vector(3, digits, 0))
  ParticleManager:SetParticleControl(pidx, 3, color)
end

function _modifier_int:PopupSpellCrit(damage, target)
  local digits = 1
  if damage < 10 then digits = 2 end
  if damage > 9 and damage < 100 then digits = 3 end
  if damage > 99 and damage < 1000 then digits = 4 end
  if damage > 999 then digits = 5 end

  local pidx = ParticleManager:CreateParticle("particles/msg_fx/msg_crit.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
  ParticleManager:SetParticleControl(pidx, 1, Vector(0, damage, 4))
  ParticleManager:SetParticleControl(pidx, 2, Vector(3, digits, 0))
  ParticleManager:SetParticleControl(pidx, 3, Vector(100, 0, 150))

  if IsServer() then target:EmitSound("Item_Desolator.Target") end
end