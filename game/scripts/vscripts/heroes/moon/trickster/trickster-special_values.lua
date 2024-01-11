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
      if value_name == "attack_speed" then return 1 end
		end

    if caster:FindAbilityByName("trickster_1__double_rank_12") then
		end

		if caster:FindAbilityByName("trickster_1__double_rank_21") then
      if value_name == "special_bonus_damage" then return 1 end
		end

    if caster:FindAbilityByName("trickster_1__double_rank_22") then
		end

		if caster:FindAbilityByName("trickster_1__double_rank_31") then
      if value_name == "special_bleeding_chance" then return 1 end
      if value_name == "special_bleeding_duration" then return 1 end
		end

    if caster:FindAbilityByName("trickster_1__double_rank_32") then
		end
	end

	if ability:GetAbilityName() == "trickster_2__dodge" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
		if value_name == "evasion" then return 1 end

		if caster:FindAbilityByName("trickster_2__dodge_rank_11") then
      if value_name == "critical_chance" then return 1 end
		end

    if caster:FindAbilityByName("trickster_2__dodge_rank_12") then
      if value_name == "special_attack_time" then return 1 end
		end

		if caster:FindAbilityByName("trickster_2__dodge_rank_21") then
      if value_name == "special_linkens_chance" then return 1 end
		end

    if caster:FindAbilityByName("trickster_2__dodge_rank_22") then
		end

		if caster:FindAbilityByName("trickster_2__dodge_rank_31") then
      if value_name == "special_health_regen" then return 1 end
		end

    if caster:FindAbilityByName("trickster_2__dodge_rank_32") then
      if value_name == "special_disarm_chance" then return 1 end
      if value_name == "special_disarm_duration" then return 1 end
		end
	end

	if ability:GetAbilityName() == "trickster_3__hide" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
		if value_name == "cooldown" then return 1 end

		if caster:FindAbilityByName("trickster_3__hide_rank_11") then
      if value_name == "duration" then return 1 end
		end

    if caster:FindAbilityByName("trickster_3__hide_rank_12") then
		end

		if caster:FindAbilityByName("trickster_3__hide_rank_21") then
      if value_name == "ms" then return 1 end
		end

    if caster:FindAbilityByName("trickster_3__hide_rank_22") then
		end

		if caster:FindAbilityByName("trickster_3__hide_rank_31") then
      if value_name == "hits" then return 1 end
		end

    if caster:FindAbilityByName("trickster_3__hide_rank_32") then
      if value_name == "special_lifesteal" then return 1 end
		end
	end

	if ability:GetAbilityName() == "trickster_4__heart" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
		if value_name == "max_stack" then return 1 end

		if caster:FindAbilityByName("trickster_4__heart_rank_11") then
      if value_name == "special_slow_stack" then return 1 end
		end

    if caster:FindAbilityByName("trickster_4__heart_rank_12") then
		end

		if caster:FindAbilityByName("trickster_4__heart_rank_21") then
      if value_name == "special_armor_stack" then return 1 end
		end

    if caster:FindAbilityByName("trickster_4__heart_rank_22") then
		end

		if caster:FindAbilityByName("trickster_4__heart_rank_31") then
      if value_name == "percent_stack" then return 1 end
		end

    if caster:FindAbilityByName("trickster_4__heart_rank_32") then
		end
	end

	if ability:GetAbilityName() == "trickster_5__teleport" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
		if value_name == "AbilityCastRange" then return 1 end
    if value_name == "AbilityChannelTime" then return 1 end
		if value_name == "channel_time" then return 1 end

		if caster:FindAbilityByName("trickster_5__teleport_rank_11") then
		end

    if caster:FindAbilityByName("trickster_5__teleport_rank_12") then
		end

		if caster:FindAbilityByName("trickster_5__teleport_rank_21") then
      if value_name == "cast_range" then return 1 end
      if value_name == "special_blink" then return 1 end
		end

    if caster:FindAbilityByName("trickster_5__teleport_rank_22") then
		end

		if caster:FindAbilityByName("trickster_5__teleport_rank_31") then
      if value_name == "special_stun_duration" then return 1 end
		end

    if caster:FindAbilityByName("trickster_5__teleport_rank_32") then
		end
	end

	if ability:GetAbilityName() == "trickster_u__autocast" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
		if value_name == "AbilityCastRange" then return 1 end
		if value_name == "AbilityCharges" then return 1 end
		if value_name == "AbilityChargeRestoreTime" then return 1 end
		if value_name == "ability_level" then return 1 end

		if caster:FindAbilityByName("trickster_u__autocast_rank_11") then
      if value_name == "_rank_11" then return 1 end
		end

    if caster:FindAbilityByName("trickster_u__autocast_rank_12") then
      if value_name == "_rank_12" then return 1 end
		end

		if caster:FindAbilityByName("trickster_u__autocast_rank_21") then
      if value_name == "_rank_21" then return 1 end
		end

    if caster:FindAbilityByName("trickster_u__autocast_rank_22") then
      if value_name == "_rank_22" then return 1 end
		end

		if caster:FindAbilityByName("trickster_u__autocast_rank_31") then
      if value_name == "_rank_31" then return 1 end
		end

    if caster:FindAbilityByName("trickster_u__autocast_rank_32") then
      if value_name == "_rank_32" then return 1 end
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

  local mana_mult = (1 + ((ability_level - 1) * 0.1))

	if ability:GetAbilityName() == "trickster_1__double" then
		if value_name == "AbilityManaCost" then return 0 end
		if value_name == "AbilityCooldown" then return 0 end
		if value_name == "chance" then return 30 + (value_level * 1) end

    if value_name == "attack_speed" then return 100 end
    if value_name == "special_bonus_damage" then return 30 end
    if value_name == "special_bleeding_chance" then return 10 end
    if value_name == "special_bleeding_duration" then return 4 end
	end

	if ability:GetAbilityName() == "trickster_2__dodge" then
		if value_name == "AbilityManaCost" then return 0 end
		if value_name == "AbilityCooldown" then return 0 end
		if value_name == "evasion" then return 2 + (value_level * 0.25) end

    if value_name == "critical_chance" then return -10 end
    if value_name == "special_attack_time" then return 0.2 end
    if value_name == "special_linkens_chance" then return 5 end
    if value_name == "special_health_regen" then return 30 end
    if value_name == "special_disarm_chance" then return 5 end
    if value_name == "special_disarm_duration" then return 2.5 end
	end

	if ability:GetAbilityName() == "trickster_3__hide" then
		if value_name == "AbilityManaCost" then return 100 * mana_mult end
		if value_name == "AbilityCooldown" then return ability:GetSpecialValueFor("cooldown") end
		if value_name == "cooldown" then return 18 - (value_level * 0.5) end

    if value_name == "duration" then return 12 end
    if value_name == "ms" then return 100 end
    if value_name == "hits" then return 25 end
    if value_name == "special_lifesteal" then return 50 end
	end

	if ability:GetAbilityName() == "trickster_4__heart" then
		if value_name == "AbilityManaCost" then return 0 end
		if value_name == "AbilityCooldown" then return 0 end
		if value_name == "max_stack" then return 24 + (value_level * 1) end

    if value_name == "special_slow_stack" then return 3 end
    if value_name == "special_armor_stack" then return -0.1 end
    if value_name == "percent_stack" then return -1 end
	end

	if ability:GetAbilityName() == "trickster_5__teleport" then
		if value_name == "AbilityManaCost" then return 150 * mana_mult end

		if value_name == "AbilityCooldown" then
      if caster:FindAbilityByName("trickster_5__teleport_rank_11") then
        return 40
      end
      return 50
    end

    if value_name == "AbilityCastRange" then return ability:GetSpecialValueFor("cast_range") end
    if value_name == "AbilityChannelTime" then return ability:GetSpecialValueFor("channel_time") end

		if value_name == "channel_time" then return 2 - (value_level * 0.1) end
    if value_name == "cast_range" then return 750 end
    if value_name == "special_blink" then return 1 end
    if value_name == "special_stun_duration" then return 4 end
	end

	if ability:GetAbilityName() == "trickster_u__autocast" then
		if value_name == "AbilityManaCost" then return 0 end
		if value_name == "AbilityCooldown" then return 0 end
    if value_name == "AbilityCastRange" then return 400 end
		if value_name == "AbilityCharges" then return 2 end
		if value_name == "AbilityChargeRestoreTime" then return 120 end

		if value_name == "ability_level" then return 1 + (value_level * 1) end

    if value_name == "_rank_11" then return 1 end
    if value_name == "_rank_12" then return 1 end
    if value_name == "_rank_21" then return 1 end
    if value_name == "_rank_22" then return 1 end
    if value_name == "_rank_31" then return 1 end
    if value_name == "_rank_32" then return 1 end
	end

	return 0
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------