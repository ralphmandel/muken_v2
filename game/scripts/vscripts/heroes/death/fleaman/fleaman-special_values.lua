fleaman_special_values = class({})

function fleaman_special_values:IsHidden() return true end
function fleaman_special_values:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function fleaman_special_values:OnCreated(kv)
end

function fleaman_special_values:OnRefresh(kv)
end

function fleaman_special_values:OnRemoved()
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
		if value_name == "duration" then return 1 end

		if caster:FindAbilityByName("fleaman_1__precision_rank_11") then
		end

    if caster:FindAbilityByName("fleaman_1__precision_rank_12") then
		end

		if caster:FindAbilityByName("fleaman_1__precision_rank_21") then
      if value_name == "attack_speed" then return 1 end
		end

    if caster:FindAbilityByName("fleaman_1__precision_rank_22") then
      if value_name == "evasion" then return 1 end
		end

		if caster:FindAbilityByName("fleaman_1__precision_rank_31") then
      if value_name == "special_damage" then return 1 end
      if value_name == "special_pulses" then return 1 end
      if value_name == "special_aoe" then return 1 end
		end

    if caster:FindAbilityByName("fleaman_1__precision_rank_32") then
      if value_name == "special_purge" then return 1 end
		end
	end

	if ability:GetAbilityName() == "fleaman_2__speed" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
		if value_name == "min_ms" then return 1 end

		if caster:FindAbilityByName("fleaman_2__speed_rank_11") then
      if value_name == "duration" then return 1 end
		end

    if caster:FindAbilityByName("fleaman_2__speed_rank_12") then
      if value_name == "special_phase" then return 1 end
		end

		if caster:FindAbilityByName("fleaman_2__speed_rank_21") then
      if value_name == "ms_gain" then return 1 end
		end

    if caster:FindAbilityByName("fleaman_2__speed_rank_22") then
      if value_name == "special_stun_duration" then return 1 end
		end

		if caster:FindAbilityByName("fleaman_2__speed_rank_31") then
      if value_name == "max_ms" then return 1 end
		end

    if caster:FindAbilityByName("fleaman_2__speed_rank_32") then
      if value_name == "special_unslow" then return 1 end
		end
	end

	if ability:GetAbilityName() == "fleaman_3__jump" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
    if value_name == "AbilityCharges" then return 1 end
    if value_name == "AbilityChargeRestoreTime" then return 1 end
		if value_name == "radius" then return 1 end

		if caster:FindAbilityByName("fleaman_3__jump_rank_11") then
      if value_name == "debuff_duration" then return 1 end
		end

    if caster:FindAbilityByName("fleaman_3__jump_rank_12") then
      if value_name == "special_root" then return 1 end
		end

		if caster:FindAbilityByName("fleaman_3__jump_rank_21") then
		end

    if caster:FindAbilityByName("fleaman_3__jump_rank_22") then
		end

		if caster:FindAbilityByName("fleaman_3__jump_rank_31") then
      if value_name == "distance" then return 1 end
		end

    if caster:FindAbilityByName("fleaman_3__jump_rank_32") then
      if value_name == "special_critical_damage" then return 1 end
		end
	end

	if ability:GetAbilityName() == "fleaman_4__strip" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
    if value_name == "chance" then return 1 end

		if caster:FindAbilityByName("fleaman_4__strip_rank_11") then
      if value_name == "special_break" then return 1 end
		end

    if caster:FindAbilityByName("fleaman_4__strip_rank_12") then
      if value_name == "special_bleeding" then return 1 end
		end

		if caster:FindAbilityByName("fleaman_4__strip_rank_21") then
      if value_name == "armor" then return 1 end
		end

    if caster:FindAbilityByName("fleaman_4__strip_rank_22") then
      if value_name == "special_evasion" then return 1 end
		end

		if caster:FindAbilityByName("fleaman_4__strip_rank_31") then
      if value_name == "special_silence" then return 1 end
		end

    if caster:FindAbilityByName("fleaman_4__strip_rank_32") then
      if value_name == "special_damage" then return 1 end
		end
	end

	if ability:GetAbilityName() == "fleaman_5__smoke" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
    if value_name == "AbilityCastRange" then return 1 end
		if value_name == "radius" then return 1 end

		if caster:FindAbilityByName("fleaman_5__smoke_rank_11") then
      if value_name == "blind" then return 1 end
		end

    if caster:FindAbilityByName("fleaman_5__smoke_rank_12") then
      if value_name == "miss_chance" then return 1 end
		end

		if caster:FindAbilityByName("fleaman_5__smoke_rank_21") then
		end

    if caster:FindAbilityByName("fleaman_5__smoke_rank_22") then
      if value_name == "duration" then return 1 end
		end

		if caster:FindAbilityByName("fleaman_5__smoke_rank_31") then
      if value_name == "special_hp_regen" then return 1 end
		end

    if caster:FindAbilityByName("fleaman_5__smoke_rank_32") then
      if value_name == "special_hide" then return 1 end
		end
	end

	if ability:GetAbilityName() == "fleaman_u__steal" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
    if value_name == "duration" then return 1 end

		if caster:FindAbilityByName("fleaman_u__steal_rank_11") then
      if value_name == "special_respawn_self" then return 1 end
		end

    if caster:FindAbilityByName("fleaman_u__steal_rank_12") then
      if value_name == "special_respawn_enemy" then return 1 end
		end

		if caster:FindAbilityByName("fleaman_u__steal_rank_21") then
      if value_name == "special_lifesteal" then return 1 end
		end

    if caster:FindAbilityByName("fleaman_u__steal_rank_22") then
      if value_name == "special_manasteal" then return 1 end
		end

		if caster:FindAbilityByName("fleaman_u__steal_rank_31") then
      if value_name == "attack_steal" then return 1 end
    end

    if caster:FindAbilityByName("fleaman_u__steal_rank_32") then
      if value_name == "special_chain_chance" then return 1 end
      if value_name == "special_chain_hits" then return 1 end
      if value_name == "special_chain_damage" then return 1 end
      if value_name == "special_chain_radius" then return 1 end
    end
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
		if value_name == "AbilityManaCost" then
      if caster:FindAbilityByName("fleaman_1__precision_rank_12") then
        return 80 * mana_mult
      end
      return 100 * mana_mult
    end

    if value_name == "AbilityCooldown" then return 0 end

    if value_name == "AbilityCharges" then
      if caster:FindAbilityByName("fleaman_1__precision_rank_11") then
        return 4
      end
      return 3
    end

    if value_name == "AbilityChargeRestoreTime" then return 20 end
		if value_name == "duration" then return 15 + (value_level * 0.5) end

    if value_name == "attack_speed" then return 50 end
    if value_name == "evasion" then return 5 end
    if value_name == "special_damage" then return 175 end
    if value_name == "special_pulses" then return 7 end
    if value_name == "special_aoe" then return 325 end
    if value_name == "special_purge" then return 1 end
	end

	if ability:GetAbilityName() == "fleaman_2__speed" then
		if value_name == "AbilityManaCost" then return 0 end
		if value_name == "AbilityCooldown" then return 0 end
		if value_name == "min_ms" then return value_level * 5 end

    if value_name == "duration" then return 4 end
    if value_name == "special_phase" then return 1 end
    if value_name == "ms_gain" then return 10 end
    if value_name == "special_stun_duration" then return 2 end
    if value_name == "max_ms" then return 240 end
    if value_name == "special_unslow" then return 1 end
	end

	if ability:GetAbilityName() == "fleaman_3__jump" then
		if value_name == "AbilityManaCost" then return 75 * mana_mult end
    if value_name == "AbilityCooldown" then return 0 end

    if value_name == "AbilityCharges" then
      if caster:FindAbilityByName("fleaman_3__jump_rank_21") then
        return 3
      end
  
      if caster:FindAbilityByName("fleaman_3__jump_rank_22") then
        return 1
      end

      return 2
    end

    if value_name == "AbilityChargeRestoreTime" then
      if caster:FindAbilityByName("fleaman_3__jump_rank_22") then
        return 10
      end
      return 15
    end

    if value_name == "radius" then return 270 + (value_level * 15) end

    if value_name == "debuff_duration" then return 3.5 end
    if value_name == "special_root" then return 1 end
    if value_name == "distance" then return 900 end
    if value_name == "special_critical_damage" then return 150 end
	end

	if ability:GetAbilityName() == "fleaman_4__strip" then
		if value_name == "AbilityManaCost" then return 0 end
		if value_name == "AbilityCooldown" then return 0 end
    if value_name == "chance" then return 9 + (value_level * 0.5) end

    if value_name == "special_break" then return 1 end
    if value_name == "special_bleeding" then return 1 end
    if value_name == "armor" then return -6.5 end
    if value_name == "special_evasion" then return -2 end
    if value_name == "special_silence" then return 1 end
    if value_name == "special_damage" then return 20 end
	end

	if ability:GetAbilityName() == "fleaman_5__smoke" then
		if value_name == "AbilityManaCost" then return 150 * mana_mult end

		if value_name == "AbilityCooldown" then
      if caster:FindAbilityByName("fleaman_5__smoke_rank_21") then
        return 20
      end
      return 25
    end

    if value_name == "AbilityCastRange" then return ability:GetSpecialValueFor("cast_range") end
		if value_name == "radius" then return 450 + (value_level * 25) end

    if value_name == "blind" then return 90 end
    if value_name == "miss_chance" then return 35 end
    if value_name == "duration" then return 25 end
    if value_name == "special_hp_regen" then return 50 end
    if value_name == "special_hide" then return 5 end
	end

	if ability:GetAbilityName() == "fleaman_u__steal" then
		if value_name == "AbilityManaCost" then return 0 end

		if value_name == "AbilityCooldown" then
      if caster:FindAbilityByName("fleaman_u__steal_rank_31") then
        return 1
      end

      return 0
    end
    
    if value_name == "duration" then return 15 + (value_level * 0.5) end
    
    if value_name == "special_respawn_self" then return 0.5 end
    if value_name == "special_respawn_enemy" then return 0.5 end
    if value_name == "special_lifesteal" then return 20 end
    if value_name == "special_manasteal" then return 15 end
    if value_name == "attack_steal" then return 4 end
    if value_name == "special_chain_chance" then return 25 end
    if value_name == "special_chain_hits" then return 4 end
    if value_name == "special_chain_damage" then return 100 end
    if value_name == "special_chain_radius" then return 700 end
	end

	return 0
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------