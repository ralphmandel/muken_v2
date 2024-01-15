fleaman_1_modifier_precision = class({})
local tempTable = require("libraries/tempTable")

function fleaman_1_modifier_precision:IsHidden() return false end
function fleaman_1_modifier_precision:IsPurgable() return true end

-- CONSTRUCTORS -----------------------------------------------------------

function fleaman_1_modifier_precision:OnCreated(kv)
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

  if not IsServer() then return end

  AddStatusEfx(self.ability, "fleaman_1_modifier_precision_status_efx", self.caster, self.parent)
  
  self:SetStackCount(0)
  self:AddMultStack()
end

function fleaman_1_modifier_precision:OnRefresh(kv)
  if not IsServer() then return end

	self:AddMultStack()
end

function fleaman_1_modifier_precision:OnRemoved()
  if not IsServer() then return end

  RemoveStatusEfx(self.ability, "fleaman_1_modifier_precision_status_efx", self.caster, self.parent)
  RemoveSubStats(self.parent, self.ability, {"attack_speed"})
end

-- API FUNCTIONS -----------------------------------------------------------

function fleaman_1_modifier_precision:OnStackCountChanged(old)
	if old == self:GetStackCount() then return end
	if self:GetStackCount() == 0 then self:Destroy() return end

  if IsServer() then
    RemoveSubStats(self.parent, self.ability, {"attack_speed", "evasion"})
    AddSubStats(self.parent, self.ability, {
      attack_speed = self:GetStackCount() * self.ability:GetSpecialValueFor("attack_speed"),
      evasion = self:GetStackCount() * self.ability:GetSpecialValueFor("evasion")
    }, false)
  end
end

-- UTILS -----------------------------------------------------------

function fleaman_1_modifier_precision:AddMultStack()
  local duration = self.ability:GetSpecialValueFor("duration")
  self:SetDuration(duration, true)
  self:IncrementStackCount()
  self.parent:EmitSound("Fleaman.Precision")
  
  AddModifier(self.parent, self.ability, "fleaman_1_modifier_precision_stack", {
    duration = duration, modifier = tempTable:AddATValue(self)
  }, false)
end

-- EFFECTS -----------------------------------------------------------

function fleaman_1_modifier_precision:GetStatusEffectName()
  return "particles/status_fx/status_effect_slark_shadow_dance.vpcf"
end

function fleaman_1_modifier_precision:StatusEffectPriority()
	return MODIFIER_PRIORITY_HIGH
end