paladin_2_modifier_burn_efx = class({})

function paladin_2_modifier_burn_efx:IsHidden() return true end
function paladin_2_modifier_burn_efx:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function paladin_2_modifier_burn_efx:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()
  
  if not IsServer() then return end

  self:PlayEfxStart()
  self:StartIntervalThink(0.1)
end

function paladin_2_modifier_burn_efx:OnRefresh(kv)
end

function paladin_2_modifier_burn_efx:OnRemoved()
  self.parent:StopSound("Hero_Batrider.Firefly.loop")
end

-- API FUNCTIONS -----------------------------------------------------------

-- UTILS -----------------------------------------------------------

function paladin_2_modifier_burn_efx:OnIntervalThink()
  if not IsServer() then return end

	if self.particle then ParticleManager:SetParticleControl(self.particle, 1, self.caster:GetAbsOrigin()) end

	self:StartIntervalThink(0.1)
end

-- EFFECTS -----------------------------------------------------------

function paladin_2_modifier_burn_efx:PlayEfxStart()
	if self.particle then ParticleManager:DestroyParticle(self.particle, false) end

	local string_2 = "particles/units/heroes/hero_phoenix/phoenix_supernova_radiance.vpcf"
	self.particle = ParticleManager:CreateParticle(string_2, PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(self.particle, 0, self.parent:GetAbsOrigin())
	ParticleManager:SetParticleControl(self.particle, 1, self.caster:GetAbsOrigin())
	self:AddParticle(self.particle, false, false, -1, false, false)

  self.parent:EmitSound("Hero_Inquisitor.Shield.Fire")
  self.parent:EmitSound("Hero_Batrider.Firefly.loop")
end