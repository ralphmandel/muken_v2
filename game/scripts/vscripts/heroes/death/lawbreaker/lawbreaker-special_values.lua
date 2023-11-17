lawbreaker_special_values = class({})

function lawbreaker_special_values:IsHidden() return true end
function lawbreaker_special_values:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function lawbreaker_special_values:OnCreated(kv)
end

function lawbreaker_special_values:OnRefresh(kv)
end

function lawbreaker_special_values:OnRemoved()
end

-- API FUNCTIONS -----------------------------------------------------------

function lawbreaker_special_values:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE
	}

	return funcs
end

function lawbreaker_special_values:GetModifierOverrideAbilitySpecial(keys)
	local caster = self:GetCaster()
	local ability = keys.ability
	local value_name = keys.ability_special_value
	local value_level = keys.ability_special_level
  --"AbilityCastRange"
  --"AbilityCharges"
  --"AbilityChargeRestoreTime"

  if ability:GetAbilityName() == "muerta_gunslinger" then
    if value_name == "double_shot_chance" then return 1 end
  end

	if ability:GetAbilityName() == "lawbreaker_1__dual" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
		if value_name == "lifesteal" then return 1 end

		if caster:FindAbilityByName("lawbreaker_1__dual_rank_11") then
      if value_name == "special_attack_range" then return 1 end
		end

    if caster:FindAbilityByName("lawbreaker_1__dual_rank_12") then
		end

		if caster:FindAbilityByName("lawbreaker_1__dual_rank_21") then
      if value_name == "special_critical_chance" then return 1 end
		end

    if caster:FindAbilityByName("lawbreaker_1__dual_rank_22") then
		end

		if caster:FindAbilityByName("lawbreaker_1__dual_rank_31") then
      if value_name == "max_hit" then return 1 end
		end

    if caster:FindAbilityByName("lawbreaker_1__dual_rank_32") then
		end
	end

	if ability:GetAbilityName() == "lawbreaker_2__combo" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
		if value_name == "AbilityCharges" then return 1 end
		if value_name == "AbilityChargeRestoreTime" then return 1 end
		if value_name == "max_shots" then return 1 end

		if caster:FindAbilityByName("lawbreaker_2__combo_rank_11") then
      if value_name == "fast_reload" then return 1 end
		end

    if caster:FindAbilityByName("lawbreaker_2__combo_rank_12") then
		end

		if caster:FindAbilityByName("lawbreaker_2__combo_rank_21") then
      if value_name == "slow_percent" then return 1 end
		end

    if caster:FindAbilityByName("lawbreaker_2__combo_rank_22") then
		end

		if caster:FindAbilityByName("lawbreaker_2__combo_rank_31") then
      if value_name == "speed_mult" then return 1 end
      if value_name == "attack_range" then return 1 end
      if value_name == "special_pierce" then return 1 end
		end

    if caster:FindAbilityByName("lawbreaker_2__combo_rank_32") then
		end
	end

	if ability:GetAbilityName() == "lawbreaker_3__grenade" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
    if value_name == "AbilityCastRange" then return 1 end
		if value_name == "duration" then return 1 end

		if caster:FindAbilityByName("lawbreaker_3__grenade_rank_11") then
      if value_name == "special_stun_duration" then return 1 end
		end

    if caster:FindAbilityByName("lawbreaker_3__grenade_rank_12") then
		end

		if caster:FindAbilityByName("lawbreaker_3__grenade_rank_21") then
      if value_name == "miss_chance" then return 1 end
		end

    if caster:FindAbilityByName("lawbreaker_3__grenade_rank_22") then
		end

		if caster:FindAbilityByName("lawbreaker_3__grenade_rank_31") then
      if value_name == "damage" then return 1 end
      if value_name == "delay" then return 1 end
		end

    if caster:FindAbilityByName("lawbreaker_3__grenade_rank_32") then
		end
	end

	if ability:GetAbilityName() == "lawbreaker_4__rain" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
    if value_name == "AbilityCastRange" then return 1 end
    if value_name == "radius" then return 1 end

		if caster:FindAbilityByName("lawbreaker_4__rain_rank_11") then
      if value_name == "cast_range" then return 1 end
		end

    if caster:FindAbilityByName("lawbreaker_4__rain_rank_12") then
		end

		if caster:FindAbilityByName("lawbreaker_4__rain_rank_21") then
      if value_name == "duration" then return 1 end
		end

    if caster:FindAbilityByName("lawbreaker_4__rain_rank_22") then
		end

		if caster:FindAbilityByName("lawbreaker_4__rain_rank_31") then
      if value_name == "damage" then return 1 end
		end

    if caster:FindAbilityByName("lawbreaker_4__rain_rank_32") then
		end
	end

	if ability:GetAbilityName() == "lawbreaker_5__blink" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
    if value_name == "AbilityCastRange" then return 1 end
    if value_name == "AbilityCharges" then return 1 end
    if value_name == "AbilityChargeRestoreTime" then return 1 end
		if value_name == "restore_time" then return 1 end

		if caster:FindAbilityByName("lawbreaker_5__blink_rank_11") then
      if value_name == "special_cast_silence" then return 1 end
		end

    if caster:FindAbilityByName("lawbreaker_5__blink_rank_12") then
		end

		if caster:FindAbilityByName("lawbreaker_5__blink_rank_21") then
      if value_name == "special_illusion_duration" then return 1 end
		end

    if caster:FindAbilityByName("lawbreaker_5__blink_rank_22") then
		end

		if caster:FindAbilityByName("lawbreaker_5__blink_rank_31") then
		end

    if caster:FindAbilityByName("lawbreaker_5__blink_rank_32") then
		end
	end

	if ability:GetAbilityName() == "lawbreaker_u__form" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
		if value_name == "duration" then return 1 end

		if caster:FindAbilityByName("lawbreaker_u__form_rank_11") then
      if value_name == "special_fly" then return 1 end
		end

    if caster:FindAbilityByName("lawbreaker_u__form_rank_12") then
		end

		if caster:FindAbilityByName("lawbreaker_u__form_rank_21") then
      if value_name == "special_status_resist" then return 1 end
		end

    if caster:FindAbilityByName("lawbreaker_u__form_rank_22") then
		end

		if caster:FindAbilityByName("lawbreaker_u__form_rank_31") then
      if value_name == "special_burn_damage" then return 1 end
		end

    if caster:FindAbilityByName("lawbreaker_u__form_rank_32") then
		end
	end

	return 0
