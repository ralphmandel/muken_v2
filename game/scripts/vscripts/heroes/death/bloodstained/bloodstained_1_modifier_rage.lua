bloodstained_1_modifier_rage = class({})

function bloodstained_1_modifier_rage:IsHidden() return false end
function bloodstained_1_modifier_rage:IsPurgable() return true end

-- CONSTRUCTORS -----------------------------------------------------------

function bloodstained_1_modifier_rage:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()
  self.damage = self.ability:GetSpecialValueFor("special_damage_init")

	self.ability:EndCooldown()
	self.ability:SetActivated(false)

  AddStatusEfx(self.ability, "bloodstained_1_modifier_rage_status_efx", self.caster, self.parent)

  if IsServer() then self:SetStackCount(self.damage) end
end

function bloodstained_1_modifier_rage:OnRefresh(kv)
  self.damage = self.ability:GetSpecialValueFor("special_damage_init")
end

function bloodstained_1_modifier_rage:OnRemoved()
	if IsServer() then self.parent:StopSound("Bloodstained.rage") end

  RemoveStatusEfx(self.ability, "bloodstained_1_modifier_rage_status_efx", self.caster, self.parent)
	RemoveSubStats(self.parent, self.ability, {"attack_damage"})

	self.ability:StartCooldown(self.ability:GetEffectiveCooldown(self.ability:GetLevel()))
	self.ability:SetActivated(true)
end

-- API FUNCTIONS -----------------------------------------------------------

function bloodstained_1_modifier_rage:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
    MODIFIER_EVENT_ON_DEATH
	}

	return funcs
end

function bloodstained_1_modifier_rage:OnTakeDamage(keys)
	if keys.unit ~= self.parent then return end
  self:FilterDamage(keys.damage)
end

function bloodstained_1_modifier_rage:OnAttackLanded(keys)
  if keys.attacker ~= self.parent then return end
end

function bloodstained_1_modifier_rage:OnDeath(keys)
  if keys.attacker == nil then return end
	if keys.attacker:IsBaseNPC() == false then return end
  if keys.attacker ~= self.parent then return end
  if keys.unit:GetTeamNumber() == self.parent:GetTeamNumber() then return end
	if keys.unit:IsHero() == false then return end
	if keys.unit:IsIllusion() then return end
  
  if self.ability:GetSpecialValueFor("special_reset") == 1 then
    self:SetDuration(self:GetDuration(), true)
  end
end

function bloodstained_1_modifier_rage:OnStackCountChanged(old)
	RemoveSubStats(self.parent, self.ability, {"attack_damage"})
  AddSubStats(self.parent, self.ability, {attack_damage = self:GetStackCount()}, false)
end

-- UTILS -----------------------------------------------------------

function bloodstained_1_modifier_rage:FilterDamage(amount)
  self:CalcGain(amount * self.ability:GetSpecialValueFor("damage_gain") * 0.01)
end

function bloodstained_1_modifier_rage:CalcGain(gain)
	if IsServer() then
    self.damage = self.damage + gain
    self:SetStackCount(math.floor(self.damage))
  end
end

-- EFFECTS -----------------------------------------------------------

function bloodstained_1_modifier_rage:GetEffectName()
	return "particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_ignite_debuff.vpcf"
end

function bloodstained_1_modifier_rage:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function bloodstained_1_modifier_rage:GetStatusEffectName()
	return "particles/econ/items/lifestealer/lifestealer_immortal_backbone/status_effect_life_stealer_immortal_rage.vpcf"
end

function bloodstained_1_modifier_rage:StatusEffectPriority()
	return MODIFIER_PRIORITY_HIGH
end