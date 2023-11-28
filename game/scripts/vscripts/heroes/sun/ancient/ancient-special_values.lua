ancient_special_values = class({})

function ancient_special_values:IsHidden() return true end
function ancient_special_values:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function ancient_special_values:OnCreated(kv)
end

function ancient_special_values:OnRefresh(kv)
end

function ancient_special_values:OnRemoved()
end

-- API FUNCTIONS -----------------------------------------------------------

function ancient_special_values:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE
	}

	return funcs
end

function ancient_special_values:GetModifierOverrideAbilitySpecial(keys)
	local caster = self:GetCaster()
	local ability = keys.ability
	local value_name = keys.ability_special_value
	local value_level = keys.ability_special_level
  --"AbilityCastRange"
  --"AbilityCharges"
  --"AbilityChargeRestoreTime"

	if ability:GetAbilityName() == "ancient_1__leap" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
    if value_name == "AbilityCharges" then return 1 end
    if value_name == "AbilityChargeRestoreTime" then return 1 end
    if value_name == "jump_distance" then return 1 end
		if value_name == "radius" then return 1 end

		if caster:FindAbilityByName("ancient_1__leap_rank_11") then
		end

    if caster:FindAbilityByName("ancient_1__leap_rank_12") then
		end

		if caster:FindAbilityByName("ancient_1__leap_rank_21") then
		end

    if caster:FindAbilityByName("ancient_1__leap_rank_22") then
		end

		if caster:FindAbilityByName("ancient_1__leap_rank_31") then
      if value_name == "damage" then return 1 end
		end

    if caster:FindAbilityByName("ancient_1__leap_rank_32") then
		end
	end

	if ability:GetAbilityName() == "ancient_2__roar" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
    if value_name == "AbilityCastRange" then return 1 end
		if value_name == "cast_range" then return 1 end

		if caster:FindAbilityByName("ancient_2__roar_rank_11") then
      if value_name == "turn_rate" then return 1 end
		end

    if caster:FindAbilityByName("ancient_2__roar_rank_12") then
      if value_name == "step" then return 1 end
      if value_name == "cast_time" then return 1 end
		end

		if caster:FindAbilityByName("ancient_2__roar_rank_21") then
      if value_name == "damage" then return 1 end
		end

    if caster:FindAbilityByName("ancient_2__roar_rank_22") then
		end

		if caster:FindAbilityByName("ancient_2__roar_rank_31") then
      if value_name == "special_debuff_duration" then return 1 end
      if value_name == "special_disarm" then return 1 end
		end

    if caster:FindAbilityByName("ancient_2__roar_rank_32") then
      if value_name == "special_debuff_duration" then return 1 end
      if value_name == "special_armor" then return 1 end
		end
	end

	if ability:GetAbilityName() == "ancient_3__flesh" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
		if value_name == "stun_duration" then return 1 end
		if value_name == "hp_regen_percent" then return 1 end

		if caster:FindAbilityByName("ancient_3__flesh_rank_11") then
      if value_name == "special_break_duration" then return 1 end
		end

    if caster:FindAbilityByName("ancient_3__flesh_rank_12") then
		end

		if caster:FindAbilityByName("ancient_3__flesh_rank_21") then
      if value_name == "damage_percent" then return 1 end
		end

    if caster:FindAbilityByName("ancient_3__flesh_rank_22") then
      if value_name == "special_double_chance" then return 1 end
		end

		if caster:FindAbilityByName("ancient_3__flesh_rank_31") then
      if value_name == "special_return_chance" then return 1 end
      if value_name == "special_return_damage" then return 1 end
		end

    if caster:FindAbilityByName("ancient_3__flesh_rank_32") then
		end
	end

	if ability:GetAbilityName() == "ancient_4__vitality" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
		if value_name == "radius" then return 1 end

		if caster:FindAbilityByName("ancient_4__vitality_rank_11") then
      if value_name == "special_heal_amp" then return 1 end
		end

    if caster:FindAbilityByName("ancient_4__vitality_rank_12") then
		end

		if caster:FindAbilityByName("ancient_4__vitality_rank_21") then
      if value_name == "special_buff_amp" then return 1 end
		end

    if caster:FindAbilityByName("ancient_4__vitality_rank_22") then
		end

		if caster:FindAbilityByName("ancient_4__vitality_rank_31") then
      if value_name == "max_health" then return 1 end
		end

    if caster:FindAbilityByName("ancient_4__vitality_rank_32") then
		end
	end

	if ability:GetAbilityName() == "ancient_5__walk" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
		if value_name == "waves" then return 1 end
		if value_name == "interval" then return 1 end

		if caster:FindAbilityByName("ancient_5__walk_rank_11") then
      if value_name == "cast_point" then return 1 end
		end

    if caster:FindAbilityByName("ancient_5__walk_rank_12") then
		end

		if caster:FindAbilityByName("ancient_5__walk_rank_21") then
      if value_name == "block_physical" then return 1 end
		end

    if caster:FindAbilityByName("ancient_5__walk_rank_22") then
      if value_name == "block_magical" then return 1 end
		end

		if caster:FindAbilityByName("ancient_5__walk_rank_31") then
      if value_name == "special_petrify_chance" then return 1 end
		end

    if caster:FindAbilityByName("ancient_5__walk_rank_32") then
      if value_name == "special_bkb_chance" then return 1 end
		end
	end

	if ability:GetAbilityName() == "ancient_u__fissure" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
		if value_name == "crack_time" then return 1 end

		if caster:FindAbilityByName("ancient_u__fissure_rank_11") then
      if value_name == "cast_range_mult" then return 1 end
		end

    if caster:FindAbilityByName("ancient_u__fissure_rank_12") then
		end

		if caster:FindAbilityByName("ancient_u__fissure_rank_21") then
      if value_name == "energy_loss_tick" then return 1 end
		end

    if caster:FindAbilityByName("ancient_u__fissure_rank_22") then
		end

		if caster:FindAbilityByName("ancient_u__fissure_rank_31") then
      if value_name == "damage" then return 1 end
      if value_name == "special_heal" then return 1 end
		end

    if caster:FindAbilityByName("ancient_u__fissure_rank_32") then
      if value_name == "min_cost" then return 1 end
      if value_name == "special_silence_duration" then return 1 end
		end
	end

	return 0
