mk_gorillaz_buff = class({})

function mk_gorillaz_buff:IsHidden()
	return false
end

function mk_gorillaz_buff:IsPurgable()
	return true
end

--------------------------------------------------------------------------------

function mk_gorillaz_buff:OnCreated(kv)
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.bonus_damage = 0

	AddBonus(self.ability, "AGI", self.parent, 20, 0, nil)
  AddModifier(self.parent, self.ability, "_modifier_movespeed_buff", {percent = 100}, false)

  if IsServer() then
    self.parent:EmitSound("Hero_LoneDruid.BattleCry.Bear")
    self:SetStackCount(self.bonus_damage)
  end
end

function mk_gorillaz_buff:OnRefresh(kv)
end

function mk_gorillaz_buff:OnRemoved()
	RemoveBonus(self.ability, "AGI", self.parent)
  RemoveAllModifiersByNameAndAbility(self.parent, "_modifier_movespeed_buff", self.ability)
end

--------------------------------------------------------------------------------

function mk_gorillaz_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_DEATH
	}

	return funcs
end

function mk_gorillaz_buff:GetModifierProcAttack_BonusDamage_Physical(keys)
	return self:GetStackCount()
end

function mk_gorillaz_buff:OnAttackLanded(keys)
	if keys.attacker ~= self.parent then return end
	self.bonus_damage = self.bonus_damage + 10

  if IsServer() then self:SetStackCount(self.bonus_damage) end
end

--------------------------------------------------------------------------------

function mk_gorillaz_buff:GetEffectName()
	return "particles/econ/items/alchemist/alchemist_aurelian_weapon/alchemist_chemical_rage_aurelian.vpcf"
end

function mk_gorillaz_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function mk_gorillaz_buff:GetStatusEffectName()
	return "particles/status_fx/status_effect_life_stealer_rage.vpcf"
end

function mk_gorillaz_buff:StatusEffectPriority()
	return MODIFIER_PRIORITY_HIGH
end