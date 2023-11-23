templar_4_modifier_revenge = class({})

function templar_4_modifier_revenge:IsHidden() return true end
function templar_4_modifier_revenge:IsPurgable() return true end
function templar_4_modifier_revenge:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

-- CONSTRUCTORS -----------------------------------------------------------

function templar_4_modifier_revenge:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if IsServer() then
    self:SetStackCount(self.ability:GetSpecialValueFor("hits"))
    self:PlayEfxStart()
    self:StartIntervalThink(1.1)
  end
end

function templar_4_modifier_revenge:OnRefresh(kv)
end

function templar_4_modifier_revenge:OnRemoved()
  if IsServer() then self.parent:StopSound("Templar.Light") end
end

-- API FUNCTIONS -----------------------------------------------------------

function templar_4_modifier_revenge:OnIntervalThink()
  if IsServer() then
    if self.parent:IsOutOfGame() == false then
      self:PlayEfxHit()

      AddModifier(self.parent, self.ability, "_modifier_stun", {duration = 0.1}, false)
  
      ApplyDamage({
        victim = self.parent, attacker = self.caster,
        damage = self.ability:GetSpecialValueFor("damage_hit"),
        damage_type = self.ability:GetAbilityDamageType(),
        ability = self.ability
      })
  
      self:DecrementStackCount()      
    end

    self:StartIntervalThink(self.ability:GetSpecialValueFor("stun_interval"))
  end
end

function templar_4_modifier_revenge:OnStackCountChanged(old)
  if self:GetStackCount() == 0 and self:GetStackCount() ~= old then self:Destroy() end
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function templar_4_modifier_revenge:PlayEfxStart()
  local particle_pre = "particles/units/heroes/hero_dawnbreaker/dawnbreaker_solar_guardian_beam_shaft.vpcf"
  self.pfx = ParticleManager:CreateParticle(particle_pre, PATTACH_ABSORIGIN_FOLLOW, self.parent)
  ParticleManager:SetParticleControl(self.pfx, 0, self.parent:GetOrigin())
	self:AddParticle(self.pfx, false, false, -1, true, false)

  if IsServer() then self.parent:EmitSound("Templar.Light") end
end

function templar_4_modifier_revenge:PlayEfxHit()
  if IsServer() then self.parent:EmitSound("Templar.Combo.Hit") end
end