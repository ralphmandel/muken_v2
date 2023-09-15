bloodstained_special_values = class({})

function bloodstained_special_values:IsHidden() return true end
function bloodstained_special_values:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function bloodstained_special_values:OnCreated(kv)
end

function bloodstained_special_values:OnRefresh(kv)
end

function bloodstained_special_values:OnRemoved()
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
		if value_name == "rank" then return 1 end
		if value_name == "cooldown" then return 1 end

		if caster:FindAbilityByName("bloodstained_1__rage_rank_11") then
		end

    if caster:FindAbilityByName("bloodstained_1__rage_rank_12") then
		end

		if caster:FindAbilityByName("bloodstained_1__rage_rank_21") then
		end

    if caster:FindAbilityByName("bloodstained_1__rage_rank_22") then
		end

		if caster:FindAbilityByName("bloodstained_1__rage_rank_31") then
		end

    if caster:FindAbilityByName("bloodstained_1__rage_rank_32") then
		end
	end

  if ability:GetAbilityName() == "bloodstained_2__frenzy" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
		if value_name == "rank" then return 1 end
		if value_name == "duration" then return 1 end

		if caster:FindAbilityByName("bloodstained_2__frenzy_rank_11") then
		end

    if caster:FindAbilityByName("bloodstained_2__frenzy_rank_12") then
		end

		if caster:FindAbilityByName("bloodstained_2__frenzy_rank_21") then
		end

    if caster:FindAbilityByName("bloodstained_2__frenzy_rank_22") then
		end

		if caster:FindAbilityByName("bloodstained_2__frenzy_rank_31") then
		end

    if caster:FindAbilityByName("bloodstained_2__frenzy_rank_32") then
		end
	end

	if ability:GetAbilityName() == "bloodstained_3__curse" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
    if value_name == "AbilityCastRange" then return 1 end
		if value_name == "rank" then return 1 end
    if value_name == "max_range" then return 1 end

		if caster:FindAbilityByName("bloodstained_3__curse_rank_11") then
		end

    if caster:FindAbilityByName("bloodstained_3__curse_rank_12") then
		end

		if caster:FindAbilityByName("bloodstained_3__curse_rank_21") then
		end

    if caster:FindAbilityByName("bloodstained_3__curse_rank_22") then
		end

		if caster:FindAbilityByName("bloodstained_3__curse_rank_31") then
		end

    if caster:FindAbilityByName("bloodstained_3__curse_rank_32") then
		end
	end

	if ability:GetAbilityName() == "bloodstained_4__tear" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
		if value_name == "rank" then return 1 end
    if value_name == "blood_percent" then return 1 end

		if caster:FindAbilityByName("bloodstained_4__tear_rank_11") then
		end

    if caster:FindAbilityByName("bloodstained_4__tear_rank_12") then
		end

		if caster:FindAbilityByName("bloodstained_4__tear_rank_21") then
		end

    if caster:FindAbilityByName("bloodstained_4__tear_rank_22") then
		end

		if caster:FindAbilityByName("bloodstained_4__tear_rank_31") then
		end

    if caster:FindAbilityByName("bloodstained_4__tear_rank_32") then
		end
	end

  if ability:GetAbilityName() == "bloodstained_5__lifesteal" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
		if value_name == "rank" then return 1 end
		if value_name == "base_heal" then return 1 end

		if caster:FindAbilityByName("bloodstained_5__lifesteal_rank_11") then
		end

    if caster:FindAbilityByName("bloodstained_5__lifesteal_rank_12") then
		end

		if caster:FindAbilityByName("bloodstained_5__lifesteal_rank_21") then
		end

    if caster:FindAbilityByName("bloodstained_5__lifesteal_rank_22") then
		end

		if caster:FindAbilityByName("bloodstained_5__lifesteal_rank_31") then
		end

    if caster:FindAbilityByName("bloodstained_5__lifesteal_rank_32") then
		end
	end

	if ability:GetAbilityName() == "bloodstained_u__seal" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
    if value_name == "AbilityCastRange" then return 1 end
		if value_name == "rank" then return 1 end
		if value_name == "duration" then return 1 end

		if caster:FindAbilityByName("bloodstained_u__seal_rank_11") then
		end

    if caster:FindAbilityByName("bloodstained_u__seal_rank_12") then
		end

		if caster:FindAbilityByName("bloodstained_u__seal_rank_21") then
		end

    if caster:FindAbilityByName("bloodstained_u__seal_rank_22") then
		end

		if caster:FindAbilityByName("bloodstained_u__seal_rank_31") then
		end

    if caster:FindAbilityByName("bloodstained_u__seal_rank_32") then
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

	if ability:GetAbilityName() == "bloodstained_1__rage" then
		if value_name == "AbilityManaCost" then return 275 * (1 + ((ability_level - 1) * 0.05)) end
		if value_name == "AbilityCooldown" then return ability:GetSpecialValueFor("cooldown") end
		if value_name == "rank" then return 6 + (value_level * 1) end
		if value_name == "cooldown" then return 16 - (value_level * 1) end
	end

  if ability:GetAbilityName() == "bloodstained_2__frenzy" then
		if value_name == "AbilityManaCost" then return 0 * (1 + ((ability_level - 1) * 0.05)) end
		if value_name == "AbilityCooldown" then return 3 end
		if value_name == "rank" then return 6 + (value_level * 1) end
		if value_name == "duration" then return 3 + (value_level * 0.25) end
	end

	if ability:GetAbilityName() == "bloodstained_3__curse" then
		if value_name == "AbilityManaCost" then return 450 * (1 + ((ability_level - 1) * 0.05)) end
		if value_name == "AbilityCooldown" then return 30 end
    if value_name == "AbilityCastRange" then return 350 end
		if value_name == "rank" then return 6 + (value_level * 1) end
		if value_name == "max_range" then return 700 + (value_level * 50) end
	end

	if ability:GetAbilityName() == "bloodstained_4__tear" then
		if value_name == "AbilityManaCost" then return 0 end
    
		if value_name == "AbilityCooldown" then return 40 end
		if value_name == "rank" then return 6 + (value_level * 1) end
    if value_name == "blood_percent" then return 8 + (value_level * 0.25) end
	end

  if ability:GetAbilityName() == "bloodstained_5__lifesteal" then
		if value_name == "AbilityManaCost" then return 0 * (1 + ((ability_level - 1) * 0.05)) end
		if value_name == "AbilityCooldown" then return 0 end
		if value_name == "rank" then return 6 + (value_level * 1) end
		if value_name == "base_heal" then return 4 + (value_level * 1) end
	end

	if ability:GetAbilityName() == "bloodstained_u__seal" then
		if value_name == "AbilityManaCost" then return 850 * (1 + ((ability_level - 1) * 0.05)) end
		if value_name == "AbilityCooldown" then return 100 end
    if value_name == "AbilityCastRange" then return ability:GetSpecialValueFor("radius") - 50 end

		if value_name == "rank" then return 9 + (value_level * 1) end
    if value_name == "duration" then return 12 + (value_level * 0.5) end
	end

	return 0
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------