_modifier_int = class ({})

function _modifier_int:IsHidden() return true end
function _modifier_int:IsPermanent() return true end
function _modifier_int:IsPurgable() return false end

function _modifier_int:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  self.main_bonus = 0

  self.data = {
    sub_stat_max_mana = {mult = self.ability:GetSpecialValueFor("sub_stat_max_mana"), bonus = 0},
    sub_stat_magical_damage = {mult = self.ability:GetSpecialValueFor("sub_stat_magical_damage"), bonus = 0},
    sub_stat_holy_damage = {mult = self.ability:GetSpecialValueFor("sub_stat_holy_damage"), bonus = 0},
    sub_stat_heal_power = {mult = self.ability:GetSpecialValueFor("sub_stat_heal_power"), bonus = 0},
    sub_stat_debuff_amp = {mult = self.ability:GetSpecialValueFor("sub_stat_debuff_amp"), bonus = 0},
    sub_stat_magic_resist = {mult = self.ability:GetSpecialValueFor("sub_stat_magic_resist"), bonus = 0},
    sub_stat_status_resist = {mult = self.ability:GetSpecialValueFor("sub_stat_status_resist"), bonus = 0},
    sub_stat_status_resist_stack = {mult = 0, bonus = 0}
  }

  self:LoadData()
end

function _modifier_int:OnRefresh(kv)
end

-- PROPERTIES --------------------------------------------------------------------------------

function _modifier_int:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_MANA_BONUS,
    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
    MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
    MODIFIER_PROPERTY_STATUS_RESISTANCE,
    MODIFIER_EVENT_ON_TAKEDAMAGE
  }

  return funcs
end

function _modifier_int:GetModifierManaBonus()
  if self.parent:HasModifier("ancient_1_modifier_passive") then
    if self.parent:HasModifier("ancient_u_modifier_passive") == false then
      return 0
    else
      return 750 + self:GetCalculedDataStack("sub_stat_max_mana", false)
    end
  end
  
  return self:GetCalculedDataStack("sub_stat_max_mana", false)
end

function _modifier_int:GetModifierSpellAmplify_Percentage(keys)
  if keys.damage_category == DOTA_DAMAGE_CATEGORY_ATTACK then return 0 end
  if keys.damage_flags == 31 then return 0 end
  if keys.damage_type == DAMAGE_TYPE_PURE and keys.damage_flags == 2048 then return 0 end

  if keys.damage_type == DAMAGE_TYPE_MAGICAL then
    return self:GetCalculedData("sub_stat_magical_damage", false)
  end

  if keys.damage_type == DAMAGE_TYPE_PURE then
    return self:GetCalculedData("sub_stat_holy_damage", false)
  end
end

function _modifier_int:GetModifierMagicalResistanceBonus()
  return self:GetCalculedData("sub_stat_magic_resist", true)
end

function _modifier_int:GetModifierStatusResistance()
  return self:GetCalculedData("sub_stat_status_resist", true)
end

function _modifier_int:OnTakeDamage(keys)
  if keys.damage_category == DOTA_DAMAGE_CATEGORY_ATTACK or keys.damage_flags == 1024 then return end
  if keys.unit ~= self.parent then return end

  if keys.damage_type == DAMAGE_TYPE_MAGICAL then
    local efx = OVERHEAD_ALERT_BONUS_SPELL_DAMAGE

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
    if keys.damage_flags == DOTA_DAMAGE_FLAG_DONT_DISPLAY_DAMAGE_IF_SOURCE_HIDDEN then
      self:PopupBleedDamage(math.floor(keys.damage), self.parent)
    else
      self:PopupHolyDamage(math.floor(keys.damage), Vector(255, 225, 175), self.parent)
    end
  end
end

-- GETTERS --------------------------------------------------------------------------------

function _modifier_int:GetData(property)
  return self.data[property].bonus
end

function _modifier_int:GetMagicalDamageAmp()
  return self:GetCalculedData("sub_stat_magical_damage", false) + 100
end

function _modifier_int:GetHealPower()
  return self:GetCalculedData("sub_stat_heal_power", false) * 0.01
end

function _modifier_int:GetDebuffAmp()
  return self:GetCalculedData("sub_stat_debuff_amp", false) * 0.01
end

function _modifier_int:GetStatusResist()
  if self.parent:IsHero() then return self:GetCaster():GetStatusResistance() end
  local base = self:GetCalculedData("sub_stat_status_resist", true)
  --local total = base + ((100 - base) * self:GetCalculedData("sub_stat_status_resist_stack", false) * 0.01)
  return base * 0.01
end

function _modifier_int:GetCalculedDataStack(property, bScalar)
  local value = self.data[property].mult * (math.floor(self.ability:GetLevel() / 5))
  value = value + self.data[property].bonus
  if bScalar then value = (value * 6) / (1 +  (value * 0.06)) end
  return value
end

function _modifier_int:GetCalculedData(property, bScalar)
  local value = self.data[property].mult * (self.ability:GetLevel() + self.main_bonus)
  value = value + self.data[property].bonus
  if bScalar then value = (value * 6) / (1 +  (value * 0.06)) end
  return value
end

function _modifier_int:UpdateMainBonus(value)
  self.main_bonus = value
end

function _modifier_int:UpdateSubBonus(property)
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

function _modifier_int:PopupBleeding(damage, target)
  if damage <= 0 then return end
  local digits = 1 + #tostring(damage)

  local pidx = ParticleManager:CreateParticle("particles/bocuse/bocuse_msg.vpcf", PATTACH_OVERHEAD_FOLLOW, target)
  ParticleManager:SetParticleControl(pidx, 3, Vector(0, damage, 3))
  ParticleManager:SetParticleControl(pidx, 4, Vector(1, digits, 0))
end

function _modifier_int:PopupDamage(damage, color, target)
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