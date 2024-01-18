orb_ice__max_status = class({})

function orb_ice__max_status:IsHidden() return false end
function orb_ice__max_status:IsPurgable() return false end
function orb_ice__max_status:GetTexture() return "status_freeze" end

-- CONSTRUCTORS -----------------------------------------------------------

function orb_ice__max_status:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  self.current_status = kv.amount
  self.max_status = kv.amount
  self.multiplier = kv.multiplier

  self.parent:UpdatePanel({
    current_status = self.current_status * self.multiplier,
    max_status = self.max_status * self.multiplier,
    status_name = "ice__status",
    max_state = 1
  })

  self:PlayEfxStart()
end

function orb_ice__max_status:OnRefresh(kv)
end

function orb_ice__max_status:OnRemoved()
  if not IsServer() then return end

  self.parent:RemovePanelFromList("ice__status")

  self:PlayEfxEnd()
end

-- API FUNCTIONS -----------------------------------------------------------

function orb_ice__max_status:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true,
		[MODIFIER_STATE_INVISIBLE] = false
	}

	return state
end

function orb_ice__max_status:DeclareFunctions()
	local funcs = {
    MODIFIER_PROPERTY_MIN_HEALTH,
    MODIFIER_EVENT_ON_TAKEDAMAGE
	}

	return funcs
end

function orb_ice__max_status:GetMinHealth(keys)
  return 1
end

function orb_ice__max_status:OnTakeDamage(keys)
  if not IsServer() then return end

  if keys.unit ~= self.parent then return end

  self.current_status = self.current_status - keys.damage
  if self.current_status <= 0 then self:Destroy() return end

  self.parent:UpdatePanel({
    current_status = self.current_status * self.multiplier,
    max_status = self.max_status * self.multiplier,
    status_name = "ice__status",
    max_state = 1
  })
end


-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function orb_ice__max_status:GetEffectName()
	return "particles/econ/items/winter_wyvern/winter_wyvern_ti7/wyvern_cold_embrace_ti7buff.vpcf"
end

function orb_ice__max_status:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function orb_ice__max_status:GetStatusEffectName()
	return "particles/econ/items/drow/drow_ti9_immortal/status_effect_drow_ti9_frost_arrow.vpcf"
end

function orb_ice__max_status:StatusEffectPriority()
	return MODIFIER_PRIORITY_ULTRA
end

function orb_ice__max_status:PlayEfxStart()
  AddStatusEfx(nil, "orb_ice__max_status_efx", nil, self.parent)

	self.parent:EmitSound("Hero_Ancient_Apparition.IceBlast.Tracker")
end

function orb_ice__max_status:PlayEfxEnd()
  RemoveStatusEfx(nil, "orb_ice__max_status_efx", nil, self.parent)

	local particle = "particles/units/heroes/hero_winter_wyvern/wyvern_arctic_burn_start.vpcf"
	local effect_cast = ParticleManager:CreateParticle(particle, PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(effect_cast, 0, self.parent:GetOrigin())

	local particle_2 = "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/cm_arcana_pup_flee.vpcf"
	local effect_cast_2 = ParticleManager:CreateParticle(particle_2, PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(effect_cast_2, 0, self.parent:GetOrigin())

	self.parent:EmitSound("Hero_Lich.IceSpire.Destroy")
end