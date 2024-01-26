paladin_2_modifier_shield = class({})

function paladin_2_modifier_shield:IsHidden() return false end
function paladin_2_modifier_shield:IsPurgable() return true end

-- AURA -----------------------------------------------------------

function paladin_2_modifier_shield:IsAura() return self.radius > 0 end
function paladin_2_modifier_shield:GetAuraDuration() return 0 end
function paladin_2_modifier_shield:GetModifierAura() return "paladin_2_modifier_aura_effect" end
function paladin_2_modifier_shield:GetAuraRadius() return self.radius end
function paladin_2_modifier_shield:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function paladin_2_modifier_shield:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function paladin_2_modifier_shield:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end
function paladin_2_modifier_shield:GetAuraEntityReject(hEntity) return false end

-- CONSTRUCTORS -----------------------------------------------------------

function paladin_2_modifier_shield:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  self.radius = self:GetAbility():GetAOERadius()

  if not IsServer() then return end

  self.parent:AddSubStats(self.ability, {
    status_resist_stack = self.ability:GetSpecialValueFor("status_resist"),
    health_regen = self.ability:GetSpecialValueFor("special_hp_regen"),
  })

  if self.ability:GetSpecialValueFor("special_bkb") == 1 then
    self.parent:AddModifier(self.ability, "_modifier_bkb", {})
  end

  self:SetStackCount(self.ability:GetSpecialValueFor("hits"))
  self:PlayEfxStart()
  self:StartIntervalThink(0.1)
end

function paladin_2_modifier_shield:OnRefresh(kv)
  self.radius = self:GetAbility():GetAOERadius()

  if not IsServer() then return end

  self.parent:RemoveSubStats(self.ability, {"status_resist_stack", "health_regen"})
  self.parent:RemoveAllModifiersByNameAndAbility("_modifier_bkb", self.ability)

  self.parent:AddSubStats(self.ability, {
    status_resist_stack = self.ability:GetSpecialValueFor("status_resist"),
    health_regen = self.ability:GetSpecialValueFor("special_hp_regen"),
  })

  if self.ability:GetSpecialValueFor("special_bkb") == 1 then
    self.parent:AddModifier(self.ability, "_modifier_bkb", {})
  end

  self:SetStackCount(self.ability:GetSpecialValueFor("hits"))
  self:PlayEfxStart()
end

function paladin_2_modifier_shield:OnRemoved()
  if not IsServer() then return end

	self.parent:EmitSound("Hero_Medusa.ManaShield.Off")
  self.parent:RemoveSubStats(self.ability, {"status_resist_stack", "health_regen"})
  self.parent:RemoveAllModifiersByNameAndAbility("_modifier_bkb", self.ability)
end

-- API FUNCTIONS -----------------------------------------------------------

function paladin_2_modifier_shield:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK
	}

	return funcs
end

function paladin_2_modifier_shield:OnAttackLanded(keys)
  if not IsServer() then return end

	if keys.target ~= self.parent then return end
	self:DecrementStackCount()
end

function paladin_2_modifier_shield:GetModifierPhysical_ConstantBlock(keys)
  if not IsServer() then return end

	if keys.damage_category ~= DOTA_DAMAGE_CATEGORY_ATTACK then return end

  self:PlayEfxBlocked(keys)
	if self:GetStackCount() < 1 then self:Destroy() end

  return keys.damage
end

function paladin_2_modifier_shield:OnIntervalThink()
  if not IsServer() then return end

  if self.radius > 0 then
    local trees = GridNav:GetAllTreesAroundPoint(self.parent:GetOrigin(), 150, false)

    if trees then
      for _, tree in pairs(trees) do
        tree:CutDownRegrowAfter(15, self.parent:GetTeamNumber())
      end
    end    
  end

  self:StartIntervalThink(0.1)
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function paladin_2_modifier_shield:PlayEfxStart()
  if self.shield_particle then
    ParticleManager:DestroyParticle(self.shield_particle, true)
    self.shield_particle = nil
  end

  if self.burn_efx then
    ParticleManager:DestroyParticle(self.burn_efx, true)
    self.burn_efx = nil
  end

  local string = "particles/econ/items/lanaya/ta_ti9_immortal_shoulders/ta_ti9_refraction.vpcf"
	self.shield_particle = ParticleManager:CreateParticle(string, PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControlEnt(self.shield_particle, 0, self.parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
  ParticleManager:SetParticleControlEnt(self.shield_particle, 1, self.parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
  ParticleManager:SetParticleControlEnt(self.shield_particle, 5, self.parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
	self:AddParticle(self.shield_particle, false, false, -1, true, false)

  if self.radius > 0 then
    local string = "particles/econ/items/ember_spirit/ember_ti9/ember_ti9_flameguard.vpcf"
    self.burn_efx = ParticleManager:CreateParticle(string, PATTACH_ABSORIGIN_FOLLOW, self.parent)
    ParticleManager:SetParticleControlEnt(self.burn_efx, 0, self.parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(self.burn_efx, 1, self.parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
    ParticleManager:SetParticleControl(self.burn_efx, 2, Vector(self.radius, 0, 0 ))
    self:AddParticle(self.burn_efx, false, false, -1, true, false)
  
    self.parent:EmitSound("Hero_EmberSpirit.FlameGuard.Cast")  
  end

  self.parent:EmitSound("Hero_TemplarAssassin.Refraction")
end

function paladin_2_modifier_shield:PlayEfxBlocked(keys)
	local particle_cast = "particles/units/heroes/hero_oracle/oracle_false_promise_attacked.vpcf"
	local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(effect_cast, 1, Vector(keys.damage, 0, 0 ))
	ParticleManager:ReleaseParticleIndex(effect_cast)

  self.parent:EmitSound("Hero_Striker.Shield.Block")
end