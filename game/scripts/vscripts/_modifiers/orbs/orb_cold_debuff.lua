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

  AddSubStats(self.parent, self.ability, {attack_time = attack_time}, false)
  AddModifier(self.parent, self.ability, "sub_stat_movespeed_decrease", {value = self.slow}, false)
  AddStatusEfx(nil, "orb_cold_debuff_efx", nil, self.parent)

  self:PlayEfxStart()
  self:StartIntervalThink(self.interval)
end

function orb_cold_debuff:OnRefresh(kv)
  if not IsServer() then return end

  self:SetDuration(kv.duration, true)

  self.slow = self.caster:GetDebuffPower(75, self.parent)
  local attack_time = self.caster:GetDebuffPower(0.4, self.parent)

  RemoveSubStats(self.parent, self.ability, {"attack_time"})
  RemoveAllModifiersByNameAndAbility(self.parent, "sub_stat_movespeed_decrease", self.ability)

  AddSubStats(self.parent, self.ability, {attack_time = attack_time}, false)
  AddModifier(self.parent, self.ability, "sub_stat_movespeed_decrease", {value = self.slow}, false)

  self:PlayEfxStart()
end

function orb_cold_debuff:OnRemoved()
  if not IsServer() then return end

  RemoveSubStats(self.parent, self.ability, {"attack_time"})
  RemoveAllModifiersByNameAndAbility(self.parent, "sub_stat_movespeed_decrease", self.ability)
  RemoveStatusEfx(nil, "orb_cold_debuff_efx", nil, self.parent)
end

-- API FUNCTIONS -----------------------------------------------------------

function orb_cold_debuff:OnIntervalThink()
  if not IsServer() then return end

  if self.caster == nil then self:Destroy() return end
  if IsValidEntity(self.caster) == false then self:Destroy() return end

  AddModifier(self.parent, self.ability, "orb_cold__status", {
    inflictor = self.caster:entindex(),
    status_amount = self.caster:GetDebuffPower(self.slow * self.interval * self.status_mult, nil)
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