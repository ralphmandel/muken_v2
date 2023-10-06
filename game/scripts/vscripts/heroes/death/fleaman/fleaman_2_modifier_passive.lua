fleaman_2_modifier_passive = class({})

function fleaman_2_modifier_passive:IsHidden() return false end
function fleaman_2_modifier_passive:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function fleaman_2_modifier_passive:OnCreated(kv)
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

  self.min_ms = self.ability:GetSpecialValueFor("min_ms")

	if IsServer() then self:SetStackCount(self.min_ms) end
end

function fleaman_2_modifier_passive:OnRefresh(kv)
  self.min_ms = self.ability:GetSpecialValueFor("min_ms")

  if IsServer() then
    if self:GetStackCount() < self.min_ms then
      self:SetStackCount(self.min_ms)
    end
  end
end

function fleaman_2_modifier_passive:OnRemoved()
end

-- API FUNCTIONS -----------------------------------------------------------

function fleaman_2_modifier_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end

function fleaman_2_modifier_passive:OnAttackLanded(keys)
	if keys.attacker ~= self.parent then return end
  if self.parent:PassivesDisabled() then return end
  
  AddModifier(self.parent, self.ability, "fleaman_2_modifier_speed_stack", {
    duration = self.ability:GetSpecialValueFor("duration")
  }, true)
end

function fleaman_2_modifier_passive:OnStackCountChanged(old)
  RemoveAllModifiersByNameAndAbility(self.parent, "sub_stat_movespeed_increase", self.ability)
  AddModifier(self.parent, self.ability, "sub_stat_movespeed_increase", {value = self:GetStackCount()}, false)
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------