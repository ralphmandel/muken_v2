templar_special_values = class({})

function templar_special_values:IsHidden() return true end
function templar_special_values:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function templar_special_values:OnCreated(kv)
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
    luck = 0,
    day_time = 0
  }
end

function templar_special_values:OnRefresh(kv)
end

function templar_special_values:OnRemoved()
end

function templar_special_values:AddCustomTransmitterData()
  return {
    ranks = self.ranks,
    data_props = self.data_props
  }
end

function templar_special_values:HandleCustomTransmitterData(data)
	self.ranks = data.ranks
	self.data_props = data.data_props
end

-- API FUNCTIONS -----------------------------------------------------------

function templar_special_values:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE
	}

	return funcs
end

function templar_special_values:GetModifierOverrideAbilitySpecial(keys)
	local caster = self:GetCaster()
	local ability = keys.ability
	local value_name = keys.ability_special_value
	local value_level = keys.ability_special_level
  --"AbilityCastRange"
  --"AbilityCharges"
  --"AbilityChargeRestoreTime"

	if ability:GetAbilityName() == "templar_1__shield" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end

    if value_name == "radius" then return 1 end
    if value_name == "base" then return 1 end
		if value_name == "res_stack" then return 1 end
    if value_name == "special_day_vision" then return 1 end
    if value_name == "special_armor" then return 1 end
    if value_name == "special_return" then return 1 end
    if value_name == "special_spellblock_chance" then return 1 end
	end

	if ability:GetAbilityName() == "templar_2__protection" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
		if value_name == "AbilityCastRange" then return 1 end

    if value_name == "cast_range" then return 1 end
    if value_name == "duration" then return 1 end
		if value_name == "cooldown" then return 1 end
    if value_name == "special_ms" then return 1 end
    if value_name == "special_bkb" then return 1 end
    if value_name == "special_heal" then return 1 end
    if value_name == "special_hp_cap" then return 1 end
    if value_name == "special_self_cast" then return 1 end
	end

	if ability:GetAbilityName() == "templar_3__hammer" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
    if value_name == "AbilityCastRange" then return 1 end
    if value_name == "AbilityCharges" then return 1 end
    if value_name == "AbilityChargeRestoreTime" then return 1 end

		if value_name == "proj_speed" then return 1 end
		if value_name == "bounce_range" then return 1 end
		if value_name == "hits" then return 1 end
		if value_name == "damage" then return 1 end
		if value_name == "interval" then return 1 end
		if value_name == "slow_start" then return 1 end
		if value_name == "reduction" then return 1 end
		if value_name == "cast_range" then return 1 end
		if value_name == "special_heal" then return 1 end
		if value_name == "special_as_start" then return 1 end
	end

	if ability:GetAbilityName() == "templar_4__revenge" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
		if value_name == "AbilityCastRange" then return 1 end
		if value_name == "revenge_chance" then return 1 end

		if caster:FindAbilityByName("templar_4__revenge_rank_11") then
      if value_name == "duration" then return 1 end
		end

    if caster:FindAbilityByName("templar_4__revenge_rank_12") then
      if value_name == "stack" then return 1 end
		end

		if caster:FindAbilityByName("templar_4__revenge_rank_21") then
      if value_name == "delay" then return 1 end
		end

    if caster:FindAbilityByName("templar_4__revenge_rank_22") then
      if value_name == "special_microstun" then return 1 end
		end

		if caster:FindAbilityByName("templar_4__revenge_rank_31") then
      if value_name == "damage_hit" then return 1 end
		end

    if caster:FindAbilityByName("templar_4__revenge_rank_32") then
      if value_name == "special_autocast" then return 1 end
		end
	end

	if ability:GetAbilityName() == "templar_5__reborn" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
		if value_name == "AbilityCastRange" then return 1 end
		if value_name == "cooldown" then return 1 end

		if caster:FindAbilityByName("templar_5__reborn_rank_11") then
      if value_name == "special_refresh" then return 1 end
		end

    if caster:FindAbilityByName("templar_5__reborn_rank_12") then
      if value_name == "special_bkb" then return 1 end
		end

		if caster:FindAbilityByName("templar_5__reborn_rank_21") then
      if value_name == "cast_point" then return 1 end
		end

    if caster:FindAbilityByName("templar_5__reborn_rank_22") then
      if value_name == "cast_range" then return 1 end
		end

		if caster:FindAbilityByName("templar_5__reborn_rank_31") then
      if value_name == "percent" then return 1 end
		end

    if caster:FindAbilityByName("templar_5__reborn_rank_32") then
      if value_name == "special_reborn" then return 1 end
		end
	end

	if ability:GetAbilityName() == "templar_u__praise" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
		if value_name == "hp_cap" then return 1 end

		if caster:FindAbilityByName("templar_u__praise_rank_11") then
      if value_name == "duration" then return 1 end
		end

    if caster:FindAbilityByName("templar_u__praise_rank_12") then
		end

		if caster:FindAbilityByName("templar_u__praise_rank_21") then
      if value_name == "special_bkb" then return 1 end
		end

    if caster:FindAbilityByName("templar_u__praise_rank_22") then
      if value_name == "special_ethereal" then return 1 end
		end

		if caster:FindAbilityByName("templar_u__praise_rank_31") then
      if value_name == "heal" then return 1 end
		end

    if caster:FindAbilityByName("templar_u__praise_rank_32") then
      if value_name == "special_mana" then return 1 end
		end
  end

	return 0
