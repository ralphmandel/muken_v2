neutral_iron_guard_modifier_resistance = class({})

function neutral_iron_guard_modifier_resistance:IsHidden() return true end
function neutral_iron_guard_modifier_resistance:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function neutral_iron_guard_modifier_resistance:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()
  self.hp_percent = 0

  if not IsServer() then return end

  self:UpdateResistance()
  self:StartIntervalThink(0.5)
end

function neutral_iron_guard_modifier_resistance:OnRefresh(kv)
  if not IsServer() then return end

  self:UpdateResistance()
  self:StartIntervalThink(0.5)
end

function neutral_iron_guard_modifier_resistance:OnRemoved()
  if not IsServer() then return end
  
  self.parent:RemoveSubStats(self.ability, {"status_resist_stack"})
end

-- API FUNCTIONS -----------------------------------------------------------

function neutral_iron_guard_modifier_resistance:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}

	return funcs
end

function neutral_iron_guard_modifier_resistance:OnIntervalThink()
  if not IsServer() then return end
  
  local hp_percent = math.floor(self.parent:GetHealthPercent() / 5)
  if self.hp_percent ~= hp_percent then self:UpdateResistance() end
end

-- UTILS -----------------------------------------------------------

function neutral_iron_guard_modifier_resistance:UpdateResistance()
  if self.parent:GetHealthPercent() == 100 then self:Destroy() return end

  self.hp_percent = math.floor(self.parent:GetHealthPercent() / 5)
  self.parent:RemoveSubStats(self.ability, {"status_resist_stack"})
  self.parent:AddSubStats(self.ability, {status_resist_stack = 100 - (self.hp_percent * 5)})
end

-- EFFECTS -----------------------------------------------------------