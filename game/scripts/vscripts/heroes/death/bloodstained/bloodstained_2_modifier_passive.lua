bloodstained_2_modifier_passive = class({})

function bloodstained_2_modifier_passive:IsHidden() return false end
function bloodstained_2_modifier_passive:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function bloodstained_2_modifier_passive:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  self.parent:AddStatusEfx(self.caster, self.ability, "bloodstained_2_modifier_passive_status_efx")

	self:OnIntervalThink()
end

function bloodstained_2_modifier_passive:OnRefresh(kv)
end

function bloodstained_2_modifier_passive:OnRemoved()
  if not IsServer() then return end

  self.parent:RemoveStatusEfx(self.caster, self.ability, "bloodstained_2_modifier_passive_status_efx")
end

-- API FUNCTIONS -----------------------------------------------------------

function bloodstained_2_modifier_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACKED,
    MODIFIER_EVENT_ON_DEATH
	}

	return funcs
end

function bloodstained_2_modifier_passive:OnAttacked(keys)
  if not IsServer() then return end

	if self.parent:PassivesDisabled() then return end
	if self.parent:GetTeamNumber() == keys.target:GetTeamNumber() then return end

  local base_heal = self.ability:GetSpecialValueFor("base_heal")
  local max_heal = self.ability:GetSpecialValueFor("max_heal")

  local heal = keys.original_damage * self:GetLifestealPercent(keys.attacker, base_heal, max_heal) * 0.01

  if heal > 0 then
    keys.attacker:ApplyHeal(heal, self.ability, false)
    self:PlayEfxLifesteal(keys.attacker, keys.target)
  end
end

function bloodstained_2_modifier_passive:OnIntervalThink()
  if not IsServer() then return end

  local base_heal = self.ability:GetSpecialValueFor("base_heal")
  local max_heal = self.ability:GetSpecialValueFor("max_heal")

  self:SetStackCount(math.floor(self:GetLifestealPercent(self.parent, base_heal, max_heal)))
  self:StartIntervalThink(0.25)
end

-- UTILS -----------------------------------------------------------

function bloodstained_2_modifier_passive:GetLifestealPercent(target, base_heal, max_heal)
  if base_heal > max_heal then return base_heal end

	local deficit_percent =  1 - (target:GetHealth() / target:GetMaxHealth())
	return ((max_heal - base_heal) * deficit_percent) + base_heal
end

-- EFFECTS -----------------------------------------------------------

function bloodstained_2_modifier_passive:GetStatusEffectName()
  return "particles/bloodstained/status_efx/status_effect_bloodstained.vpcf"
end

function bloodstained_2_modifier_passive:StatusEffectPriority()
return MODIFIER_PRIORITY_NORMAL
end

function bloodstained_2_modifier_passive:GetEffectName()
	return "particles/bioshadow/bioshadow_drain.vpcf"
end

function bloodstained_2_modifier_passive:GetEffectAttachType()
	return PATTACH_POINT_FOLLOW
end

function bloodstained_2_modifier_passive:PlayEfxLifesteal(attacker, target)
	local particle_cast = "particles/units/heroes/hero_bloodseeker/bloodseeker_rupture_nuke.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControlEnt(effect_cast, 1, target, PATTACH_ABSORIGIN_FOLLOW, "", Vector(0,0,0), true)

	local particle_cast2 = "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodbath.vpcf"
  local effect_cast2 = ParticleManager:CreateParticle(particle_cast2, PATTACH_ABSORIGIN_FOLLOW, attacker)
	ParticleManager:ReleaseParticleIndex(effect_cast2)

	attacker:EmitSound("Bloodstained.Lifesteal")
end