end

function templar_special_values:GetModifierOverrideAbilitySpecialValue(keys)
	local caster = self:GetCaster()
	local ability = keys.ability
	local value_name = keys.ability_special_value
	local value_level = keys.ability_special_level
	local ability_level = ability:GetLevel()
	if ability_level < 1 then ability_level = 1 end

  local mana_mult = (1 + ((ability_level - 1) * 0.1))

	if ability:GetAbilityName() == "templar_1__shield" then
    if self:HasRank(1, 1, 1) then
      if value_name == "radius" and self.data_props["day_time"] == 1 then return -1 end
    end

    if self:HasRank(1, 1, 2) then
      if value_name == "special_day_vision" then return 150 end
    end

    if self:HasRank(1, 2, 1) then
      if value_name == "base" then return 2 end
		end

    if self:HasRank(1, 2, 2) then
      if value_name == "special_armor" then return 0.5 end
		end

		if self:HasRank(1, 3, 1) then
      if value_name == "special_return" then return 20 end
		end

    if self:HasRank(1, 3, 2) then
      if value_name == "special_spellblock_chance" then return 10 end
		end

		if value_name == "AbilityManaCost" then return 0 end
		if value_name == "AbilityCooldown" then return 0 end
		if value_name == "res_stack" then return 12 + (value_level * 0.25) end

    if value_name == "radius" then return 1000 end
    if value_name == "base" then return 1 end
	end

	if ability:GetAbilityName() == "templar_2__protection" then
    if self:HasRank(2, 1, 1) then
      if value_name == "cast_range" then return 800 end
    end

    if self:HasRank(2, 1, 2) then
      if value_name == "special_ms" then return 50 end
    end

    if self:HasRank(2, 2, 1) then
      if value_name == "duration" then return 6.5 end
		end

    if self:HasRank(2, 2, 2) then
      if value_name == "duration" then return 4 end
      if value_name == "special_bkb" then return 1 end
		end

		if self:HasRank(2, 3, 1) then
      if value_name == "special_heal" then return 60 * self:GetHealPower() end
      if value_name == "special_hp_cap" then return 75 end
		end

    if self:HasRank(2, 3, 2) then
      if value_name == "special_self_cast" then return 1 end
		end

		if value_name == "AbilityManaCost" then return 200 * mana_mult end
		if value_name == "AbilityCooldown" then return ability:GetSpecialValueFor("cooldown") end
    if value_name == "AbilityCastRange" then return ability:GetSpecialValueFor("cast_range") end
		if value_name == "cooldown" then return 18 - (value_level * 0.5) end

    if value_name == "cast_range" then return 500 end
    if value_name == "duration" then return 5 end
	end

	if ability:GetAbilityName() == "templar_3__hammer" then
    if self:HasRank(3, 1, 1) then
      if value_name == "damage" then return 375 * self:GetHolyDamageAmp() end
    end

    if self:HasRank(3, 1, 2) then
      if value_name == "special_heal" then return 30 end
    end

    if self:HasRank(3, 2, 1) then
      if value_name == "hits" then return 3 end
		end

    if self:HasRank(3, 2, 2) then
      if value_name == "AbilityCharges" then return 2 end
		end

		if self:HasRank(3, 3, 1) then
      if value_name == "slow_start" then return 100 * self:GetDebuffAmp() end
      if value_name == "interval" then return 0.9 end

		end

    if self:HasRank(3, 3, 2) then
      if value_name == "special_as_start" then return -50 * self:GetDebuffAmp() end
		end

		if value_name == "AbilityManaCost" then return 125 * mana_mult end
		if value_name == "AbilityCooldown" then return 0 end
    if value_name == "AbilityCastRange" then return ability:GetSpecialValueFor("cast_range") end
    if value_name == "AbilityCharges" then return 1 end
    if value_name == "AbilityChargeRestoreTime" then return 13 end
		if value_name == "cast_range" then return 700 + (value_level * 50) end

		if value_name == "proj_speed" then return 1500 end
		if value_name == "bounce_range" then return 500 end
		if value_name == "hits" then return 2 end
		if value_name == "damage" then return 300 * self:GetHolyDamageAmp() end
		if value_name == "interval" then return 0.6 end
		if value_name == "slow_start" then return 75 * self:GetDebuffAmp() end
		if value_name == "reduction" then return 20 end
	end

	if ability:GetAbilityName() == "templar_4__revenge" then
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

		if value_name == "AbilityManaCost" then return 175 * mana_mult end
		if value_name == "AbilityCooldown" then return 40 end
    if value_name == "AbilityCastRange" then return ability:GetSpecialValueFor("cast_range") end

		if value_name == "revenge_chance" then return 6 + (value_level * 0.25) end
    if value_name == "duration" then return 50 end
    if value_name == "stack" then return 9 end
    if value_name == "delay" then return 2.2 end
    if value_name == "special_microstun" then return 0.1 end
    if value_name == "damage_hit" then return 50 end
    if value_name == "special_autocast" then return 7 end
	end

	if ability:GetAbilityName() == "templar_5__reborn" then
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

		if value_name == "AbilityManaCost" then return 250 * mana_mult end
		if value_name == "AbilityCooldown" then return ability:GetSpecialValueFor("cooldown") end
		if value_name == "AbilityCastRange" then return ability:GetSpecialValueFor("cast_range") end
    
		if value_name == "cooldown" then return 75 - (value_level * 2.5) end
    if value_name == "special_refresh" then return 1 end
    if value_name == "special_bkb" then return 10 end
    if value_name == "cast_point" then return 2 end
    if value_name == "cast_range" then return 900 end
    if value_name == "percent" then return 75 end
    if value_name == "special_reborn" then return 17 end
	end

	if ability:GetAbilityName() == "templar_u__praise" then
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

		if value_name == "AbilityManaCost" then return 400 * mana_mult end
    
		if value_name == "AbilityCooldown" then
      if caster:FindAbilityByName("templar_u__praise_rank_12") then
        return 100
      end
      return 120
    end

    if value_name == "hp_cap" then return 60 + (value_level * 2.5) end
    if value_name == "duration" then return 10 end
    if value_name == "heal" then return 80 end
    if value_name == "special_bkb" then return 1 end
    if value_name == "special_ethereal" then return 1 end
    if value_name == "special_mana" then return 30 end
	end

	return 0
