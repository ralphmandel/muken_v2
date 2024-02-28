genuine_special_values = class({})

function genuine_special_values:IsHidden() return true end
function genuine_special_values:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function genuine_special_values:OnCreated(kv)
  if not IsServer() then return end

  self:SetHasCustomTransmitterData(true)
  self.ranks = {}

  local index = 0
  for skill_id = 1, 6, 1 do
    for tier = 1, 3, 1 do
      for path = 1, 2, 1 do
        self.ranks[index] = {
          skill_id = skill_id,
          tier = tier,
          path = path,
          learned = 0
        }
        index = index + 1
      end
    end
  end

  self.data_props = {
    buff_amp = 0,
    debuff_amp = 0,
    physical_damage = 0,
    magical_damage = 0,
    holy_damage = 0,
    heal_power = 0,
    luck = 0
  }
end

function genuine_special_values:OnRefresh(kv)
end

function genuine_special_values:OnRemoved()
end

function genuine_special_values:AddCustomTransmitterData()
  return {
    ranks = self.ranks,
    data_props = self.data_props
  }
end

function genuine_special_values:HandleCustomTransmitterData(data)
	self.ranks = data.ranks
	self.data_props = data.data_props
end

-- API FUNCTIONS -----------------------------------------------------------

function genuine_special_values:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE
	}

	return funcs
end

function genuine_special_values:GetModifierOverrideAbilitySpecial(keys)
	local caster = self:GetCaster()
	local ability = keys.ability
	local value_name = keys.ability_special_value
	local value_level = keys.ability_special_level

	if ability:GetAbilityName() == "genuine_1__shooting" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
    if value_name == "AbilityCastRange" then return 1 end

    if value_name == "damage" then return 1 end
    if value_name == "special_attack_range" then return 1 end
    if value_name == "special_arrow_speed" then return 1 end
    if value_name == "special_fear_chance" then return 1 end
    if value_name == "special_fear_duration" then return 1 end
    if value_name == "special_lifesteal" then return 1 end
    if value_name == "special_crit_damage" then return 1 end
	end

	if ability:GetAbilityName() == "genuine_2__fallen" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
    if value_name == "AbilityCharges" then return 1 end
    if value_name == "AbilityChargeRestoreTime" then return 1 end

    if value_name == "radius" then return 1 end
    if value_name == "distance" then return 1 end
    if value_name == "speed" then return 1 end
    if value_name == "fear_duration" then return 1 end
    if value_name == "special_wide" then return 1 end
    if value_name == "special_curse_percent" then return 1 end
    if value_name == "special_status_reduction" then return 30 end
    if value_name == "special_purge" then return 1 end
	end

  if ability:GetAbilityName() == "genuine_3__travel" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
    if value_name == "AbilityCastRange" then return 1 end
    if value_name == "AbilityCharges" then return 1 end
    if value_name == "AbilityChargeRestoreTime" then return 1 end
	end

  if ability:GetAbilityName() == "genuine_4__under" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
    if value_name == "AbilityCastRange" then return 1 end
    if value_name == "AbilityCharges" then return 1 end
    if value_name == "AbilityChargeRestoreTime" then return 1 end
	end

  if ability:GetAbilityName() == "genuine_5__nightfall" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
    if value_name == "AbilityCastRange" then return 1 end
    if value_name == "AbilityCharges" then return 1 end
    if value_name == "AbilityChargeRestoreTime" then return 1 end
	end

  if ability:GetAbilityName() == "genuine_u__morning" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
    if value_name == "AbilityCastRange" then return 1 end
    if value_name == "AbilityCharges" then return 1 end
    if value_name == "AbilityChargeRestoreTime" then return 1 end
	end

	return 0
end

