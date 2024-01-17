orb_bleed_debuff = class({})

function orb_bleed_debuff:IsHidden() return false end
function orb_bleed_debuff:IsPurgable() return false end
function orb_bleed_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function orb_bleed_debuff:GetTexture() return "bleeding" end

-- CONSTRUCTORS -----------------------------------------------------------

function orb_bleed_debuff:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end
  
  self.interval = 0.25
  self.status_mult = 0.1
  self.bleed_damage = 50

  self.damageTable = {
    attacker = self.caster,
    victim = self.parent,
    ability = self.ability,
		damage_type = DAMAGE_TYPE_PHYSICAL
  }

  self:PlayEfxStart()
  self:StartIntervalThink(self.interval)
end

function orb_bleed_debuff:OnRefresh(kv)
  if not IsServer then return end

  self:SetDuration(kv.duration, true)
  self:PlayEfxStart()
end

function orb_bleed_debuff:OnRemoved()
end

-- API FUNCTIONS -----------------------------------------------------------

function orb_bleed_debuff:OnIntervalThink()
  if not IsServer() then return end

  if self.caster == nil then self:Destroy() return end
  if IsValidEntity(self.caster) == false then self:Destroy() return end

  self.damageTable.damage = self.parent:GetSpellDamage(self.bleed_damage, DAMAGE_TYPE_PHYSICAL) * self.interval
  if self.parent:IsMoving() then self.damageTable.damage = self.damageTable.damage * 2 end

  local damage_result = ApplyDamage(self.damageTable)
  self:PopupBleedDamage(math.floor(damage_result), self.parent)

  AddModifier(self.parent, self.ability, "orb_bleed__status", {
    inflictor = self.caster:entindex(),
    status_amount = CalcStatusDebuffAmp(damage_result * self.status_mult, self.caster)
  })

  self:StartIntervalThink(self.interval)
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function orb_bleed_debuff:GetEffectName()
	return "particles/econ/items/bloodseeker/bloodseeker_ti7/bloodseeker_ti7_thirst_owner.vpcf"
end

function orb_bleed_debuff:GetEffectAttachType()
	return PATTACH_POINT_FOLLOW
end

function orb_bleed_debuff:PlayEfxStart()
	local particle_cast = "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodritual_impact.vpcf"
	local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(effect_cast, 0, self.parent:GetOrigin())
	ParticleManager:SetParticleControl(effect_cast, 1, self.parent:GetOrigin())
	ParticleManager:ReleaseParticleIndex(effect_cast)

	if IsServer() then self.parent:EmitSound("Generic.Bleed") end
end