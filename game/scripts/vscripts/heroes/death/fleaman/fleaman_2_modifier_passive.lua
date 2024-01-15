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
    RemoveAllModifiersByNameAndAbility(self.parent, "_modifier_unslowable", self.ability)
    AddModifier(self.parent, self.ability, "_modifier_unslowable", {}, false)
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
  
  AddModifier(self.parent, self.ability, "fleaman_2_modifier_speed_stack", {
    duration = self.ability:GetSpecialValueFor("duration")
  }, true)
end

function fleaman_2_modifier_passive:OnStackCountChanged(old)
  if not IsServer() then return end

  RemoveAllModifiersByNameAndAbility(self.parent, "sub_stat_movespeed_increase", self.ability)
  AddModifier(self.parent, self.ability, "sub_stat_movespeed_increase", {value = self:GetStackCount()}, false)
end

function fleaman_2_modifier_passive:OnIntervalThink()
  if not IsServer() then return end

	local distance = (self.origin - self.parent:GetOrigin()):Length2D()
	self.origin = self.parent:GetOrigin()

	if self.ability:GetSpecialValueFor("special_stun_duration") > 0
  and self.parent:PassivesDisabled() == false and distance > 0 then
    AddModifier(self.parent, self.ability, "fleaman_2_modifier_charge", {distance = distance}, false)
	end

	self:StartIntervalThink(0.1)
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------