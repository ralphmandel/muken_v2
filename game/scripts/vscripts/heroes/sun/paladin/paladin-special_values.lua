paladin_special_values = class({})

function paladin_special_values:IsHidden() return true end
function paladin_special_values:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function paladin_special_values:OnCreated(kv)
end

function paladin_special_values:OnRefresh(kv)
end

function paladin_special_values:OnRemoved()
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
		if value_name == "rank" then return 1 end
		if value_name == "cast_range" then return 1 end
		if value_name == "max_range" then return 1 end

		if caster:FindAbilityByName("paladin_1__link_rank_11") then
      if value_name == "duration" then return 1 end
		end

    if caster:FindAbilityByName("paladin_1__link_rank_12") then
		end

		if caster:FindAbilityByName("paladin_1__link_rank_21") then
      if value_name == "pure_damage" then return 1 end
		end

    if caster:FindAbilityByName("paladin_1__link_rank_22") then
		end

		if caster:FindAbilityByName("paladin_1__link_rank_31") then
      if value_name == "absorption" then return 1 end
		end

    if caster:FindAbilityByName("paladin_1__link_rank_32") then
		end
	end

	if ability:GetAbilityName() == "paladin_2__shield" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
		if value_name == "AbilityCastRange" then return 1 end
		if value_name == "duration" then return 1 end

		if caster:FindAbilityByName("paladin_2__shield_rank_11") then
		end

    if caster:FindAbilityByName("paladin_2__shield_rank_12") then
      if value_name == "special_cast_range" then return 1 end
		end

		if caster:FindAbilityByName("paladin_2__shield_rank_21") then
      if value_name == "special_burn_damage" then return 1 end
      if value_name == "special_burn_radius" then return 1 end
      if value_name == "special_burn_tick" then return 1 end
		end

    if caster:FindAbilityByName("paladin_2__shield_rank_22") then
      if value_name == "special_hp_regen" then return 1 end
		end

		if caster:FindAbilityByName("paladin_2__shield_rank_31") then
      if value_name == "hits" then return 1 end
		end

    if caster:FindAbilityByName("paladin_2__shield_rank_32") then
      if value_name == "special_bkb" then return 1 end
      if value_name == "status_resist" then return 1 end
		end
	end

	if ability:GetAbilityName() == "paladin_3__hammer" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
		if value_name == "AbilityCastRange" then return 1 end
		if value_name == "AbilityCharges" then return 1 end
		if value_name == "AbilityChargeRestoreTime" then return 1 end
		if value_name == "damage" then return 1 end
		if value_name == "heal" then return 1 end

		if caster:FindAbilityByName("paladin_3__hammer_rank_11") then
		end

    if caster:FindAbilityByName("paladin_3__hammer_rank_12") then
		end

		if caster:FindAbilityByName("paladin_3__hammer_rank_21") then
      if value_name == "cast_range" then return 1 end
		end

    if caster:FindAbilityByName("paladin_3__hammer_rank_22") then
      if value_name == "special_stun_duration" then return 1 end
      if value_name == "special_purge" then return 1 end
		end

		if caster:FindAbilityByName("paladin_3__hammer_rank_31") then
      if value_name == "target_mult" then return 1 end
		end

    if caster:FindAbilityByName("paladin_3__hammer_rank_32") then
      if value_name == "target_mult" then return 1 end
      if value_name == "max_mult" then return 1 end
      if value_name == "radius" then return 1 end
		end
	end

	if ability:GetAbilityName() == "paladin_4__magnus" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
		if value_name == "duration" then return 1 end

		if caster:FindAbilityByName("paladin_4__magnus_rank_11") then
		end

    if caster:FindAbilityByName("paladin_4__magnus_rank_12") then
		end

		if caster:FindAbilityByName("paladin_4__magnus_rank_21") then
		end

    if caster:FindAbilityByName("paladin_4__magnus_rank_22") then
		end

		if caster:FindAbilityByName("paladin_4__magnus_rank_31") then
		end

    if caster:FindAbilityByName("paladin_4__magnus_rank_32") then
		end
	end

	if ability:GetAbilityName() == "paladin_5__smite" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end

		if caster:FindAbilityByName("paladin_5__smite_rank_11") then
		end

    if caster:FindAbilityByName("paladin_5__smite_rank_12") then
		end

		if caster:FindAbilityByName("paladin_5__smite_rank_21") then
		end

    if caster:FindAbilityByName("paladin_5__smite_rank_22") then
		end

		if caster:FindAbilityByName("paladin_5__smite_rank_31") then
		end

    if caster:FindAbilityByName("paladin_5__smite_rank_32") then
		end
	end

	if ability:GetAbilityName() == "paladin_u__faith" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end

		if caster:FindAbilityByName("paladin_u__faith_rank_11") then
		end

    if caster:FindAbilityByName("paladin_u__faith_rank_12") then
		end

		if caster:FindAbilityByName("paladin_u__faith_rank_21") then
		end

    if caster:FindAbilityByName("paladin_u__faith_rank_22") then
		end

		if caster:FindAbilityByName("paladin_u__faith_rank_31") then
		end

    if caster:FindAbilityByName("paladin_u__faith_rank_32") then
		end
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
		if value_name == "AbilityManaCost" then return 200 * mana_mult end
		if value_name == "AbilityCooldown" then return 0 end
    if value_name == "AbilityCastRange" then return ability:GetSpecialValueFor("cast_range") end

    if value_name == "AbilityCharges" then
      if caster:FindAbilityByName("paladin_1__link_rank_31") then
        return 2
      end

      return 1
    end

    if value_name == "AbilityChargeRestoreTime" then return 60 end

    if value_name == "cast_range" then return 600 + (value_level * 50) end
		if value_name == "max_range" then return 900 + (value_level * 50) end
    if value_name == "duration" then return 35 end
    if value_name == "pure_damage" then return 30 end
    if value_name == "absorption" then return 75 end
	end

	if ability:GetAbilityName() == "paladin_2__shield" then
		if value_name == "AbilityManaCost" then return 120 * mana_mult end

		if value_name == "AbilityCooldown" then
      if caster:FindAbilityByName("paladin_2__shield_rank_11") then
        return 16
      end
      return 18
    end

		if value_name == "AbilityCastRange" then return ability:GetSpecialValueFor("special_cast_range") end
		if value_name == "duration" then return 18 + (value_level * 1) end

    if value_name == "special_cast_range" then return 500 end
    if value_name == "special_burn_damage" then return 50 end
    if value_name == "special_burn_radius" then return 250 end
    if value_name == "special_burn_tick" then return 0.4 end
    if value_name == "special_hp_regen" then return 40 end
    if value_name == "hits" then return 12 end
    if value_name == "special_bkb" then return 1 end
    if value_name == "status_resist" then return 0 end
	end

	if ability:GetAbilityName() == "paladin_3__hammer" then
		if value_name == "AbilityManaCost" then
      if caster:FindAbilityByName("paladin_3__hammer_rank_11") then
        return 150 * mana_mult
      end
      return 180 * mana_mult
    end

		if value_name == "AbilityCooldown" then return 0 end
    if value_name == "AbilityCastRange" then return ability:GetSpecialValueFor("cast_range") end

    if value_name == "AbilityCharges" then
      if caster:FindAbilityByName("paladin_3__hammer_rank_12") then
        return 2
      end
      return 1
    end

		if value_name == "AbilityChargeRestoreTime" then
      if caster:FindAbilityByName("paladin_3__hammer_rank_12") then
        return 18
      end
      return 15
    end

		if value_name == "damage" then return 90 + math.floor(value_level * 5) end
		if value_name == "heal" then return 60 + math.floor(value_level * 2.5) end

    if value_name == "cast_range" then return 0 end
    if value_name == "special_stun_duration" then return 1.5 end
    if value_name == "special_purge" then return 1 end
    if value_name == "max_mult" then return 4 end
    if value_name == "radius" then return 400 end

    if value_name == "target_mult" then
      if caster:FindAbilityByName("paladin_3__hammer_rank_31") then return 3 end
      if caster:FindAbilityByName("paladin_3__hammer_rank_32") then return 0 end
    end
	end

	if ability:GetAbilityName() == "paladin_4__magnus" then
		if value_name == "AbilityManaCost" then return 300 * mana_mult end
		if value_name == "AbilityCooldown" then return 45 end

		if value_name == "duration" then return 4 + (value_level * 0.2) end
	end

	if ability:GetAbilityName() == "paladin_5__smite" then
		if value_name == "AbilityManaCost" then return 100 end
		if value_name == "AbilityCooldown" then return 10 end
		if value_name == "rank" then return 6 + (value_level * 1) end
	end

	if ability:GetAbilityName() == "paladin_u__faith" then
		if value_name == "AbilityManaCost" then return 100 end
		if value_name == "AbilityCooldown" then return 10 end
		if value_name == "rank" then return 9 + (value_level * 1) end
	end

	return 0
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------