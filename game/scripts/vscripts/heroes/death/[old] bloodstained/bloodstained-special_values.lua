bloodstained_special_values = class({})

function bloodstained_special_values:IsHidden() return true end
function bloodstained_special_values:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function bloodstained_special_values:OnCreated(kv)
  if IsServer() then
    self:SetHasCustomTransmitterData(true)

    self.data_props = {
      buff_amp = 0,
      debuff_amp = 0
    }
  end
end

function bloodstained_special_values:OnRefresh(kv)
end

function bloodstained_special_values:OnRemoved()
end

function bloodstained_special_values:AddCustomTransmitterData()
  return {data_props = self.data_props}
end

function bloodstained_special_values:HandleCustomTransmitterData(data)
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
		if value_name == "AbilityCooldown" then return 1 end
    if value_name == "AbilityCastRange" then return 1 end

    if value_name == "radius" then return 1 end
    if value_name == "call_duration" then return 1 end
    if value_name == "damage_gain" then return 1 end
    if value_name == "duration" then return 1 end
		if value_name == "cooldown" then return 1 end
    if value_name == "special_reset" then return 1 end
    if value_name == "special_blink" then return 1 end
    if value_name == "special_damage_init" then return 1 end
	end

  if ability:GetAbilityName() == "bloodstained_2__frenzy" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
		if value_name == "duration" then return 1 end

		if caster:FindAbilityByName("bloodstained_2__frenzy_rank_11") then
      if value_name == "ms" then return 1 end
		end

    if caster:FindAbilityByName("bloodstained_2__frenzy_rank_12") then
      if value_name == "special_purge" then return 1 end
		end

		if caster:FindAbilityByName("bloodstained_2__frenzy_rank_21") then
      if value_name == "status_res" then return 1 end
		end

    if caster:FindAbilityByName("bloodstained_2__frenzy_rank_22") then
      if value_name == "special_bleeding_duration" then return 1 end
		end

		if caster:FindAbilityByName("bloodstained_2__frenzy_rank_31") then
      if value_name == "attack_speed" then return 1 end
		end

    if caster:FindAbilityByName("bloodstained_2__frenzy_rank_32") then
      if value_name == "special_cleave" then return 1 end
		end
	end

	if ability:GetAbilityName() == "bloodstained_3__curse" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
    if value_name == "AbilityCastRange" then return 1 end
    if value_name == "AbilityCharges" then return 1 end
    if value_name == "AbilityChargeRestoreTime" then return 1 end
    if value_name == "max_range" then return 1 end
		if value_name == "duration" then return 1 end

		if caster:FindAbilityByName("bloodstained_3__curse_rank_11") then
		end

    if caster:FindAbilityByName("bloodstained_3__curse_rank_12") then
      if value_name == "special_slow_percent" then return 1 end
		end

		if caster:FindAbilityByName("bloodstained_3__curse_rank_21") then
      if value_name == "shared_damage" then return 1 end
		end

    if caster:FindAbilityByName("bloodstained_3__curse_rank_22") then
      if value_name == "special_max_hp_steal" then return 1 end
		end

		if caster:FindAbilityByName("bloodstained_3__curse_rank_31") then
		end

    if caster:FindAbilityByName("bloodstained_3__curse_rank_32") then
      if value_name == "special_kill_reset" then return 1 end
		end
	end

	if ability:GetAbilityName() == "bloodstained_4__tear" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
    if value_name == "blood_percent" then return 1 end

		if caster:FindAbilityByName("bloodstained_4__tear_rank_11") then
		end

    if caster:FindAbilityByName("bloodstained_4__tear_rank_12") then
      if value_name == "special_copy_leech" then return 1 end
		end

		if caster:FindAbilityByName("bloodstained_4__tear_rank_21") then
      if value_name == "blood_duration" then return 1 end
		end

    if caster:FindAbilityByName("bloodstained_4__tear_rank_22") then
      if value_name == "special_init_loss" then return 1 end
		end

		if caster:FindAbilityByName("bloodstained_4__tear_rank_31") then
      if value_name == "hp_lost" then return 1 end
      if value_name == "tick" then return 1 end
    end

    if caster:FindAbilityByName("bloodstained_4__tear_rank_32") then
      if value_name == "radius" then return 1 end
		end
	end

  if ability:GetAbilityName() == "bloodstained_5__lifesteal" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
		if value_name == "base_heal" then return 1 end

		if caster:FindAbilityByName("bloodstained_5__lifesteal_rank_11") then
      if value_name == "special_target_hp" then return 1 end
		end

    if caster:FindAbilityByName("bloodstained_5__lifesteal_rank_12") then
      if value_name == "special_self_hp_hero" then return 1 end
      if value_name == "special_self_hp_creep" then return 1 end
      if value_name == "special_heal_radius" then return 1 end
		end

		if caster:FindAbilityByName("bloodstained_5__lifesteal_rank_21") then
      if value_name == "max_heal" then return 1 end
		end

    if caster:FindAbilityByName("bloodstained_5__lifesteal_rank_22") then
      if value_name == "special_max_hp_regen" then return 1 end
		end

		if caster:FindAbilityByName("bloodstained_5__lifesteal_rank_31") then
      if value_name == "special_min_heal" then return 1 end
		end

    if caster:FindAbilityByName("bloodstained_5__lifesteal_rank_32") then
      if value_name == "special_max_heal" then return 1 end
		end
	end

	if ability:GetAbilityName() == "bloodstained_u__seal" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
    if value_name == "AbilityCastRange" then return 1 end
		if value_name == "steal_duration" then return 1 end

		if caster:FindAbilityByName("bloodstained_u__seal_rank_11") then
      if value_name == "duration" then return 1 end
		end

    if caster:FindAbilityByName("bloodstained_u__seal_rank_12") then
      if value_name == "slow_duration" then return 1 end
		end

		if caster:FindAbilityByName("bloodstained_u__seal_rank_21") then
      if value_name == "special_break" then return 1 end
		end

    if caster:FindAbilityByName("bloodstained_u__seal_rank_22") then
      if value_name == "hp_stolen" then return 1 end
		end

		if caster:FindAbilityByName("bloodstained_u__seal_rank_31") then
      if value_name == "special_kill" then return 1 end
      if value_name == "special_bleed_in" then return 1 end
		end

    if caster:FindAbilityByName("bloodstained_u__seal_rank_32") then
      if value_name == "special_bleed_out" then return 1 end
		end
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
		if value_name == "AbilityManaCost" then return 120 * mana_mult end
		if value_name == "AbilityCooldown" then return ability:GetSpecialValueFor("cooldown") end
    if value_name == "AbilityCastRange" then return ability:GetSpecialValueFor("special_blink") end
		if value_name == "cooldown" then return 16 - (value_level * 1) end

		if caster:FindAbilityByName("bloodstained_1__rage_rank_11") then
      if value_name == "duration" then return 12 * self:GetBuffAmp() end
		end

    if caster:FindAbilityByName("bloodstained_1__rage_rank_12") then
      if value_name == "special_reset" then return 1 end
		end

		if caster:FindAbilityByName("bloodstained_1__rage_rank_21") then
      if value_name == "call_duration" then return 6 * self:GetDebuffAmp() end
		end

    if caster:FindAbilityByName("bloodstained_1__rage_rank_22") then
      if value_name == "radius" then return 375 end
      if value_name == "special_blink" then return 300 end
		end

		if caster:FindAbilityByName("bloodstained_1__rage_rank_31") then
      if value_name == "damage_gain" then return 10 end
		end

    if caster:FindAbilityByName("bloodstained_1__rage_rank_32") then
      if value_name == "special_damage_init" then return 100 end
		end

    if value_name == "radius" then return 275 end
    if value_name == "call_duration" then return 3 * self:GetDebuffAmp() end
    if value_name == "damage_gain" then return 6 end
    if value_name == "duration" then return 10 * self:GetBuffAmp() end

    return 0
	end

  if ability:GetAbilityName() == "bloodstained_2__frenzy" then
		if value_name == "AbilityManaCost" then return 0 end
		if value_name == "AbilityCooldown" then return 0 end
		if value_name == "duration" then return (3 + (value_level * 0.25)) * self:GetBuffAmp() end

    if value_name == "ms" then return 300 end
    if value_name == "special_purge" then return 1 end
    if value_name == "status_res" then return 50 end
    if value_name == "special_bleeding_duration" then return 3 end
    if value_name == "attack_speed" then return 100 end
    if value_name == "special_cleave" then return 100 end
  end

	if ability:GetAbilityName() == "bloodstained_3__curse" then
		if value_name == "AbilityManaCost" then return 150 * mana_mult end
		if value_name == "AbilityCooldown" then return 0 end

    if value_name == "AbilityCharges" then
      if caster:FindAbilityByName("bloodstained_3__curse_rank_31") then
        return 2
      end
      return 1
    end

    if value_name == "AbilityChargeRestoreTime" then
      if caster:FindAbilityByName("bloodstained_3__curse_rank_31") then
        return 45
      end
      return 60
    end
    
    if value_name == "AbilityCastRange" then
      if caster:FindAbilityByName("bloodstained_3__curse_rank_11") then
        return 550
      end
      return 350
    end

		if value_name == "max_range" then return ability:GetSpecialValueFor("AbilityCastRange") + 350 end
		if value_name == "duration" then return 30 + (value_level * 5) end
		if value_name == "special_slow_percent" then return 20 end
    if value_name == "shared_damage" then return 80 end
    if value_name == "special_max_hp_steal" then return 20 end
    if value_name == "special_kill_reset" then return 1 end
	end

	if ability:GetAbilityName() == "bloodstained_4__tear" then
		if value_name == "AbilityManaCost" then
      if ability:GetCurrentAbilityCharges() == 1 then
        return 100 * mana_mult
      end
      return 0
    end
    
		if value_name == "AbilityCooldown" then
      if caster:FindAbilityByName("bloodstained_4__tear_rank_11") then
        return 20
      end

      return 40
    end

    if value_name == "blood_percent" then return 8 + (value_level * 0.25) end
    if value_name == "special_copy_leech" then return 1 end
    if value_name == "blood_duration" then return 30 end
    if value_name == "special_init_loss" then return 30 end
    if value_name == "hp_lost" then return 2 end
    if value_name == "tick" then return 0.75 end
    if value_name == "radius" then return 500 end
	end

  if ability:GetAbilityName() == "bloodstained_5__lifesteal" then
		if value_name == "AbilityManaCost" then return 0 end
		if value_name == "AbilityCooldown" then return 0 end
		if value_name == "base_heal" then return 4 + (value_level * 1) end

    if value_name == "special_target_hp" then return 15 end
    if value_name == "special_self_hp_hero" then return 10 end
    if value_name == "special_self_hp_creep" then return 2 end
    if value_name == "special_heal_radius" then return 500 end
    if value_name == "max_heal" then return 50 end
    if value_name == "special_max_hp_regen" then return 40 end
    if value_name == "special_min_heal" then return 25 end
    if value_name == "special_max_heal" then return 40 end
	end

	if ability:GetAbilityName() == "bloodstained_u__seal" then
		if value_name == "AbilityManaCost" then return 250 * mana_mult end
		if value_name == "AbilityCooldown" then return 100 end
    if value_name == "AbilityCastRange" then return ability:GetSpecialValueFor("radius") - 50 end
    if value_name == "steal_duration" then return 90 + (value_level * 10) end

    if value_name == "duration" then return 15 end
    if value_name == "slow_duration" then return 3 end
    if value_name == "special_break" then return 1 end
    if value_name == "hp_stolen" then return 15 end
    if value_name == "special_kill" then return 20 end
    if value_name == "special_bleed_in" then return 1 end
    if value_name == "special_bleed_out" then return 1 end
	end

	return 0
end

-- UTILS -----------------------------------------------------------

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

-- EFFECTS -----------------------------------------------------------