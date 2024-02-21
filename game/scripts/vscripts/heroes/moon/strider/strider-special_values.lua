strider_special_values = class({})

function strider_special_values:IsHidden() return true end
function strider_special_values:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function strider_special_values:OnCreated(kv)
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

function strider_special_values:OnRefresh(kv)
end

function strider_special_values:OnRemoved()
end

function strider_special_values:AddCustomTransmitterData()
  return {
    ranks = self.ranks,
    data_props = self.data_props
  }
end

function strider_special_values:HandleCustomTransmitterData(data)
	self.ranks = data.ranks
	self.data_props = data.data_props
end

-- API FUNCTIONS -----------------------------------------------------------

function strider_special_values:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE
	}

	return funcs
end

function strider_special_values:GetModifierOverrideAbilitySpecial(keys)
	local caster = self:GetCaster()
	local ability = keys.ability
	local value_name = keys.ability_special_value
	local value_level = keys.ability_special_level
  --"AbilityCastRange"
  --"AbilityCharges"
  --"AbilityChargeRestoreTime"

	if ability:GetAbilityName() == "strider_1__silence" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
		if value_name == "AbilityCastRange" then return 1 end
		if value_name == "AbilityHealthCost" then return 1 end

    if value_name == "proj_speed" then return 1 end
		if value_name == "cast_range" then return 1 end
		if value_name == "heal_bonus" then return 1 end
		if value_name == "duration" then return 1 end
    if value_name == "special_slow_percent" then return 1 end
		if value_name == "special_damage_mult" then return 1 end
		if value_name == "special_stun_mult" then return 1 end
	end

	if ability:GetAbilityName() == "strider_2__spin" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end

		if value_name == "spin_duration" then return 1 end
		if value_name == "radius" then return 1 end
		if value_name == "critical_damage_stack" then return 1 end
		if value_name == "bleed_damage" then return 1 end
		if value_name == "bleed_duration" then return 1 end
		if value_name == "cooldown" then return 1 end
    if value_name == "special_bash_duration" then return 1 end
    if value_name == "special_barrier_mult" then return 1 end
    if value_name == "special_barrier_duration" then return 1 end
    if value_name == "special_cast_chance" then return 1 end
	end

	if ability:GetAbilityName() == "strider_3__smoke" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
		if value_name == "AbilityCastRange" then return 1 end

    if value_name == "fade_inv" then return 1 end
    if value_name == "evasion" then return 1 end
    if value_name == "radius" then return 1 end
    if value_name == "attack_break" then return 1 end
    if value_name == "spell_break" then return 1 end
    if value_name == "duration" then return 1 end
    if value_name == "special_cast_on_death" then return 1 end
    if value_name == "special_mute" then return 1 end
	end

	if ability:GetAbilityName() == "strider_4__shuriken" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
		if value_name == "AbilityCastRange" then return 1 end

    if value_name == "blink_range" then return 1 end
    if value_name == "damage" then return 1 end
    if value_name == "angle" then return 1 end
    if value_name == "special_allow_move" then return 1 end
    if value_name == "interval" then return 1 end
    if value_name == "shuriken_amount" then return 1 end
    if value_name == "shuriken_speed" then return 1 end
    if value_name == "shuriken_range" then return 1 end
    if value_name == "finder_range" then return 1 end
    if value_name == "special_pierce" then return 1 end
    if value_name == "special_stun_duration" then return 1 end
    if value_name == "special_lifetime" then return 1 end
    if value_name == "vector_target" then return 1 end
	end

	if ability:GetAbilityName() == "strider_5__aspd" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end

    if value_name == "attack_speed" then return 1 end
    if value_name == "movespeed" then return 1 end
    if value_name == "duration" then return 1 end
    if value_name == "special_double_ms_duration" then return 1 end
    if value_name == "special_no_slow" then return 1 end
    if value_name == "special_attack_lifesteal" then return 1 end
    if value_name == "special_aura_radius" then return 1 end
    if value_name == "special_purge" then return 1 end
	end

	if ability:GetAbilityName() == "strider_u__shadow" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
    if value_name == "AbilityCastRange" then return 1 end
    if value_name == "AbilityCharges" then return 1 end
    if value_name == "AbilityChargeRestoreTime" then return 1 end

    if value_name == "vision_range" then return 1 end
    if value_name == "max_shadows" then return 1 end
    if value_name == "duration" then return 1 end
    if value_name == "incoming_damage" then return 1 end
	end

	return 0
end

