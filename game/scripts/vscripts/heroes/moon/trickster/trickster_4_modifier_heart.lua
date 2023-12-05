trickster_4_modifier_heart = class({})

function trickster_4_modifier_heart:IsHidden() return false end
function trickster_4_modifier_heart:IsPurgable() return true end

-- CONSTRUCTORS -----------------------------------------------------------

function trickster_4_modifier_heart:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if IsServer() then
    self:SetStackCount(1)
    self:PlayEfxHeart()
    self.parent:EmitSound("Hero_Pangolier.HeartPiercer.Creep")
  end
end

function trickster_4_modifier_heart:OnRefresh(kv)
  if IsServer() then self:IncrementStackCount() end
end

function trickster_4_modifier_heart:OnRemoved()
  RemoveSubStats(self.parent, self.ability, {"max_health_percent"})
end

-- API FUNCTIONS -----------------------------------------------------------


function trickster_4_modifier_heart:OnStackCountChanged(old)
  if self:GetStackCount() > self.ability:GetSpecialValueFor("max_stack") then self:SetStackCount(old) return end

  if IsServer() and self:GetStackCount() > old then
    if self.efx then
      ParticleManager:SetParticleControl(self.efx, 1, Vector(75 + (self:GetStackCount() * 4), 0, self:GetStackCount() + 25))
    end
  end

  RemoveSubStats(self.parent, self.ability, {"max_health_percent"})

  AddSubStats(self.parent, self.ability, {
    max_health_percent = self.ability:GetSpecialValueFor("percent_stack") * self:GetStackCount()
  }, false)
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function trickster_4_modifier_heart:PlayEfxHeart()
  if self.efx then
    ParticleManager:DestroyParticle(self.efx, true)
    self.efx = nil
  end

  local particle_cast = "particles/trickster/bloodloss/trickster_bloodloss.vpcf"
  self.efx = ParticleManager:CreateParticle(particle_cast, PATTACH_OVERHEAD_FOLLOW, self.parent)
  ParticleManager:SetParticleControl(self.efx, 1, Vector(75 + (self:GetStackCount() * 4), 0, self:GetStackCount() + 25))
  self:AddParticle(self.efx, false, false, -1, true, false)
end