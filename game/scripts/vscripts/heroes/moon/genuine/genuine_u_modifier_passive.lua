genuine_u_modifier_passive = class({})

function genuine_u_modifier_passive:IsHidden() return false end
function genuine_u_modifier_passive:IsPurgable() return false end

-- AURA -----------------------------------------------------------

function genuine_u_modifier_passive:IsAura() return true end
function genuine_u_modifier_passive:GetAuraDuration() return 0 end
function genuine_u_modifier_passive:GetModifierAura() return "genuine_u_modifier_morning" end
function genuine_u_modifier_passive:GetAuraRadius() return FIND_UNITS_EVERYWHERE end
function genuine_u_modifier_passive:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function genuine_u_modifier_passive:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO end
function genuine_u_modifier_passive:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD end
function genuine_u_modifier_passive:GetAuraEntityReject(hEntity)
  if not IsServer() then return true end
  return self.caster ~= hEntity or self.ability:GetSpecialValueFor("special_passive") == 0 or GameRules:IsDaytime()
end

-- CONSTRUCTORS -----------------------------------------------------------

function genuine_u_modifier_passive:OnCreated(kv)
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

  if not IsServer() then return end

  self:SetStackCount(0)
  self:StartIntervalThink(1)
end

function genuine_u_modifier_passive:OnRefresh(kv)  
end

function genuine_u_modifier_passive:OnRemoved(kv)
end

-- API FUNCTIONS -----------------------------------------------------------

function genuine_u_modifier_passive:OnStackCountChanged(old)
  if not IsServer() then return end
  if self:GetStackCount() <= old then return end

  self.parent:GetBaseHeroAbility():AddPermanentStat({"int", "agi"}, 1)
end

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