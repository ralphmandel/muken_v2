orb_ice_debuff = class({})

function orb_ice_debuff:IsHidden() return false end
function orb_ice_debuff:IsPurgable() return false end
function orb_ice_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function orb_ice_debuff:GetTexture() return "cold" end

-- CONSTRUCTORS -----------------------------------------------------------

function orb_ice_debuff:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer then return end

  self.interval = 0.25
  self.status_mult = 0.05
  self.slow = self.caster:GetDebuffPower(100, self.parent)
  local attack_time = self.caster:GetDebuffPower(0.4, self.parent)

  AddSubStats(self.parent, self.ability, {attack_time = attack_time}, false)
  AddModifier(self.parent, self.ability, "sub_stat_movespeed_decrease", {value = self.slow}, false)

  self:PlayEfxStart()
  self:StartIntervalThink(self.interval)
end

function orb_ice_debuff:OnRefresh(kv)
  if not IsServer then return end

  self:SetDuration(kv.duration, true)

  self.slow = self.caster:GetDebuffPower(75, self.parent)
  local attack_time = self.caster:GetDebuffPower(0.4, self.parent)

  RemoveSubStats(self.parent, self.ability, {"attack_time"})
  RemoveAllModifiersByNameAndAbility(self.parent, "sub_stat_movespeed_decrease", self.ability)

  AddSubStats(self.parent, self.ability, {attack_time = attack_time}, false)
  AddModifier(self.parent, self.ability, "sub_stat_movespeed_decrease", {value = self.slow}, false)

  self:PlayEfxStart()
end

function orb_ice_debuff:OnRemoved()
  if not IsServer then return end

  RemoveSubStats(self.parent, self.ability, {"attack_time"})
  RemoveAllModifiersByNameAndAbility(self.parent, "sub_stat_movespeed_decrease", self.ability)
end

-- API FUNCTIONS -----------------------------------------------------------

function orb_ice_debuff:OnIntervalThink()
  if not IsServer() then return end

  if self.caster == nil then self:Destroy() return end
  if IsValidEntity(self.caster) == false then self:Destroy() return end

  AddModifier(self.parent, self.ability, "orb_ice__status", {
    inflictor = self.caster:entindex(),
    status_amount = CalcStatusDebuffAmp(self.slow * self.interval * self.status_mult, self.caster)
  })

  self:StartIntervalThink(self.interval)
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function orb_ice_debuff:GetEffectName()
	return "particles/units/heroes/hero_abaddon/abaddon_curse_frostmourne_debuff.vpcf"
end

function orb_ice_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function orb_ice_debuff:PlayEfxStart()
	self.parent:EmitSound("Hero_Icebreaker.Frost")
end