end

function lawbreaker_special_values:GetModifierOverrideAbilitySpecialValue(keys)
	local caster = self:GetCaster()
	local ability = keys.ability
	local value_name = keys.ability_special_value
	local value_level = keys.ability_special_level
	local ability_level = ability:GetLevel()
	if ability_level < 1 then ability_level = 1 end

  if value_name == "double_shot_chance" then
    if ability:GetCurrentAbilityCharges() == 1 then
      return 100
    end
    return 0
  end

	if ability:GetAbilityName() == "lawbreaker_1__dual" then
		if value_name == "AbilityManaCost" then return 0 end
		if value_name == "AbilityCooldown" then return 0 end
		if value_name == "lifesteal" then return 15 + (value_level * 2.5) end

    if value_name == "special_attack_range" then return 150 end
    if value_name == "special_critical_chance" then return 2 end
    if value_name == "max_hit" then return 3 end
	end

  	if ability:GetAbilityName() == "lawbreaker_2__combo" then
    if value_name == "AbilityManaCost" then
      return ability:GetCurrentAbilityCharges() * 15
    end

		if value_name == "AbilityCooldown" then return 0 end
		if value_name == "AbilityCharges" then return ability:GetSpecialValueFor("max_shots") end

		if value_name == "AbilityChargeRestoreTime" then
      if caster:HasModifier("lawbreaker_2_modifier_combo")
      or caster:HasModifier("lawbreaker_2_modifier_reload") then
        return 0
      end
      return 2
    end

    if value_name == "max_shots" then return 12 + (value_level * 1) end

    if value_name == "fast_reload" then return 0.3 end
    if value_name == "slow_percent" then return 0 end
    if value_name == "speed_mult" then return 6 end
    if value_name == "attack_range" then return 1000 end
    if value_name == "special_pierce" then return 1 end
	end

	if ability:GetAbilityName() == "lawbreaker_3__grenade" then
		if value_name == "AbilityManaCost" then return 175 end
		if value_name == "AbilityCooldown" then return 14 end
    if value_name == "AbilityCastRange" then return ability:GetSpecialValueFor("cast_range") end

    if value_name == "duration" then return 7 + (value_level * 0.5) end

    if value_name == "special_stun_duration" then return 1 end
    if value_name == "miss_chance" then return 40 end
    if value_name == "damage" then return 400 end
    if value_name == "delay" then return 0.7 end
	end

	if ability:GetAbilityName() == "lawbreaker_4__rain" then
		if value_name == "AbilityManaCost" then return 200 end
		if value_name == "AbilityCooldown" then return 16 end
    if value_name == "AbilityCastRange" then return ability:GetSpecialValueFor("cast_range") end

		if value_name == "radius" then return 360 + (value_level * 15) end

    if value_name == "cast_range" then return 0 end
    if value_name == "duration" then return 9 end
    if value_name == "damage" then return 150 end
	end

	if ability:GetAbilityName() == "lawbreaker_5__blink" then
		if value_name == "AbilityManaCost" then return 150 end
    if value_name == "AbilityCooldown" then return 0 end
    if value_name == "AbilityCastRange" then return ability:GetSpecialValueFor("range") end

    if value_name == "AbilityCharges" then
      if caster:FindAbilityByName("lawbreaker_5__blink_rank_31") then
        return 6
      end
      return 3
    end

    if value_name == "AbilityChargeRestoreTime" then return ability:GetSpecialValueFor("restore_time") end
    
		if value_name == "restore_time" then return 15 - (value_level * 0.5) end

    if value_name == "special_cast_silence" then return 1 end
    if value_name == "special_illusion_duration" then return 5 end
	end

	if ability:GetAbilityName() == "lawbreaker_u__form" then
		if value_name == "AbilityManaCost" then return 700 end
		if value_name == "AbilityCooldown" then return 60 end

		if value_name == "duration" then return 17 + (value_level * 0.5) end

    if value_name == "special_fly" then return 1 end
    if value_name == "special_status_resist" then return 50 end
    if value_name == "special_burn_damage" then return 30 end
	end

	return 0
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------