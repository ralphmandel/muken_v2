status_bar_cold_max = class({})

function status_bar_cold_max:IsHidden() return false end
function status_bar_cold_max:IsPurgable() return false end
function status_bar_cold_max:GetTexture() return "status_freeze" end

-- CONSTRUCTORS -----------------------------------------------------------

function status_bar_cold_max:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  self.current_status = 1
  self.max_status = kv.amount
  self.multiplier = kv.multiplier
  self.status_name = string.sub(self:GetName(), 1, -5)

  self.parent:UpdatePanel({
    current_status = self.current_status * self.multiplier,
    max_status = self.max_status * self.multiplier,
    status_name = self.status_name,
    max_state = 1
  })

  self:PlayEfxStart()
end

function status_bar_cold_max:OnRefresh(kv)
end

function status_bar_cold_max:OnRemoved()
  if not IsServer() then return end

  local damage_result = ApplyDamage({
    attacker = self.caster, victim = self.parent, ability = nil,
    damage = self.current_status, damage_type = DAMAGE_TYPE_PURE,
    damage_flags = DOTA_DAMAGE_FLAG_DONT_DISPLAY_DAMAGE_IF_SOURCE_HIDDEN + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
  })

  self:PlayEfxEnd(damage_result)

  local status_modifier = self.parent:FindModifierByName("status_bar_cold")

  if status_modifier then
    status_modifier.bCompleted = nil
    status_modifier:OnIntervalThink()
  else
    self.parent:RemovePanelFromList(self.status_name)
  end
end

-- API FUNCTIONS -----------------------------------------------------------

function status_bar_cold_max:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true,
		[MODIFIER_STATE_INVISIBLE] = false
	}

	return state
end

function status_bar_cold_max:DeclareFunctions()
	local funcs = {
    MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT
	}

	return funcs
end

function status_bar_cold_max:GetModifierIncomingDamageConstant(keys)
  if not IsServer() then return 0 end

  local damage = keys.damage

  self.current_status = self.current_status + keys.damage

  if self.current_status >= self.max_status then
    damage = damage + self.max_status - self.current_status
    self.current_status = self.max_status
    self:Destroy()
  else
    self.parent:UpdatePanel({
      current_status = self.current_status * self.multiplier,
      max_status = self.max_status * self.multiplier,
      status_name = self.status_name,
      max_state = 1
    })
  end

  return -damage
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function status_bar_cold_max:GetEffectName()
	return "particles/econ/items/winter_wyvern/winter_wyvern_ti7/wyvern_cold_embrace_ti7buff.vpcf"
end

function status_bar_cold_max:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function status_bar_cold_max:GetStatusEffectName()
	return "particles/econ/items/drow/drow_ti9_immortal/status_effect_drow_ti9_frost_arrow.vpcf"
end

function status_bar_cold_max:StatusEffectPriority()
	return MODIFIER_PRIORITY_ULTRA
end

function status_bar_cold_max:PlayEfxStart()
  self.parent:AddStatusEfx(self.caster, self.ability, "status_bar_cold_max_efx")
	self.parent:EmitSound("Hero_Ancient_Apparition.IceBlast.Tracker")
end

function status_bar_cold_max:PlayEfxEnd(damage_result)
  if self.parent == nil then return end
  if IsValidEntity(self.parent) == false then return end

  self:PopupColdDamage(damage_result, self.parent)
  self.parent:RemoveStatusEfx(nil, nil, "status_bar_cold_max_efx")

	local particle = "particles/units/heroes/hero_winter_wyvern/wyvern_arctic_burn_start.vpcf"
	local effect_cast = ParticleManager:CreateParticle(particle, PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(effect_cast, 0, self.parent:GetOrigin())

	local particle_2 = "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/cm_arcana_pup_flee.vpcf"
	local effect_cast_2 = ParticleManager:CreateParticle(particle_2, PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(effect_cast_2, 0, self.parent:GetOrigin())

	self.parent:EmitSound("Hero_Lich.IceSpire.Destroy")
end