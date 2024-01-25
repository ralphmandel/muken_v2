paladin_1_modifier_link = class({})

function paladin_1_modifier_link:IsHidden() return false end
function paladin_1_modifier_link:IsPurgable() return true end

-- CONSTRUCTORS -----------------------------------------------------------

function paladin_1_modifier_link:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  self.parent:AddModifier(self.ability, "orb_holy__modifier", {})

  self:PlayEfxStart()
  self:StartIntervalThink(1)
end

function paladin_1_modifier_link:OnRefresh(kv)
end

function paladin_1_modifier_link:OnRemoved()  
  if not IsServer() then return end

  self.parent:RemoveAllModifiersByNameAndAbility("orb_holy__modifier", self.ability)

  self.caster:StopSound("Hero_Wisp.Tether")
  self.caster:EmitSound("Hero_Wisp.Tether.Stop")
end

-- API FUNCTIONS -----------------------------------------------------------

function paladin_1_modifier_link:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
    MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,
  }

	return funcs
end

function paladin_1_modifier_link:OnDeath(keys)
  if not IsServer() then return end

  if keys.unit == self.caster then self:Destroy() end
end

function paladin_1_modifier_link:GetModifierIncomingDamageConstant(keys)
  if not IsServer() then return 0 end

  if keys.damage == 0 then return 0 end

  if keys.damage_flags ~= 1040 then
    local damage = keys.damage * self.ability:GetSpecialValueFor("absorption") * 0.01
  
    ApplyDamage({
      victim = self.caster, attacker = keys.attacker, damage = damage,
      damage_type = self.ability:GetAbilityDamageType(), ability = self.ability,
      damage_flags = 1040
    })

    return -damage
  end

  return 0
end

function paladin_1_modifier_link:OnIntervalThink()
  if not IsServer() then return end

  local cast_range = self.ability:GetSpecialValueFor("cast_range")
  local max_range = self.ability:GetSpecialValueFor("max_range")

  if self.efx then ParticleManager:SetParticleControl(self.pfx, 3, Vector(cast_range, max_range, 0)) end

  self.parent:ApplyHeal(self.ability:GetSpecialValueFor("special_heal"), self.ability, false)
  self.parent:ApplyMana(self.ability:GetSpecialValueFor("special_mana"), self.ability, false, false, true)

  self:StartIntervalThink(1)
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function paladin_1_modifier_link:PlayEfxStart()
  local string = "particles/paladin/link/paladin_link.vpcf"
  local cast_range = self.ability:GetSpecialValueFor("cast_range")
  local max_range = self.ability:GetSpecialValueFor("max_range")

  self.pfx = ParticleManager:CreateParticle(string, PATTACH_ABSORIGIN_FOLLOW, self.parent)
  ParticleManager:SetParticleControlEnt(self.pfx, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetAbsOrigin(), true)
  ParticleManager:SetParticleControlEnt(self.pfx, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
  ParticleManager:SetParticleControl(self.pfx, 3, Vector(cast_range, max_range, 0))
  self:AddParticle(self.pfx, false, false, -1, false, false)

  self.caster:EmitSound("Hero_Wisp.Tether")
  self.parent:EmitSound("Hero_Wisp.Tether.Target")
end