sub_stat_movespeed_percent_increase = class({})

function sub_stat_movespeed_percent_increase:IsPurgable() return true end
function sub_stat_movespeed_percent_increase:IsHidden() return false end
function sub_stat_movespeed_percent_increase:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function sub_stat_movespeed_percent_increase:RemoveOnDeath() return false end
function sub_stat_movespeed_percent_increase:GetTexture() return "_modifier_percent_movespeed_buff" end

function sub_stat_movespeed_percent_increase:OnCreated(kv)
  self.value = kv.value

  UpdateMovespeed(self:GetParent(), self:GetName())

  if IsServer() then self:SetStackCount(self.value) end
end

function sub_stat_movespeed_percent_increase:OnRemoved()
end

function sub_stat_movespeed_percent_increase:OnDestroy()
  UpdateMovespeed(self:GetParent(), self:GetName())

  if self.endCallback then self.endCallback(self.interrupted) end
end

function sub_stat_movespeed_percent_increase:SetEndCallback(func)
	self.endCallback = func
end