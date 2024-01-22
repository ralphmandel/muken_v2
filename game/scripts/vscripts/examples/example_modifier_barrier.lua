example_modifier_barrier = class({})

function example_modifier_barrier:IsHidden() return false end
function example_modifier_barrier:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function example_modifier_barrier:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  self:SetHasCustomTransmitterData(true)

  self.max_barrier = 1000
  self.barrier = kv.gain

  self:StartIntervalThink(10)
end

function example_modifier_barrier:OnRefresh(kv)
  if not IsServer() then return end

  self.max_barrier = 1000
  self.barrier = self.barrier + kv.gain
  if self.barrier > self.max_barrier then self.barrier = self.max_barrier end

  self:SendBuffRefreshToClients()
  self:StartIntervalThink(10)
end

function example_modifier_barrier:OnRemoved()
end

function example_modifier_barrier:AddCustomTransmitterData()
  return {
    max_barrier = self.max_barrier,
    barrier = self.barrier,
  }
end

function example_modifier_barrier:HandleCustomTransmitterData(data)
  self.max_barrier = data.max_barrier
  self.barrier = data.barrier  
end

-- API FUNCTIONS -----------------------------------------------------------

function example_modifier_barrier:DeclareFunctions()
	local funcs = {
    MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT
	}

	return funcs
end

function example_modifier_barrier:GetModifierIncomingDamageConstant(keys)  
  if not IsServer() then
    if keys.report_max then
      return self.max_barrier
    else
      return self.barrier
    end
  end

  if self.parent:GetHealthPercent() > 50 then return 0 end

  local damage = keys.damage
  self.barrier = self.barrier - damage

  if self.barrier < 0 then damage = damage - self.barrier end
  if self.barrier <= 0 then
    self:Destroy()
  else
    self:SendBuffRefreshToClients()
    self:StartIntervalThink(10)
  end

  return -damage
end

function example_modifier_barrier:OnIntervalThink()
  if not IsServer() then return end

  self.barrier = self.barrier - (self.max_barrier * 0.001)

  if self.barrier <= 0 then
    self:Destroy()
  else
    self:SendBuffRefreshToClients()
    self:StartIntervalThink(0.1)
  end
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------