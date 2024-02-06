strider_2_modifier_passive = class({})

function strider_2_modifier_passive:IsHidden() return true end
function strider_2_modifier_passive:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function strider_2_modifier_passive:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()
end

function strider_2_modifier_passive:OnRefresh(kv)
end

function strider_2_modifier_passive:OnRemoved()
end

-- API FUNCTIONS -----------------------------------------------------------

function strider_2_modifier_passive:DeclareFunctions()
	local funcs = {
    MODIFIER_PROPERTY_PRE_ATTACK,
    MODIFIER_EVENT_ON_ORDER,
    MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end

function strider_2_modifier_passive:GetModifierPreAttack(keys)
  if self.parent:HasModifier("strider_2_modifier_spin") then return end
  self.ability.aggro = keys.target
end

function strider_2_modifier_passive:OnOrder(keys)
  if keys.unit ~= self.parent then return end
  if keys.order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION then
    self.ability.aggro = nil
  end
end

function strider_2_modifier_passive:OnAttackLanded(keys)
  if not IsServer() then return end
  
  if keys.attacker ~= self.parent then return end
  if self.parent:PassivesDisabled() then return end
  if self.parent:HasModifier("strider_2_modifier_spin") then return end

  local mods = self.parent:FindAllModifiersByName("trickster_u_modifier_autocast")
  for _,mod in pairs(mods) do
    if mod.stolen_ability:GetAbilityName() == self.ability:GetAbilityName() then
      if mod.enabled == false then return end
    end
  end

  if RandomFloat(0, 100) < self.ability:GetSpecialValueFor("special_cast_chance") then
    self.ability.aggro = self.parent:GetAttackTarget()
    self.ability:OnSpellStart()
  end
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------