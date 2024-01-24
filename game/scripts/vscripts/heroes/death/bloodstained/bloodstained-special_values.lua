bloodstained_special_values = class({})

function bloodstained_special_values:IsHidden() return true end
function bloodstained_special_values:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function bloodstained_special_values:OnCreated(kv)
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
    luck = 0,
    tears_step = 1
  }
end

function bloodstained_special_values:OnRefresh(kv)
end

function bloodstained_special_values:OnRemoved()
end

function bloodstained_special_values:AddCustomTransmitterData()
  return {
    ranks = self.ranks,
    data_props = self.data_props
  }
end

function bloodstained_special_values:HandleCustomTransmitterData(data)
	self.ranks = data.ranks
	self.data_props = data.data_props
end

-- API FUNCTIONS -----------------------------------------------------------

function bloodstained_special_values:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE
	}

	return funcs
end

function bloodstained_special_values:GetModifierOverrideAbilitySpecial(keys)
	local caster = self:GetCaster()
	local ability = keys.ability
	local value_name = keys.ability_special_value
	local value_level = keys.ability_special_level

	if ability:GetAbilityName() == "bloodstained_1__rage" then
		if value_name == "AbilityManaCost" then return 1 end
    if value_name == "AbilityHealthCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
    if value_name == "AbilityCastRange" then return 1 end

    if value_name == "radius" then return 1 end
    if value_name == "call_duration" then return 1 end
    if value_name == "damage_gain" then return 1 end
    if value_name == "duration" then return 1 end
		if value_name == "cooldown" then return 1 end
    if value_name == "special_reset" then return 1 end
    if value_name == "special_blink" then return 1 end
    if value_name == "special_status_resist" then return 1 end
    if value_name == "special_attack_speed" then return 1 end
	end

	if ability:GetAbilityName() == "bloodstained_2__bloodsteal" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end

    if value_name == "max_heal" then return 1 end
		if value_name == "base_heal" then return 1 end
    if value_name == "incoming_heal" then return 1 end
    if value_name == "special_min_hp" then return 1 end
    if value_name == "special_death_delay" then return 1 end
    if value_name == "special_respawn_time" then return 1 end
    if value_name == "special_rage_restore" then return 1 end
    if value_name == "special_kill_radius" then return 1 end
    if value_name == "special_kill_heal" then return 1 end
    if value_name == "special_overhealth" then return 1 end
	end

  if ability:GetAbilityName() == "bloodstained_3__curse" then
		if value_name == "AbilityManaCost" then return 1 end
    if value_name == "AbilityHealthCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
    if value_name == "AbilityCastRange" then return 1 end
    if value_name == "AbilityCharges" then return 1 end
    if value_name == "AbilityChargeRestoreTime" then return 1 end
    if value_name == "AbilityCastRange" then return 1 end

    if value_name == "duration" then return 1 end
    if value_name == "shared_damage" then return 1 end
    if value_name == "max_range" then return 1 end
    if value_name == "special_ms" then return 1 end
    if value_name == "special_slow_percent" then return 1 end
    if value_name == "special_slow_duration" then return 1 end
    if value_name == "special_mute" then return 1 end
	end

  if ability:GetAbilityName() == "bloodstained_4__bloodloss" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
    if value_name == "heal_percent" then return 1 end
	end

  if ability:GetAbilityName() == "bloodstained_5__tears" then
		if value_name == "AbilityManaCost" then return 1 end
    if value_name == "AbilityHealthCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end

    if value_name == "step" then return 1 end
    if value_name == "radius" then return 1 end
    if value_name == "blood_duration" then return 1 end
    if value_name == "hp_lost" then return 1 end
    if value_name == "interval" then return 1 end
    if value_name == "blood_percent" then return 1 end
    if value_name == "special_purge" then return 1 end
    if value_name == "special_status_reduction" then return 1 end
    if value_name == "special_critical_chance" then return 1 end
	end

  if ability:GetAbilityName() == "bloodstained_u__seal" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
    if value_name == "AbilityCastRange" then return 1 end

    if value_name == "radius" then return 1 end
    if value_name == "hp_stolen" then return 1 end
    if value_name == "copy_duration" then return 1 end
    if value_name == "slow_duration" then return 1 end
    if value_name == "steal_duration" then return 1 end
    if value_name == "duration" then return 1 end
    if value_name == "special_lifesteal" then return 1 end
    if value_name == "special_break" then return 1 end
    if value_name == "special_bleed_damage" then return 1 end
	end

	return 0
end

