paladin_special_values = class({})

function paladin_special_values:IsHidden() return true end
function paladin_special_values:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function paladin_special_values:OnCreated(kv)
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

function paladin_special_values:OnRefresh(kv)
end

function paladin_special_values:OnRemoved()
end

function paladin_special_values:AddCustomTransmitterData()
  return {
    ranks = self.ranks,
    data_props = self.data_props
  }
end

function paladin_special_values:HandleCustomTransmitterData(data)
	self.ranks = data.ranks
	self.data_props = data.data_props
end

-- API FUNCTIONS -----------------------------------------------------------

function paladin_special_values:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE
	}

	return funcs
end

function paladin_special_values:GetModifierOverrideAbilitySpecial(keys)
	local caster = self:GetCaster()
	local ability = keys.ability
	local value_name = keys.ability_special_value
	local value_level = keys.ability_special_level
  --"AbilityCastRange"
  --"AbilityCharges"
  --"AbilityChargeRestoreTime"

	if ability:GetAbilityName() == "paladin_1__link" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
    if value_name == "AbilityCastRange" then return 1 end
    if value_name == "AbilityCharges" then return 1 end
    if value_name == "AbilityChargeRestoreTime" then return 1 end

    if value_name == "absorption" then return 1 end
    if value_name == "duration" then return 1 end
		if value_name == "cast_range" then return 1 end
		if value_name == "max_range" then return 1 end
		if value_name == "special_magical_damage" then return 1 end
		if value_name == "special_physical_damage" then return 1 end
		if value_name == "special_heal" then return 1 end
		if value_name == "special_mana" then return 1 end
	end

	if ability:GetAbilityName() == "paladin_2__shield" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
		if value_name == "AbilityCastRange" then return 1 end

    if value_name == "hits" then return 1 end
    if value_name == "status_resist" then return 1 end
		if value_name == "duration" then return 1 end
    if value_name == "special_cast_range" then return 1 end
    if value_name == "special_burn_damage" then return 1 end
    if value_name == "special_burn_radius" then return 1 end
    if value_name == "special_burn_tick" then return 1 end
    if value_name == "special_hp_regen" then return 1 end
    if value_name == "special_bkb" then return 1 end
	end

	if ability:GetAbilityName() == "paladin_3__hammer" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
		if value_name == "AbilityCastRange" then return 1 end
		if value_name == "AbilityCharges" then return 1 end
		if value_name == "AbilityChargeRestoreTime" then return 1 end

    if value_name == "cast_range" then return 1 end
    if value_name == "radius" then return 1 end
    if value_name == "min_mult" then return 1 end
    if value_name == "max_mult" then return 1 end
    if value_name == "target_mult" then return 1 end
		if value_name == "damage" then return 1 end
		if value_name == "heal" then return 1 end
    if value_name == "special_stun_duration" then return 1 end
    if value_name == "special_purge" then return 1 end
	end

	if ability:GetAbilityName() == "paladin_4__magnus" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
    if value_name == "AbilityCastRange" then return 1 end

    if value_name == "damage_percent" then return 1 end
		if value_name == "interval" then return 1 end
		if value_name == "radius" then return 1 end
		if value_name == "disarmed" then return 1 end
		if value_name == "duration" then return 1 end
    if value_name == "special_heal_unit" then return 1 end
    if value_name == "special_heal_hero" then return 1 end
    if value_name == "special_manaloss" then return 1 end
    if value_name == "special_cast_range" then return 1 end
	end

	if ability:GetAbilityName() == "paladin_5__smite" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
    if value_name == "AbilityCastRange" then return 1 end
    if value_name == "AbilityCharges" then return 1 end
    if value_name == "AbilityChargeRestoreTime" then return 1 end

    if value_name == "damage" then return 1 end
    if value_name == "heal" then return 1 end
    if value_name == "special_attack_range" then return 1 end
    if value_name == "special_stun_duration" then return 1 end
    if value_name == "special_hits" then return 1 end
	end

	if ability:GetAbilityName() == "paladin_u__faith" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end

    if value_name == "max_health" then return 1 end
    if value_name == "special_stone_resist" then return 1 end
    if value_name == "special_cold_resist" then return 1 end
    if value_name == "special_poison_resist" then return 1 end
    if value_name == "special_thunder_resist" then return 1 end
    if value_name == "special_sleep_resist" then return 1 end
    if value_name == "special_bleed_resit" then return 1 end
    if value_name == "special_magic_resist" then return 1 end
    if value_name == "special_aura_radius" then return 1 end
    if value_name == "special_max_mana" then return 1 end
	end

	return 0
end

