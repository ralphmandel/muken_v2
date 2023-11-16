lawbreaker_2_modifier_delay_reload = class({})

function lawbreaker_2_modifier_delay_reload:IsHidden() return true end
function lawbreaker_2_modifier_delay_reload:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function lawbreaker_2_modifier_delay_reload:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()
  
  if IsServer() then
    self:StartIntervalThink(self.ability:GetSpecialValueFor("fast_reload_delay"))
  end
end

function lawbreaker_2_modifier_delay_reload:OnRefresh(kv)
end

function lawbreaker_2_modifier_delay_reload:OnRemoved()
end

-- API FUNCTIONS -----------------------------------------------------------

function lawbreaker_2_modifier_delay_reload:DeclareFunctions()
	local funcs = {
    MODIFIER_EVENT_ON_STATE_CHANGED,
    MODIFIER_EVENT_ON_UNIT_MOVED,
		MODIFIER_EVENT_ON_ATTACK_START
	}

	return funcs
end

function lawbreaker_2_modifier_delay_reload:OnStateChanged(keys)
	if keys.unit ~= self.parent then return end
	if self.parent:IsStunned() or self.parent:IsHexed() or self.parent:IsFrozen() then
		self:Destroy()
	end
end

function lawbreaker_2_modifier_delay_reload:OnUnitMoved(keys)
  if keys.unit == self.parent then self:Destroy() end
end 

function lawbreaker_2_modifier_delay_reload:OnAttackStart(keys)
  if keys.attacker == self.parent then self:Destroy() end
end

-- UTILS -----------------------------------------------------------

function lawbreaker_2_modifier_delay_reload:OnIntervalThink()
  if self.ability:GetCurrentAbilityCharges() < self.ability:GetMaxAbilityCharges(self.ability:GetLevel()) then
    AddModifier(self.parent, self.ability, "lawbreaker_2_modifier_reload", {}, false)
  end

  self:Destroy()
end

-- EFFECTS -----------------------------------------------------------