trickster_u_modifier_autocast = class({})

function trickster_u_modifier_autocast:IsHidden() return false end
function trickster_u_modifier_autocast:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function trickster_u_modifier_autocast:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if IsServer() then
    local target = EntIndexToHScript(kv.target_index)
    self.special_kv_name = GetHeroName(target:GetUnitName()).."_special_values"
    AddModifier(self.caster, self.ability, self.special_kv_name, {}, false)

    local ability = EntIndexToHScript(kv.ability_index)
    self.stolen_ability = self.parent:AddAbility(ability:GetAbilityName())
    self.stolen_ability:UpgradeAbility(true)
    self.stolen_ability:SetHidden(false)
    self.modifiers = {}

    self:SetStackCount(math.ceil(self:GetChance()))
  end
end

function trickster_u_modifier_autocast:OnRefresh(kv)
end

function trickster_u_modifier_autocast:OnRemoved()
  for _, modifier in pairs(self.modifiers) do
    if modifier.Destroy() then modifier:Destroy() end
  end

  self.parent:RemoveModifierByName(self.special_kv_name)
  self.parent:RemoveAbilityByHandle(self.stolen_ability)
end

-- API FUNCTIONS -----------------------------------------------------------

function trickster_u_modifier_autocast:DeclareFunctions()
	local funcs = {
    MODIFIER_EVENT_ON_MODIFIER_ADDED,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end

function trickster_u_modifier_autocast:OnModifierAdded(keys)
  if keys.added_buff:GetAbility() == self.stolen_ability then
    table.insert(self.modifiers, keys.added_buff)
  end
end

function trickster_u_modifier_autocast:OnAttackLanded(keys)
  if keys.attacker ~= self.parent then return end

  local chance = self:GetChance()

  if IsServer() then self:SetStackCount(math.ceil(chance)) end

  if RandomFloat(0, 100) < chance then
    self.parent:SetCursorCastTarget(keys.target)
    self.stolen_ability:OnSpellStart()
  end
end

-- UTILS -----------------------------------------------------------

function trickster_u_modifier_autocast:GetChance()
  local cooldown = self.stolen_ability:GetCooldown(self.stolen_ability:GetLevel())
  local restore_time = self.stolen_ability:GetAbilityChargeRestoreTime(self.stolen_ability:GetLevel())

  local chance = 100 / cooldown
  if restore_time > 0 then chance = 100 / restore_time end

  chance = chance * self.ability:GetSpecialValueFor("chance_mult")
  return chance
end

-- EFFECTS -----------------------------------------------------------