function paladin_special_values:GetModifierOverrideAbilitySpecialValue(keys)
	local caster = self:GetCaster()
	local ability = keys.ability
	local value_name = keys.ability_special_value
	local value_level = keys.ability_special_level
	local ability_level = ability:GetLevel()
	if ability_level < 1 then ability_level = 1 end

  local mana_mult = (1 + ((ability_level - 1) * 0.1))

	if ability:GetAbilityName() == "paladin_1__link" then
    if self:HasRank(1, 1, 1) then
      if value_name == "special_magical_damage" then return 30 end
    end

    if self:HasRank(1, 1, 2) then
      if value_name == "special_physical_damage" then return 30 end
    end

    if self:HasRank(1, 2, 1) then
      if value_name == "AbilityChargeRestoreTime" then return 30 end
      if value_name == "absorption" then return 100 end
		end

    if self:HasRank(1, 2, 2) then
      if value_name == "AbilityCharges" then return 2 end
      if value_name == "absorption" then return 50 end
		end

		if self:HasRank(1, 3, 1) then
      if value_name == "special_heal" then return 20 * self:GetHealPower() end
		end

    if self:HasRank(1, 3, 2) then
      if value_name == "special_mana" then return 10 * self:GetHealPower() end
		end

		if value_name == "AbilityManaCost" then return 200 * mana_mult end
		if value_name == "AbilityCooldown" then return 0 end
    if value_name == "AbilityCastRange" then return ability:GetSpecialValueFor("cast_range") end
    if value_name == "AbilityCharges" then return 1 end
    if value_name == "AbilityChargeRestoreTime" then return 40 end
    if value_name == "cast_range" then return 600 + (value_level * 50) end
		if value_name == "max_range" then return 900 + (value_level * 50) end

    if value_name == "absorption" then return 75 end
    if value_name == "duration" then return 20 end
	end

	if ability:GetAbilityName() == "paladin_2__shield" then
    if self:HasRank(2, 1, 1) then
      if value_name == "AbilityCooldown" then return 16 end
    end

    if self:HasRank(2, 1, 2) then
      if value_name == "special_cast_range" then return 500 end
    end

    if self:HasRank(2, 2, 1) then
      if value_name == "special_burn_damage" then return 40 * self:GetMagicalDamageAmp() end
      if value_name == "special_burn_radius" then return 250 end
      if value_name == "special_burn_tick" then return 0.4 end
		end

    if self:HasRank(2, 2, 2) then
      if value_name == "special_hp_regen" then return 40 end
		end

		if self:HasRank(2, 3, 1) then
      if value_name == "hits" then return 12 end
		end

    if self:HasRank(2, 3, 2) then
      if value_name == "special_bkb" then return 1 end
      if value_name == "status_resist" then return 0 end
		end

		if value_name == "AbilityManaCost" then return 120 * mana_mult end
		if value_name == "AbilityCooldown" then return 18 end
		if value_name == "AbilityCastRange" then return ability:GetSpecialValueFor("special_cast_range") end
		if value_name == "duration" then return (18 + (value_level * 1)) * self:GetBuffAmp() end

    if value_name == "hits" then return 8 end
    if value_name == "status_resist" then return 40 end
	end

	if ability:GetAbilityName() == "paladin_3__hammer" then
    if self:HasRank(3, 1, 1) then
      if value_name == "AbilityManaCost" then return 150 * mana_mult end
    end

    if self:HasRank(3, 1, 2) then
      if value_name == "AbilityCharges" then return 2 end
      if value_name == "AbilityChargeRestoreTime" then return 18 end
    end

    if self:HasRank(3, 2, 1) then
      if value_name == "cast_range" then return 0 end
		end

    if self:HasRank(3, 2, 2) then
      if value_name == "special_stun_duration" then return 2.5 * self:GetDebuffAmp() end
      if value_name == "special_purge" then return 1 end
		end

		if self:HasRank(3, 3, 1) then
      if value_name == "target_mult" then return 3 end
		end

    if self:HasRank(3, 3, 2) then
      if value_name == "target_mult" then return 0 end
      if value_name == "max_mult" then return 4 end
      if value_name == "radius" then return 450 end
		end

		if value_name == "AbilityManaCost" then return 180 * mana_mult end
		if value_name == "AbilityCooldown" then return 0 end
    if value_name == "AbilityCastRange" then return ability:GetSpecialValueFor("cast_range") end
    if value_name == "AbilityCharges" then return 1 end
		if value_name == "AbilityChargeRestoreTime" then return 15 end
		if value_name == "damage" then return 90 + math.floor(value_level * 5) * self:GetHolyDamageAmp() end
		if value_name == "heal" then return 60 + math.floor(value_level * 2.5) * self:GetHealPower() end

    if value_name == "cast_range" then return 750 end
    if value_name == "radius" then return 275 end
    if value_name == "min_mult" then return 2 end
    if value_name == "max_mult" then return 3 end
    if value_name == "target_mult" then return 1 end
	end

	if ability:GetAbilityName() == "paladin_4__magnus" then
    if self:HasRank(4, 1, 1) then
      if value_name == "special_heal_unit" then return 1 end
      if value_name == "special_heal_hero" then return 5 end
    end

    if self:HasRank(4, 1, 2) then
      if value_name == "disarmed" then return 0 end
    end

    if self:HasRank(4, 2, 1) then
      if value_name == "damage_percent" then return 2.75 end
		end

    if self:HasRank(4, 2, 2) then
      if value_name == "special_manaloss" then return 25 end
		end

		if self:HasRank(4, 3, 1) then
      if value_name == "radius" then return 450 end
		end

    if self:HasRank(4, 3, 2) then
      if value_name == "AbilityCooldown" then return 50 end
      if value_name == "special_cast_range" then return 600 end
		end

		if value_name == "AbilityManaCost" then return 400 * mana_mult end
		if value_name == "AbilityCooldown" then return 60 end
    if value_name == "AbilityCastRange" then return ability:GetSpecialValueFor("special_cast_range") end
		if value_name == "duration" then return 6 + (value_level * 0.25) end

    if value_name == "damage_percent" then return 2 end
		if value_name == "interval" then return 0.2 end
		if value_name == "radius" then return 325 end
		if value_name == "disarmed" then return 1 end
	end

	if ability:GetAbilityName() == "paladin_5__smite" then
    if self:HasRank(5, 1, 1) then
      if value_name == "special_attack_range" then return 50 end
    end

    if self:HasRank(5, 1, 2) then
      if value_name == "special_stun_duration" then return 0.1 end
    end

    if self:HasRank(5, 2, 1) then
      if value_name == "heal" then return 80 * self:GetHealPower() end
		end

    if self:HasRank(5, 2, 2) then
      if value_name == "damage" then return 180 * self:GetHolyDamageAmp() end
		end

		if self:HasRank(5, 3, 1) then
      if value_name == "AbilityManaCost" then return 25 * mana_mult end
      if value_name == "AbilityCharges" then return 4 end
		end

    if self:HasRank(5, 3, 2) then
      if value_name == "special_hits" then return 5 end
      if value_name == "AbilityCharges" then return 2 end
		end

		if value_name == "AbilityManaCost" then return 50 * mana_mult end
		if value_name == "AbilityCooldown" then return 0 end
    if value_name == "AbilityCastRange" then return caster:Script_GetAttackRange() end
    if value_name == "AbilityCharges" then return 3 end
    if value_name == "AbilityChargeRestoreTime" then return ability:GetSpecialValueFor("restore_time") end

    if value_name == "damage" then return 120 * self:GetHolyDamageAmp() end
    if value_name == "heal" then return 40 * self:GetHealPower() end
	end

	if ability:GetAbilityName() == "paladin_u__faith" then
    if self:HasRank(6, 1, 1) then
      if value_name == "special_stone_resist" then return 20 end
      if value_name == "special_cold_resist" then return 20 end
      if value_name == "special_poison_resist" then return 20 end
    end

    if self:HasRank(6, 1, 2) then
      if value_name == "special_thunder_resist" then return 20 end
      if value_name == "special_sleep_resist" then return 20 end
      if value_name == "special_bleed_resit" then return 20 end
    end

    if self:HasRank(6, 2, 1) then
      if value_name == "special_magic_resist" then return 4 end
		end

    if self:HasRank(6, 2, 2) then
      if value_name == "special_aura_radius" then return 900 end
		end

		if self:HasRank(6, 3, 1) then
      if value_name == "max_health" then return 4000 end
		end

    if self:HasRank(6, 3, 2) then
      if value_name == "special_max_mana" then return 300 end
		end

		if value_name == "AbilityManaCost" then return 0 end
		if value_name == "AbilityCooldown" then return 0 end

    if value_name == "max_health" then return 3000 end
	end

	return 0
