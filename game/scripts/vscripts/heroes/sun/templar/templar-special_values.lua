templar_special_values = class({})

function templar_special_values:IsHidden() return true end
function templar_special_values:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function templar_special_values:OnCreated(kv)
end

function templar_special_values:OnRefresh(kv)
end

function templar_special_values:OnRemoved()
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
		if value_name == "res_stack" then return 1 end

    if caster:FindAbilityByName("templar_1__shield_rank_11") then
      if value_name == "radius" then return 1 end
		end

    if caster:FindAbilityByName("templar_1__shield_rank_12") then
		end

		if caster:FindAbilityByName("templar_1__shield_rank_21") then
      if value_name == "base" then return 1 end
		end

    if caster:FindAbilityByName("templar_1__shield_rank_22") then
      if value_name == "special_armor" then return 1 end
		end

		if caster:FindAbilityByName("templar_1__shield_rank_31") then
      if value_name == "special_return" then return 1 end
		end

    if caster:FindAbilityByName("templar_1__shield_rank_32") then
		end
	end

	if ability:GetAbilityName() == "templar_2__protection" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
		if value_name == "AbilityCastRange" then return 1 end
		if value_name == "cooldown" then return 1 end

		if caster:FindAbilityByName("templar_2__protection_rank_11") then
      if value_name == "cast_range" then return 1 end
		end

    if caster:FindAbilityByName("templar_2__protection_rank_12") then
		end

		if caster:FindAbilityByName("templar_2__protection_rank_21") then
      if value_name == "special_ms" then return 1 end
		end

    if caster:FindAbilityByName("templar_2__protection_rank_22") then
		end

		if caster:FindAbilityByName("templar_2__protection_rank_31") then
      if value_name == "special_heal" then return 1 end
      if value_name == "special_hp_cap" then return 1 end
		end

    if caster:FindAbilityByName("templar_2__protection_rank_32") then
		end
	end

	if ability:GetAbilityName() == "templar_3__hammer" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
    if value_name == "AbilityCastRange" then return 1 end
    if value_name == "AbilityCharges" then return 1 end
    if value_name == "AbilityChargeRestoreTime" then return 1 end
		if value_name == "cast_range" then return 1 end

		if caster:FindAbilityByName("templar_3__hammer_rank_11") then
      if value_name == "damage" then return 1 end
		end

    if caster:FindAbilityByName("templar_3__hammer_rank_12") then
      if value_name == "special_heal" then return 1 end
		end

		if caster:FindAbilityByName("templar_3__hammer_rank_21") then
      if value_name == "hits" then return 1 end
		end

    if caster:FindAbilityByName("templar_3__hammer_rank_22") then
		end

		if caster:FindAbilityByName("templar_3__hammer_rank_31") then
      if value_name == "slow_start" then return 1 end
      if value_name == "interval" then return 1 end
		end

    if caster:FindAbilityByName("templar_3__hammer_rank_32") then
      if value_name == "special_as_start" then return -50 end
		end
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
		if value_name == "AbilityManaCost" then return 0 end
		if value_name == "AbilityCooldown" then return 0 end

    if value_name == "radius" then
      if ability:GetCurrentAbilityCharges() == CYCLE_DAY then
        return -1
      end
      return 1000
    end

		if value_name == "res_stack" then return 12 + (value_level * 0.5) end
    if value_name == "base" then return 2 end
    if value_name == "special_armor" then return 0.5 end
    if value_name == "special_return" then return 20 end
	end

	if ability:GetAbilityName() == "templar_2__protection" then
		if value_name == "AbilityManaCost" then return 200 * mana_mult end
		if value_name == "AbilityCooldown" then return ability:GetSpecialValueFor("cooldown") end
    if value_name == "AbilityCastRange" then return ability:GetSpecialValueFor("cast_range") end

		if value_name == "cooldown" then return 18 - (value_level * 0.5) end
    if value_name == "cast_range" then return 750 end
    if value_name == "special_ms" then return 100 end
    if value_name == "special_heal" then return 60 end
    if value_name == "special_hp_cap" then return 75 end
	end

	if ability:GetAbilityName() == "templar_3__hammer" then
		if value_name == "AbilityManaCost" then return 125 * mana_mult end
		if value_name == "AbilityCooldown" then return 0 end
    if value_name == "AbilityCastRange" then return ability:GetSpecialValueFor("cast_range") end

    if value_name == "AbilityCharges" then
      if caster:FindAbilityByName("templar_3__hammer_rank_22") then
        return 2
      end
      return 1
    end

    if value_name == "AbilityChargeRestoreTime" then return 13 end

		if value_name == "cast_range" then return 700 + (value_level * 50) end
    if value_name == "damage" then return 375 end
    if value_name == "special_heal" then return 30 end
    if value_name == "hits" then return 3 end
    if value_name == "slow_start" then return 100 end
    if value_name == "interval" then return 0.9 end
    if value_name == "special_as_start" then return -50 end
	end

	if ability:GetAbilityName() == "templar_4__revenge" then
		if value_name == "AbilityManaCost" then return 175 * mana_mult end
		if value_name == "AbilityCooldown" then return 40 end
    if value_name == "AbilityCastRange" then return ability:GetSpecialValueFor("cast_range") end

		if value_name == "revenge_chance" then return 7 + (value_level * 0.5) end
    if value_name == "duration" then return 50 end
    if value_name == "stack" then return 9 end
    if value_name == "delay" then return 2.2 end
    if value_name == "special_microstun" then return 0.1 end
    if value_name == "damage_hit" then return 50 end
    if value_name == "special_autocast" then return 7 end
	end

	if ability:GetAbilityName() == "templar_5__reborn" then
		if value_name == "AbilityManaCost" then return 250 * mana_mult end
		if value_name == "AbilityCooldown" then return ability:GetSpecialValueFor("cooldown") end
		if value_name == "AbilityCastRange" then return ability:GetSpecialValueFor("cast_range") end
    
		if value_name == "cooldown" then return 75 - (value_level * 2.5) end
    if value_name == "special_refresh" then return 1 end
    if value_name == "special_bkb" then return 10 end
    if value_name == "cast_point" then return 2 end
    if value_name == "cast_range" then return 900 end
    if value_name == "percent" then return 75 end
    if value_name == "special_reborn" then return 20 end
	end

	if ability:GetAbilityName() == "templar_u__praise" then
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

-- EFFECTS -----------------------------------------------------------