sub_stat_modifier = class({})

function sub_stat_modifier:IsPurgable() return false end
function sub_stat_modifier:IsHidden() return true end
function sub_stat_modifier:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function sub_stat_modifier:RemoveOnDeath() return false end

function sub_stat_modifier:OnCreated(kv)
  self.kv = kv
  self.status_resist_stack = kv.status_resist_stack or 0

  UpdateStatKV(self:GetParent(), self.kv)
end

function sub_stat_modifier:OnRemoved()
end

function sub_stat_modifier:OnDestroy()
  UpdateStatKV(self:GetParent(), self.kv)
  if self.endCallback then self.endCallback(self.interrupted) end
end

function sub_stat_modifier:SetEndCallback(func)
	self.endCallback = func
end

function sub_stat_modifier:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
  }

  return funcs
end

function sub_stat_modifier:GetModifierStatusResistanceStacking()
  return self.status_resist_stack
end