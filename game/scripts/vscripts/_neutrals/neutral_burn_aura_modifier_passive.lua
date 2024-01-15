neutral_burn_aura_modifier_passive = class({})

function neutral_burn_aura_modifier_passive:IsHidden() return true end
function neutral_burn_aura_modifier_passive:IsPurgable() return false end

-- AURA -----------------------------------------------------------

function neutral_burn_aura_modifier_passive:IsAura() return true end
function neutral_burn_aura_modifier_passive:GetAuraDuration() return 0 end
function neutral_burn_aura_modifier_passive:GetModifierAura() return "neutral_burn_aura_modifier_aura_effect" end
function neutral_burn_aura_modifier_passive:GetAuraRadius() return self:GetAbility():GetAOERadius() end
function neutral_burn_aura_modifier_passive:GetAuraSearchTeam() return self:GetAbility():GetAbilityTargetTeam() end
function neutral_burn_aura_modifier_passive:GetAuraSearchType() return self:GetAbility():GetAbilityTargetType() end
function neutral_burn_aura_modifier_passive:GetAuraSearchFlags() return self:GetAbility():GetAbilityTargetFlags() end
function neutral_burn_aura_modifier_passive:GetAuraEntityReject(hEntity)
  if not IsServer() then return false end
  return hEntity:GetTeamNumber() == TIER_TEAMS[RARITY_COMMON] or hEntity:GetTeamNumber() >= TIER_TEAMS[RARITY_RARE]
end

-- CONSTRUCTORS -----------------------------------------------------------

function neutral_burn_aura_modifier_passive:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if IsServer() then
    self:PlayEfxAmbient()
    self:StartIntervalThink(2)
  end
end

function neutral_burn_aura_modifier_passive:OnRefresh(kv)
end

function neutral_burn_aura_modifier_passive:OnRemoved()
end

-- API FUNCTIONS -----------------------------------------------------------

function neutral_burn_aura_modifier_passive:OnIntervalThink()
  if IsServer() then
		self.parent:StopSound("Igneo.Burn.Loop")
		self.parent:EmitSound("Igneo.Burn.Loop")
	end
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function neutral_burn_aura_modifier_passive:GetEffectName()
	return "particles/units/heroes/hero_ember_spirit/ember_spirit_flameguard.vpcf"
end

function neutral_burn_aura_modifier_passive:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function neutral_burn_aura_modifier_passive:PlayEfxAmbient()
	local ambient = "particles/econ/items/warlock/warlock_hellsworn_construct/golem_hellsworn_ambient.vpcf"
	local particle = ParticleManager:CreateParticle(ambient, PATTACH_POINT_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(particle, 0, self.parent:GetOrigin())
	ParticleManager:SetParticleControlEnt(particle, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
	self:AddParticle(particle, false, false, -1, false, false)

  if IsServer() then self.parent:EmitSound("Igneo.Burn.Loop") end
end