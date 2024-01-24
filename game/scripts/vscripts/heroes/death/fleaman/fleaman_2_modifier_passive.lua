fleaman_2_modifier_passive = class({})

function fleaman_2_modifier_passive:IsHidden() return false end
function fleaman_2_modifier_passive:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function fleaman_2_modifier_passive:OnCreated(kv)
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

  if not IsServer() then return end

  self.origin = self.parent:GetOrigin()
  self.min_ms = self.ability:GetSpecialValueFor("min_ms")

  self:SetStackCount(self.min_ms)
  self:OnIntervalThink()
end

function fleaman_2_modifier_passive:OnRefresh(kv)
  if not IsServer() then return end

  self.min_ms = self.ability:GetSpecialValueFor("min_ms")

  if self.ability:GetSpecialValueFor("special_unslow") == 1 then
    self.parent:RemoveAllModifiersByNameAndAbility("_modifier_unslowable", self.ability)
    self.parent:AddModifier(self.ability, "_modifier_unslowable", {})
  end

  if self:GetStackCount() < self.min_ms then
    self:SetStackCount(self.min_ms)
  end
end

function fleaman_2_modifier_passive:OnRemoved()
end

-- API FUNCTIONS -----------------------------------------------------------

function fleaman_2_modifier_passive:CheckState()
	local state = {}

	if self:GetAbility():GetSpecialValueFor("special_phase") == 1 then
		table.insert(state, MODIFIER_STATE_NO_UNIT_COLLISION, true)
	end

	return state
end

function fleaman_2_modifier_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end

function fleaman_2_modifier_passive:OnAttackLanded(keys)
  if not IsServer() then return end

	if keys.attacker ~= self.parent then return end
  if self.parent:PassivesDisabled() then return end
  
  self.parent:AddModifier(self.ability, "fleaman_2_modifier_speed_stack", {
    duration = self.ability:GetSpecialValueFor("duration")
  })
end

function fleaman_2_modifier_passive:OnStackCountChanged(old)
  if not IsServer() then return end

  self.parent:RemoveAllModifiersByNameAndAbility("sub_stat_movespeed_increase", self.ability)
  self.parent:AddModifier(self.ability, "sub_stat_movespeed_increase", {value = self:GetStackCount()})
end

function fleaman_2_modifier_passive:OnIntervalThink()
  if not IsServer() then return end

	local distance = (self.origin - self.parent:GetOrigin()):Length2D()
	self.origin = self.parent:GetOrigin()

	if self.ability:GetSpecialValueFor("special_stun_duration") > 0
  and self.parent:PassivesDisabled() == false and distance > 0 then
    self.parent:AddModifier(self.ability, "fleaman_2_modifier_charge", {distance = distance})
	end

	self:StartIntervalThink(0.1)
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------