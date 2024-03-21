item_epic_fury_plate_mod_passive = class({})

function item_epic_fury_plate_mod_passive:IsHidden() return false end
function item_epic_fury_plate_mod_passive:IsPurgable() return false end
function item_epic_fury_plate_mod_passive:GetTexture() return "armor/fury_plate" end

-- CONSTRUCTORS -----------------------------------------------------------

function item_epic_fury_plate_mod_passive:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  self.parent:AddAbilityStats(self.ability, {"str"})
  self.parent:AddAbilityStats(self.ability, {"armor", "max_health"})

  self.decrement_time = self.ability:GetSpecialValueFor("decrement_time")

  self:SetStackCount(0)
end

function item_epic_fury_plate_mod_passive:OnRefresh(kv)
end

function item_epic_fury_plate_mod_passive:OnRemoved()
  if not IsServer() then return end

  self.parent:RemoveMainStats(self.ability, {"str"})
  self.parent:RemoveSubStats(self.ability, {"armor", "max_health"})
end

-- API FUNCTIONS -----------------------------------------------------------

function item_epic_fury_plate_mod_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end

function item_epic_fury_plate_mod_passive:OnAttackLanded(keys)
  if not IsServer() then return end

  if keys.attacker ~= self.parent then return end
  if keys.target:GetTeamNumber() == self.parent:GetTeamNumber() then return end
  if self.parent:IsMuted() then return end
  if self.ability:IsCooldownReady() == false then return end
  if self:GetStackCount() >= self.ability:GetSpecialValueFor("max_stack") then return end

  local refresh = self.ability:GetEffectiveCooldown(self.ability:GetLevel())

  self.ability:StartCooldown(refresh)
  self:IncrementStackCount()
  self:StartIntervalThink(refresh + self.decrement_time)
end

function item_epic_fury_plate_mod_passive:OnIntervalThink()
  if not IsServer() then return end

  if self:GetStackCount() == 0 then self:StartIntervalThink(-1) return end

  self:DecrementStackCount()
  self:StartIntervalThink(self.decrement_time)
end

function item_epic_fury_plate_mod_passive:OnStackCountChanged(old)
  if not IsServer() then return end

  self.parent:RemoveMainStats(self.ability, {"str"})
  self.parent:AddMainStats(self.ability, {str = self.ability:GetSpecialValueFor("str") + self:GetStackCount()})
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------