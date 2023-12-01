trickster_special_values = class({})

function trickster_special_values:IsHidden() return true end
function trickster_special_values:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function trickster_special_values:OnCreated(kv)
end

function trickster_special_values:OnRefresh(kv)
end

function trickster_special_values:OnRemoved()
end

-- API FUNCTIONS -----------------------------------------------------------

function trickster_special_values:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE
	}

	return funcs
end

function trickster_special_values:GetModifierOverrideAbilitySpecial(keys)
	local caster = self:GetCaster()
	local ability = keys.ability
	local value_name = keys.ability_special_value
	local value_level = keys.ability_special_level
  --"AbilityCastRange"
  --"AbilityCharges"
  --"AbilityChargeRestoreTime"

	if ability:GetAbilityName() == "trickster_1__double" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
		if value_name == "chance" then return 1 end

		if caster:FindAbilityByName("trickster_1__double_rank_11") then
		end

    if caster:FindAbilityByName("trickster_1__double_rank_12") then
		end

		if caster:FindAbilityByName("trickster_1__double_rank_21") then
		end

    if caster:FindAbilityByName("trickster_1__double_rank_22") then
		end

		if caster:FindAbilityByName("trickster_1__double_rank_31") then
		end

    if caster:FindAbilityByName("trickster_1__double_rank_32") then
		end
	end

	if ability:GetAbilityName() == "trickster_2__dodge" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
		if value_name == "evasion" then return 1 end

		if caster:FindAbilityByName("trickster_2__dodge_rank_11") then
		end

    if caster:FindAbilityByName("trickster_2__dodge_rank_12") then
		end

		if caster:FindAbilityByName("trickster_2__dodge_rank_21") then
		end

    if caster:FindAbilityByName("trickster_2__dodge_rank_22") then
		end

		if caster:FindAbilityByName("trickster_2__dodge_rank_31") then
		end

    if caster:FindAbilityByName("trickster_2__dodge_rank_32") then
		end
	end

	if ability:GetAbilityName() == "trickster_3__hide" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end

		if caster:FindAbilityByName("trickster_3__hide_rank_11") then
		end

    if caster:FindAbilityByName("trickster_3__hide_rank_12") then
		end

		if caster:FindAbilityByName("trickster_3__hide_rank_21") then
		end

    if caster:FindAbilityByName("trickster_3__hide_rank_22") then
		end

		if caster:FindAbilityByName("trickster_3__hide_rank_31") then
		end

    if caster:FindAbilityByName("trickster_3__hide_rank_32") then
		end
	end

	if ability:GetAbilityName() == "trickster_4__heart" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end

		if caster:FindAbilityByName("trickster_4__heart_rank_11") then
		end

    if caster:FindAbilityByName("trickster_4__heart_rank_12") then
		end

		if caster:FindAbilityByName("trickster_4__heart_rank_21") then
		end

    if caster:FindAbilityByName("trickster_4__heart_rank_22") then
		end

		if caster:FindAbilityByName("trickster_4__heart_rank_31") then
		end

    if caster:FindAbilityByName("trickster_4__heart_rank_32") then
		end
	end

	if ability:GetAbilityName() == "trickster_5__teleport" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end

		if caster:FindAbilityByName("trickster_5__teleport_rank_11") then
		end

    if caster:FindAbilityByName("trickster_5__teleport_rank_12") then
		end

		if caster:FindAbilityByName("trickster_5__teleport_rank_21") then
		end

    if caster:FindAbilityByName("trickster_5__teleport_rank_22") then
		end

		if caster:FindAbilityByName("trickster_5__teleport_rank_31") then
		end

    if caster:FindAbilityByName("trickster_5__teleport_rank_32") then
		end
	end

	if ability:GetAbilityName() == "trickster_u__autocast" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end

		if caster:FindAbilityByName("trickster_u__autocast_rank_11") then
		end

    if caster:FindAbilityByName("trickster_u__autocast_rank_12") then
		end

		if caster:FindAbilityByName("trickster_u__autocast_rank_21") then
		end

    if caster:FindAbilityByName("trickster_u__autocast_rank_22") then
		end

		if caster:FindAbilityByName("trickster_u__autocast_rank_31") then
		end

    if caster:FindAbilityByName("trickster_u__autocast_rank_32") then
		end
	end

	return 0
end

function trickster_special_values:GetModifierOverrideAbilitySpecialValue(keys)
	local caster = self:GetCaster()
	local ability = keys.ability
	local value_name = keys.ability_special_value
	local value_level = keys.ability_special_level
	local ability_level = ability:GetLevel()
	if ability_level < 1 then ability_level = 1 end

	if ability:GetAbilityName() == "trickster_1__double" then
		if value_name == "AbilityManaCost" then return 0 end
		if value_name == "AbilityCooldown" then return 0 end
		if value_name == "chance" then return 60 + (value_level * 2.5) end
	end

	if ability:GetAbilityName() == "trickster_2__dodge" then
		if value_name == "AbilityManaCost" then return 0 end
		if value_name == "AbilityCooldown" then return 0 end
		if value_name == "evasion" then return 1.5 + (value_level * 0.25) end
	end

	if ability:GetAbilityName() == "trickster_3__hide" then
		if value_name == "AbilityManaCost" then return 100 end
		if value_name == "AbilityCooldown" then return 10 end
		if value_name == "rank" then return 6 + (value_level * 1) end
	end

	if ability:GetAbilityName() == "trickster_4__heart" then
		if value_name == "AbilityManaCost" then return 0 end
		if value_name == "AbilityCooldown" then return 0 end
		if value_name == "rank" then return 6 + (value_level * 1) end
	end

	if ability:GetAbilityName() == "trickster_5__teleport" then
		if value_name == "AbilityManaCost" then return 100 end
		if value_name == "AbilityCooldown" then return 10 end
		if value_name == "rank" then return 6 + (value_level * 1) end
	end

	if ability:GetAbilityName() == "trickster_u__autocast" then
		if value_name == "AbilityManaCost" then return 100 end
		if value_name == "AbilityCooldown" then return 10 end
		if value_name == "rank" then return 9 + (value_level * 1) end
	end

	return 0
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------