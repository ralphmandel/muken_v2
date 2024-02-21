templar_2_modifier_protection = class({})

function templar_2_modifier_protection:IsHidden() return false end
function templar_2_modifier_protection:IsPurgable() return true end

-- CONSTRUCTORS -----------------------------------------------------------

function templar_2_modifier_protection:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  self.parent:AddSubStats(self.ability, {speed = self.ability:GetSpecialValueFor("special_ms")})

  if self.ability:GetSpecialValueFor("special_bkb") == 1 then
    self.parent:AddModifier(self.ability, "_modifier_bkb", {})
  end

  self:PlayEfxStart()

  if self.parent:GetHealthPercent() < self.ability:GetSpecialValueFor("special_hp_cap") then
    self.parent:Purge(false, true, false, true, false)
    self.parent:ApplyHeal(self.ability:GetSpecialValueFor("special_heal"), self.ability, false)
    self:StartEfxBeam(self.parent)

    self.caster:Purge(false, true, false, true, false)
    self.caster:ApplyHeal(self.ability:GetSpecialValueFor("special_heal"), self.ability, false)
    self:StartEfxBeam(self.caster)
  end

  if self.caster == self.parent and self.ability:GetSpecialValueFor("special_self_cast") == 1 then
    self.ability:SetActivated(false)
    self.ability:EndCooldown()
  end
end

function templar_2_modifier_protection:OnRefresh(kv)
end

function templar_2_modifier_protection:OnRemoved()
  if not IsServer() then return end

  self.parent:RemoveSubStats(self.ability, {"speed"})
  self.parent:RemoveAllModifiersByNameAndAbility("_modifier_bkb", self.ability)

  if self.ability:GetSpecialValueFor("special_self_cast") == 1
  and self.ability:IsActivated() == false and self.caster == self.parent then
    self.ability:StartCooldown(self.ability:GetEffectiveCooldown(self.ability:GetLevel()))
    self.ability:SetActivated(true)
  end
end

-- API FUNCTIONS -----------------------------------------------------------

function templar_2_modifier_protection:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE
	}

	return funcs
end

function templar_2_modifier_protection:GetAbsoluteNoDamagePhysical(keys)
  if keys.attacker ~= self:GetParent() then return 1 end
  return 0
end

function templar_2_modifier_protection:GetAbsoluteNoDamageMagical(keys)
  if keys.attacker ~= self:GetParent() then return 1 end
  return 0
end

function templar_2_modifier_protection:GetAbsoluteNoDamagePure(keys)
  if keys.attacker ~= self:GetParent() then return 1 end
  return 0
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function templar_2_modifier_protection:GetEffectName()
	return "particles/units/heroes/hero_omniknight/omniknight_guardian_angel_halo_buff.vpcf"
end

function templar_2_modifier_protection:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function templar_2_modifier_protection:PlayEfxStart()  
  local particle = "particles/econ/items/omniknight/omni_2021_immortal/omni_2021_immortal.vpcf"
  local efx = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, self.parent)
  ParticleManager:SetParticleControl(efx, 0, self.parent:GetOrigin())
  self:AddParticle(efx, false, false, -1, true, false)

  self.parent:EmitSound("Hero_Omniknight.GuardianAngel.Cast")
end

function templar_2_modifier_protection:StartEfxBeam(unit)
  local particle = "particles/econ/items/luna/luna_lucent_ti5_gold/luna_eclipse_impact_notarget_moonfall_gold.vpcf"
  local efx = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, unit)
	ParticleManager:SetParticleControl(efx, 0, unit:GetOrigin())
	ParticleManager:SetParticleControlEnt(efx, 1, unit, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
	ParticleManager:SetParticleControlEnt(efx, 5, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
	ParticleManager:SetParticleControlEnt(efx, 6, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
	ParticleManager:ReleaseParticleIndex(efx)

  unit:EmitSound("Hero_Luna.Eclipse.Target")
  unit:EmitSound("Hero_Chen.HandOfGodHealHero")
end