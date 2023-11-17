lawbreaker_2_modifier_passive = class({})

function lawbreaker_2_modifier_passive:IsHidden() return true end
function lawbreaker_2_modifier_passive:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function lawbreaker_2_modifier_passive:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if IsServer() then
    self.ability:PlayEfxStart(true)
    self:StartIntervalThink(FrameTime())
  end
end

function lawbreaker_2_modifier_passive:OnRefresh(kv)
end

function lawbreaker_2_modifier_passive:OnRemoved()
end

-- API FUNCTIONS -----------------------------------------------------------

function lawbreaker_2_modifier_passive:OnIntervalThink()
  if self.parent:HasModifier("lawbreaker_2_modifier_delay_reload") == false
  and self.parent:HasModifier("lawbreaker_2_modifier_reload") == false
  and self.parent:HasModifier("lawbreaker_2_modifier_combo") == false
  and self.ability:GetCurrentAbilityCharges() < self.ability:GetMaxAbilityCharges(self.ability:GetLevel())
  and self.parent:IsAttacking() == false
  and self.parent:IsMoving() == false
  and self.parent:IsStunned() == false
  and self.parent:IsHexed() == false
  and self.ability.casting == false then
    AddModifier(self.caster, self.ability, "lawbreaker_2_modifier_delay_reload", {}, false)
  end

  if self.ability.particle then
    for bar = 1, self.ability:GetSpecialValueFor("max_shots") do
      local value = 1
      if bar > self.ability:GetCurrentAbilityCharges() then value = 0 end
      ParticleManager:SetParticleControl(self.ability.particle, bar + 1, Vector(value, 0, 0))
    end
  end

  local min_shots = self.ability:GetSpecialValueFor("min_shots")
  self.ability:SetActivated(self.ability:GetCurrentAbilityCharges() >= min_shots)

  if IsServer() then
    self:StartIntervalThink(FrameTime())
  end
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------