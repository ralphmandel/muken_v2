trickster_4_modifier_heart = class({})

function trickster_4_modifier_heart:IsHidden() return false end
function trickster_4_modifier_heart:IsPurgable() return true end

-- CONSTRUCTORS -----------------------------------------------------------

function trickster_4_modifier_heart:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if IsServer() then self:SetStackCount(1) end
end

function trickster_4_modifier_heart:OnRefresh(kv)
  if IsServer() then self:IncrementStackCount() end
end

function trickster_4_modifier_heart:OnRemoved()
  RemoveSubStats(self.parent, self.ability, {"max_health_percent"})
end

-- API FUNCTIONS -----------------------------------------------------------


function trickster_4_modifier_heart:OnStackCountChanged(old)
  if self:GetStackCount() > self.ability:GetSpecialValueFor("max_stack") then self:SetStackCount(old) return end

  RemoveSubStats(self.parent, self.ability, {"max_health_percent"})

  AddSubStats(self.parent, self.ability, {
    max_health_percent = self.ability:GetSpecialValueFor("percent_stack") * self:GetStackCount()
  }, false)
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function trickster_4_modifier_heart:GetEffectName()
	return "particles/units/heroes/hero_pangolier/pangolier_heartpiercer_debuff.vpcf"
end

function trickster_4_modifier_heart:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end