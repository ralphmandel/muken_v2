fleaman_special_values = class({})

function fleaman_special_values:IsHidden() return true end
function fleaman_special_values:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function fleaman_special_values:OnCreated(kv)
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
    luck = 0
  }
end

function fleaman_special_values:OnRefresh(kv)
end

function fleaman_special_values:OnRemoved()
end

function fleaman_special_values:AddCustomTransmitterData()
  return {
    ranks = self.ranks,
    data_props = self.data_props
  }
end

function fleaman_special_values:HandleCustomTransmitterData(data)
	self.ranks = data.ranks
	self.data_props = data.data_props
end

-- API FUNCTIONS -----------------------------------------------------------

function fleaman_special_values:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE
	}

	return funcs
end

function fleaman_special_values:GetModifierOverrideAbilitySpecial(keys)
	local caster = self:GetCaster()
	local ability = keys.ability
	local value_name = keys.ability_special_value
	local value_level = keys.ability_special_level

	if ability:GetAbilityName() == "fleaman_1__precision" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
    if value_name == "AbilityCharges" then return 1 end
    if value_name == "AbilityChargeRestoreTime" then return 1 end

    if value_name == "attack_speed" then return 1 end
    if value_name == "evasion" then return 1 end
    if value_name == "duration" then return 1 end
    if value_name == "special_damage" then return 1 end
    if value_name == "special_pulses" then return 1 end
    if value_name == "special_aoe" then return 1 end
    if value_name == "special_purge" then return 1 end
	end

	if ability:GetAbilityName() == "fleaman_2__speed" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end

    if value_name == "duration" then return 1 end
    if value_name == "ms_gain" then return 1 end
    if value_name == "max_ms" then return 1 end
		if value_name == "min_ms" then return 1 end
    if value_name == "special_phase" then return 1 end
    if value_name == "special_stun_duration" then return 1 end
    if value_name == "special_unslow" then return 1 end
	end

	if ability:GetAbilityName() == "fleaman_3__jump" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
    if value_name == "AbilityCharges" then return 1 end
    if value_name == "AbilityChargeRestoreTime" then return 1 end

    if value_name == "distance" then return 1 end
    if value_name == "speed_mult" then return 1 end
    if value_name == "debuff_duration" then return 1 end
    if value_name == "slow_percent" then return 1 end
		if value_name == "radius" then return 1 end
    if value_name == "special_root" then return 1 end
    if value_name == "special_critical_damage" then return 1 end
	end

	if ability:GetAbilityName() == "fleaman_4__strip" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end

    if value_name == "duration" then return 1 end
    if value_name == "armor" then return 1 end
    if value_name == "chance" then return 1 end
    if value_name == "special_break" then return 1 end
    if value_name == "special_bleeding" then return 1 end
    if value_name == "special_evasion" then return 1 end
    if value_name == "special_silence" then return 1 end
    if value_name == "special_damage" then return 1 end
	end

	if ability:GetAbilityName() == "fleaman_5__smoke" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
    if value_name == "AbilityCastRange" then return 1 end

    if value_name == "cast_range" then return 1 end
    if value_name == "duration" then return 1 end
    if value_name == "blind" then return 1 end
    if value_name == "miss_chance" then return 1 end
		if value_name == "radius" then return 1 end
    if value_name == "special_hp_regen" then return 1 end
    if value_name == "special_hide" then return 1 end
	end

	if ability:GetAbilityName() == "fleaman_u__steal" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end

    if value_name == "attack_steal" then return 1 end
    if value_name == "duration" then return 1 end
    if value_name == "special_respawn_self" then return 1 end
    if value_name == "special_respawn_enemy" then return 1 end
    if value_name == "special_lifesteal" then return 1 end
    if value_name == "special_manasteal" then return 1 end
    if value_name == "special_chain_chance" then return 1 end
    if value_name == "special_chain_hits" then return 1 end
    if value_name == "special_chain_damage" then return 1 end
    if value_name == "special_chain_radius" then return 1 end
	end

	return 0
end

