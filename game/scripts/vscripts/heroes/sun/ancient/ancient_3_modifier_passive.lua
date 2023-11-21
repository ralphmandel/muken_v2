ancient_3_modifier_passive = class({})

function ancient_3_modifier_passive:IsHidden() return false end
function ancient_3_modifier_passive:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function ancient_3_modifier_passive:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  AddModifier(self.parent, self.ability, "sub_stat_modifier", {
    attack_time = self.ability:GetSpecialValueFor("attack_time")
  }, false)
end

function ancient_3_modifier_passive:OnRefresh(kv)
end

function ancient_3_modifier_passive:OnRemoved()
  RemoveSubStats(self.parent, self.ability, "attack_time")
end

-- API FUNCTIONS -----------------------------------------------------------

function ancient_3_modifier_passive:DeclareFunctions()
	local funcs = {
    MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
    MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    MODIFIER_EVENT_ON_TAKEDAMAGE
	}

	return funcs
end

function ancient_3_modifier_passive:GetModifierBaseDamageOutgoing_Percentage(keys)
  return self:GetAbility():GetSpecialValueFor("damage_percent")
end

function ancient_3_modifier_passive:GetModifierConstantHealthRegen(keys)
  return self:GetParent():GetMaxHealth() * self:GetAbility():GetSpecialValueFor("hp_regen_percent") * 0.01
end

function ancient_3_modifier_passive:OnTakeDamage(keys)
  if keys.attacker ~= self.parent then return end
  if keys.damage_type ~= DAMAGE_TYPE_PHYSICAL then return end
  if keys.unit:IsMagicImmune() then return end
  if self.parent:PassivesDisabled() then return end

  local crit = true

  if keys.damage_category == DOTA_DAMAGE_CATEGORY_ATTACK then
    crit = MainStats(self.parent, "STR").has_crit
    PlayEfxAncientStun(self.parent, keys.damage, crit)
  end

  AddModifier(keys.unit, self.ability, "_modifier_stun", {
    duration = keys.damage * self.ability:GetSpecialValueFor("stun_duration") * 0.01
  }, false)

  PlayEfxAncientStun(keys.unit, keys.damage, crit)
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------