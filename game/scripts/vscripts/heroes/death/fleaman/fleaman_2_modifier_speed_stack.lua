fleaman_2_modifier_speed_stack = class({})

function fleaman_2_modifier_speed_stack:IsPurgable() return true end
function fleaman_2_modifier_speed_stack:IsHidden() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function fleaman_2_modifier_speed_stack:OnCreated(kv)
  self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

  self:ChangeMS()
end

function fleaman_2_modifier_speed_stack:OnRefresh(kv)
  self:ChangeMS()
end

function fleaman_2_modifier_speed_stack:OnRemoved()
end

function fleaman_2_modifier_speed_stack:OnDestroy()
end

-- API FUNCTIONS -----------------------------------------------------------

-- UTILS -----------------------------------------------------------

function fleaman_2_modifier_speed_stack:ChangeMS()
  local modifier = self.parent:FindModifierByName(self.ability:GetIntrinsicModifierName())
  local max_ms = self.ability:GetSpecialValueFor("max_ms")

  if modifier then
    local stack = modifier:GetStackCount() + self.ability:GetSpecialValueFor("ms_gain")
    if stack > max_ms then stack = max_ms end

    if IsServer() then
      modifier:SetStackCount(stack)
    end
  end
end

-- EFFECTS -----------------------------------------------------------