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
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
		if value_name == "AbilityCastRange" then return 1 end
		if value_name == "AbilityHealthCost" then return 1 end
		if value_name == "duration" then return 1 end		

		if caster:FindAbilityByName("strider_1__silence_rank_11") then
      if value_name == "cast_range" then return 1 end		
		end

    if caster:FindAbilityByName("strider_1__silence_rank_12") then
		end

		if caster:FindAbilityByName("strider_1__silence_rank_21") then
      if value_name == "heal_bonus" then return 1 end		
		end

    if caster:FindAbilityByName("strider_1__silence_rank_22") then
      if value_name == "special_damage_mult" then return 1 end
		end

		if caster:FindAbilityByName("strider_1__silence_rank_31") then
      if value_name == "special_disarm" then return 1 end		
		end

    if caster:FindAbilityByName("strider_1__silence_rank_32") then
      if value_name == "special_stun_mult" then return 1 end		
		end
	end

	if ability:GetAbilityName() == "strider_2__spin" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
		if value_name == "cooldown" then return 1 end

		if caster:FindAbilityByName("strider_2__spin_rank_11") then
      if value_name == "special_crit_damage" then return 1 end
		end

    if caster:FindAbilityByName("strider_2__spin_rank_12") then
		end

		if caster:FindAbilityByName("strider_2__spin_rank_21") then
      if value_name == "radius" then return 1 end
		end

    if caster:FindAbilityByName("strider_2__spin_rank_22") then
		end

		if caster:FindAbilityByName("strider_2__spin_rank_31") then
      if value_name == "bleeding_duration" then return 1 end
		end

    if caster:FindAbilityByName("strider_2__spin_rank_32") then
      if value_name == "special_bleed_chance" then return 1 end
		end
	end

	if ability:GetAbilityName() == "strider_3__smoke" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
		if value_name == "AbilityCastRange" then return 1 end
		if value_name == "radius" then return 1 end

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

	if ability:GetAbilityName() == "strider_u__shadow" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
    if value_name == "AbilityCastRange" then return 1 end
    if value_name == "AbilityCharges" then return 1 end
    if value_name == "AbilityChargeRestoreTime" then return 1 end

		if caster:FindAbilityByName("strider_u__shadow_rank_11") then
		end

    if caster:FindAbilityByName("strider_u__shadow_rank_12") then
		end

		if caster:FindAbilityByName("strider_u__shadow_rank_21") then
		end

    if caster:FindAbilityByName("strider_u__shadow_rank_22") then
		end

		if caster:FindAbilityByName("strider_u__shadow_rank_31") then
		end

    if caster:FindAbilityByName("strider_u__shadow_rank_32") then
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
		if value_name == "AbilityManaCost" then return 0 end
		if value_name == "AbilityCooldown" then return 15 end
		if value_name == "AbilityCastRange" then return ability:GetSpecialValueFor("cast_range") end
		if value_name == "AbilityHealthCost" then return 300 + (caster:GetLevel() * 20) end
    if value_name == "duration" then return 5 + (value_level * 0.25) end

    if value_name == "cast_range" then return 1200 end
    if value_name == "heal_bonus" then return 75 end
    if value_name == "special_damage_mult" then return 0.004 end
    if value_name == "special_disarm" then return 1 end
    if value_name == "special_stun_mult" then return 0.6 end
	end

	if ability:GetAbilityName() == "strider_2__spin" then
		if value_name == "AbilityManaCost" then return 50 end
		if value_name == "AbilityCooldown" then return ability:GetSpecialValueFor("cooldown") end
		if value_name == "cooldown" then return 7.5 - (value_level * 0.25) end

    if value_name == "special_crit_damage" then return 50 end
    if value_name == "radius" then return 350 end
    if value_name == "bleeding_duration" then return 5 end
    if value_name == "special_bleed_chance" then return 10 end
	end

	if ability:GetAbilityName() == "strider_3__smoke" then
		if value_name == "AbilityManaCost" then return 120 end
		if value_name == "AbilityCooldown" then return 22 end
		if value_name == "AbilityCastRange" then return ability:GetSpecialValueFor("radius") end
    if value_name == "radius" then return 300 + (value_level * 10) end
	end

	if ability:GetAbilityName() == "strider_4__shuriken" then
		if value_name == "AbilityManaCost" then return 50 end
		if value_name == "AbilityCooldown" then return 3 end
		if value_name == "AbilityCastRange" then return 600 end
	end

	if ability:GetAbilityName() == "strider_5__aspd" then
		if value_name == "AbilityManaCost" then return 80 end
		if value_name == "AbilityCooldown" then return 15 end
	end

	if ability:GetAbilityName() == "strider_u__shadow" then
		if value_name == "AbilityManaCost" then return 100 end
		if value_name == "AbilityCooldown" then return 0 end
    if value_name == "AbilityCastRange" then return 500 end
    if value_name == "AbilityCharges" then return 2 end
    if value_name == "AbilityChargeRestoreTime" then return 30 end


	end

	return 0
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------