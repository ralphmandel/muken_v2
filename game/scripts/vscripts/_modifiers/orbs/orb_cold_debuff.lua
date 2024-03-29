orb_cold_debuff = class({})

function orb_cold_debuff:IsHidden() return false end
function orb_cold_debuff:IsPurgable() return true end
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

  self.base_slow = 100
  self.base_attack_time = 0.4

  self.spell_immune = self.parent:IsMagicImmune()
  self.slow = self.caster:GetDebuffPower(self.base_slow, self.parent)
  self.attack_time = self.caster:GetDebuffPower(self.base_attack_time, self.parent)
  self:CheckSpellImmunity()

  self.parent:AddStatusEfx(nil, nil, "orb_cold_debuff_efx")

  self:PlayEfxStart()
  self:StartIntervalThink(self.interval)
end

function orb_cold_debuff:OnRefresh(kv)
  if not IsServer() then return end

  self:SetDuration(kv.duration, true)

  self.spell_immune = self.parent:IsMagicImmune()
  self.slow = self.caster:GetDebuffPower(self.base_slow, self.parent)
  self.attack_time = self.caster:GetDebuffPower(self.base_attack_time, self.parent)
  self:CheckSpellImmunity()

  self:PlayEfxStart()
end

function orb_cold_debuff:OnRemoved()
  if not IsServer() then return end

  self.parent:RemoveSubStats(self.ability, {"attack_time", "slow"})
  self.parent:RemoveStatusEfx(nil, nil, "orb_cold_debuff_efx")
end

-- API FUNCTIONS -----------------------------------------------------------

function orb_cold_debuff:DeclareFunctions()
	local funcs = {
    MODIFIER_EVENT_ON_STATE_CHANGED
	}

	return funcs
end

function orb_cold_debuff:OnStateChanged(keys)
  if keys.unit ~= self.parent then return end
  
  if self.spell_immune == false and self.parent:PassivesDisabled() then
    self:CheckSpellImmunity()
    self.passives_disabled = true
  end

  if self.spell_immune == true and self.parent:PassivesDisabled() == false then
    self:CheckSpellImmunity()
    self.passives_disabled = false
  end
end

function orb_cold_debuff:OnIntervalThink()
  if not IsServer() then return end

  if self.caster == nil then self:Destroy() return end
  if IsValidEntity(self.caster) == false then self:Destroy() return end

  self.parent:IncrementStatus("status_bar_cold", self.ability, self.caster, self.slow * self.interval * self.status_mult)

  self:StartIntervalThink(self.interval)
end

-- UTILS -----------------------------------------------------------

function orb_cold_debuff:CheckSpellImmunity()
  self.parent:RemoveSubStats(self.ability, {"attack_time", "slow"})

  if self.parent:IsMagicImmune() == false then
    self.parent:AddSubStats(self.ability, {attack_time = self.attack_time, slow = self.slow})
  end
end

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