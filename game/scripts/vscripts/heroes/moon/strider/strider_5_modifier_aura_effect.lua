strider_5_modifier_aura_effect = class({})

function strider_5_modifier_aura_effect:IsHidden() return false end
function strider_5_modifier_aura_effect:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function strider_5_modifier_aura_effect:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  self.parent:AddSubStats(self.ability, {
    attack_speed = self.ability:GetSpecialValueFor("attack_speed"),
    speed = self.ability:GetSpecialValueFor("movespeed")
  })

  self:PlayEfxStart()
end

function strider_5_modifier_aura_effect:OnRefresh(kv)
end

function strider_5_modifier_aura_effect:OnRemoved()
  if not IsServer() then return end

  self.parent:RemoveSubStats(self.ability, {"attack_speed", "speed"})

  self.ability:SetActivated(true)
  self.ability:StartCooldown(self.ability:GetEffectiveCooldown(self.ability:GetLevel()))
end

-- API FUNCTIONS -----------------------------------------------------------

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function strider_5_modifier_aura_effect:GetEffectName()
	return "particles/strider/aspd_buff/strider_aspd_buff_resistance_buff.vpcf"
end

function strider_5_modifier_aura_effect:PlayEfxStart()
	local string = "particles/strider/aspd_buff/strider_aspd_buff.vpcf"
	local particle = ParticleManager:CreateParticle(string, PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(particle, 0, self.parent:GetOrigin())
	ParticleManager:ReleaseParticleIndex(particle)

	self.parent:EmitSound("Strider.aspdbuff")
end

-- function strider_5_modifier_aura_effect:PlayEfxStart()
--   local owner = self:GetParent()
--   local string = "particles/strider/aspd_buff/strider_aspd_buff_shadow_track.vpcf"
-- 	local particle = ParticleManager:CreateParticle(string, PATTACH_ABSORIGIN_FOLLOW, owner)
-- 	ParticleManager:SetParticleControl(particle, 0, owner:GetOrigin())
-- 	ParticleManager:ReleaseParticleIndex( particle )
--   --print('EFEITO FUNFOU')

-- end