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
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end

function fleaman_u_modifier_passive:OnAttackLanded(keys)
	if keys.attacker ~= self.parent then return end
  if keys.target:GetTeamNumber() == self.parent:GetTeamNumber() then return end
	if self.parent:PassivesDisabled() then return end
  if self.parent:IsIllusion() then return end
  if keys.target:FindAbilityByName("_ability_str") == nil then return end

  local damage_steal = self.ability:GetSpecialValueFor("damage_steal")
  local duration = self.ability:GetSpecialValueFor("duration")
  local chain_hits = self.ability:GetSpecialValueFor("special_chain_hits")
  local chain_damage = self.ability:GetSpecialValueFor("special_chain_damage")
  local chain_chance = self.ability:GetSpecialValueFor("special_chain_chance")

  local modifier = AddModifier(self.parent, self.ability, "sub_stat_modifier", {
    duration = duration, attack_damage = damage_steal
  }, false)
  
  AddModifier(keys.target, self.ability, "sub_stat_modifier", {
    duration = duration, attack_damage = -damage_steal
  }, false)

  if IsServer() then
    self:SetStackCount(self:GetStackCount() + damage_steal)
    self:PlayEfxHit(keys.target)
  end

  modifier:SetEndCallback(function(interrupted)
    local modifiers = self.parent:FindAllModifiersByName("sub_stat_modifier")
    local stacks = 0

    if modifiers then
      for k, mod in pairs(modifiers) do
        if mod.kv.attack_damage and mod:GetAbility() == self.ability then
          stacks = stacks + mod.kv.attack_damage
        end
      end
    end

    if IsServer() then self:SetStackCount(stacks) end
  end)

  if RandomFloat(0, 100) < chain_chance and self.ability:IsCooldownReady() then
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