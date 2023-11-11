vulture_special_values = class({})

function vulture_special_values:IsHidden() return true end
function vulture_special_values:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function vulture_special_values:OnCreated(kv)
end

function vulture_special_values:OnRefresh(kv)
end

function vulture_special_values:OnRemoved()
end

-- API FUNCTIONS -----------------------------------------------------------

function vulture_special_values:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE
	}

	return funcs
end

function vulture_special_values:GetModifierOverrideAbilitySpecial(keys)
	local caster = self:GetCaster()
	local ability = keys.ability
	local value_name = keys.ability_special_value
	local value_level = keys.ability_special_level
  --"AbilityCastRange"
  --"AbilityCharges"
  --"AbilityChargeRestoreTime"

	if ability:GetAbilityName() == "vulture_1__tree" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
		if value_name == "AbilityCastRange" then return 1 end

		if caster:FindAbilityByName("vulture_1__tree_rank_11") then
		end

    if caster:FindAbilityByName("vulture_1__tree_rank_12") then
		end

		if caster:FindAbilityByName("vulture_1__tree_rank_21") then
		end

    if caster:FindAbilityByName("vulture_1__tree_rank_22") then
		end

		if caster:FindAbilityByName("vulture_1__tree_rank_31") then
		end

    if caster:FindAbilityByName("vulture_1__tree_rank_32") then
		end
	end

	if ability:GetAbilityName() == "vulture_2__sk2" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end

		if caster:FindAbilityByName("vulture_2__sk2_rank_11") then
		end

    if caster:FindAbilityByName("vulture_2__sk2_rank_12") then
		end

		if caster:FindAbilityByName("vulture_2__sk2_rank_21") then
		end

    if caster:FindAbilityByName("vulture_2__sk2_rank_22") then
		end

		if caster:FindAbilityByName("vulture_2__sk2_rank_31") then
		end

    if caster:FindAbilityByName("vulture_2__sk2_rank_32") then
		end
	end

	if ability:GetAbilityName() == "vulture_3__sk3" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end

		if caster:FindAbilityByName("vulture_3__sk3_rank_11") then
		end

    if caster:FindAbilityByName("vulture_3__sk3_rank_12") then
		end

		if caster:FindAbilityByName("vulture_3__sk3_rank_21") then
		end

    if caster:FindAbilityByName("vulture_3__sk3_rank_22") then
		end

		if caster:FindAbilityByName("vulture_3__sk3_rank_31") then
		end

    if caster:FindAbilityByName("vulture_3__sk3_rank_32") then
		end
	end

	if ability:GetAbilityName() == "vulture_4__sk4" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end

		if caster:FindAbilityByName("vulture_4__sk4_rank_11") then
		end

    if caster:FindAbilityByName("vulture_4__sk4_rank_12") then
		end

		if caster:FindAbilityByName("vulture_4__sk4_rank_21") then
		end

    if caster:FindAbilityByName("vulture_4__sk4_rank_22") then
		end

		if caster:FindAbilityByName("vulture_4__sk4_rank_31") then
		end

    if caster:FindAbilityByName("vulture_4__sk4_rank_32") then
		end
	end

	if ability:GetAbilityName() == "vulture_5__sk5" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end

		if caster:FindAbilityByName("vulture_5__sk5_rank_11") then
		end

    if caster:FindAbilityByName("vulture_5__sk5_rank_12") then
		end

		if caster:FindAbilityByName("vulture_5__sk5_rank_21") then
		end

    if caster:FindAbilityByName("vulture_5__sk5_rank_22") then
		end

		if caster:FindAbilityByName("vulture_5__sk5_rank_31") then
		end

    if caster:FindAbilityByName("vulture_5__sk5_rank_32") then
		end
	end

	if ability:GetAbilityName() == "vulture_u__sk6" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end

		if caster:FindAbilityByName("vulture_u__sk6_rank_11") then
		end

    if caster:FindAbilityByName("vulture_u__sk6_rank_12") then
		end

		if caster:FindAbilityByName("vulture_u__sk6_rank_21") then
		end

    if caster:FindAbilityByName("vulture_u__sk6_rank_22") then
		end

		if caster:FindAbilityByName("vulture_u__sk6_rank_31") then
		end

    if caster:FindAbilityByName("vulture_u__sk6_rank_32") then
		end
	end

	return 0
end

function vulture_special_values:GetModifierOverrideAbilitySpecialValue(keys)
	local caster = self:GetCaster()
	local ability = keys.ability
	local value_name = keys.ability_special_value
	local value_level = keys.ability_special_level
	local ability_level = ability:GetLevel()
	if ability_level < 1 then ability_level = 1 end

	if ability:GetAbilityName() == "vulture_1__tree" then
		if value_name == "AbilityManaCost" then return 100 end
		if value_name == "AbilityCooldown" then return 10 end
		if value_name == "AbilityCastRange" then return 1000 end
		if value_name == "rank" then return 6 + (value_level * 1) end
	end

	if ability:GetAbilityName() == "vulture_2__sk2" then
		if value_name == "AbilityManaCost" then return 100 end
		if value_name == "AbilityCooldown" then return 10 end
		if value_name == "rank" then return 6 + (value_level * 1) end
	end

	if ability:GetAbilityName() == "vulture_3__sk3" then
		if value_name == "AbilityManaCost" then return 100 end
		if value_name == "AbilityCooldown" then return 10 end
		if value_name == "rank" then return 6 + (value_level * 1) end
	end

	if ability:GetAbilityName() == "vulture_4__sk4" then
		if value_name == "AbilityManaCost" then return 100 end
		if value_name == "AbilityCooldown" then return 10 end
		if value_name == "rank" then return 6 + (value_level * 1) end
	end

	if ability:GetAbilityName() == "vulture_5__sk5" then
		if value_name == "AbilityManaCost" then return 100 end
		if value_name == "AbilityCooldown" then return 10 end
		if value_name == "rank" then return 6 + (value_level * 1) end
	end

	if ability:GetAbilityName() == "vulture_u__sk6" then
		if value_name == "AbilityManaCost" then return 100 end
		if value_name == "AbilityCooldown" then return 10 end
		if value_name == "rank" then return 9 + (value_level * 1) end
	end

	return 0
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------