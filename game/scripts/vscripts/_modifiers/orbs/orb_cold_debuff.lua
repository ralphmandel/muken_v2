orb_cold_debuff = class({})

function orb_cold_debuff:IsHidden() return false end
function orb_cold_debuff:IsPurgable() return false end
function orb_cold_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function orb_cold_debuff:GetTexture() return "cold" end

-- CONSTRUCTORS -----------------------------------------------------------

function orb_cold_debuff:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  self.interval = 0.25
  self.status_mult = 0.05
  self.slow = self.caster:GetDebuffPower(100, self.parent)
  local attack_time = self.caster:GetDebuffPower(0.4, self.parent)

  self.parent:AddSubStats(self.ability, {attack_time = attack_time})
  self.parent:AddModifier(self.ability, "sub_stat_movespeed_decrease", {value = self.slow})
  self.parent:AddStatusEfx(nil, nil, "orb_cold_debuff_efx")

  self:PlayEfxStart()
  self:StartIntervalThink(self.interval)
end

function orb_cold_debuff:OnRefresh(kv)
  if not IsServer() then return end

  self:SetDuration(kv.duration, true)

  self.slow = self.caster:GetDebuffPower(75, self.parent)
  local attack_time = self.caster:GetDebuffPower(0.4, self.parent)

  self.parent:RemoveSubStats(self.ability, {"attack_time"})
  self.parent:RemoveAllModifiersByNameAndAbility("sub_stat_movespeed_decrease", self.ability)
  self.parent:AddSubStats(self.ability, {attack_time = attack_time})
  self.parent:AddModifier(self.ability, "sub_stat_movespeed_decrease", {value = self.slow})

  self:PlayEfxStart()
end

function orb_cold_debuff:OnRemoved()
  if not IsServer() then return end

  self.parent:RemoveSubStats(self.ability, {"attack_time"})
  self.parent:RemoveAllModifiersByNameAndAbility("sub_stat_movespeed_decrease", self.ability)
  self.parent:RemoveStatusEfx(nil, nil, "orb_cold_debuff_efx")
end

-- API FUNCTIONS -----------------------------------------------------------

function orb_cold_debuff:OnIntervalThink()
  if not IsServer() then return end

  if self.caster == nil then self:Destroy() return end
  if IsValidEntity(self.caster) == false then self:Destroy() return end

  self.parent:AddModifier(self.ability, "orb_cold__status", {
    inflictor = self.caster:entindex(),
    status_amount = self.slow * self.interval * self.status_mult
  })

  self:StartIntervalThink(self.interval)
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function orb_cold_debuff:GetEffectName()
	return "particles/units/heroes/hero_abaddon/abaddon_curse_frostmourne_debuff.vpcf"
end

function orb_cold_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function orb_cold_debuff:GetStatusEffectName()
	return "particles/econ/items/drow/drow_ti9_immortal/status_effect_drow_ti9_frost_arrow.vpcf"
end

function orb_cold_debuff:StatusEffectPriority()
	return MODIFIER_PRIORITY_HIGH
end

function orb_cold_debuff:PlayEfxStart()
	self.parent:EmitSound("Hero_Icebreaker.Frost")
end