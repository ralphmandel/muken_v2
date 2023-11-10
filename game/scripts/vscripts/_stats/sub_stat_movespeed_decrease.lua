sub_stat_movespeed_decrease = class({})

function sub_stat_movespeed_decrease:IsPurgable() return true end
function sub_stat_movespeed_decrease:IsHidden() return false end
function sub_stat_movespeed_decrease:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function sub_stat_movespeed_decrease:RemoveOnDeath() return false end
function sub_stat_movespeed_decrease:GetTexture() return "_modifier_movespeed_debuff" end

function sub_stat_movespeed_decrease:OnCreated(kv)
  self.value = kv.value

  UpdateMovespeed(self:GetParent(), self:GetName())

  if IsServer() then self:SetStackCount(self.value) end
end

function sub_stat_movespeed_decrease:OnRemoved()
end

function sub_stat_movespeed_decrease:OnDestroy()
  UpdateMovespeed(self:GetParent(), self:GetName())

  if self.endCallback then self.endCallback(self.interrupted) end
end

function sub_stat_movespeed_decrease:SetEndCallback(func)
	self.endCallback = func
end