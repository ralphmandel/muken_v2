strider_3_modifier_smoke = class({})

function strider_3_modifier_smoke:IsHidden() return true end
function strider_3_modifier_smoke:IsPurgable() return false end

-- AURA -----------------------------------------------------------

function strider_3_modifier_smoke:IsAura() return true end
function strider_3_modifier_smoke:GetAuraDuration() return 0 end
function strider_3_modifier_smoke:GetModifierAura() return "strider_3_modifier_aura_effect" end
function strider_3_modifier_smoke:GetAuraRadius() return self.radius end
function strider_3_modifier_smoke:GetAuraSearchTeam() return self:GetAbility():GetAbilityTargetTeam() end
function strider_3_modifier_smoke:GetAuraSearchType() return self:GetAbility():GetAbilityTargetType() end
function strider_3_modifier_smoke:GetAuraSearchFlags() return self:GetAbility():GetAbilityTargetFlags() end
function strider_3_modifier_smoke:GetAuraEntityReject(hEntity) return false end

-- CONSTRUCTORS -----------------------------------------------------------

function strider_3_modifier_smoke:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  self.radius = self.ability:GetAOERadius()

	if IsServer() then self:PlayEfxStart(self.radius) end
end

function strider_3_modifier_smoke:OnRefresh(kv)
end

function strider_3_modifier_smoke:OnRemoved()
	if IsServer() then self.parent:StopSound( "Hero_Wisp.Spirits.Muerta.Layer") end
end

-- API FUNCTIONS -----------------------------------------------------------

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function strider_3_modifier_smoke:PlayEfxStart()
	local string_2 = "particles/strider/smoke/strider_smoke.vpcf"
	local particle_2 = ParticleManager:CreateParticle(string_2, PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(particle_2, 0, self.parent:GetOrigin())
	ParticleManager:SetParticleControl(particle_2, 1, Vector(self.radius, self.radius, self.radius))
	ParticleManager:SetParticleControl(particle_2, 2, Vector(self:GetDuration(), 0, 0))
	self:AddParticle(particle_2, false, false, -1, false, false)

	if IsServer() then self.parent:EmitSound("Hero_Wisp.Spirits.Muerta.Layer") end
end