function genuine_special_values:GetModifierOverrideAbilitySpecialValue(keys)
	local caster = self:GetCaster()
	local ability = keys.ability
	local value_name = keys.ability_special_value
	local value_level = keys.ability_special_level
	local ability_level = ability:GetLevel()
	if ability_level < 1 then ability_level = 1 end

  local mana_mult = (1 + ((ability_level - 1) * 0.1))

	if ability:GetAbilityName() == "genuine_1__shooting" then
    if self:HasRank(1, 1, 1) then
      if value_name == "special_attack_range" then return 100 end
    end

    if self:HasRank(1, 1, 2) then
      if value_name == "special_arrow_speed" then return 800 end
    end

    if self:HasRank(1, 2, 1) then
      if value_name == "AbilityManaCost" then return 50 * mana_mult end
		end

    if self:HasRank(1, 2, 2) then
      if value_name == "special_fear_chance" then return self:CalcLuck(12) end
      if value_name == "special_fear_duration" then return 1 * self:GetDebuffAmp() end
      if value_name == "AbilityCooldown" then return 5 end
		end

		if self:HasRank(1, 3, 1) then
      if value_name == "special_lifesteal" then return 30 end
		end

    if self:HasRank(1, 3, 2) then
      if value_name == "special_crit_damage" then return 175 end
		end

    if value_name == "AbilityManaCost" then return 60 * mana_mult end
    if value_name == "AbilityCooldown" then return 0 end
    if value_name == "AbilityCastRange" then return caster:Script_GetAttackRange() end
    if value_name == "damage" then return math.floor((75 + (value_level * 2.5)) * self:GetMagicalDamageAmp()) end
	end

	if ability:GetAbilityName() == "genuine_2__fallen" then
    if self:HasRank(2, 1, 1) then
      if value_name == "distance" then return 900 end
    end

    if self:HasRank(2, 1, 2) then
      if value_name == "speed" then return 1500 end
      if value_name == "radius" then return 425 end
      if value_name == "distance" then return 300 end
      if value_name == "special_wide" then return 1 end
    end

    if self:HasRank(2, 2, 1) then
      if value_name == "AbilityChargeRestoreTime" then return 12 end
		end

    if self:HasRank(2, 2, 2) then
      if value_name == "AbilityCharges" then return 3 end
      if value_name == "AbilityChargeRestoreTime" then return 18 end
		end

		if self:HasRank(2, 3, 1) then
      if value_name == "special_curse_percent" then return 30 * self:GetDebuffAmp() end
		end

    if self:HasRank(2, 3, 2) then
      if value_name == "special_status_reduction" then return 30 end
      if value_name == "special_purge" then return 1 end
		end

    if value_name == "AbilityManaCost" then return 125 * mana_mult end
    if value_name == "AbilityCooldown" then return 0 end
    if value_name == "AbilityCharges" then return 1 end
    if value_name == "AbilityChargeRestoreTime" then return 15 end

    if value_name == "fear_duration" then return (1.5 + (value_level * 0.05)) * self:GetDebuffAmp() end

    if value_name == "radius" then return 250 end
    if value_name == "distance" then return 600 end
    if value_name == "speed" then return 1200 end
	end

	if ability:GetAbilityName() == "genuine_3__travel" then
    if self:HasRank(3, 1, 1) then
    end

    if self:HasRank(3, 1, 2) then
    end

    if self:HasRank(3, 2, 1) then
		end

    if self:HasRank(3, 2, 2) then
		end

		if self:HasRank(3, 3, 1) then
		end

    if self:HasRank(3, 3, 2) then
		end

    if value_name == "AbilityManaCost" then return 100 * mana_mult end
    if value_name == "AbilityCooldown" then return 0 end
	end

	if ability:GetAbilityName() == "genuine_4__under" then
    if self:HasRank(4, 1, 1) then
    end

    if self:HasRank(4, 1, 2) then
    end

    if self:HasRank(4, 2, 1) then
		end

    if self:HasRank(4, 2, 2) then
		end

		if self:HasRank(4, 3, 1) then
		end

    if self:HasRank(4, 3, 2) then
		end

    if value_name == "AbilityManaCost" then return 100 * mana_mult end
    if value_name == "AbilityCooldown" then return 0 end
	end

	if ability:GetAbilityName() == "genuine_5__smoke" then
    if self:HasRank(5, 1, 1) then
    end

    if self:HasRank(5, 1, 2) then
    end

    if self:HasRank(5, 2, 1) then
		end

    if self:HasRank(5, 2, 2) then
		end

		if self:HasRank(5, 3, 1) then
		end

    if self:HasRank(5, 3, 2) then
		end

    if value_name == "AbilityManaCost" then return 100 * mana_mult end
    if value_name == "AbilityCooldown" then return 0 end
	end

	if ability:GetAbilityName() == "genuine_u__morning" then
    if self:HasRank(6, 1, 1) then
    end

    if self:HasRank(6, 1, 2) then
    end

    if self:HasRank(6, 2, 1) then
		end

    if self:HasRank(6, 2, 2) then
		end

		if self:HasRank(6, 3, 1) then
		end

    if self:HasRank(6, 3, 2) then
		end

    if value_name == "AbilityManaCost" then return 100 * mana_mult end
    if value_name == "AbilityCooldown" then return 0 end
	end

	return 0
end

-- UTILS -----------------------------------------------------------

function genuine_special_values:LearnRank(skill_id, tier, path)
  for index, table in pairs(self.ranks) do
    if table.skill_id == skill_id and table.tier == tier and table.path == path then
      self.ranks[index].learned = 1
    end
  end

  self:SendBuffRefreshToClients()
end

function genuine_special_values:HasRank(skill_id, tier, path)
  for index, table in pairs(self.ranks) do
    if table.skill_id == skill_id and table.tier == tier and table.path == path then
      return self.ranks[index].learned == 1
    end
  end
end

function genuine_special_values:UpdateData(data, value)
	self.data_props[data] = value
  self:SendBuffRefreshToClients()
end

function genuine_special_values:GetBuffAmp()
  return 1 + self.data_props["buff_amp"]
end

function genuine_special_values:GetDebuffAmp()
  return 1 + self.data_props["debuff_amp"]
end

function genuine_special_values:GetPhysicalDamageAmp()
  return self.data_props["physical_damage"] * 0.01
end

function genuine_special_values:GetMagicalDamageAmp()
  return self.data_props["magical_damage"] * 0.01
end

function genuine_special_values:GetHolyDamageAmp()
  return self.data_props["holy_damage"] * 0.01
end

function genuine_special_values:GetHealPower()
  return 1 + self.data_props["heal_power"]
end

function genuine_special_values:CalcLuck(value)
  local result = value * (1 + self.data_props["luck"])
  if result < 0 then result = 0 elseif result > 100 then result = 100 end

  return result
end

-- EFFECTS -----------------------------------------------------------