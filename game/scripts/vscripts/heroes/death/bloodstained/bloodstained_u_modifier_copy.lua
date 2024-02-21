bloodstained_u_modifier_copy = class({})

function bloodstained_u_modifier_copy:IsHidden() return false end
function bloodstained_u_modifier_copy:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function bloodstained_u_modifier_copy:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  self:SetHasCustomTransmitterData(true)

  self.target = EntIndexToHScript(kv.target)

  self.stat_mod = self.target:AddSubStats(self.ability, {max_health = 0})
  self.parent:AddSubStats(self.ability, {speed_percent = 100})
  self.parent:AddStatusEfx(self.caster, self.ability, "bloodstained_u_modifier_copy_status_efx")

  self.max_barrier = kv.hp_stolen
  self.barrier = kv.hp_stolen

  self:OnIntervalThink()
end

function bloodstained_u_modifier_copy:OnRefresh(kv)
end

function bloodstained_u_modifier_copy:OnRemoved()
  if not IsServer() then return end

  self.parent:RemoveStatusEfx(self.caster, self.ability, "bloodstained_u_modifier_copy_status_efx")

  if self.parent:IsAlive() or self.barrier > 0 then
    local steal_duration = self.ability:GetSpecialValueFor("steal_duration")
    self.caster:AddSubStats(self.ability, {max_health = self.barrier, duration = steal_duration})
    self.stat_mod:OnRefresh({max_health = -self.barrier, duration = steal_duration})
  else
    self.stat_mod:Destroy()
  end

  self.target:SetBloodIllusion(nil)
end

function bloodstained_u_modifier_copy:AddCustomTransmitterData()
  return {
    max_barrier = self.max_barrier,
    barrier = self.barrier,
  }
end

function bloodstained_u_modifier_copy:HandleCustomTransmitterData(data)
  self.max_barrier = data.max_barrier
  self.barrier = data.barrier
end

-- API FUNCTIONS -----------------------------------------------------------

function bloodstained_u_modifier_copy:CheckState()
	local state = {
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true
	}

	return state
end

function bloodstained_u_modifier_copy:DeclareFunctions()
	local funcs = {
    MODIFIER_PROPERTY_MIN_HEALTH,
    MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_CONSTANT,
    MODIFIER_EVENT_ON_DEATH,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end

function bloodstained_u_modifier_copy:GetMinHealth(keys)
	return self:GetParent():GetMaxHealth()
end

function bloodstained_u_modifier_copy:GetModifierIncomingPhysicalDamageConstant(keys)  
  if not IsServer() then
    if keys.report_max then
      return self.max_barrier
    else
      return self.barrier
    end
  end

  if keys.damage_category ~= DOTA_DAMAGE_CATEGORY_ATTACK then return 0 end

  self.barrier = self.barrier - keys.damage
  if self.barrier <= 0 then self.parent:ForceKill(false) end

  self:SendBuffRefreshToClients()

  return -keys.damage
end

function bloodstained_u_modifier_copy:OnDeath(keys)
  if keys.unit == self.caster then
    self.barrier = 0
    self.parent:ForceKill(false)
  end
end

function bloodstained_u_modifier_copy:OnAttackLanded(keys)
  if not IsServer() then return end

	if keys.attacker ~= self.parent then return end

  self.max_barrier = self.max_barrier + keys.damage
  self.barrier = self.barrier + keys.damage
  self:SendBuffRefreshToClients()
end

function bloodstained_u_modifier_copy:OnIntervalThink()
  if not IsServer() then return end

  AddFOWViewer(self.target:GetTeamNumber(), self.parent:GetOrigin(), 100, 0.3, false)
  self:StartIntervalThink(0.2)
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function bloodstained_u_modifier_copy:GetStatusEffectName()
	return "particles/bloodstained/bloodstained_u_illusion_status.vpcf"
end

function bloodstained_u_modifier_copy:StatusEffectPriority()
	return 99999999
end

function bloodstained_u_modifier_copy:GetEffectName()
	return "particles/units/heroes/hero_bloodseeker/bloodseeker_rupture.vpcf"
end