function bloodstained_special_values:GetModifierOverrideAbilitySpecialValue(keys)
	local caster = self:GetCaster()
	local ability = keys.ability
	local value_name = keys.ability_special_value
	local value_level = keys.ability_special_level
	local ability_level = ability:GetLevel()
	if ability_level < 1 then ability_level = 1 end

  local mana_mult = (1 + ((ability_level - 1) * 0.1))

	if ability:GetAbilityName() == "bloodstained_1__rage" then
    if self:HasRank(1, 1, 1) then
      if value_name == "duration" then return 14 * self:GetBuffAmp() end
    end

    if self:HasRank(1, 1, 2) then
      if value_name == "special_reset" then return 1 end
    end

    if self:HasRank(1, 2, 1) then
      if value_name == "special_status_resist" then return 30 end
		end

    if self:HasRank(1, 2, 2) then
      if value_name == "special_attack_speed" then return 75 end
		end

		if self:HasRank(1, 3, 1) then
      if value_name == "call_duration" then return 7.5 * self:GetDebuffAmp() end
		end

    if self:HasRank(1, 3, 2) then
      if value_name == "radius" then return 400 end
      if value_name == "special_blink" then return 500 end
		end

		if value_name == "AbilityManaCost" then return 0 * mana_mult end
    if value_name == "AbilityHealthCost" then return 250 * mana_mult end
		if value_name == "AbilityCooldown" then return ability:GetSpecialValueFor("cooldown") end
    if value_name == "AbilityCastRange" then return ability:GetSpecialValueFor("special_blink") end
		if value_name == "cooldown" then return 18 - (value_level * 1) end

    if value_name == "radius" then return 275 end
    if value_name == "call_duration" then return 3 * self:GetDebuffAmp() end
    if value_name == "damage_gain" then return 5 end
    if value_name == "duration" then return 12 * self:GetBuffAmp() end
	end

	if ability:GetAbilityName() == "bloodstained_2__bloodsteal" then
    if self:HasRank(2, 1, 1) then
      if value_name == "special_min_hp" then return 1 end
      if value_name == "special_death_delay" then return 5 * self:GetBuffAmp() end
    end

    if self:HasRank(2, 1, 2) then
      if value_name == "special_respawn_time" then return -30 end
    end

    if self:HasRank(2, 2, 1) then
      if value_name == "special_rage_restore" then return 50 end
		end

    if self:HasRank(2, 2, 2) then
      if value_name == "special_kill_radius" then return 1000 end
      if value_name == "special_kill_heal" then return 5 end
		end

		if self:HasRank(2, 3, 1) then
      if value_name == "max_heal" then return 50 end
		end

    if self:HasRank(2, 3, 2) then
      if value_name == "base_heal" then return 10 end
      if value_name == "special_overhealth" then return 500 + (caster:GetLevel() * 50) end
		end

    if value_name == "AbilityManaCost" then return 0 * mana_mult end
    if value_name == "AbilityCooldown" then return 0 end
    if value_name == "incoming_heal" then return 0 + (value_level * 1) end

    if value_name == "max_heal" then return 35 end
    if value_name == "base_heal" then return 5 end
	end

	if ability:GetAbilityName() == "bloodstained_3__curse" then
    if self:HasRank(3, 1, 1) then
      if value_name == "special_ms" then return 30 end
    end

    if self:HasRank(3, 1, 2) then
      if value_name == "special_slow_percent" then return 100 end
      if value_name == "special_slow_duration" then return 1.5 end
    end

    if self:HasRank(3, 2, 1) then
      if value_name == "AbilityCharges" then return 2 end
		end

    if self:HasRank(3, 2, 2) then
      if value_name == "AbilityChargeRestoreTime" then return 20 end
		end

		if self:HasRank(3, 3, 1) then
      if value_name == "shared_damage" then return 80 end
		end

    if self:HasRank(3, 3, 2) then
      if value_name == "special_mute" then return 1 end
		end

    if value_name == "AbilityManaCost" then return 0 * mana_mult end
    if value_name == "AbilityHealthCost" then return 200 * mana_mult end
    if value_name == "AbilityCooldown" then return 0 end
    if value_name == "AbilityCharges" then return 1 end
    if value_name == "AbilityChargeRestoreTime" then return 30 end
    if value_name == "AbilityCastRange" then return 350 + ((ability_level - 1) * 25) end
    if value_name == "max_range" then return 350 + (value_level * 25) end

    if value_name == "duration" then return 20 end
    if value_name == "shared_damage" then return 50 end
	end

	if ability:GetAbilityName() == "bloodstained_4__bloodloss" then
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

    if value_name == "AbilityManaCost" then return 0 * mana_mult end
    if value_name == "AbilityCooldown" then return 0 end
    if value_name == "heal_percent" then return 70 + (value_level * 5) end
	end

	if ability:GetAbilityName() == "bloodstained_5__tears" then
    if self:HasRank(5, 1, 1) then
      if value_name == "blood_percent" then return 9 end
    end

    if self:HasRank(5, 1, 2) then
      if value_name == "blood_duration" then return 25 end
    end

    if self:HasRank(5, 2, 1) then
      if value_name == "special_purge" then return 1 end
      if value_name == "special_status_reduction" then return 5 end
		end

    if self:HasRank(5, 2, 2) then
      if value_name == "special_critical_chance" then return 10 end
		end

		if self:HasRank(5, 3, 1) then
      if value_name == "hp_lost" then return 2 end
		end

    if self:HasRank(5, 3, 2) then
      if value_name == "radius" then return 550 end
		end

    if value_name == "AbilityManaCost" then return 0 * mana_mult end
    if value_name == "AbilityHealthCost" then return 300 * mana_mult end
    if value_name == "AbilityCooldown" then return ability:GetSpecialValueFor("cooldown") end
    if value_name == "cooldown" then return 40 - (value_level * 2.5) end

    if value_name == "step" then return self.data_props["tears_step"] end
    if value_name == "radius" then return 350 end
    if value_name == "blood_duration" then return 20 end
    if value_name == "hp_lost" then return 1 end
    if value_name == "interval" then return 1 end
    if value_name == "blood_percent" then return 8 end
	end

	if ability:GetAbilityName() == "bloodstained_u__seal" then
    if self:HasRank(6, 1, 1) then
      if value_name == "slow_duration" then return 2 * self:GetDebuffAmp() end
    end

    if self:HasRank(6, 1, 2) then
      if value_name == "special_lifesteal" then return 10 end
    end

    if self:HasRank(6, 2, 1) then
      if value_name == "steal_duration" then return 180 end
		end

    if self:HasRank(6, 2, 2) then
      if value_name == "special_break" then return 1 end
		end

    if self:HasRank(6, 3, 1) then
      if value_name == "hp_stolen" then return 15 end
		end

    if self:HasRank(6, 3, 2) then
      if value_name == "special_bleed_damage" then return 100 * self:GetPhysicalDamageAmp() end
		end

    if value_name == "AbilityManaCost" then return 0 * mana_mult end
    if value_name == "AbilityCooldown" then return 100 end
    if value_name == "AbilityCastRange" then return ability:GetSpecialValueFor("radius") - 50 end
    if value_name == "duration" then return 12 + (value_level * 0.5) end

    if value_name == "radius" then return 500 end
    if value_name == "hp_stolen" then return 10 end
    if value_name == "copy_duration" then return 15 end
    if value_name == "slow_duration" then return 1 * self:GetDebuffAmp() end
    if value_name == "steal_duration" then return 90 end
  end

	return 0
