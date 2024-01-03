neutral_acid_puddle_modifier_aura = class({})

function neutral_acid_puddle_modifier_aura:IsHidden() return true end
function neutral_acid_puddle_modifier_aura:IsPurgable() return false end

-- AURA -----------------------------------------------------------

function neutral_acid_puddle_modifier_aura:IsAura() return true end
function neutral_acid_puddle_modifier_aura:GetAuraDuration() return 0 end
function neutral_acid_puddle_modifier_aura:GetModifierAura() return "neutral_acid_puddle_modifier_aura_effect" end
function neutral_acid_puddle_modifier_aura:GetAuraRadius() return self:GetAbility():GetAOERadius() end
function neutral_acid_puddle_modifier_aura:GetAuraSearchTeam() return self:GetAbility():GetAbilityTargetTeam() end
function neutral_acid_puddle_modifier_aura:GetAuraSearchType() return self:GetAbility():GetAbilityTargetType() end
function neutral_acid_puddle_modifier_aura:GetAuraSearchFlags() return self:GetAbility():GetAbilityTargetFlags() end
function neutral_acid_puddle_modifier_aura:GetAuraEntityReject(hEntity)
  return hEntity:GetTeamNumber() == TIER_TEAMS[RARITY_COMMON] or hEntity:GetTeamNumber() >= TIER_TEAMS[RARITY_RARE]
end

-- CONSTRUCTORS -----------------------------------------------------------

function neutral_acid_puddle_modifier_aura:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if IsServer() then self:PlayEfxStart() end
end

function neutral_acid_puddle_modifier_aura:OnRefresh(kv)
end

function neutral_acid_puddle_modifier_aura:OnRemoved()
end

-- API FUNCTIONS -----------------------------------------------------------

function neutral_acid_puddle_modifier_aura:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH
	}

	return funcs
end

function neutral_acid_puddle_modifier_aura:OnDeath(keys)
	if keys.unit ~= self.caster then return end
	self:Destroy()
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function neutral_acid_puddle_modifier_aura:PlayEfxStart()
	local particle_cast = "particles/units/heroes/hero_alchemist/alchemist_acid_spray.vpcf"
	local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(effect_cast, 0, self.parent:GetOrigin())
	ParticleManager:SetParticleControl(effect_cast, 1, Vector(self.ability:GetAOERadius(), 1, 1))
	self:AddParticle(effect_cast, false, false, -1, false, false)

	if IsServer() then self.parent:EmitSound("Hero_Alchemist.AcidSpray") end
end