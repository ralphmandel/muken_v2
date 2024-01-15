neutral_rage_modifier_buff = class({})

function neutral_rage_modifier_buff:IsHidden() return false end
function neutral_rage_modifier_buff:IsPurgable() return true end

-- CONSTRUCTORS -----------------------------------------------------------

function neutral_rage_modifier_buff:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if IsServer() then
    self.parent:EmitSound("Hero_Ursa.Enrage")

    AddSubStats(self.parent, self.ability, {
      attack_speed = self.ability:GetSpecialValueFor("attack_speed")
    }, false)
  end
end

function neutral_rage_modifier_buff:OnRefresh(kv)
end

function neutral_rage_modifier_buff:OnRemoved()
  if not IsServer() then return end

  RemoveSubStats(self.parent, self.ability, {"attack_speed"})
end

-- API FUNCTIONS -----------------------------------------------------------

function neutral_rage_modifier_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACKED
	}

	return funcs
end

function neutral_rage_modifier_buff:OnAttacked(keys)
  if not IsServer() then return end
  
  if keys.attacker ~= self.parent then return end

  self.parent:Heal(keys.original_damage * self.ability:GetSpecialValueFor("lifesteal") * 0.01, self.ability)
  self:PlayEfxLifesteal()
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function neutral_rage_modifier_buff:GetStatusEffectName()
  return "particles/econ/items/lifestealer/lifestealer_immortal_backbone/status_effect_life_stealer_immortal_rage.vpcf"
end

function neutral_rage_modifier_buff:StatusEffectPriority()
	return MODIFIER_PRIORITY_NORMAL
end

function neutral_rage_modifier_buff:GetEffectName()
	return "particles/units/heroes/hero_ursa/ursa_enrage_buff.vpcf"
end

function neutral_rage_modifier_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function neutral_rage_modifier_buff:PlayEfxLifesteal()
	local particle = "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf"
	local effect = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(effect, 1, self.parent:GetOrigin())
	ParticleManager:ReleaseParticleIndex(effect)
end