ancient_3_modifier_passive = class({})

function ancient_3_modifier_passive:IsHidden() return false end
function ancient_3_modifier_passive:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function ancient_3_modifier_passive:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  AddModifier(self.parent, self.ability, "sub_stat_modifier", {
    attack_time = self.ability:GetSpecialValueFor("attack_time")
  }, false)
end

function ancient_3_modifier_passive:OnRefresh(kv)
end

function ancient_3_modifier_passive:OnRemoved()
  RemoveSubStats(self.parent, self.ability, "attack_time")
end

-- API FUNCTIONS -----------------------------------------------------------

function ancient_3_modifier_passive:DeclareFunctions()
	local funcs = {
    MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE
	}

	return funcs
end

function ancient_3_modifier_passive:GetModifierBaseDamageOutgoing_Percentage(keys)
  return self:GetAbility():GetSpecialValueFor("damage_percent")
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------