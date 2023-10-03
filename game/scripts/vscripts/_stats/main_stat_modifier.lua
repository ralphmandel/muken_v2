main_stat_modifier = class({})

function main_stat_modifier:IsPurgable() return false end
function main_stat_modifier:IsHidden() return true end
function main_stat_modifier:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function main_stat_modifier:RemoveOnDeath() return false end

function main_stat_modifier:OnCreated(kv)
  self.kv = kv

  for k, v in pairs(self.kv) do
    UpdatePanoramaStat(self:GetParent(), k)
  end
end

function main_stat_modifier:OnRemoved()
end

function main_stat_modifier:OnDestroy()
  for k, v in pairs(self.kv) do
    UpdatePanoramaStat(self:GetParent(), k)
  end

  if self.endCallback then self.endCallback(self.interrupted) end
end

function main_stat_modifier:SetEndCallback(func)
	self.endCallback = func
end