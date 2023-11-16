lawbreaker_1_modifier_passive = class({})

function lawbreaker_1_modifier_passive:IsHidden() return false end
function lawbreaker_1_modifier_passive:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function lawbreaker_1_modifier_passive:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  self.gunslinger = self.parent:AddAbility("muerta_gunslinger")
  self.gunslinger:SetCurrentAbilityCharges(0)
  self.gunslinger:UpgradeAbility(true)
  self.gunslinger:SetHidden(true)

  if IsServer() then self:SetStackCount(0) end
end

function lawbreaker_1_modifier_passive:OnRefresh(kv)
  RemoveSubStats(self.parent, self.ability, {"critical_chance"})

  AddModifier(self.parent, self.ability, "sub_stat_modifier", {
    critical_chance = self.ability:GetSpecialValueFor("special_critical_chance")
  }, false)
end

function lawbreaker_1_modifier_passive:OnRemoved()
  RemoveSubStats(self.parent, self.ability, {"critical_chance"})
end

-- API FUNCTIONS -----------------------------------------------------------

function lawbreaker_1_modifier_passive:CheckState()
	local state = {
		[MODIFIER_STATE_CANNOT_MISS] = true
	}

	return state
end

function lawbreaker_1_modifier_passive:DeclareFunctions()
	local funcs = {
    MODIFIER_PROPERTY_PROJECTILE_NAME,
    MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
    MODIFIER_EVENT_ON_ATTACK_START,
    MODIFIER_EVENT_ON_ATTACKED,
    MODIFIER_EVENT_ON_PROJECTILE_DODGE,
	}

	return funcs
end

function lawbreaker_1_modifier_passive:GetModifierAttackRangeBonus(keys)
  return self:GetAbility():GetSpecialValueFor("special_attack_range")
end

function lawbreaker_1_modifier_passive:GetModifierProjectileName()
  if self:GetStackCount() >= self:GetAbility():GetSpecialValueFor("max_hit") - 1 then
    return "particles/units/heroes/hero_muerta/muerta_base_attack_alt.vpcf"
  end
end

function lawbreaker_1_modifier_passive:OnAttackStart(keys)
  if keys.attacker ~= self.parent then return end

  if self.parent:PassivesDisabled() == false and self:GetStackCount() == self.ability:GetSpecialValueFor("max_hit") - 1 then
    self.gunslinger:SetCurrentAbilityCharges(1)
  else
    self.gunslinger:SetCurrentAbilityCharges(0)
  end

  self.gunslinger:SetLevel(1)
end

function lawbreaker_1_modifier_passive:OnAttacked(keys)
  if keys.attacker ~= self.parent then return end

  if self.parent:PassivesDisabled() == false and self:GetStackCount() >= self.ability:GetSpecialValueFor("max_hit") - 1 then
    local heal = keys.original_damage * self.ability:GetSpecialValueFor("lifesteal") * 0.01
    self.parent:Heal(heal, self.ability)
    self:PlayEfxLifesteal(keys.attacker)
  end

  if IsServer() then self:IncrementStackCount() end
end

function lawbreaker_1_modifier_passive:OnProjectileDodge(keys)
  if MainStats(keys.target, "AGI") == nil then return end

  local attacker = MainStats(keys.target, "AGI").proj_miss_attacker
  if attacker ~= self.parent then return end
  if IsServer() then self:IncrementStackCount() end
end

function lawbreaker_1_modifier_passive:OnStackCountChanged(old)
  local double = 1
  if self.parent:HasModifier("lawbreaker_2_modifier_combo") then double = 0 end

  if self:GetStackCount() >= self.ability:GetSpecialValueFor("max_hit") + double then 
    if IsServer() then self:SetStackCount(0) end
  end

  -- if self:GetStackCount() == self.ability:GetSpecialValueFor("max_hit") then
  --   local critical_damage = MainStats(self.parent, "STR"):GetCriticalDamage() + self.ability:GetSpecialValueFor("crit_dmg")
  --   MainStats(self.parent, "STR"):SetForceCrit(100, critical_damage)
  -- end
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function lawbreaker_1_modifier_passive:PlayEfxLifesteal(target)
	local particle = "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf"
	local effect = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(effect, 1, target:GetOrigin())
	ParticleManager:ReleaseParticleIndex(effect)

  if IsServer() then target:EmitSound("Hero_Muerta.PartingShot.Start") end
end