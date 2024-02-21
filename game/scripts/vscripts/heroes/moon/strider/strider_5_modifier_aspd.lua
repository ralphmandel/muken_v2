strider_5_modifier_aspd = class({})

function strider_5_modifier_aspd:IsHidden() return false end
function strider_5_modifier_aspd:IsPurgable() return true end

-- AURA -----------------------------------------------------------

function strider_5_modifier_aspd:IsAura() return true end
function strider_5_modifier_aspd:GetAuraDuration() return 0.5 end
function strider_5_modifier_aspd:GetModifierAura() return "strider_5_modifier_aura_effect" end
function strider_5_modifier_aspd:GetAuraRadius() return self.aura_radius end
function strider_5_modifier_aspd:GetAuraSearchTeam() return self.ability:GetAbilityTargetTeam() end
function strider_5_modifier_aspd:GetAuraSearchType() return self.ability:GetAbilityTargetType() end
function strider_5_modifier_aspd:GetAuraSearchFlags() return self.ability:GetAbilityTargetFlags() end
function strider_5_modifier_aspd:GetAuraEntityReject(hEntity)
  return hEntity == self:GetCaster()
end

-- CONSTRUCTORS -----------------------------------------------------------

function strider_5_modifier_aspd:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  self.aura_radius = self.ability:GetAOERadius()

  if not IsServer() then return end

  self.parent:AddSubStats(self.ability, {
    attack_speed = self.ability:GetSpecialValueFor("attack_speed"),
    speed = self.ability:GetSpecialValueFor("movespeed")
  })

  self.parent:AddSubStats(self.ability, {
    speed = self.ability:GetSpecialValueFor("movespeed"),
    duration = self.ability:GetSpecialValueFor("special_double_ms_duration")
  })

  if self.ability:GetSpecialValueFor("special_no_slow") == 1 then
    self.parent:AddModifier(self.ability, "_modifier_unslowable", {})
  end

  self.ability:SetActivated(false)
  self.ability:EndCooldown()
  self:PlayEfxStart()
end

function strider_5_modifier_aspd:OnRefresh(kv)
end

function strider_5_modifier_aspd:OnRemoved()
  if not IsServer() then return end

  self.parent:RemoveSubStats(self.ability, {"attack_speed", "speed"})
  self.parent:RemoveSubStats(self.ability, {"speed"})
  self.parent:RemoveAllModifiersByNameAndAbility("_modifier_unslowable", self.ability)

  self.ability:SetActivated(true)
  self.ability:StartCooldown(self.ability:GetEffectiveCooldown(self.ability:GetLevel()))
end

-- API FUNCTIONS -----------------------------------------------------------

function strider_5_modifier_aspd:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACKED
	}

	return funcs
end

function strider_5_modifier_aspd:OnAttacked(keys)
  if not IsServer() then return end

  if keys.attacker ~= self.parent then return end

  local lifesteal = keys.original_damage * self.ability:GetSpecialValueFor("special_attack_lifesteal") * 0.01
  local heal_result = self.parent:ApplyHeal(lifesteal, self.ability, false)
  if heal_result > 0 then self:PlayEfxLifesteal(self.parent) end
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function strider_5_modifier_aspd:GetEffectName()
	return "particles/strider/aspd_buff/strider_aspd_buff_resistance_buff.vpcf"
end

function strider_5_modifier_aspd:PlayEfxStart()
	local string = "particles/strider/aspd_buff/strider_aspd_buff.vpcf"
	local particle = ParticleManager:CreateParticle(string, PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(particle, 0, self.parent:GetOrigin())
	ParticleManager:ReleaseParticleIndex(particle)

	self.parent:EmitSound("Strider.aspdbuff")
end

function strider_5_modifier_aspd:PlayEfxLifesteal(target)
	local particle = "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf"
	local effect = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(effect, 1, target:GetOrigin())
	ParticleManager:ReleaseParticleIndex(effect)
end

-- function strider_5_modifier_aspd:PlayEfxStart()
--   local owner = self:GetParent()
--   local string = "particles/strider/aspd_buff/strider_aspd_buff_shadow_track.vpcf"
-- 	local particle = ParticleManager:CreateParticle(string, PATTACH_ABSORIGIN_FOLLOW, owner)
-- 	ParticleManager:SetParticleControl(particle, 0, owner:GetOrigin())
-- 	ParticleManager:ReleaseParticleIndex( particle )
--   --print('EFEITO FUNFOU')

-- end