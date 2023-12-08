trickster_1_modifier_bonus_damage = class({})

function trickster_1_modifier_bonus_damage:IsHidden() return true end
function trickster_1_modifier_bonus_damage:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function trickster_1_modifier_bonus_damage:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()
end

function trickster_1_modifier_bonus_damage:OnRefresh(kv)
end

function trickster_1_modifier_bonus_damage:OnRemoved()
end

-- API FUNCTIONS -----------------------------------------------------------

function trickster_1_modifier_bonus_damage:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL
	}

	return funcs
end

function trickster_1_modifier_bonus_damage:GetModifierProcAttack_BonusDamage_Physical(keys)
  return self:GetAbility():GetSpecialValueFor("special_bonus_damage")
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------