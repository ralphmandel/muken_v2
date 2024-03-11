_modifier_barrier = class({})

--------------------------------------------------------------------------------

function _modifier_barrier:IsHidden()
	return false
end

function _modifier_barrier:IsPurgable()
	return false
end

function _modifier_barrier:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------

function _modifier_barrier:OnCreated( kv )
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

  if not IsServer() then return end

  self:SetHasCustomTransmitterData(true)

  self.max_physical_barrier = kv.max_physical_barrier or 0
  self.physical_barrier = kv.physical_barrier or 0
  self.max_magical_barrier = kv.max_magical_barrier or 0
  self.magical_barrier = kv.magical_barrier or 0
  self.max_universal_barrier = kv.max_universal_barrier or 0
  self.universal_barrier = kv.universal_barrier or 0

  if self.universal_barrier > 0 then self:PlayEfxUniversal() end
end

function _modifier_barrier:OnRefresh(kv)
end

function _modifier_barrier:OnRemoved()
  if not IsServer() then return end

  self.parent:RemoveStatusEfx(self.caster, self.ability, "_modifier_barrier_universal_efx")
end

function _modifier_barrier:OnDestroy(kv)
  if not IsServer() then return end

  if self.endCallback then self.endCallback(self.interrupted) end
end

function _modifier_barrier:SetEndCallback(func)
	self.endCallback = func
end

function _modifier_barrier:AddCustomTransmitterData()
  return {
    max_physical_barrier = self.max_physical_barrier,
    physical_barrier = self.physical_barrier,
    max_magical_barrier = self.max_magical_barrier,
    magical_barrier = self.magical_barrier,
    max_universal_barrier = self.max_universal_barrier,
    universal_barrier = self.universal_barrier,
  }
end

function _modifier_barrier:HandleCustomTransmitterData(data)
  self.max_physical_barrier = data.max_physical_barrier
  self.physical_barrier = data.physical_barrier
  self.max_magical_barrier = data.max_magical_barrier
  self.magical_barrier = data.magical_barrier
  self.max_universal_barrier = data.max_universal_barrier
  self.universal_barrier = data.universal_barrier
end

--------------------------------------------------------------------------------

function _modifier_barrier:DeclareFunctions()
	local funcs = {
    MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_CONSTANT,
    MODIFIER_PROPERTY_INCOMING_SPELL_DAMAGE_CONSTANT,
    MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT
	}
	
	return funcs
end

function _modifier_barrier:GetModifierIncomingPhysicalDamageConstant(keys)  
  if not IsServer() then
    if keys.report_max then
      return self.max_physical_barrier
    else
      return self.physical_barrier
    end
  end

  local damage = keys.damage

  self.physical_barrier = self.physical_barrier - damage
  if self.physical_barrier <= 0 then
    damage = damage + self.physical_barrier
    self.physical_barrier = 0
  end

  if self.physical_barrier <= 0
  and self.magical_barrier <= 0
  and self.universal_barrier <= 0 then
    self:Destroy()
  else
    self:SendBuffRefreshToClients()
  end

  return -damage
end

function _modifier_barrier:GetModifierIncomingSpellDamageConstant(keys)  
  if not IsServer() then
    if keys.report_max then
      return self.max_magical_barrier
    else
      return self.magical_barrier
    end
  end

  local damage = keys.damage

  self.magical_barrier = self.magical_barrier - damage
  if self.magical_barrier <= 0 then
    damage = damage + self.magical_barrier
    self.magical_barrier = 0
  end

  if self.physical_barrier <= 0
  and self.magical_barrier <= 0
  and self.universal_barrier <= 0 then
    self:Destroy()
  else
    self:SendBuffRefreshToClients()
  end

  return -damage
end

function _modifier_barrier:GetModifierIncomingDamageConstant(keys)  
  if not IsServer() then
    if keys.report_max then
      return self.max_universal_barrier
    else
      return self.universal_barrier
    end
  end

  local damage = keys.damage

  self.universal_barrier = self.universal_barrier - damage
  if self.universal_barrier <= 0 then
    damage = damage + self.universal_barrier
    self.universal_barrier = 0
  end

  if self.universal_barrier <= 0 then
    self:StopEfxUniversal()
  end

  if self.physical_barrier <= 0
  and self.magical_barrier <= 0
  and self.universal_barrier <= 0 then
    self:Destroy()
  else
    self:SendBuffRefreshToClients()
  end

  return -damage
end

--------------------------------------------------------------------------------

function _modifier_barrier:PlayEfxUniversal()
	local particle_cast = "particles/status_fx/status_effect_shield_rune.vpcf"
	self.universal_efx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent)
	self:AddParticle(self.universal_efx, false, true, MODIFIER_PRIORITY_ULTRA, false, false)
	self.parent:AddStatusEfx(self.caster, self.ability, "_modifier_barrier_universal_efx")
end

function _modifier_barrier:StopEfxUniversal()
	if self.universal_efx then ParticleManager:DestroyParticle(self.universal_efx, false) end
  self.parent:RemoveStatusEfx(self.caster, self.ability, "_modifier_barrier_universal_efx")
end