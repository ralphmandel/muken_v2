fleaman_5_modifier_aura_effect = class({})

function fleaman_5_modifier_aura_effect:IsHidden() return true end
function fleaman_5_modifier_aura_effect:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function fleaman_5_modifier_aura_effect:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  if self.caster:GetTeamNumber() == self.parent:GetTeamNumber() then
    RemoveAllModifiersByNameAndAbility(self.parent, "fleaman_5_modifier_shadow", self.ability)
    AddSubStats(self.parent, self.ability, {
      health_regen = self.ability:GetSpecialValueFor("special_hp_regen")
    }, false)

    self:PlayEfxStart()
    self:OnIntervalThink()
  else
    AddModifier(self.parent, self.ability, "_modifier_no_vision_attacker", {}, false)

    AddModifier(self.parent, self.ability, "_modifier_blind", {
      percent = self.ability:GetSpecialValueFor("blind")
    }, false)

    AddSubStats(self.parent, self.ability, {
      miss_chance = self.ability:GetSpecialValueFor("miss_chance")
    }, false)
  end
end

function fleaman_5_modifier_aura_effect:OnRefresh(kv)
end

function fleaman_5_modifier_aura_effect:OnRemoved()
  if not IsServer() then return end

  RemoveAllModifiersByNameAndAbility(self.parent, "_modifier_no_vision_attacker", self.ability)
  RemoveAllModifiersByNameAndAbility(self.parent, "_modifier_blind", self.ability)
  RemoveSubStats(self.parent, self.ability, {"miss_chance"})
  RemoveSubStats(self.parent, self.ability, {"health_regen"})

  if self.caster:GetTeamNumber() == self.parent:GetTeamNumber() then
    AddModifier(self.parent, self.ability, "fleaman_5_modifier_shadow", {
      duration = self.ability:GetSpecialValueFor("special_hide")
    }, true)
  end
end

-- API FUNCTIONS -----------------------------------------------------------

function fleaman_5_modifier_aura_effect:CheckState()
	local state = {}

  if self:GetParent() == self:GetCaster() then
    table.insert(state, MODIFIER_STATE_NO_HEALTH_BAR_FOR_ENEMIES, true)
  end

	return state
end

function fleaman_5_modifier_aura_effect:DeclareFunctions()
	local funcs = {}

  if self:GetParent() == self:GetCaster() then
    table.insert(funcs, MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS)
  end

	return funcs
end

function fleaman_5_modifier_aura_effect:GetActivityTranslationModifiers()
  return "shadow_dance"
end

function fleaman_5_modifier_aura_effect:OnIntervalThink()
  if not IsServer() then return end

	if self.effect_cast then ParticleManager:SetParticleControl(self.effect_cast, 1, self.parent:GetOrigin()) end
	self:StartIntervalThink(FrameTime())
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function fleaman_5_modifier_aura_effect:PlayEfxStart()
	local particle_cast = "particles/units/heroes/hero_slark/slark_shadow_dance.vpcf"
	local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent)
  ParticleManager:SetParticleControlEnt(effect_cast, 1, self.parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
	ParticleManager:SetParticleControlEnt(effect_cast, 3, self.parent, PATTACH_POINT_FOLLOW, "attach_eyeR", Vector(0,0,0), true)
	ParticleManager:SetParticleControlEnt(effect_cast, 4, self.parent, PATTACH_POINT_FOLLOW, "attach_eyeL", Vector(0,0,0), true)
	self:AddParticle(effect_cast, false, false, -1, false, false)

	local particle_cast_2 = "particles/units/heroes/hero_slark/slark_shadow_dance_dummy.vpcf"
	local effect_cast_1 = ParticleManager:CreateParticle(particle_cast_2, PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(effect_cast_1, 0, self.parent:GetOrigin())
	ParticleManager:SetParticleControl(effect_cast_1, 1, self.parent:GetOrigin())
	self:AddParticle(effect_cast_1, false, false, -1, false, false)

	self.effect_cast = effect_cast_1
end