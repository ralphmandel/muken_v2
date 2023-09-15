icebreaker_5_modifier_passive = class({})

function icebreaker_5_modifier_passive:IsHidden() return false end
function icebreaker_5_modifier_passive:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function icebreaker_5_modifier_passive:OnCreated(kv)
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

  if IsServer() then
    self.ability.kills = 0
    self:SetStackCount(self.ability.kills)
    self:PlayEfxAmbient()
  end
end

function icebreaker_5_modifier_passive:OnRefresh(kv)
	if IsServer() then
		self:SetStackCount(self.ability.kills)
	end
end

function icebreaker_5_modifier_passive:OnRemoved()
end

-- API FUNCTIONS -----------------------------------------------------------

function icebreaker_5_modifier_passive:DeclareFunctions()
	local funcs = {
    MODIFIER_PROPERTY_DISABLE_TURNING,
		MODIFIER_EVENT_ON_ABILITY_START,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_HERO_KILLED
	}

	return funcs
end

function icebreaker_5_modifier_passive:GetModifierDisableTurning()
	return self.ability.turn
end

function icebreaker_5_modifier_passive:OnAbilityStart(keys)
	if keys.unit ~= self.parent then return end
	if keys.ability ~= self.ability then return end
	
	self.ability.turn = 1
end

function icebreaker_5_modifier_passive:OnTakeDamage(keys)
	if keys.attacker == nil then return end
	if keys.attacker:IsBaseNPC() == false then return end
	if keys.attacker ~= self.parent then return end
	if keys.inflictor == nil then return end
	if keys.inflictor ~= self.ability then return end
  if self.ability.break_damage == false then return end

	local heal = keys.original_damage * self.ability:GetSpecialValueFor("special_break_heal") * 0.01
  self.ability.break_damage = false

	if heal > 0 then
		self.parent:Heal(heal, self.ability)
		self:PlayEfxSpellLifesteal(self.parent)
	end
end

function icebreaker_5_modifier_passive:OnHeroKilled(keys)
	if keys.target:GetTeamNumber() == self.parent:GetTeamNumber() then return end
	if keys.inflictor ~= self.ability then return end

	if IsServer() then
    self.ability.kills = self.ability.kills + 1
		self:SetStackCount(self.ability.kills)
		self:PlayEfxKill()
	end
end

function icebreaker_5_modifier_passive:OnStackCountChanged(old)
	RemoveBonus(self.ability, "AGI", self.parent)
  AddBonus(self.ability, "AGI", self.parent, self:GetStackCount(), 0, nil)
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function icebreaker_5_modifier_passive:GetStatusEffectName()
	return "particles/econ/items/effigies/status_fx_effigies/status_effect_effigy_frosty_radiant.vpcf"
end

function icebreaker_5_modifier_passive:StatusEffectPriority()
	return MODIFIER_PRIORITY_NORMAL
end

function icebreaker_5_modifier_passive:PlayEfxAmbient()
  if self.effect_cast_1 then ParticleManager:DestroyParticle(self.effect_cast_1, true) end
	local particle_cast_1 = "particles/units/heroes/hero_ancient_apparition/ancient_apparition_ambient.vpcf"
	self.effect_cast_1 = ParticleManager:CreateParticle(particle_cast_1, PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControlEnt(self.effect_cast_1, 1, self.parent, PATTACH_ABSORIGIN_FOLLOW, "", Vector(0,0,0), true)
	self:AddParticle(self.effect_cast_1, false, false, -1, false, false)
end

function icebreaker_5_modifier_passive:PlayEfxKill()
	local particle_cast = "particles/econ/items/techies/techies_arcana/techies_suicide_kills_arcana.vpcf"
	local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_OVERHEAD_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(effect_cast, 0, self.parent:GetOrigin())

	local nFXIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_pudge/pudge_fleshheap_count.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(nFXIndex, 1, Vector(1, 0, 0))
	ParticleManager:ReleaseParticleIndex(nFXIndex)
end

function icebreaker_5_modifier_passive:PlayEfxSpellLifesteal(target)
	local particle = "particles/items3_fx/octarine_core_lifesteal.vpcf"
	local effect = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControl(effect, 0, target:GetOrigin())
	ParticleManager:ReleaseParticleIndex(effect)
end