neutral_iron_guard_modifier_passive = class({})

function neutral_iron_guard_modifier_passive:IsHidden() return false end
function neutral_iron_guard_modifier_passive:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function neutral_iron_guard_modifier_passive:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()
  
  if IsServer() then self:SetStackCount(0) end
end

function neutral_iron_guard_modifier_passive:OnRefresh(kv)
end

function neutral_iron_guard_modifier_passive:OnRemoved()
end

-- API FUNCTIONS -----------------------------------------------------------

function neutral_iron_guard_modifier_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
    MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end

function neutral_iron_guard_modifier_passive:OnTakeDamage(keys)
  if keys.unit ~= self.parent then return end

  if self.parent:GetHealthPercent() <= 95 then
    AddModifier(self.parent, self.ability, "neutral_iron_guard_modifier_resistance", {}, false)
  end
end

function neutral_iron_guard_modifier_passive:OnAttackLanded(keys)
  if keys.target ~= self.parent then return end
  if self.parent:PassivesDisabled() then return end

  self:PlayEfxHit(keys.attacker)

  if IsServer() then self:IncrementStackCount() end
end

function neutral_iron_guard_modifier_passive:OnIntervalThink()
  if IsServer() then self:DecrementStackCount() end
end

function neutral_iron_guard_modifier_passive:OnStackCountChanged(old)
  RemoveSubStats(self.parent, self.ability, {"armor"})

  if IsServer() then
    if self:GetStackCount() > 0 then
      local mod = AddSubStats(self.parent, self.ability, {armor = self.ability:GetSpecialValueFor("armor") * self:GetStackCount()}, false)
      self:StartIntervalThink(self.ability:GetSpecialValueFor("decrease_time"))
    else
      self:StartIntervalThink(-1)
    end
  end
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function neutral_iron_guard_modifier_passive:GetEffectName()
	return "particles/units/heroes/hero_skeletonking/wraith_king_ambient.vpcf"
end

function neutral_iron_guard_modifier_passive:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function neutral_iron_guard_modifier_passive:PlayEfxHit(target)
  local string = "particles/econ/items/lanaya/ta_ti9_immortal_shoulders/ta_ti9_refract_hit.vpcf"
  local direction = (self.parent:GetOrigin() - target:GetOrigin()):Normalized()
  local origin = self.parent:GetAbsOrigin()
  origin.z = origin.z -200

  local hit_particle = ParticleManager:CreateParticle(string, PATTACH_POINT_FOLLOW, self.parent)
  ParticleManager:SetParticleControlEnt(hit_particle, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", origin, true)
  ParticleManager:SetParticleControlTransformForward(hit_particle, 1, self.parent:GetOrigin(), direction)
  ParticleManager:SetParticleControlEnt(hit_particle, 2, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", origin, true)
  ParticleManager:ReleaseParticleIndex(hit_particle)

  if IsServer() then self.parent:EmitSound("Hero_TemplarAssassin.Refraction.Absorb") end
end