function strider_special_values:GetModifierOverrideAbilitySpecialValue(keys)
	local caster = self:GetCaster()
	local ability = keys.ability
	local value_name = keys.ability_special_value
	local value_level = keys.ability_special_level
	local ability_level = ability:GetLevel()
	if ability_level < 1 then ability_level = 1 end

  local mana_mult = (1 + ((ability_level - 1) * 0.1))

	if ability:GetAbilityName() == "strider_1__silence" then
    if self:HasRank(1, 1, 1) then
      if value_name == "cast_range" then return 1200 end
    end

    if self:HasRank(1, 1, 2) then
      if value_name == "special_slow_percent" then return 30 end
    end

    if self:HasRank(1, 2, 1) then
      if value_name == "heal_bonus" then return 75 end
		end

    if self:HasRank(1, 2, 2) then
      if value_name == "AbilityHealthCost" then return 150 + (caster:GetLevel() * 10) end
		end

		if self:HasRank(1, 3, 1) then
      if value_name == "special_damage_mult" then return 0.006 end
		end

    if self:HasRank(1, 3, 2) then
      if value_name == "special_stun_mult" then return 0.6 end
    end

		if value_name == "AbilityManaCost" then return 0 end
		if value_name == "AbilityCooldown" then return 15 end
		if value_name == "AbilityCastRange" then return ability:GetSpecialValueFor("cast_range") end
		if value_name == "AbilityHealthCost" then return 300 + (caster:GetLevel() * 20) end
    if value_name == "duration" then return (5 + (value_level * 0.2)) * self:GetDebuffAmp() end

    if value_name == "proj_speed" then return 1500 end
		if value_name == "cast_range" then return 600 end
		if value_name == "heal_bonus" then return 50 end
	end

	if ability:GetAbilityName() == "strider_2__spin" then
    if self:HasRank(2, 1, 1) then
      if value_name == "radius" then return 350 end
    end

    if self:HasRank(2, 1, 2) then
      if value_name == "special_bash_duration" then return 0.6 * self:GetDebuffAmp() end
    end

    if self:HasRank(2, 2, 1) then
      if value_name == "critical_damage_stack" then return 175 end
		end

		if self:HasRank(2, 2, 2) then
      if value_name == "bleed_damage" then return 60 * self:GetPhysicalDamageAmp() end
      if value_name == "bleed_duration" then return 4 end
		end

    if self:HasRank(2, 3, 1) then
      if value_name == "special_barrier_mult" then return 300 end
      if value_name == "special_barrier_duration" then return 5 * self:GetBuffAmp() end
		end

    if self:HasRank(2, 3, 2) then
      if value_name == "special_cast_chance" then return self:CalcLuck(10) end
      if value_name == "AbilityManaCost" then return 0 end
      if value_name == "cooldown" then return 0 end
    end

		if value_name == "AbilityManaCost" then return 50 * mana_mult end
		if value_name == "AbilityCooldown" then return ability:GetSpecialValueFor("cooldown") end
		if value_name == "cooldown" then return 9 - (value_level * 0.25) end

    if value_name == "spin_duration" then return 0.23 end
		if value_name == "radius" then return 250 end
		if value_name == "critical_damage_stack" then return 75 end
		if value_name == "bleed_damage" then return 50 * self:GetPhysicalDamageAmp() end
		if value_name == "bleed_duration" then return 3.5 end
	end

	if ability:GetAbilityName() == "strider_3__smoke" then
    if self:HasRank(3, 1, 1) then
      if value_name == "AbilityCooldown" then return 18 end
    end

    if self:HasRank(3, 1, 2) then
      if value_name == "special_cast_on_death" then return 1 end
    end

    if self:HasRank(3, 2, 1) then
      if value_name == "special_mute" then return 1 end
		end

    if self:HasRank(3, 2, 2) then
      if value_name == "radius" then return 400 end
		end

		if self:HasRank(3, 3, 1) then
      if value_name == "evasion" then return 12 end
      if value_name == "fade_inv" then return -1 end
		end

    if self:HasRank(3, 3, 2) then
      if value_name == "spell_break" then return 0 end
      if value_name == "evasion" then return 0 end
      if value_name == "fade_inv" then return 1 end
      if value_name == "attack_break" then return 30 end
    end

		if value_name == "AbilityManaCost" then return 125 * mana_mult end
		if value_name == "AbilityCooldown" then return 21 end
		if value_name == "AbilityCastRange" then return ability:GetSpecialValueFor("radius") end
    if value_name == "duration" then return 9 + (value_level * 0.5) end

    if value_name == "radius" then return 300 end
    if value_name == "fade_inv" then return 2 end
    if value_name == "evasion" then return 2 end
    if value_name == "attack_break" then return 100 end
    if value_name == "spell_break" then return 100 end
	end

	if ability:GetAbilityName() == "strider_4__shuriken" then
    if self:HasRank(4, 1, 1) then
      if value_name == "blink_range" then return 600 end
		end

    if self:HasRank(4, 1, 2) then
      if value_name == "special_allow_move" then return 1 end
      if value_name == "interval" then return 0.04 end
		end

    if self:HasRank(4, 2, 1) then
      if value_name == "damage" then return 100 * self:GetPhysicalDamageAmp() end
    end

    if self:HasRank(4, 2, 2) then
      if value_name == "shuriken_amount" then return 20 end
    end

		if self:HasRank(4, 3, 1) then
      if value_name == "special_pierce" then return 1 end
		end

    if self:HasRank(4, 3, 2) then
      if value_name == "special_stun_duration" then return 0.2 * self:GetDebuffAmp() end
      if value_name == "special_lifetime" then return 5 end
      if value_name == "shuriken_range" then return 9999 end
    end

		if value_name == "AbilityManaCost" then return 135 * mana_mult end
		if value_name == "AbilityCooldown" then return 18 end
		if value_name == "AbilityCastRange" then return ability:GetSpecialValueFor("blink_range") end
    if value_name == "finder_range" then return 900 + (value_level * 50) end

    if value_name == "blink_range" then return 400 end
    if value_name == "damage" then return 75 * self:GetPhysicalDamageAmp() end
    if value_name == "angle" then return 19 end
    if value_name == "interval" then return 0.03 end
    if value_name == "shuriken_amount" then return 15 end
    if value_name == "shuriken_speed" then return 1500 end
    if value_name == "shuriken_range" then return ability:GetSpecialValueFor("finder_range") end
    if value_name == "vector_target" then return 1 end
	end

	if ability:GetAbilityName() == "strider_5__aspd" then
    if self:HasRank(5, 1, 1) then
      if value_name == "special_double_ms_duration" then return 2.5 * self:GetBuffAmp() end
    end

    if self:HasRank(5, 1, 2) then
      if value_name == "special_no_slow" then return 1 end
    end

    if self:HasRank(5, 2, 1) then
      if value_name == "attack_speed" then return 75 end
		end

    if self:HasRank(5, 2, 2) then
      if value_name == "special_attack_lifesteal" then return 20 end
		end

		if self:HasRank(5, 3, 1) then
      if value_name == "special_aura_radius" then return 350 end
		end

    if self:HasRank(5, 3, 2) then
      if value_name == "special_purge" then return 1 end
    end

		if value_name == "AbilityManaCost" then return 100 * mana_mult end
		if value_name == "AbilityCooldown" then return 12 end
    if value_name == "duration" then return (7.5 + (value_level * 0.25)) * self:GetBuffAmp() end

    if value_name == "attack_speed" then return 50 end
    if value_name == "movespeed" then return 75 end
	end

	if ability:GetAbilityName() == "strider_u__shadow" then
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

		if value_name == "AbilityManaCost" then return 80 end
		if value_name == "AbilityCooldown" then return 0 end
    if value_name == "AbilityCastRange" then return 350 end
    if value_name == "AbilityCharges" then return 2 end
    if value_name == "AbilityChargeRestoreTime" then return 45 end
    if value_name == "incoming_damage" then return 450 - (value_level * 25) end

    if value_name == "vision_range" then return 400 end
    if value_name == "max_shadows" then return 2 end
    if value_name == "duration" then return 60 end
	end

	return 0
