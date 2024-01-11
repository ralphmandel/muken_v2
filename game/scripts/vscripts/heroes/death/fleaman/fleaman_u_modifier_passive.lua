fleaman_u_modifier_passive = class({})

function fleaman_u_modifier_passive:IsHidden() return false end
function fleaman_u_modifier_passive:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function fleaman_u_modifier_passive:OnCreated(kv)
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then self:SetStackCount(0) end
end

function fleaman_u_modifier_passive:OnRefresh(kv)
end

function fleaman_u_modifier_passive:OnRemoved()
end

-- API FUNCTIONS -----------------------------------------------------------

function fleaman_u_modifier_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACKED
	}

	return funcs
end

function fleaman_u_modifier_passive:OnAttacked(keys)
	if keys.attacker ~= self.parent then return end
  if keys.target:GetTeamNumber() == self.parent:GetTeamNumber() then return end
	if self.parent:PassivesDisabled() then return end
  if self.parent:IsIllusion() then return end
  if keys.target:FindAbilityByName("_ability_str") == nil then return end

  local attack_steal = self.ability:GetSpecialValueFor("attack_steal")
  local duration = self.ability:GetSpecialValueFor("duration")
  local chain_hits = self.ability:GetSpecialValueFor("special_chain_hits")
  local chain_damage = self.ability:GetSpecialValueFor("special_chain_damage")
  local chain_chance = self.ability:GetSpecialValueFor("special_chain_chance")
  local manasteal = keys.original_damage * self.ability:GetSpecialValueFor("special_manasteal") * 0.01
  local lifesteal = keys.original_damage * self.ability:GetSpecialValueFor("special_lifesteal") * 0.01
  local modifier = AddSubStats(self.parent, self.ability, {duration = duration, attack_damage = attack_steal}, false)
  AddSubStats(keys.target, self.ability, {duration = duration, attack_damage = -attack_steal}, false)

  if IsServer() then
    self:SetStackCount(self:GetStackCount() + attack_steal)
    self:PlayEfxHit(keys.target)
  end

  modifier:SetEndCallback(function(interrupted)
    local modifiers = self.parent:FindAllModifiersByName("sub_stat_modifier")
    local stacks = 0

    if modifiers then
      for _, mod in pairs(modifiers) do
        if mod.kv.attack_damage and mod:GetAbility() == self.ability then
          stacks = stacks + mod.kv.attack_damage
        end
      end
    end

    if IsServer() then self:SetStackCount(stacks) end
  end)

  if manasteal > 0 then
    StealMana(keys.target, keys.attacker, self.ability, manasteal)
    self:PlayEfxManasteal(keys.attacker)
  end

  if lifesteal > 0 then
    keys.attacker:Heal(lifesteal, self.ability)
    self:PlayEfxLifesteal(keys.attacker)
  end

  if RandomFloat(0, 100) < CalcLuck(self.parent, chain_chance) and self.ability:IsCooldownReady() then
    AddModifier(self.parent, self.ability, "fleaman_u_modifier_chain", {target_index = keys.target:GetEntityIndex()}, false)
    self.ability:StartCooldown(self.ability:GetEffectiveCooldown(self.ability:GetLevel()))
  end
end

function fleaman_u_modifier_passive:OnStackCountChanged(old)
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function fleaman_u_modifier_passive:PlayEfxHit(target)
	local particle_cast = "particles/econ/items/slark/slark_ti6_blade/slark_ti6_blade_essence_shift.vpcf"
	local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(effect_cast, 1, self.caster:GetOrigin() + Vector(0, 0, 64))
  ParticleManager:SetParticleControlTransformForward(effect_cast, 3, self.parent:GetOrigin(), self.caster:GetLeftVector())
	ParticleManager:ReleaseParticleIndex(effect_cast)

	if IsServer() then target:EmitSound("Hero_BountyHunter.Jinada") end
end

function fleaman_u_modifier_passive:PlayEfxManasteal(target)
	local particle = "particles/generic/give_mana.vpcf"
	local effect = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(effect, 1, target:GetOrigin())
	ParticleManager:ReleaseParticleIndex(effect)
end

function fleaman_u_modifier_passive:PlayEfxLifesteal(target)
	local particle = "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf"
	local effect = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(effect, 1, target:GetOrigin())
	ParticleManager:ReleaseParticleIndex(effect)
end