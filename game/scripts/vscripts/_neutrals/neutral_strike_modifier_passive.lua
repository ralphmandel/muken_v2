neutral_strike_modifier_passive = class({})

function neutral_strike_modifier_passive:IsHidden() return true end
function neutral_strike_modifier_passive:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function neutral_strike_modifier_passive:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()
  self.strike = false

  if IsServer() then self:StartIntervalThink(2) end
end

function neutral_strike_modifier_passive:OnRefresh(kv)
end

function neutral_strike_modifier_passive:OnRemoved()
end

-- API FUNCTIONS -----------------------------------------------------------

function neutral_strike_modifier_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end

function neutral_strike_modifier_passive:OnAttackLanded(keys)
  if not IsServer() then return end
  
  if keys.attacker ~= self.parent then return end

  if self.parent:HasModifier("neutral_strike_modifier_wind") then
    keys.target:EmitSound("Crocodile.Strike")
  end

  self.parent:RemoveModifierByName("neutral_strike_modifier_wind")

  local interval = 0

  if self.strike == true then
    interval = self.ability:GetEffectiveCooldown(self.ability:GetLevel())
    self.ability:StartCooldown(interval)
    self.strike = false
  else
    interval = self.ability:GetCooldownTimeRemaining() + 0.5
    self.ability:StartCooldown(interval)
  end

  self:StartIntervalThink(interval)
end

function neutral_strike_modifier_passive:OnIntervalThink()
  if not IsServer() then return end
  
  if self.parent:PassivesDisabled() then self:StartIntervalThink(0.5) end

  AddModifier(self.parent, self.ability, "neutral_strike_modifier_wind", {}, false)
  self.parent:GetMainStat("STR"):SetForceCrit(100, self.ability:GetSpecialValueFor("critical_damage"))
  self.strike = true

  self:StartIntervalThink(-1)
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------