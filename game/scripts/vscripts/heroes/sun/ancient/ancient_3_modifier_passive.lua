ancient_3_modifier_passive = class({})

function ancient_3_modifier_passive:IsHidden() return false end
function ancient_3_modifier_passive:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function ancient_3_modifier_passive:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if IsServer() then self:SetStackCount(0) end
end

function ancient_3_modifier_passive:OnRefresh(kv)
end

function ancient_3_modifier_passive:OnRemoved()
  RemoveSubStats(self.parent, self.ability, {"attack_time"})
end

-- API FUNCTIONS -----------------------------------------------------------

function ancient_3_modifier_passive:DeclareFunctions()
	local funcs = {
    MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
    MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    MODIFIER_EVENT_ON_ATTACKED,
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

function ancient_3_modifier_passive:GetModifierAttackSpeedBonus_Constant()
  if self:GetStackCount() == 0 then return 0 end
  return 400
end

function ancient_3_modifier_passive:OnAttacked(keys)
  if keys.target == self.parent then
    if RandomFloat(0, 100) < self.ability:GetSpecialValueFor("special_return_chance") then
      if keys.damage_flags ~= 31 then
        ApplyDamage({
          damage = keys.original_damage * self.ability:GetSpecialValueFor("special_return_damage") * 0.01,
          damage_type = DAMAGE_TYPE_PHYSICAL,
          attacker = self.caster, victim = keys.attacker, ability = self.ability,
          damage_flags = 31 --DOTA_DAMAGE_FLAG_REFLECTION
        })
      end
    end
    return
  end

  if keys.attacker ~= self.parent then return end
  if IsServer() then self:DecrementStackCount() end

  if keys.attacker:PassivesDisabled() then return end
  
  if keys.target:IsMagicImmune() == false and self.ability:IsCooldownReady() then
    self.ability:StartCooldown(self.ability:GetEffectiveCooldown(self.ability:GetLevel()))

    AddModifier(keys.target, self.ability, "_modifier_break", {
      duration = self.ability:GetSpecialValueFor("special_break_duration")
    }, true)
  end

  if RandomFloat(0, 100) < self.ability:GetSpecialValueFor("special_double_chance")
  and MainStats(self.parent, "STR").has_crit == false then
    if IsServer() then self:IncrementStackCount() end
  end
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

function ancient_3_modifier_passive:OnStackCountChanged(old)
  local attack_time = self.ability:GetSpecialValueFor("attack_time")

  if self:GetStackCount() > 0 then attack_time = 0 end

  RemoveSubStats(self.parent, self.ability, {"attack_time"})
  AddModifier(self.parent, self.ability, "sub_stat_modifier", {attack_time = attack_time}, false)
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------