end

-- UTILS -----------------------------------------------------------

function paladin_special_values:LearnRank(skill_id, tier, path)
  for index, table in pairs(self.ranks) do
    if table.skill_id == skill_id and table.tier == tier and table.path == path then
      self.ranks[index].learned = 1
    end
  end

  self:SendBuffRefreshToClients()
end

function paladin_special_values:HasRank(skill_id, tier, path)
  for index, table in pairs(self.ranks) do
    if table.skill_id == skill_id and table.tier == tier and table.path == path then
      return self.ranks[index].learned == 1
    end
  end
end

function paladin_special_values:UpdateData(data, value)
	self.data_props[data] = value
  self:SendBuffRefreshToClients()
end

function paladin_special_values:GetBuffAmp()
  return 1 + self.data_props["buff_amp"]
end

function paladin_special_values:GetDebuffAmp()
  return 1 + self.data_props["debuff_amp"]
end

function paladin_special_values:GetPhysicalDamageAmp()
  return self.data_props["physical_damage"] * 0.01
end

function paladin_special_values:GetMagicalDamageAmp()
  return self.data_props["magical_damage"] * 0.01
end

function paladin_special_values:GetHolyDamageAmp()
  return self.data_props["holy_damage"] * 0.01
end

function paladin_special_values:GetHealPower()
  return 1 + self.data_props["heal_power"]
end

function paladin_special_values:CalcLuck(value)
  local result = value * (1 + self.data_props["luck"])
  if result < 0 then result = 0 elseif result > 100 then result = 100 end

  return result
end

-- EFFECTS -----------------------------------------------------------