bloodstained_4_modifier_passive = class({})

function bloodstained_4_modifier_passive:IsHidden() return true end
function bloodstained_4_modifier_passive:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function bloodstained_4_modifier_passive:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  self.parent:AddModifier(self.ability, "orb_bleed__modifier", {})
end

function bloodstained_4_modifier_passive:OnRefresh(kv)
end

function bloodstained_4_modifier_passive:OnRemoved()
  if not IsServer() then return end

  self.parent:RemoveAllModifiersByNameAndAbility("orb_bleed__modifier", self.ability)
end

-- API FUNCTIONS -----------------------------------------------------------

function bloodstained_4_modifier_passive:OnBloodLoss(keys)
  if keys.attacker ~= self.parent then return end

  self.parent:ApplyHeal(keys.damage * self.ability:GetSpecialValueFor("heal_percent") * 0.01, self.ability, false)
  self:PlayEfxHeal()
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function bloodstained_4_modifier_passive:PlayEfxHeal()
  local particle_cast2 = "particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodbath_eztzhok.vpcf"
	local effect_cast2 = ParticleManager:CreateParticle(particle_cast2, PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(effect_cast2, 0, self.parent:GetOrigin())
	ParticleManager:SetParticleControl(effect_cast2, 1, self.parent:GetOrigin())
	ParticleManager:ReleaseParticleIndex(effect_cast2)

  self.parent:EmitSound("Hero_LifeStealer.Consume.TI10")
end