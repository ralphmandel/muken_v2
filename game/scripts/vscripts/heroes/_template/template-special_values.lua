template_special_values = class({})

function template_special_values:IsHidden() return true end
function template_special_values:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function template_special_values:OnCreated(kv)
  if not IsServer() then return end

  self:SetHasCustomTransmitterData(true)
  self.ranks = {}

  local index = 0
  for skill_id = 1, 6, 1 do
    for tier = 1, 3, 1 do
      for path = 1, 2, 1 do
        self.ranks[index] = {
          skill_id = skill_id,
          tier = tier,
          path = path,
          learned = 0
        }
        index = index + 1
      end
    end
  end

  self.data_props = {
    buff_amp = 0,
    debuff_amp = 0,
    physical_damage = 0,
    magical_damage = 0,
    holy_damage = 0,
    luck = 0
  }
end

function template_special_values:OnRefresh(kv)
end

function template_special_values:OnRemoved()
end

function template_special_values:AddCustomTransmitterData()
  return {
    ranks = self.ranks,
    data_props = self.data_props
  }
end

function template_special_values:HandleCustomTransmitterData(data)
	self.ranks = data.ranks
	self.data_props = data.data_props
end

-- API FUNCTIONS -----------------------------------------------------------

function template_special_values:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE
	}

	return funcs
end

function template_special_values:GetModifierOverrideAbilitySpecial(keys)
	local caster = self:GetCaster()
	local ability = keys.ability
	local value_name = keys.ability_special_value
	local value_level = keys.ability_special_level

	if ability:GetAbilityName() == "template_1__sk1" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
    if value_name == "AbilityCastRange" then return 1 end
    if value_name == "AbilityCharges" then return 1 end
    if value_name == "AbilityChargeRestoreTime" then return 1 end
	end

	if ability:GetAbilityName() == "template_2__sk2" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
    if value_name == "AbilityCastRange" then return 1 end
    if value_name == "AbilityCharges" then return 1 end
    if value_name == "AbilityChargeRestoreTime" then return 1 end
	end

  if ability:GetAbilityName() == "template_3__sk3" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
    if value_name == "AbilityCastRange" then return 1 end
    if value_name == "AbilityCharges" then return 1 end
    if value_name == "AbilityChargeRestoreTime" then return 1 end
	end

  if ability:GetAbilityName() == "template_4__sk4" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
    if value_name == "AbilityCastRange" then return 1 end
    if value_name == "AbilityCharges" then return 1 end
    if value_name == "AbilityChargeRestoreTime" then return 1 end
	end

  if ability:GetAbilityName() == "template_5__sk5" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
    if value_name == "AbilityCastRange" then return 1 end
    if value_name == "AbilityCharges" then return 1 end
    if value_name == "AbilityChargeRestoreTime" then return 1 end
	end

  if ability:GetAbilityName() == "template_u__sk6" then
		if value_name == "AbilityManaCost" then return 1 end
		if value_name == "AbilityCooldown" then return 1 end
    if value_name == "AbilityCastRange" then return 1 end
    if value_name == "AbilityCharges" then return 1 end
    if value_name == "AbilityChargeRestoreTime" then return 1 end
	end

	return 0
end

