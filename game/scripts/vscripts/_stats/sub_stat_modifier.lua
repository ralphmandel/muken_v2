sub_stat_modifier = class({})

function sub_stat_modifier:IsPurgable() return false end
function sub_stat_modifier:IsHidden() return true end
function sub_stat_modifier:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function sub_stat_modifier:RemoveOnDeath() return false end

function sub_stat_modifier:OnCreated(kv)
  if not IsServer() then return end

  self:SetHasCustomTransmitterData(true)

  self.kv = kv
  self.status_resist_stack = kv.status_resist_stack or 0
  self:UpdateStatKV()
end

function sub_stat_modifier:OnRefresh(kv)
  if not IsServer() then return end

  self.kv = kv
  self.status_resist_stack = kv.status_resist_stack or 0
  self.stat_mod:SendBuffRefreshToClients()
  self:UpdateStatKV()

  if kv.duration then self.stat_mod:SetDuration(kv.duration, true) end
end

function sub_stat_modifier:OnRemoved()
end

function sub_stat_modifier:OnDestroy()
  if not IsServer() then return end

  self:UpdateStatKV()

  if self.endCallback then self.endCallback(self.interrupted) end
end

function sub_stat_modifier:SetEndCallback(func)
	self.endCallback = func
end

function sub_stat_modifier:AddCustomTransmitterData()
  return {kv = self.kv}
end

function sub_stat_modifier:HandleCustomTransmitterData(data)
	self.kv = data.kv
end

--------------------------------------------------------------------------------

function sub_stat_modifier:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
  }

  return funcs
end

function sub_stat_modifier:GetModifierStatusResistanceStacking()
  if IsServer() then
    return self.status_resist_stack
  end
end

--------------------------------------------------------------------------------

function sub_stat_modifier:UpdateStatKV()
  for _, main in pairs({"str", "agi", "int", "vit"}) do
    local modifier = self:GetParent():FindModifierByName("_modifier_"..main)
    if modifier then
      for property, value in pairs(self.kv) do
        if modifier.data["sub_stat_"..property] then
          modifier:UpdateSubBonus(property)
        end
      end
    end
  end
end