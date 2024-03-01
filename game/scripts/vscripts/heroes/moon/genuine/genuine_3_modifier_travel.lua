genuine_3_modifier_travel = class({})

function genuine_3_modifier_travel:IsHidden() return true end
function genuine_3_modifier_travel:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function genuine_3_modifier_travel:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  self.parent:Stop()
  self.ban = self.parent:AddModifier(self.ability, "_modifier_ban", {})
	self:PlayEfxStart()
end

function genuine_3_modifier_travel:OnRefresh(kv)
end

function genuine_3_modifier_travel:OnRemoved()
  if not IsServer() then return end

  if self.ban:IsNull() == false then self.ban:Destroy() end

  self:PlayEfxEnd()
end

-- API FUNCTIONS -----------------------------------------------------------

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function genuine_3_modifier_travel:PlayEfxStart()
  local particle_cast = "particles/units/heroes/hero_puck/puck_illusory_orb_blink_out.vpcf"
  local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN, self.parent)
  ParticleManager:SetParticleControl(effect_cast, 0, self.parent:GetOrigin())
  ParticleManager:ReleaseParticleIndex(effect_cast)
end

function genuine_3_modifier_travel:PlayEfxEnd()
  local radius = self.ability:GetSpecialValueFor("silence_radius")
  local particle_cast = "particles/genuine/genuine_travel_silence/genuine_silence_aproset.vpcf"
  local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_WORLDORIGIN, self.parent)
  ParticleManager:SetParticleControl(effect_cast, 0, self.parent:GetOrigin())
  ParticleManager:SetParticleControl(effect_cast, 1, Vector(radius, radius, radius))
  ParticleManager:ReleaseParticleIndex(effect_cast)

  self.parent:EmitSound("Hero_Puck.Waning_Rift")
end