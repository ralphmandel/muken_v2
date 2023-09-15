genuine_special_values = class({})

function genuine_special_values:IsHidden() return true end
function genuine_special_values:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function genuine_special_values:OnCreated(kv)
end

function genuine_special_values:OnRefresh(kv)
end

function genuine_special_values:OnRemoved()
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

  if value_name == "special_starfall_damage" then return 1 end
	if value_name == "special_starfall_radius" then return 1 end
	if value_name == "special_starfall_delay" then return 1 end

	if ability:GetAbilityName() == "genuine_1__shooting" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
    if value_name == "AbilityCastRange" then return 1 end
		if value_name == "rank" then return 1 end
		if value_name == "atk_range" then return 1 end

		if caster:FindAbilityByName("genuine_1__shooting_rank_11") then
      if value_name == "damage" then return 1 end
		end

    if caster:FindAbilityByName("genuine_1__shooting_rank_12") then
      if value_name == "proj_speed" then return 1 end
      if value_name == "special_lck" then return 1 end
		end

		if caster:FindAbilityByName("genuine_1__shooting_rank_21") then
		end

    if caster:FindAbilityByName("genuine_1__shooting_rank_22") then
      if value_name == "special_mana_steal" then return 1 end
		end

		if caster:FindAbilityByName("genuine_1__shooting_rank_31") then
      if value_name == "special_silence_duration" then return 1 end
		end

    if caster:FindAbilityByName("genuine_1__shooting_rank_32") then
      if value_name == "special_fear_chance" then return 1 end
      if value_name == "special_fear_duration" then return 1 end
		end

		if caster:FindAbilityByName("genuine_1__shooting_rank_41") then
      if value_name == "special_spell_lifesteal" then return 1 end
		end

    if caster:FindAbilityByName("genuine_1__shooting_rank_42") then
      if value_name == "special_starfall_combo" then return 1 end
      if value_name == "special_starfall_damage" then return 1 end
      if value_name == "special_starfall_radius" then return 1 end
      if value_name == "special_starfall_delay" then return 1 end
		end
	end

	if ability:GetAbilityName() == "genuine_2__fallen" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
		if value_name == "rank" then return 1 end

		if caster:FindAbilityByName("genuine_2__fallen_rank_11") then
      if value_name == "special_slow" then return 1 end
		end

    if caster:FindAbilityByName("genuine_2__fallen_rank_12") then
      if value_name == "special_invi_break" then return 1 end
		end

    if caster:FindAbilityByName("genuine_2__fallen_rank_21") then
      if value_name == "special_manaburn" then return 1 end
		end

    if caster:FindAbilityByName("genuine_2__fallen_rank_22") then
      if value_name == "special_purge_ally" then return 1 end
		end

		if caster:FindAbilityByName("genuine_2__fallen_rank_31") then
      if value_name == "fear_duration" then return 1 end
		end

    if caster:FindAbilityByName("genuine_2__fallen_rank_32") then
      if value_name == "special_wide" then return 1 end
      if value_name == "speed" then return 1 end
      if value_name == "radius" then return 1 end
      if value_name == "distance" then return 1 end
		end

		if caster:FindAbilityByName("genuine_2__fallen_rank_41") then
      if value_name == "special_damage" then return 1 end
		end

    if caster:FindAbilityByName("genuine_2__fallen_rank_42") then
      if value_name == "special_heal" then return 1 end
		end
	end

	if ability:GetAbilityName() == "genuine_3__morning" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
		if value_name == "rank" then return 1 end

		if caster:FindAbilityByName("genuine_3__morning_rank_11") then
      if value_name == "special_starfall_count" then return 1 end
		end

    if caster:FindAbilityByName("genuine_3__morning_rank_12") then
      if value_name == "special_track_duration" then return 1 end
    end

		if caster:FindAbilityByName("genuine_3__morning_rank_21") then
      if value_name == "special_rec" then return 1 end
    end

    if caster:FindAbilityByName("genuine_3__morning_rank_22") then
      if value_name == "agi" then return 1 end
    end

		if caster:FindAbilityByName("genuine_3__morning_rank_31") then
      if value_name == "special_ms_night" then return 1 end
    end

    if caster:FindAbilityByName("genuine_3__morning_rank_32") then
      if value_name == "ms" then return 1 end
    end

		if caster:FindAbilityByName("genuine_3__morning_rank_41") then
      if value_name == "special_strike_damage" then return 1 end
      if value_name == "special_strike_radius" then return 1 end
    end

    if caster:FindAbilityByName("genuine_3__morning_rank_42") then
      if value_name == "special_int_allies" then return 1 end
    end
	end

	if ability:GetAbilityName() == "genuine_4__awakening" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
    if value_name == "AbilityCastRange" then return 1 end
		if value_name == "rank" then return 1 end
		if value_name == "damage" then return 1 end

		if caster:FindAbilityByName("genuine_4__awakening_rank_11") then
      if value_name == "special_mana" then return 1 end
		end

    if caster:FindAbilityByName("genuine_4__awakening_rank_12") then
		end

		if caster:FindAbilityByName("genuine_4__awakening_rank_21") then
      if value_name == "arrow_range" then return 1 end
		end

    if caster:FindAbilityByName("genuine_4__awakening_rank_22") then
      if value_name == "damage_reduction" then return 1 end
		end

		if caster:FindAbilityByName("genuine_4__awakening_rank_31") then
      if value_name == "special_bash_power" then return 1 end
		end

    if caster:FindAbilityByName("genuine_4__awakening_rank_32") then
      if value_name == "channel_time" then return 1 end
		end

		if caster:FindAbilityByName("genuine_4__awakening_rank_41") then
		end

    if caster:FindAbilityByName("genuine_4__awakening_rank_42") then
      if value_name == "special_pure_dmg" then return 1 end
		end
	end

	if ability:GetAbilityName() == "genuine_5__nightfall" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
		if value_name == "rank" then return 1 end

		if caster:FindAbilityByName("genuine_5__nightfall_rank_11") then
      if value_name == "barrier_regen" then return 1 end
		end

    if caster:FindAbilityByName("genuine_5__nightfall_rank_12") then
      if value_name == "special_hp_regen" then return 1 end
		end

		if caster:FindAbilityByName("genuine_5__nightfall_rank_21") then
      if value_name == "max_barrier" then return 1 end
		end

    if caster:FindAbilityByName("genuine_5__nightfall_rank_22") then
      if value_name == "special_universal" then return 1 end
		end

		if caster:FindAbilityByName("genuine_5__nightfall_rank_31") then
      if value_name == "special_invi" then return 1 end
		end

    if caster:FindAbilityByName("genuine_5__nightfall_rank_32") then
      if value_name == "special_linkens" then return 1 end
		end

		if caster:FindAbilityByName("genuine_5__nightfall_rank_41") then
      if value_name == "special_night_vision" then return 1 end
		end

    if caster:FindAbilityByName("genuine_5__nightfall_rank_42") then
      if value_name == "special_fly_vision" then return 1 end
		end
	end

	if ability:GetAbilityName() == "genuine_u__star" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
    if value_name == "AbilityCastRange" then return 1 end
		if value_name == "rank" then return 1 end
    if value_name == "special_interval" then return 1 end

		if caster:FindAbilityByName("genuine_u__star_rank_11") then
      if value_name == "special_reset" then return 1 end
		end

    if caster:FindAbilityByName("genuine_u__star_rank_12") then
      if value_name == "cast_range" then return 1 end
		end

		if caster:FindAbilityByName("genuine_u__star_rank_21") then
      if value_name == "mana_steal" then return 1 end
		end

    if caster:FindAbilityByName("genuine_u__star_rank_22") then
      if value_name == "special_swap" then return 1 end
      if value_name == "mana_steal" then return 1 end
		end

		if caster:FindAbilityByName("genuine_u__star_rank_31") then
      if value_name == "duration_night" then return 1 end
      if value_name == "night_vision" then return 1 end
		end

    if caster:FindAbilityByName("genuine_u__star_rank_32") then
      if value_name == "special_day_vision" then return 1 end
      if value_name == "duration" then return 1 end
		end

		if caster:FindAbilityByName("genuine_u__star_rank_41") then
      if value_name == "special_slow" then return 1 end
		end

    if caster:FindAbilityByName("genuine_u__star_rank_42") then
      if value_name == "special_starfall" then return 1 end
		end
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

	if value_name == "special_starfall_damage" then return 100 end
	if value_name == "special_starfall_radius" then return 250 end
	if value_name == "special_starfall_delay" then return 0.5 end

	if ability:GetAbilityName() == "genuine_1__shooting" then
		if value_name == "AbilityManaCost" then
      local manacost = 50 * (1 + ((ability_level - 1) * 0.05))
      if caster:FindAbilityByName("genuine_1__shooting_rank_21") then
        return manacost * 0.8
      end
      return manacost
    end

		if value_name == "AbilityCooldown" then
      if caster:FindAbilityByName("genuine_1__shooting_rank_31") then
        return 15
      end
      if caster:FindAbilityByName("genuine_1__shooting_rank_32") then
        return 5
      end
      return 0
    end

    if value_name == "AbilityCastRange" then return caster:Script_GetAttackRange() end
		if value_name == "rank" then return 6 + (value_level * 1) end
    if value_name == "atk_range" then return 0 + (value_level * 20) end

    if value_name == "damage" then return 70 end
    if value_name == "proj_speed" then return 1200 end
    if value_name == "special_lck" then return 5 end
    if value_name == "special_mana_steal" then return 1 end
    if value_name == "special_silence_duration" then return 3 end
    if value_name == "special_fear_chance" then return 12 end
    if value_name == "special_fear_duration" then return 1 end
    if value_name == "special_spell_lifesteal" then return 25 end
    if value_name == "special_starfall_combo" then return 5 end
	end

	if ability:GetAbilityName() == "genuine_2__fallen" then
		if value_name == "AbilityManaCost" then return 200 * (1 + ((ability_level - 1) * 0.05)) end
    if value_name == "AbilityCooldown" then return 15 - ((ability_level - 1) * 0.2) end
		if value_name == "rank" then return 6 + (value_level * 1) end

    if value_name == "special_slow" then return 75 end
    if value_name == "special_invi_break" then return 1 end
    if value_name == "special_manaburn" then return 100 end
    if value_name == "special_purge_ally" then return 1 end
    if value_name == "fear_duration" then return 3 end
    if value_name == "special_wide" then return 1 end
    if value_name == "speed" then return 2000 end
    if value_name == "radius" then return 400 end
    if value_name == "distance" then return 1000 end
    if value_name == "special_damage" then return 2 end
    if value_name == "special_heal" then return 15 end
	end

	if ability:GetAbilityName() == "genuine_3__morning" then
		if value_name == "AbilityManaCost" then return 550 * (1 + ((ability_level - 1) * 0.05)) end
    if value_name == "AbilityCooldown" then return 120 - ((ability_level - 1) * 2) end
		if value_name == "rank" then return 6 + (value_level * 1) end

    if value_name == "special_starfall_count" then return 3 end
    if value_name == "special_track_duration" then return 3 end
    if value_name == "special_rec" then return 15 end
    if value_name == "agi" then return 25 end
    if value_name == "special_ms_night" then return 1 end
    if value_name == "ms" then return 175 end
    if value_name == "special_strike_damage" then return 50 end
    if value_name == "special_strike_radius" then return 2000 end
    if value_name == "special_int_allies" then return 1 end
	end

	if ability:GetAbilityName() == "genuine_4__awakening" then
		if value_name == "AbilityManaCost" then
      local manacost = 75 * (1 + ((ability_level - 1) * 0.05))
      if caster:FindAbilityByName("genuine_4__awakening_rank_12") then
        return manacost * 0.8
      end
      return manacost
    end

		if value_name == "AbilityCooldown" then
      if caster:FindAbilityByName("genuine_4__awakening_rank_41") then
        return 1
      end 
      return 10
    end
    
    if value_name == "AbilityCastRange" then return ability:GetSpecialValueFor("arrow_range") end
		if value_name == "rank" then return 6 + (value_level * 1) end

		if value_name == "damage" then
      local calc = 400 + (value_level * 10)
      if caster:FindAbilityByName("genuine_4__awakening_rank_42") then
        return math.floor(calc * 1.5)
      end
      return calc
    end

    if value_name == "special_mana" then return 150 end
    if value_name == "arrow_range" then return 5500 end
    if value_name == "damage_reduction" then return 0 end
    if value_name == "special_bash_power" then return 600 end
    if value_name == "channel_time" then return 3 end
    if value_name == "special_pure_dmg" then return 1 end
	end

	if ability:GetAbilityName() == "genuine_5__nightfall" then
		if value_name == "AbilityManaCost" then return 0 * (1 + ((ability_level - 1) * 0.05)) end

		if value_name == "AbilityCooldown" then
      if caster:FindAbilityByName("genuine_5__nightfall_rank_31") then
        return 10
      end
      if caster:FindAbilityByName("genuine_5__nightfall_rank_32") then
        return 30
      end
      return 0
    end

		if value_name == "rank" then return 6 + (value_level * 1) end

    if value_name == "barrier_regen" then return 3 end
    if value_name == "special_hp_regen" then return 1 end
    if value_name == "max_barrier" then return 130 end
    if value_name == "special_universal" then return 1 end
    if value_name == "special_invi" then return 1 end
    if value_name == "special_linkens" then return 1 end
    if value_name == "special_night_vision" then return 400 end
    if value_name == "special_fly_vision" then return 1 end
	end

	if ability:GetAbilityName() == "genuine_u__star" then
		if value_name == "AbilityManaCost" then return 0 * (1 + ((ability_level - 1) * 0.05)) end
		if value_name == "AbilityCooldown" then return 60 end
    if value_name == "AbilityCastRange" then return ability:GetSpecialValueFor("cast_range") end
		if value_name == "rank" then return 9 + (value_level * 1) end

    if value_name == "special_reset" then return 1 end
    if value_name == "cast_range" then return 1000 end

    if caster:FindAbilityByName("genuine_u__star_rank_21") then
      if value_name == "mana_steal" then return 60 end
		end
    if caster:FindAbilityByName("genuine_u__star_rank_22") then
      if value_name == "mana_steal" then return 0 end
		end

    if value_name == "special_swap" then return 1 end
    if value_name == "duration_night" then return 14 end
    if value_name == "night_vision" then return 500 end
    if value_name == "special_day_vision" then return ability:GetSpecialValueFor("night_vision") end
    if value_name == "duration" then return ability:GetSpecialValueFor("duration_night") end
    if value_name == "special_slow" then return 1 end
    if value_name == "special_starfall" then return 1 end
    if value_name == "special_interval" then
      if caster:FindAbilityByName("genuine_u__star_rank_41") then
        return 1
      end
      if caster:FindAbilityByName("genuine_u__star_rank_42") then
        return 2
      end
      return -1
    end
	end

	return 0
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------