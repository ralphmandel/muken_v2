_modifier_vit = class ({})

function _modifier_vit:IsHidden() return true end
function _modifier_vit:IsPermanent() return true end
function _modifier_vit:IsPurgable() return false end

function _modifier_vit:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  self.main_bonus = 0

  self.data = {
    sub_stat_max_health = {mult = self.ability:GetSpecialValueFor("sub_stat_max_health"), bonus = 0},
    sub_stat_health_regen = {mult = self.ability:GetSpecialValueFor("sub_stat_health_regen"), bonus = 0},
    sub_stat_incoming_heal = {mult = self.ability:GetSpecialValueFor("sub_stat_incoming_heal"), bonus = 0},
    sub_stat_incoming_buff = {mult = self.ability:GetSpecialValueFor("sub_stat_incoming_buff"), bonus = 0}
  }
end

function _modifier_vit:OnRefresh(kv)
end

-- PROPERTIES --------------------------------------------------------------------------------

function _modifier_vit:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
    MODIFIER_PROPERTY_HEALTH_BONUS,
    MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
    MODIFIER_EVENT_ON_HEAL_RECEIVED,
  }

  return funcs
end

function _modifier_vit:GetModifierExtraHealthBonus()
  if self:GetParent():IsHero() == false then
    return self:GetCalculedData("sub_stat_max_health", false)
  end

  return 0
end

function _modifier_vit:GetModifierHealthBonus()
  if self:GetParent():IsHero() then
    return self:GetCalculedData("sub_stat_max_health", false)
  end

  return 0
end

function _modifier_vit:GetModifierConstantHealthRegen()
  return self:GetCalculedData("sub_stat_health_regen", false)
end

function _modifier_vit:GetModifierHealAmplify_PercentageTarget()
  return self:GetCalculedDataStack("sub_stat_incoming_heal", false)
end

function _modifier_vit:OnHealReceived(keys)
  if keys.unit ~= self.parent then return end
  if keys.inflictor == nil then return end
  if keys.gain < 1 then return end

  SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, keys.unit, keys.gain, keys.unit)

  if keys.inflictor:GetAbilityName() == "bloodstained_5__lifesteal" then return end

  if IsServer() then self.parent:EmitSound("Effect.Heal") end
end

-- GETTERS --------------------------------------------------------------------------------

function _modifier_vit:GetIncomingHeal()
  return self:GetCalculedDataStack("sub_stat_incoming_heal", false)
end

function _modifier_vit:GetIncomingBuff()
  return self:GetCalculedData("sub_stat_incoming_buff", false) * 0.01
end

function _modifier_vit:GetCalculedDataStack(property, bScalar)
  local value = self.data[property].mult * (math.floor(self.ability:GetLevel() / 5))
  if bScalar then value = (value * 6) / (1 +  (value * 0.06)) end
  return value + self.data[property].bonus
end

function _modifier_vit:GetCalculedData(property, bScalar)
  local value = self.data[property].mult * (self.ability:GetLevel() + self.main_bonus)
  if bScalar then value = (value * 6) / (1 +  (value * 0.06)) end
  return value + self.data[property].bonus
end

function _modifier_vit:UpdateMainBonus(value)
  self.main_bonus = value
end

function _modifier_vit:UpdateSubBonus(property)
  local value = 0
  local mods = self.parent:FindAllModifiersByName("sub_stat_modifier")
  for _,modifier in pairs(mods) do value = value + modifier.kv[property] end

  self.data["sub_stat_"..property].bonus = value
end