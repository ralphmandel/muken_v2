sub_stat_movespeed_percent_decrease = class({})

function sub_stat_movespeed_percent_decrease:IsPurgable() return true end
function sub_stat_movespeed_percent_decrease:IsHidden() return false end
function sub_stat_movespeed_percent_decrease:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function sub_stat_movespeed_percent_decrease:RemoveOnDeath() return false end
function sub_stat_movespeed_percent_decrease:GetTexture() return "_modifier_percent_movespeed_debuff" end

function sub_stat_movespeed_percent_decrease:OnCreated(kv)
  self.value = kv.value

  UpdateMovespeed(self:GetParent(), self:GetName())

  if IsServer() then self:SetStackCount(self.value) end
end

function sub_stat_movespeed_percent_decrease:OnRemoved()
end

function sub_stat_movespeed_percent_decrease:OnDestroy()
  UpdateMovespeed(self:GetParent(), self:GetName())

  if self.endCallback then self.endCallback(self.interrupted) end
end

function sub_stat_movespeed_percent_decrease:SetEndCallback(func)
	self.endCallback = func
end