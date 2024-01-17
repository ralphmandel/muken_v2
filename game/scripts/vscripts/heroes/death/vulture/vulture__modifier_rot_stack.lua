vulture__modifier_rot_stack = class({})

function vulture__modifier_rot_stack:IsHidden() return false end
function vulture__modifier_rot_stack:IsPurgable() return true end

-- CONSTRUCTORS -----------------------------------------------------------

function vulture__modifier_rot_stack:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if self.parent:HasModifier("vulture__modifier_rot") then self:Destroy() 
  else  
    local stack = CalcStatus(kv.stack, self.caster, self.parent)
    self.stack = math.floor(stack)
  
    if IsServer() then
      self:SetStackCount(self.stack)
      self:StartIntervalThink(0.5)
    end
  end

 
end

function vulture__modifier_rot_stack:OnRefresh(kv)
  local stack = CalcStatus(kv.stack, self.caster, self.parent)
  self.stack = self.stack + math.floor(stack)
  if IsServer() then
    self:SetStackCount(self.stack)
  end
end

function vulture__modifier_rot_stack:OnRemoved()
 
end

-- API FUNCTIONS -----------------------------------------------------------

function vulture__modifier_rot_stack:OnIntervalThink()
  self.stack = self.stack - 1
  if IsServer() then
    self:SetStackCount(self.stack)
  end
end

function vulture__modifier_rot_stack:OnStackCountChanged(iStackCount)
  if self:GetStackCount() >= 100 then
    --print(self.ability:GetSpecialValueFor("rot_duration"))
    AddModifier(self.parent, self.ability, "vulture__modifier_rot", {duration = self.ability:GetSpecialValueFor("rot_duration")}, true)
    self:Destroy()
  end
  if self:GetStackCount() <= 0 and iStackCount ~= self:GetStackCount() then
    self:Destroy()
  end
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function vulture__modifier_rot_stack:PlayEfxTick()
 
end
-- function vulture__modifier_rot_stack:GetEffectName()
-- 	return ""
-- end

-- function vulture__modifier_rot_stack:GetEffectAttachType()
-- 	return PATTACH_ABSORIGIN_FOLLOW
-- end