end

-- UTILS -----------------------------------------------------------

function bloodstained_special_values:LearnRank(skill_id, tier, path)
  for index, table in pairs(self.ranks) do
    if table.skill_id == skill_id and table.tier == tier and table.path == path then
      self.ranks[index].learned = 1
    end
  end

  self:SendBuffRefreshToClients()
end

function bloodstained_special_values:HasRank(skill_id, tier, path)
  for index, table in pairs(self.ranks) do
    if table.skill_id == skill_id and table.tier == tier and table.path == path then
      return self.ranks[index].learned == 1
    end
  end
end

function bloodstained_special_values:UpdateData(data, value)
	self.data_props[data] = value
  self:SendBuffRefreshToClients()
end

function bloodstained_special_values:GetBuffAmp()
  return 1 + self.data_props["buff_amp"]
end

function bloodstained_special_values:GetDebuffAmp()
  return 1 + self.data_props["debuff_amp"]
end

function bloodstained_special_values:GetPhysicalDamageAmp()
  return self.data_props["physical_damage"] * 0.01
end

function bloodstained_special_values:GetMagicalDamageAmp()
  return self.data_props["magical_damage"] * 0.01
end

function bloodstained_special_values:GetHolyDamageAmp()
  return self.data_props["holy_damage"] * 0.01
end

function bloodstained_special_values:CalcLuck(value)
  local result = value * (1 + self.data_props["luck"])
  if result < 0 then result = 0 elseif result > 100 then result = 100 end

  return result
end

-- EFFECTS -----------------------------------------------------------