end

-- UTILS -----------------------------------------------------------

function templar_special_values:LearnRank(skill_id, tier, path)
  for index, table in pairs(self.ranks) do
    if table.skill_id == skill_id and table.tier == tier and table.path == path then
      self.ranks[index].learned = 1
    end
  end

  self:SendBuffRefreshToClients()
end

function templar_special_values:HasRank(skill_id, tier, path)
  for index, table in pairs(self.ranks) do
    if table.skill_id == skill_id and table.tier == tier and table.path == path then
      return self.ranks[index].learned == 1
    end
  end
end

function templar_special_values:UpdateData(data, value)
	self.data_props[data] = value
  self:SendBuffRefreshToClients()
end

function templar_special_values:GetBuffAmp()
  return 1 + self.data_props["buff_amp"]
end

function templar_special_values:GetDebuffAmp()
  return 1 + self.data_props["debuff_amp"]
end

function templar_special_values:GetPhysicalDamageAmp()
  return self.data_props["physical_damage"] * 0.01
end

function templar_special_values:GetMagicalDamageAmp()
  return self.data_props["magical_damage"] * 0.01
end

function templar_special_values:GetHolyDamageAmp()
  return self.data_props["holy_damage"] * 0.01
end

function templar_special_values:GetHealPower()
  return 1 + self.data_props["heal_power"]
end

function templar_special_values:CalcLuck(value)
  local result = value * (1 + self.data_props["luck"])
  if result < 0 then result = 0 elseif result > 100 then result = 100 end

  return result
end

-- EFFECTS -----------------------------------------------------------