function fleaman_special_values:GetModifierOverrideAbilitySpecialValue(keys)
	local caster = self:GetCaster()
	local ability = keys.ability
	local value_name = keys.ability_special_value
	local value_level = keys.ability_special_level
	local ability_level = ability:GetLevel()
	if ability_level < 1 then ability_level = 1 end

  local mana_mult = (1 + ((ability_level - 1) * 0.1))

	if ability:GetAbilityName() == "fleaman_1__precision" then
    if self:HasRank(1, 1, 1) then
      if value_name == "AbilityCharges" then return 4 end
    end

    if self:HasRank(1, 1, 2) then
      if value_name == "AbilityManaCost" then return 80 * mana_mult end
    end

    if self:HasRank(1, 2, 1) then
      if value_name == "attack_speed" then return 50 end
		end

    if self:HasRank(1, 2, 2) then
      if value_name == "evasion" then return 4 end
		end

		if self:HasRank(1, 3, 1) then
      if value_name == "special_damage" then return 150 * self:GetMagicalDamageAmp() end
      if value_name == "special_pulses" then return 7 end
      if value_name == "special_aoe" then return 325 end
		end

    if self:HasRank(1, 3, 2) then
      if value_name == "special_purge" then return 1 end
		end

    if value_name == "AbilityManaCost" then return 100 * mana_mult end
    if value_name == "AbilityCooldown" then return 0 end
    if value_name == "AbilityCharges" then return 3 end
    if value_name == "AbilityChargeRestoreTime" then return 20 end
		if value_name == "duration" then return (15 + (value_level * 0.5)) * self:GetBuffAmp() end

    if value_name == "attack_speed" then return 30 end
    if value_name == "evasion" then return 2.5 end
	end

	if ability:GetAbilityName() == "fleaman_2__speed" then
    if self:HasRank(2, 1, 1) then
      if value_name == "duration" then return 4 * self:GetBuffAmp() end
		end

    if self:HasRank(2, 1, 2) then
      if value_name == "special_phase" then return 1 end
		end

		if self:HasRank(2, 2, 1) then
      if value_name == "ms_gain" then return 10 end
		end

    if self:HasRank(2, 2, 2) then
      if value_name == "special_stun_duration" then return 2 * self:GetDebuffAmp() end
		end

		if self:HasRank(2, 3, 1) then
      if value_name == "max_ms" then return 240 end
		end

    if self:HasRank(2, 3, 2) then
      if value_name == "special_unslow" then return 1 end
		end


		if value_name == "AbilityManaCost" then return 0 end
		if value_name == "AbilityCooldown" then return 0 end
		if value_name == "min_ms" then return value_level * 5 end
    
    if value_name == "duration" then return 3 * self:GetBuffAmp() end
    if value_name == "ms_gain" then return 5 end
    if value_name == "max_ms" then return 120 end
	end

	if ability:GetAbilityName() == "fleaman_3__jump" then
    if self:HasRank(3, 1, 1) then
      if value_name == "debuff_duration" then return 3.5 * self:GetDebuffAmp() end
		end

    if self:HasRank(3, 1, 2) then
      if value_name == "special_root" then return 1 end
		end

		if self:HasRank(3, 2, 1) then
      if value_name == "AbilityCharges" then return 3 end
		end

    if self:HasRank(3, 2, 2) then
      if value_name == "AbilityCharges" then return 1 end
      if value_name == "AbilityChargeRestoreTime" then return 10 end
		end

		if self:HasRank(3, 3, 1) then
      if value_name == "distance" then return 900 end
		end

    if self:HasRank(3, 3, 2) then
      if value_name == "special_critical_damage" then return 300 end
		end

		if value_name == "AbilityManaCost" then return 75 * mana_mult end
    if value_name == "AbilityCooldown" then return 0 end
    if value_name == "AbilityCharges" then return 2 end
    if value_name == "AbilityChargeRestoreTime" then return 15 end
    if value_name == "radius" then return 270 + (value_level * 15) end

    if value_name == "distance" then return 600 end
    if value_name == "speed_mult" then return 2 end
    if value_name == "debuff_duration" then return 2.5 * self:GetDebuffAmp() end
    if value_name == "slow_percent" then return 70 end
	end

	if ability:GetAbilityName() == "fleaman_4__strip" then
    if self:HasRank(4, 1, 1) then
      if value_name == "special_break" then return 1 end
		end

    if self:HasRank(4, 1, 2) then
      if value_name == "special_bleeding" then return 1 end
		end

		if self:HasRank(4, 2, 1) then
      if value_name == "armor" then return -6.5 end
		end

    if self:HasRank(4, 2, 2) then
      if value_name == "special_evasion" then return -2 end
		end

		if self:HasRank(4, 3, 1) then
      if value_name == "special_silence" then return 1 end
		end

    if self:HasRank(4, 3, 2) then
      if value_name == "special_damage" then return 20 end
		end

		if value_name == "AbilityManaCost" then return 0 end
		if value_name == "AbilityCooldown" then return 0 end
    if value_name == "chance" then return self:CalcLuck(7.5 + (value_level * 0.25)) end

    if value_name == "duration" then return 5 * self:GetDebuffAmp() end
    if value_name == "armor" then return -5 end
	end

	if ability:GetAbilityName() == "fleaman_5__smoke" then
    if self:HasRank(5, 1, 1) then
      if value_name == "blind" then return 90 end
		end

    if self:HasRank(5, 1, 2) then
      if value_name == "miss_chance" then return 35 end
		end

		if self:HasRank(5, 2, 1) then
      if value_name == "AbilityCooldown" then return 20 end
		end

    if self:HasRank(5, 2, 2) then
      if value_name == "duration" then return 25 end
		end

		if self:HasRank(5, 3, 1) then
      if value_name == "special_hp_regen" then return 50 end
		end

    if self:HasRank(5, 3, 2) then
      if value_name == "special_hide" then return 5 * self:GetBuffAmp() end
		end

		if value_name == "AbilityManaCost" then return 150 * mana_mult end
		if value_name == "AbilityCooldown" then return 25 end
    if value_name == "AbilityCastRange" then return ability:GetSpecialValueFor("cast_range") end
		if value_name == "radius" then return 450 + (value_level * 25) end

    if value_name == "cast_range" then return 600 end
    if value_name == "duration" then return 15 end
    if value_name == "blind" then return 75 end
    if value_name == "miss_chance" then return 25 end
	end

	if ability:GetAbilityName() == "fleaman_u__steal" then
    if self:HasRank(6, 1, 1) then
      if value_name == "special_respawn_self" then return 0.5 end
		end

    if self:HasRank(6, 1, 2) then
      if value_name == "special_respawn_enemy" then return 0.5 end
		end

		if self:HasRank(6, 2, 1) then
      if value_name == "special_lifesteal" then return 20 end
		end

    if self:HasRank(6, 2, 2) then
      if value_name == "special_manasteal" then return 15 end
		end

		if self:HasRank(6, 3, 1) then
      if value_name == "attack_steal" then return 4 end
      if value_name == "AbilityCooldown" then return 1 end
    end

    if self:HasRank(6, 3, 2) then
      if value_name == "special_chain_chance" then return self:CalcLuck(20) end
      if value_name == "special_chain_hits" then return 4 end
      if value_name == "special_chain_damage" then return 100 * self:GetMagicalDamageAmp() end
      if value_name == "special_chain_radius" then return 700 end
    end

		if value_name == "AbilityManaCost" then return 0 end
		if value_name == "AbilityCooldown" then return 0 end
    if value_name == "duration" then return 15 + (value_level * 0.5) end

    if value_name == "attack_steal" then return 3 end
	end

	return 0
