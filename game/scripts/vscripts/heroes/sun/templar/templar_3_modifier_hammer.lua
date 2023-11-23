templar_3_modifier_hammer = class({})

function templar_3_modifier_hammer:IsHidden() return false end
function templar_3_modifier_hammer:IsPurgable() return true end

-- CONSTRUCTORS -----------------------------------------------------------

function templar_3_modifier_hammer:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if IsServer() then
    self:SetStackCount(10)
    self:StartIntervalThink(kv.interval)
    self:PlayEfxStart()
  end
end

function templar_3_modifier_hammer:OnRefresh(kv)
  if IsServer() then
    self:SetStackCount(10)
    self:StartIntervalThink(kv.interval)
    self:PlayEfxStart()
  end
end

function templar_3_modifier_hammer:OnRemoved()
  RemoveAllModifiersByNameAndAbility(self.parent, "sub_stat_movespeed_percent_decrease", self.ability)
end

-- API FUNCTIONS -----------------------------------------------------------

function templar_3_modifier_hammer:OnIntervalThink()
  if IsServer() then self:DecrementStackCount() end
end

function templar_3_modifier_hammer:OnStackCountChanged(old)
  if self:GetStackCount() ~= old and self:GetStackCount() == 0 then self:Destroy() return end

  local slow = CalcStatus(self.ability:GetSpecialValueFor("slow_start") * 0.1 * self:GetStackCount(), self.caster, self.parent)
  RemoveAllModifiersByNameAndAbility(self.parent, "sub_stat_movespeed_percent_decrease", self.ability)
  AddModifier(self.parent, self.ability, "sub_stat_movespeed_percent_decrease", {value = slow}, false)
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

  if IsServer() then self.parent:EmitSound("Hero_Omniknight.HammerOfPurity.Target") end
end