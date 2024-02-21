bloodstained_u_modifier_aura_effect = class({})

function bloodstained_u_modifier_aura_effect:IsHidden() return false end
function bloodstained_u_modifier_aura_effect:IsPurgable() return false end
function bloodstained_u_modifier_aura_effect:GetPriority() return MODIFIER_PRIORITY_SUPER_ULTRA end

-- CONSTRUCTORS -----------------------------------------------------------

function bloodstained_u_modifier_aura_effect:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
	self.ability = self:GetAbility()

  if not IsServer() then return end

  if self.parent:GetTeamNumber() ~= self.caster:GetTeamNumber() then
    local bleed_damage = self.ability:GetSpecialValueFor("special_bleed_damage")

    if bleed_damage > 0 then
      self.parent:AddModifier(self.ability, "orb_bleed_debuff", {bleed_damage = bleed_damage})
    end

    if self.ability:GetSpecialValueFor("special_break") == 1 then
      self.parent:AddModifier(self.ability, "_modifier_break", {})
    end
  end
end

function bloodstained_u_modifier_aura_effect:OnRefresh(kv)
end

function bloodstained_u_modifier_aura_effect:OnRemoved()
  if not IsServer() then return end

  self.parent:RemoveAllModifiersByNameAndAbility("orb_bleed_debuff", self.ability)
	self:CreateBloodIllusion()
end

-- API FUNCTIONS -----------------------------------------------------------

function bloodstained_u_modifier_aura_effect:DeclareFunctions()
	local funcs = {
    MODIFIER_EVENT_ON_ATTACKED
	}

	return funcs
end

function bloodstained_u_modifier_aura_effect:OnAttacked(keys)
  if not IsServer() then return end

  if self.parent ~= keys.attacker then return end
	if self.parent:GetTeamNumber() ~= self.caster:GetTeamNumber() then return end
  if self.parent == self.caster then return end

  local heal = keys.original_damage * self.ability:GetSpecialValueFor("special_lifesteal") * 0.01

  if heal > 0 then
    self.parent:ApplyHeal(heal, self.ability, false)
    self:PlayEfxLifesteal(self.parent, keys.target)
  end
end

-- UTILS -----------------------------------------------------------

function bloodstained_u_modifier_aura_effect:CreateBloodIllusion()
  if self.ability:IsActivated() then return end
	if self.caster:GetTeamNumber() == self.parent:GetTeamNumber() then return end
	if self.parent:IsAlive() == false then return end
	if self.parent:IsIllusion() then return end
	if self.parent:IsHero() == false then return end
  if self.parent:GetBloodIllusions() then return end
	
	local hp_stolen = math.floor(self.parent:GetBaseMaxHealth() * self.ability:GetSpecialValueFor("hp_stolen") * 0.01)

	local illu_array = CreateIllusions(self.caster, self.parent, {
		outgoing_damage = -80,
		incoming_damage = -100,
		bounty_base = 0,
		bounty_growth = 0,
		duration = -1
	}, 1, 64, false, true)

	for _,illu in pairs(illu_array) do
    illu:AddModifier(self.ability, "bloodstained_u_modifier_copy", {
      duration = self.ability:GetSpecialValueFor("copy_duration"),
      hp_stolen = hp_stolen, target = self.parent:GetEntityIndex()
    })

		local loc = self.parent:GetAbsOrigin() + RandomVector(100)
    FindClearSpaceForUnit(illu, loc, true)
		illu:SetForwardVector((self.parent:GetAbsOrigin() - loc):Normalized())
	end

  self.parent:AddSubStats(self.ability, {
    slow_percent = 100, duration = self.ability:GetSpecialValueFor("slow_duration"), bResist = 1
  })
end

-- EFFECTS -----------------------------------------------------------

function bloodstained_u_modifier_aura_effect:GetEffectName()
	return "particles/bloodstained/bloodstained_thirst_owner_smoke_dark.vpcf"
end

function bloodstained_u_modifier_aura_effect:GetEffectAttachType()
	return PATTACH_POINT_FOLLOW
end

function bloodstained_u_modifier_aura_effect:PlayEfxLifesteal(attacker, target)
	local particle_cast = "particles/units/heroes/hero_bloodseeker/bloodseeker_rupture_nuke.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControlEnt(effect_cast, 1, target, PATTACH_ABSORIGIN_FOLLOW, "", Vector(0,0,0), true)

	local particle_cast2 = "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodbath.vpcf"
  local effect_cast2 = ParticleManager:CreateParticle(particle_cast2, PATTACH_ABSORIGIN_FOLLOW, attacker)
	ParticleManager:ReleaseParticleIndex(effect_cast2)

	attacker:EmitSound("Bloodstained.Lifesteal")
end