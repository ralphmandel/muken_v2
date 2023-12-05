strider_special_values = class({})

function strider_special_values:IsHidden() return true end
function strider_special_values:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function strider_special_values:OnCreated(kv)
end

function strider_special_values:OnRefresh(kv)
end

function strider_special_values:OnRemoved()
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
		--if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
		if value_name == "AbilityCastRange" then return 1 end
		if value_name == "AbilityHealthCost" then return 1 end
		

		if caster:FindAbilityByName("strider_1__silence_rank_11") then
		end

    if caster:FindAbilityByName("strider_1__silence_rank_12") then
		end

		if caster:FindAbilityByName("strider_1__silence_rank_21") then
		end

    if caster:FindAbilityByName("strider_1__silence_rank_22") then
		end

		if caster:FindAbilityByName("strider_1__silence_rank_31") then
		end

    if caster:FindAbilityByName("strider_1__silence_rank_32") then
		end
	end

	if ability:GetAbilityName() == "strider_2__spin" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end

		if caster:FindAbilityByName("strider_2__spin_rank_11") then
		end

    if caster:FindAbilityByName("strider_2__spin_rank_12") then
		end

		if caster:FindAbilityByName("strider_2__spin_rank_21") then
		end

    if caster:FindAbilityByName("strider_2__spin_rank_22") then
		end

		if caster:FindAbilityByName("strider_2__spin_rank_31") then
		end

    if caster:FindAbilityByName("strider_2__spin_rank_32") then
		end
	end

	if ability:GetAbilityName() == "strider_3__smoke" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
		if value_name == "AbilityCastRange" then return 1 end

		if caster:FindAbilityByName("strider_3__smoke_rank_11") then
		end

    if caster:FindAbilityByName("strider_3__smoke_rank_12") then
		end

		if caster:FindAbilityByName("strider_3__smoke_rank_21") then
		end

    if caster:FindAbilityByName("strider_3__smoke_rank_22") then
		end

		if caster:FindAbilityByName("strider_3__smoke_rank_31") then
		end

    if caster:FindAbilityByName("strider_3__smoke_rank_32") then
		end
	end

	if ability:GetAbilityName() == "strider_4__shuriken" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
		if value_name == "AbilityCastRange" then return 1 end

		if caster:FindAbilityByName("strider_4__shuriken_rank_11") then
		end

    if caster:FindAbilityByName("strider_4__shuriken_rank_12") then
		end

		if caster:FindAbilityByName("strider_4__shuriken_rank_21") then
		end

    if caster:FindAbilityByName("strider_4__shuriken_rank_22") then
		end

		if caster:FindAbilityByName("strider_4__shuriken_rank_31") then
		end

    if caster:FindAbilityByName("strider_4__shuriken_rank_32") then
		end
	end

	if ability:GetAbilityName() == "strider_5__aspd" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end

		if caster:FindAbilityByName("strider_5__aspd_rank_11") then
		end

    if caster:FindAbilityByName("strider_5__aspd_rank_12") then
		end

		if caster:FindAbilityByName("strider_5__aspd_rank_21") then
		end

    if caster:FindAbilityByName("strider_5__aspd_rank_22") then
		end

		if caster:FindAbilityByName("strider_5__aspd_rank_31") then
		end

    if caster:FindAbilityByName("strider_5__aspd_rank_32") then
		end
	end

	if ability:GetAbilityName() == "strider_u__sk6" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end

		if caster:FindAbilityByName("strider_u__sk6_rank_11") then
		end

    if caster:FindAbilityByName("strider_u__sk6_rank_12") then
		end

		if caster:FindAbilityByName("strider_u__sk6_rank_21") then
		end

    if caster:FindAbilityByName("strider_u__sk6_rank_22") then
		end

		if caster:FindAbilityByName("strider_u__sk6_rank_31") then
		end

    if caster:FindAbilityByName("strider_u__sk6_rank_32") then
		end
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

	if ability:GetAbilityName() == "strider_1__silence" then
		--if value_name == "AbilityManaCost" then return 100 end
		if value_name == "AbilityCooldown" then return 12 end
		if value_name == "AbilityCastRange" then return 600 end
		if value_name == "AbilityHealthCost" then return 200 end
		if value_name == "rank" then return 6 + (value_level * 1) end
	end

	if ability:GetAbilityName() == "strider_2__spin" then
		if value_name == "AbilityManaCost" then return 60 end
		if value_name == "AbilityCooldown" then return 8 end
		if value_name == "rank" then return 6 + (value_level * 1) end
	end

	if ability:GetAbilityName() == "strider_3__smoke" then
		if value_name == "AbilityManaCost" then return 120 end
		if value_name == "AbilityCooldown" then return 20 end
		if value_name == "AbilityCastRange" then return 300 end
		if value_name == "rank" then return 6 + (value_level * 1) end
	end

	if ability:GetAbilityName() == "strider_4__shuriken" then
		if value_name == "AbilityManaCost" then return 50 end
		if value_name == "AbilityCooldown" then return 3 end
		if value_name == "AbilityCastRange" then return 600 end
		if value_name == "rank" then return 6 + (value_level * 1) end
	end

	if ability:GetAbilityName() == "strider_5__aspd" then
		if value_name == "AbilityManaCost" then return 80 end
		if value_name == "AbilityCooldown" then return 15 end
		if value_name == "rank" then return 6 + (value_level * 1) end
	end

	if ability:GetAbilityName() == "strider_u__sk6" then
		if value_name == "AbilityManaCost" then return 100 end
		if value_name == "AbilityCooldown" then return 10 end
		if value_name == "rank" then return 9 + (value_level * 1) end
	end

	return 0
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------