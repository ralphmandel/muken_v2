genuine_u_modifier_passive = class({})

function genuine_u_modifier_passive:IsHidden() return true end
function genuine_u_modifier_passive:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function genuine_u_modifier_passive:OnCreated(kv)
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
end

function genuine_u_modifier_passive:OnRefresh(kv)  
end

function genuine_u_modifier_passive:OnRemoved(kv)
end

-- API FUNCTIONS -----------------------------------------------------------

-- function genuine_u_modifier_passive:DeclareFunctions()
-- 	local funcs = {
-- 		MODIFIER_PROPERTY_BONUS_NIGHT_VISION
-- 	}
	
-- 	return funcs
-- end

-- function genuine_u_modifier_passive:GetBonusNightVision()
-- end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function genuine_u_modifier_passive:PlayEfxBuff()
	self:StopEfxBuff()

	local particle = "particles/genuine/morning_star/genuine_morning_star.vpcf"
	self.effect_caster = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(self.effect_caster, 0, self.parent:GetOrigin())
	ParticleManager:SetParticleControl(self.effect_caster, 1, self.parent:GetOrigin())
	self:AddParticle(self.effect_caster, false, false, -1, false, false)
end

function genuine_u_modifier_passive:StopEfxBuff()
	if self.effect_caster then ParticleManager:DestroyParticle(self.effect_caster, false) end
end