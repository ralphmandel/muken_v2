ancient_4_modifier_aura_effect = class({})

function ancient_4_modifier_aura_effect:IsHidden() return false end
function ancient_4_modifier_aura_effect:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function ancient_4_modifier_aura_effect:OnCreated(kv)
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

  AddSubStats(self.parent, self.ability, {
    max_health = self.ability:GetSpecialValueFor("max_health"),
    incoming_heal = self.ability:GetSpecialValueFor("special_heal_amp"),
    incoming_buff = self.ability:GetSpecialValueFor("special_buff_amp")
  }, false)
end

function ancient_4_modifier_aura_effect:OnRefresh(kv)
end

function ancient_4_modifier_aura_effect:OnRemoved()
  RemoveSubStats(self.parent, self.ability, {"max_health", "incoming_heal", "incoming_buff"})
end

-- API FUNCTIONS -----------------------------------------------------------

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function ancient_4_modifier_aura_effect:GetEffectName()
	return "particles/ancient/flesh/ancient_aura_effect.vpcf"
end

function ancient_4_modifier_aura_effect:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end