end

function ancient_special_values:GetModifierOverrideAbilitySpecialValue(keys)
	local caster = self:GetCaster()
	local ability = keys.ability
	local value_name = keys.ability_special_value
	local value_level = keys.ability_special_level
	local ability_level = ability:GetLevel()
	if ability_level < 1 then ability_level = 1 end

	if ability:GetAbilityName() == "ancient_1__leap" then
		if value_name == "AbilityManaCost" then return 0 end
		if value_name == "AbilityCooldown" then return 0 end

    if value_name == "AbilityCharges" then
      if caster:FindAbilityByName("ancient_1__leap_rank_11") then
        return 4
      end
      if caster:FindAbilityByName("ancient_1__leap_rank_12") then
        return 2
      end

      return 3
    end

    if value_name == "AbilityChargeRestoreTime" then
      if caster:HasModifier("ancient_1_modifier_jump")
      or caster:HasModifier("ancient_1_modifier_leap") then
        return 0
      end
      if caster:FindAbilityByName("ancient_1__leap_rank_12") then
        return 5
      end

      return 6
    end
    
    if value_name == "jump_distance" then
      local distance = 100 + (caster:FindAbilityByName("ancient__jump"):GetLevel() * ability:GetCurrentAbilityCharges() * 0.5)
      
      if caster:HasModifier("ancient_1_modifier_refresh") then
        return 0
      end
      if caster:FindAbilityByName("ancient_1__leap_rank_21") then
        return distance * 1.25
      end

      return distance
    end

		if value_name == "radius" then return 300 + (value_level * 10) end

    if value_name == "damage" then return 175 end
	end

	if ability:GetAbilityName() == "ancient_2__roar" then
		if value_name == "AbilityManaCost" then return 0 end
		if value_name == "AbilityCooldown" then return 24 end
    if value_name == "AbilityCastRange" then return ability:GetSpecialValueFor("cast_range") end

		if value_name == "cast_range" then return 900 + (value_level * 50) end

    if value_name == "turn_rate" then return 100 end
    if value_name == "step" then return 3 end
    if value_name == "cast_time" then return 1.8 end
    if value_name == "damage" then return 650 end
    if value_name == "special_debuff_duration" then return 7 end
    if value_name == "special_disarm" then return 1 end
    if value_name == "special_armor" then return -10 end
	end

	if ability:GetAbilityName() == "ancient_3__flesh" then
		if value_name == "AbilityManaCost" then return 0 end

		if value_name == "AbilityCooldown" then
      if caster:FindAbilityByName("ancient_3__flesh_rank_11") then
        return 15
      end
      return 0
    end

    if value_name == "stun_duration" then return 0.2 + (value_level * 0.01) end
		if value_name == "hp_regen_percent" then return 0.5 + (value_level * 0.02) end

    if value_name == "special_break_duration" then return 3 end
    if value_name == "damage_percent" then return 70 end
    if value_name == "special_double_chance" then return 25 end
    if value_name == "special_return_chance" then return 10 end
    if value_name == "special_return_damage" then return 200 end
  end

	if ability:GetAbilityName() == "ancient_4__vitality" then
		if value_name == "AbilityManaCost" then return 0 end
		if value_name == "AbilityCooldown" then return 0 end

		if value_name == "radius" then return 700 + (value_level * 50) end
    if value_name == "special_heal_amp" then return 10 end
		if value_name == "special_buff_amp" then return 20 end
		if value_name == "max_health" then return 1500 end
	end

	if ability:GetAbilityName() == "ancient_5__walk" then
		if value_name == "AbilityManaCost" then return 0 end

		if value_name == "AbilityCooldown" then
      if caster:FindAbilityByName("ancient_5__walk_rank_12") then
        return 15
      end
      return 30
    end

		if value_name == "waves" then return 12 + (value_level * 1) end
		if value_name == "interval" then return 1.75 - (value_level * 0.05) end
    if value_name == "cast_point" then return 1.5 end
    if value_name == "block_physical" then return 40 end
    if value_name == "block_magical" then return 40 end
    if value_name == "special_petrify_chance" then return 15 end
    if value_name == "special_bkb_chance" then return 15 end
	end

	if ability:GetAbilityName() == "ancient_u__fissure" then
		if value_name == "AbilityManaCost" then
      local total_min_cost = caster:GetMaxMana() * ability:GetSpecialValueFor("min_cost") * 0.01
      if total_min_cost > caster:GetMana() then return total_min_cost else return caster:GetMana() end
    end

		if value_name == "AbilityCooldown" then return 0 end
		if value_name == "crack_time" then return 3.14 + (value_level * 0.1) end

    if value_name == "cast_range_mult" then return 375 end
    if value_name == "energy_loss_tick" then return 0.3 end
    if value_name == "damage" then return 150 end
    if value_name == "special_heal" then return 50 end
    if value_name == "min_cost" then return 30 end
    if value_name == "special_silence_duration" then return 5 end
	end

	return 0
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------