function template_special_values:GetModifierOverrideAbilitySpecialValue(keys)
	local caster = self:GetCaster()
	local ability = keys.ability
	local value_name = keys.ability_special_value
	local value_level = keys.ability_special_level
	local ability_level = ability:GetLevel()
	if ability_level < 1 then ability_level = 1 end

  local mana_mult = (1 + ((ability_level - 1) * 0.1))

	if ability:GetAbilityName() == "template_1__sk1" then
    if self:HasRank(1, 1, 1) then
    end

    if self:HasRank(1, 1, 2) then
    end

    if self:HasRank(1, 2, 1) then
		end

    if self:HasRank(1, 2, 2) then
		end

		if self:HasRank(1, 3, 1) then
		end

    if self:HasRank(1, 3, 2) then
		end

    if value_name == "AbilityManaCost" then return 100 * mana_mult end
    if value_name == "AbilityCooldown" then return 0 end
	end

	if ability:GetAbilityName() == "template_2__sk2" then
    if self:HasRank(2, 1, 1) then
    end

    if self:HasRank(2, 1, 2) then
    end

    if self:HasRank(2, 2, 1) then
		end

    if self:HasRank(2, 2, 2) then
		end

		if self:HasRank(2, 3, 1) then
		end

    if self:HasRank(2, 3, 2) then
		end

    if value_name == "AbilityManaCost" then return 100 * mana_mult end
    if value_name == "AbilityCooldown" then return 0 end
	end

	if ability:GetAbilityName() == "template_3__sk3" then
    if self:HasRank(3, 1, 1) then
    end

    if self:HasRank(3, 1, 2) then
    end

    if self:HasRank(3, 2, 1) then
		end

    if self:HasRank(3, 2, 2) then
		end

		if self:HasRank(3, 3, 1) then
		end

    if self:HasRank(3, 3, 2) then
		end

    if value_name == "AbilityManaCost" then return 100 * mana_mult end
    if value_name == "AbilityCooldown" then return 0 end
	end

	if ability:GetAbilityName() == "template_4__sk4" then
    if self:HasRank(4, 1, 1) then
    end

    if self:HasRank(4, 1, 2) then
    end

    if self:HasRank(4, 2, 1) then
		end

    if self:HasRank(4, 2, 2) then
		end

		if self:HasRank(4, 3, 1) then
		end

    if self:HasRank(4, 3, 2) then
		end

    if value_name == "AbilityManaCost" then return 100 * mana_mult end
    if value_name == "AbilityCooldown" then return 0 end
	end

	if ability:GetAbilityName() == "template_5__smoke" then
    if self:HasRank(5, 1, 1) then
    end

    if self:HasRank(5, 1, 2) then
    end

    if self:HasRank(5, 2, 1) then
		end

    if self:HasRank(5, 2, 2) then
		end

		if self:HasRank(5, 3, 1) then
		end

    if self:HasRank(5, 3, 2) then
		end

    if value_name == "AbilityManaCost" then return 100 * mana_mult end
    if value_name == "AbilityCooldown" then return 0 end
	end

	if ability:GetAbilityName() == "template_u__sk6" then
    if self:HasRank(6, 1, 1) then
    end

    if self:HasRank(6, 1, 2) then
    end

    if self:HasRank(6, 2, 1) then
		end

    if self:HasRank(6, 2, 2) then
		end

		if self:HasRank(6, 3, 1) then
		end

    if self:HasRank(6, 3, 2) then
		end

    if value_name == "AbilityManaCost" then return 100 * mana_mult end
    if value_name == "AbilityCooldown" then return 0 end
	end

	return 0
end

-- UTILS -----------------------------------------------------------

function template_special_values:LearnRank(skill_id, tier, path)
  for index, table in pairs(self.ranks) do
    if table.skill_id == skill_id and table.tier == tier and table.path == path then
      self.ranks[index].learned = 1
    end
  end

  self:SendBuffRefreshToClients()
end

function template_special_values:HasRank(skill_id, tier, path)
  for index, table in pairs(self.ranks) do
    if table.skill_id == skill_id and table.tier == tier and table.path == path then
      return self.ranks[index].learned == 1
    end
  end
end

function template_special_values:UpdateData(data, value)
	self.data_props[data] = value
  self:SendBuffRefreshToClients()
end

function template_special_values:GetBuffAmp()
  return 1 + self.data_props["buff_amp"]
end

function template_special_values:GetDebuffAmp()
  return 1 + self.data_props["debuff_amp"]
end

function template_special_values:GetPhysicalDamageAmp()
  return self.data_props["physical_damage"] * 0.01
end

function template_special_values:GetMagicalDamageAmp()
  return self.data_props["magical_damage"] * 0.01
end

function template_special_values:GetHolyDamageAmp()
  return self.data_props["holy_damage"] * 0.01
end

function template_special_values:CalcLuck(value)
  local result = value * (1 + self.data_props["luck"])
  if result < 0 then result = 0 elseif result > 100 then result = 100 end

  return result
end

-- EFFECTS -----------------------------------------------------------