end

-- UTILS -----------------------------------------------------------

function fleaman_special_values:LearnRank(skill_id, tier, path)
  for index, table in pairs(self.ranks) do
    if table.skill_id == skill_id and table.tier == tier and table.path == path then
      self.ranks[index].learned = 1
    end
  end

  self:SendBuffRefreshToClients()
end

function fleaman_special_values:HasRank(skill_id, tier, path)
  for index, table in pairs(self.ranks) do
    if table.skill_id == skill_id and table.tier == tier and table.path == path then
      return self.ranks[index].learned == 1
    end
  end
end

function fleaman_special_values:UpdateData(data, value)
	self.data_props[data] = value
  self:SendBuffRefreshToClients()
end

function fleaman_special_values:GetBuffAmp()
  return 1 + self.data_props["buff_amp"]
end

function fleaman_special_values:GetDebuffAmp()
  return 1 + self.data_props["debuff_amp"]
end

function fleaman_special_values:GetPhysicalDamageAmp()
  return self.data_props["physical_damage"] * 0.01
end

function fleaman_special_values:GetMagicalDamageAmp()
  return self.data_props["magical_damage"] * 0.01
end

function fleaman_special_values:GetHolyDamageAmp()
  return self.data_props["holy_damage"] * 0.01
end

function fleaman_special_values:CalcLuck(value)
  local result = value * (1 + self.data_props["luck"])
  if result < 0 then result = 0 elseif result > 100 then result = 100 end

  return result
end

-- EFFECTS -----------------------------------------------------------