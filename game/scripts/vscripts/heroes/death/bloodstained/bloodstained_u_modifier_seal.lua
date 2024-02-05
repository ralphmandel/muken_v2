bloodstained_u_modifier_seal = class({})

function bloodstained_u_modifier_seal:IsHidden() return true end
function bloodstained_u_modifier_seal:IsPurgable() return false end

-- AURA -----------------------------------------------------------

function bloodstained_u_modifier_seal:IsAura() return true end
function bloodstained_u_modifier_seal:GetAuraDuration() return 0.1 end
function bloodstained_u_modifier_seal:GetModifierAura() return "bloodstained_u_modifier_aura_effect" end
function bloodstained_u_modifier_seal:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("radius") end
function bloodstained_u_modifier_seal:GetAuraSearchTeam() return self:GetAbility():GetAbilityTargetTeam() end
function bloodstained_u_modifier_seal:GetAuraSearchType() return self:GetAbility():GetAbilityTargetType() end
function bloodstained_u_modifier_seal:GetAuraSearchFlags() return self:GetAbility():GetAbilityTargetFlags() end
function bloodstained_u_modifier_seal:GetAuraDuration() return 0 end

-- CONSTRUCTORS -----------------------------------------------------------

function bloodstained_u_modifier_seal:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

	self.ability:SetActivated(false)

	self:PlayEfxStart()
end

function bloodstained_u_modifier_seal:OnRefresh(kv)
end

function bloodstained_u_modifier_seal:OnRemoved()
  if not IsServer() then return end

	self.parent:StopSound("bloodstained.seal")
	self.ability:SetActivated(true)
end

-- API FUNCTIONS -----------------------------------------------------------

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function bloodstained_u_modifier_seal:PlayEfxStart()
  local radius = self.ability:GetSpecialValueFor("radius")
	local point = self.parent:GetAbsOrigin()
	point.z = point.z - 2

	local particle_cast = "particles/bloodstained/bloodstained_u_base.vpcf"
  local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(effect_cast, 0, self.parent:GetAbsOrigin())
	ParticleManager:SetParticleControl(effect_cast, 1, Vector(radius, radius, radius))
  ParticleManager:SetParticleControl(effect_cast, 2, Vector(self:GetDuration(), 0, 0))
	self:AddParticle(effect_cast, false, false, -1, false, true)

  self.parent:EmitSound("hero_bloodseeker.bloodRite")
  self.parent:EmitSound("hero_bloodseeker.rupture.cast")
  self.parent:EmitSound("bloodstained.seal")

  for i = DOTA_TEAM_CUSTOM_1, DOTA_TEAM_CUSTOM_4, 1 do
    AddFOWViewer(i, self.parent:GetOrigin(), 25, self:GetDuration(), false)
  end

  -- local particle_cast = "particles/bloodstained/bloodstained_u_bubbles.vpcf"
  -- local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_WORLDORIGIN, nil)
	-- ParticleManager:SetParticleControl(effect_cast, 0, point)
	-- self:AddParticle(effect_cast, false, false, -1, false, true)

	-- local particle_cast_2 = "particles/bloodstained/bloodstained_field_replica.vpcf"
  -- local effect_cast_2 = ParticleManager:CreateParticle(particle_cast_2, PATTACH_WORLDORIGIN, nil)
	-- ParticleManager:SetParticleControl(effect_cast_2, 0, self.parent:GetAbsOrigin())
	-- ParticleManager:SetParticleControl(effect_cast_2, 10, Vector(self:GetDuration(), 0, 0))
	-- self:AddParticle(effect_cast_2, false, false, -1, false, true)

	-- local particle_cast_3 = "particles/bloodstained/bloodstained_seal_impact.vpcf"
  -- local effect_cast_3 = ParticleManager:CreateParticle(particle_cast_3, PATTACH_WORLDORIGIN, nil)
	-- ParticleManager:SetParticleControl(effect_cast_3, 0, self.parent:GetOrigin())

	-- local particle_cast_4 = "particles/bloodstained/bloodstained_seal_war.vpcf"
  -- local effect_cast_4 = ParticleManager:CreateParticle(particle_cast_4, PATTACH_WORLDORIGIN, nil)
	-- ParticleManager:SetParticleControl(effect_cast_4, 0, self.parent:GetOrigin())
	-- self:AddParticle(effect_cast_4, false, false, -1, false, true)
end