end

-- UTILS -----------------------------------------------------------

function strider_special_values:LearnRank(skill_id, tier, path)
  for index, table in pairs(self.ranks) do
    if table.skill_id == skill_id and table.tier == tier and table.path == path then
      self.ranks[index].learned = 1
    end
  end

  self:SendBuffRefreshToClients()
end

function strider_special_values:HasRank(skill_id, tier, path)
  for index, table in pairs(self.ranks) do
    if table.skill_id == skill_id and table.tier == tier and table.path == path then
      return self.ranks[index].learned == 1
    end
  end
end

function strider_special_values:UpdateData(data, value)
	self.data_props[data] = value
  self:SendBuffRefreshToClients()
end

function strider_special_values:GetBuffAmp()
  return 1 + self.data_props["buff_amp"]
end

function strider_special_values:GetDebuffAmp()
  return 1 + self.data_props["debuff_amp"]
end

function strider_special_values:GetPhysicalDamageAmp()
  return self.data_props["physical_damage"] * 0.01
end

function strider_special_values:GetMagicalDamageAmp()
  return self.data_props["magical_damage"] * 0.01
end

function strider_special_values:GetHolyDamageAmp()
  return self.data_props["holy_damage"] * 0.01
end

function strider_special_values:GetHealPower()
  return 1 + self.data_props["heal_power"]
end

function strider_special_values:CalcLuck(value)
  local result = value * (1 + self.data_props["luck"])
  if result < 0 then result = 0 elseif result > 100 then result = 100 end

  return result
end

-- EFFECTS -----------------------------------------------------------