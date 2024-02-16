neutral_mana_burn = class({})
LinkLuaModifier("neutral_mana_burn_modifier_orb", "_neutrals/neutral_mana_burn_modifier_orb", LUA_MODIFIER_MOTION_NONE)

function neutral_mana_burn:Spawn()
  if not IsServer() then return end
  
  Timers:CreateTimer((0.2), function()
    if IsServer() then
      self:SetLevel(self:GetMaxLevel())
      self:ToggleAutoCast()
    end
  end)
end

function neutral_mana_burn:GetIntrinsicModifierName()
  return "neutral_mana_burn_modifier_orb"
end

function neutral_mana_burn:GetProjectileName()
  return "particles/units/heroes/hero_ancient_apparition/ancient_apparition_chilling_touch_projectile.vpcf"
end

function neutral_mana_burn:OnOrbFire(keys)
  local caster = self:GetCaster()
  if IsServer() then caster:EmitSound("Hero_Ancient_Apparition.ChillingTouch.Cast") end
end

function neutral_mana_burn:OnOrbImpact(keys)
  local caster = self:GetCaster()
  if IsServer() then keys.target:EmitSound("Hero_Ancient_Apparition.ChillingTouch.Target") end

  if keys.target:IsMagicImmune() == false then
    keys.target:RemoveAllModifiersByNameAndAbility("sub_stat_movespeed_percent_decrease", self)
    keys.target:AddModifier(self, "sub_stat_movespeed_percent_decrease", {
      value = caster:GetDebuffPower(self:GetSpecialValueFor("slow_percent"), keys.target),
      duration = self:GetSpecialValueFor("slow_duration")
    })
  end

  local mana_burn = keys.target:ApplyMana(-self:GetSpecialValueFor("mana_burn"), self, true, nil, true)

  ApplyDamage({
    victim = keys.target, attacker = caster,
    ability = self, damage = mana_burn,
    damage_type = self:GetAbilityDamageType()
  })
end

function neutral_mana_burn:OnOrbFail(keys)
end