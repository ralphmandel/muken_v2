paladin_2_modifier_aura_effect = class({})

function paladin_2_modifier_aura_effect:IsHidden() return true end
function paladin_2_modifier_aura_effect:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function paladin_2_modifier_aura_effect:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  self.tick = self.ability:GetSpecialValueFor("special_burn_tick")

  AddModifier(self.parent, self.ability, "paladin_2_modifier_burn_efx", {}, false)

  if IsServer() then
    self:PlayEfxStart()
    self:StartIntervalThink(self.tick)
  end
end

function paladin_2_modifier_aura_effect:OnRefresh(kv)
end

function paladin_2_modifier_aura_effect:OnRemoved()
  if IsServer() then self.parent:StopSound("Hero_Batrider.Firefly.loop") end

  self.parent:RemoveModifierByName("paladin_2_modifier_burn_efx")
end

-- API FUNCTIONS -----------------------------------------------------------

-- UTILS -----------------------------------------------------------

function paladin_2_modifier_aura_effect:OnIntervalThink()
  ApplyDamage({
    victim = self.parent, attacker = self.caster, ability = self.ability,
    damage = self.ability:GetSpecialValueFor("special_burn_damage") * self.tick,
    damage_type = self.ability:GetAbilityDamageType(),
  })

	if IsServer() then self:StartIntervalThink(self.tick) end
end

-- EFFECTS -----------------------------------------------------------

function paladin_2_modifier_aura_effect:PlayEfxStart(radius)
  if IsServer() then
    self.parent:EmitSound("Hero_Inquisitor.Shield.Fire")
    self.parent:EmitSound("Hero_Batrider.Firefly.loop")
  end
end