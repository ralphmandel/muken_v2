strider_5_modifier_aspd = class({})

function strider_5_modifier_aspd:IsHidden() return false end
function strider_5_modifier_aspd:IsPurgable() return true end

-- CONSTRUCTORS -----------------------------------------------------------

function strider_5_modifier_aspd:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

	AddSubStats(self.parent, self.ability, {attack_speed = self.ability:GetSpecialValueFor("attack_speed")}, false)
	AddModifier(self.parent, self.ability, "sub_stat_movespeed_increase", {value = self.ability:GetSpecialValueFor("special_movespeed")}, false)

  if self.ability:GetSpecialValueFor("special_bkb") == 1 then
    AddModifier(self.parent, self.ability, "_modifier_bkb", {}, false)
  end

  self.ability:SetActivated(false)
  self.ability:EndCooldown()

  if IsServer() then self:PlayEfxStart() end
end

function strider_5_modifier_aspd:OnRefresh(kv)
end

function strider_5_modifier_aspd:OnRemoved()
  RemoveSubStats(self.parent, self.ability, {"attack_speed"})
	RemoveAllModifiersByNameAndAbility(self.parent, "sub_stat_movespeed_increase", self.ability)
	RemoveAllModifiersByNameAndAbility(self.parent, "_modifier_bkb", self.ability)

  self.ability:SetActivated(true)
  self.ability:StartCooldown(self.ability:GetEffectiveCooldown(self.ability:GetLevel()))
end

-- API FUNCTIONS -----------------------------------------------------------

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

	if IsServer() then self.parent:EmitSound("Strider.aspdbuff") end
end

-- function strider_5_modifier_aspd:PlayEfxStart()
--   local owner = self:GetParent()
--   local string = "particles/strider/aspd_buff/strider_aspd_buff_shadow_track.vpcf"
-- 	local particle = ParticleManager:CreateParticle(string, PATTACH_ABSORIGIN_FOLLOW, owner)
-- 	ParticleManager:SetParticleControl(particle, 0, owner:GetOrigin())
-- 	ParticleManager:ReleaseParticleIndex( particle )
--   --print('EFEITO FUNFOU')

-- end