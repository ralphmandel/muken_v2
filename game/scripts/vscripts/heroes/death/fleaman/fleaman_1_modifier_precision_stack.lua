fleaman_1_modifier_precision_stack = class({})
local tempTable = require("libraries/tempTable")

function fleaman_1_modifier_precision_stack:IsPurgable() return true end
function fleaman_1_modifier_precision_stack:IsHidden() return true end
function fleaman_1_modifier_precision_stack:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

-- CONSTRUCTORS -----------------------------------------------------------

function fleaman_1_modifier_precision_stack:OnCreated( kv )
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

  self.pulses = self.ability:GetSpecialValueFor("special_pulses")
  
	if IsServer() then
		self.modifier = tempTable:RetATValue( kv.modifier )

    if self.pulses > 0 then
      self:PlayEfxStart()
      self:StartIntervalThink(0.1)
    end
	end
end

function fleaman_1_modifier_precision_stack:OnRemoved()
	if IsServer() then
		if not self.modifier:IsNull() then
			self.modifier:DecrementStackCount()
		end
	end
end

function fleaman_1_modifier_precision_stack:OnDestroy()
end

-- API FUNCTIONS -----------------------------------------------------------

function fleaman_1_modifier_precision_stack:OnIntervalThink()
  if not IsServer() then return end

	local enemies = FindUnitsInRadius(
		self.parent:GetTeamNumber(), self.parent:GetOrigin(), nil, self.ability:GetAOERadius(),
		DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false
	)

	for _,enemy in pairs(enemies) do
		ApplyDamage({
			damage = self.ability:GetSpecialValueFor("special_damage") / self.ability:GetSpecialValueFor("special_pulses"),
			attacker = self.parent, victim = enemy,
			damage_type = self.ability:GetAbilityDamageType(),
			ability = self.ability
		})
	end

	self.pulses = self.pulses -1

	if IsServer() then
    if self.pulses > 0 then
      self:StartIntervalThink(0.1)
    else
      self:StartIntervalThink(-1)
    end
  end
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function fleaman_1_modifier_precision_stack:GetEffectName()
	return "particles/fleaman/fleaman_precision.vpcf"
end

function fleaman_1_modifier_precision_stack:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function fleaman_1_modifier_precision_stack:PlayEfxStart()
	local particle_cast = "particles/econ/items/slark/slark_head_immortal/slark_immortal_dark_pact_pulses.vpcf"
	local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControlEnt(effect_cast, 1, self.parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self.parent:GetOrigin(), true)
	ParticleManager:SetParticleControl(effect_cast, 2, Vector(self.ability:GetAOERadius(), 0, 0))
	ParticleManager:ReleaseParticleIndex(effect_cast)

	self.parent:EmitSound("Hero_Slark.DarkPact.Cast.Immortal")
end