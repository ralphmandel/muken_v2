templar_3_modifier_hammer = class({})

function templar_3_modifier_hammer:IsHidden() return false end
function templar_3_modifier_hammer:IsPurgable() return true end

-- CONSTRUCTORS -----------------------------------------------------------

function templar_3_modifier_hammer:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  self:PlayEfxStart()
  self:SetStackCount(10)
  self:StartIntervalThink(kv.interval)
end

function templar_3_modifier_hammer:OnRefresh(kv)
  if not IsServer() then return end

  self:PlayEfxStart()
  self:SetStackCount(10)
  self:StartIntervalThink(kv.interval)
end

function templar_3_modifier_hammer:OnRemoved()
  if not IsServer() then return end

  self.parent:RemoveAllModifiersByNameAndAbility("sub_stat_movespeed_percent_decrease", self.ability)
  self.parent:RemoveSubStats(self.ability, {"attack_speed"})
end

-- API FUNCTIONS -----------------------------------------------------------

function templar_3_modifier_hammer:OnIntervalThink()
  if not IsServer() then return end

  self:DecrementStackCount()
end

function templar_3_modifier_hammer:OnStackCountChanged(old)
  if not IsServer() then return end

  if self:GetStackCount() ~= old and self:GetStackCount() == 0 then self:Destroy() return end

  local slow = self.parent:GetStatusResist(self.ability:GetSpecialValueFor("slow_start")) * 0.1 * self:GetStackCount()
  local as = self.parent:GetStatusResist(self.ability:GetSpecialValueFor("special_as_start")) * 0.1 * self:GetStackCount()

  self.parent:RemoveAllModifiersByNameAndAbility("sub_stat_movespeed_percent_decrease", self.ability)
  self.parent:AddModifier(self.ability, "sub_stat_movespeed_percent_decrease", {value = slow})

  self.parent:RemoveSubStats(self.ability, {"attack_speed"})
  self.parent:AddSubStats(self.ability, {attack_speed = as})
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function templar_3_modifier_hammer:GetEffectName()
	return "particles/units/heroes/hero_omniknight/omniknight_shard_hammer_of_purity_overhead_debuff.vpcf"
end

function templar_3_modifier_hammer:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function templar_3_modifier_hammer:PlayEfxStart()
  local string = "particles/units/heroes/hero_omniknight/omniknight_shard_hammer_of_purity_target.vpcf"
  local effect = ParticleManager:CreateParticle(string, PATTACH_ABSORIGIN_FOLLOW, self.parent)
  ParticleManager:SetParticleControl(effect, 0, self.parent:GetOrigin())
  ParticleManager:ReleaseParticleIndex(effect)

  self.parent:EmitSound("Hero_Omniknight.HammerOfPurity.Target")
end