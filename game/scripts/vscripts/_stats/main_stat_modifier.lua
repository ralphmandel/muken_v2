main_stat_modifier = class({})

function main_stat_modifier:IsPurgable() return false end
function main_stat_modifier:IsHidden() return true end
function main_stat_modifier:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function main_stat_modifier:RemoveOnDeath() return false end

function main_stat_modifier:OnCreated(kv)
  if not IsServer() then return end

  self.kv = kv
  self:UpdateStatKV()
end

function main_stat_modifier:OnRemoved()
end

function main_stat_modifier:OnDestroy()
  if not IsServer() then return end

  self:UpdateStatKV()

  if self.endCallback then self.endCallback(self.interrupted) end
end

function main_stat_modifier:SetEndCallback(func)
	self.endCallback = func
end

function main_stat_modifier:UpdateStatKV()
  for _, main in pairs({"str", "agi", "int", "vit"}) do
    local modifier = self:GetParent():FindModifierByName("_modifier_"..main)
    if modifier then
      for property, value in pairs(self.kv) do
        if property == main then
          modifier:UpdateMainBonus()
        end
      end
    end
  end
end