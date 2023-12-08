strider_5_modifier_aspd = class({})

function strider_5_modifier_aspd:IsHidden() return false end
function strider_5_modifier_aspd:IsPurgable() return true end

-- CONSTRUCTORS -----------------------------------------------------------

function strider_5_modifier_aspd:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

	AddSubStats(self.parent, self.ability, {attack_speed = kv.aspd_bonus}, false)
	AddModifier(self.parent, self.ability,"sub_stat_movespeed_increase",{value = kv.ms_bonus}, false)

end

function strider_5_modifier_aspd:OnRefresh(kv)
  if IsServer() then
  end
end

function strider_5_modifier_aspd:OnRemoved()
  RemoveSubStats(self.parent, self.ability, {"attack_speed"})
	RemoveAllModifiersByNameAndAbility(self.parent, "sub_stat_movespeed_increase", self.ability)
end

function strider_5_modifier_aspd:OnDestroy()
  if IsServer() then
	end
end

-- API FUNCTIONS -----------------------------------------------------------

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function strider_5_modifier_aspd:GetEffectName()
	return "particles/strider/aspd_buff/strider_aspd_buff_resistance_buff.vpcf"
end


-- function strider_5_modifier_aspd:PlayEfxStart()
--   local owner = self:GetParent()
--   local string = "particles/strider/aspd_buff/strider_aspd_buff_shadow_track.vpcf"
-- 	local particle = ParticleManager:CreateParticle(string, PATTACH_ABSORIGIN_FOLLOW, owner)
-- 	ParticleManager:SetParticleControl(particle, 0, owner:GetOrigin())
-- 	ParticleManager:ReleaseParticleIndex( particle )
--   print('EFEITO FUNFOU')

-- end