templar_4_modifier_revenge = class({})

function templar_4_modifier_revenge:IsHidden() return true end
function templar_4_modifier_revenge:IsPurgable() return true end
function templar_4_modifier_revenge:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

-- CONSTRUCTORS -----------------------------------------------------------

function templar_4_modifier_revenge:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  self.parent:RemoveAllModifiersByNameAndAbility("_modifier_silence", self.ability)
  self.parent:RemoveAllModifiersByNameAndAbility("_modifier_blind", self.ability)

  self.silence = self.parent:AddModifier(self.ability, "_modifier_silence", {})
  self.blind = self.parent:AddModifier(self.ability, "_modifier_blind", {
    percent = self.ability:GetSpecialValueFor("blind")
  })

  self:PlayEfxStart(self.ability:GetSpecialValueFor("delay") + 1.8)
  self:SetStackCount(self.ability:GetSpecialValueFor("hits"))
  self:StartIntervalThink(self.ability:GetSpecialValueFor("delay"))
end

function templar_4_modifier_revenge:OnRefresh(kv)
end

function templar_4_modifier_revenge:OnRemoved()
  if not IsServer() then return end

  self.parent:StopSound("Templar.Light")

  self:RemoveDebuff("_modifier_silence", self.silence)
  self:RemoveDebuff("_modifier_blind", self.blind)
end

-- API FUNCTIONS -----------------------------------------------------------

function templar_4_modifier_revenge:OnIntervalThink()
  if not IsServer() then return end

  if self.parent:IsOutOfGame() == false then
    self:PlayEfxHit()

    if self.parent:IsMagicImmune() == false then
      self.parent:AddModifier(self.ability, "_modifier_stun", {
        duration = self.ability:GetSpecialValueFor("special_microstun"), bResist = 1
      })
    end

    ApplyDamage({
      victim = self.parent, attacker = self.caster,
      damage = self.ability:GetSpecialValueFor("damage_hit"),
      damage_type = self.ability:GetAbilityDamageType(),
      ability = self.ability
    })

    self:DecrementStackCount()
  end

  self:StartIntervalThink(self.ability:GetSpecialValueFor("dmg_interval"))
end

function templar_4_modifier_revenge:OnStackCountChanged(old)
  if not IsServer() then return end

  if self:GetStackCount() == 0 and self:GetStackCount() ~= old then self:Destroy() end
end

-- UTILS -----------------------------------------------------------

function templar_4_modifier_revenge:RemoveDebuff(debuff_name, modifier)
  local mods = self.parent:FindAllModifiersByName(debuff_name)
  for _, mod in pairs(mods) do
    if mod == modifier then
      mod:Destroy()
    end
  end
end

-- EFFECTS -----------------------------------------------------------

function templar_4_modifier_revenge:PlayEfxStart(duration)
  local particle_pre = "particles/templar/pillar/templar_pillar.vpcf"
  local pfx = ParticleManager:CreateParticle(particle_pre, PATTACH_ABSORIGIN_FOLLOW, self.parent)
  ParticleManager:SetParticleControl(pfx, 0, self.parent:GetOrigin())
  ParticleManager:SetParticleControl(pfx, 1, Vector(duration, 0, 0))

  self.parent:EmitSound("Templar.Light")
end

function templar_4_modifier_revenge:PlayEfxHit()
  local particle_shake = "particles/osiris/poison_alt/osiris_poison_splash_shake.vpcf"
	local effect = ParticleManager:CreateParticle(particle_shake, PATTACH_ABSORIGIN, self.parent)
	ParticleManager:SetParticleControl(effect, 0, self.parent:GetOrigin())
	ParticleManager:SetParticleControl(effect, 1, Vector(35, 0, 0))

  self.parent:EmitSound("Templar.Combo.Hit")
end