ancient_1_modifier_refresh = class({})

function ancient_1_modifier_refresh:IsHidden() return false end
function ancient_1_modifier_refresh:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function ancient_1_modifier_refresh:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if IsServer() then self:SetStackCount(kv.stack) end
end

function ancient_1_modifier_refresh:OnRefresh(kv)
end

function ancient_1_modifier_refresh:OnRemoved()
  -- if self:GetStackCount() > 1 then
  --   AddModifier(self.parent, self.ability, self:GetName(), {
  --     duration = self:GetDuration(),
  --     stack = self:GetStackCount() - 1
  --   }, false)
  -- end
end

-- API FUNCTIONS -----------------------------------------------------------

function ancient_1_modifier_refresh:OnStackCountChanged(old)
  if self:GetStackCount() ~= old then
    if self:GetStackCount() > 0 then
      --if IsServer() then self:SetDuration(self:GetDuration(), true) end
    else
      self:Destroy()
    end
  end  
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------