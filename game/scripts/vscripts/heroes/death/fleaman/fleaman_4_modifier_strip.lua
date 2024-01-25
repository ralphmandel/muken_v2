fleaman_4_modifier_strip = class({})

function fleaman_4_modifier_strip:IsHidden() return false end
function fleaman_4_modifier_strip:IsPurgable() return true end

-- CONSTRUCTORS -----------------------------------------------------------

function fleaman_4_modifier_strip:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  self:PlayEfxStart()

  self.parent:AddSubStats(self.ability, {
    armor = self.ability:GetSpecialValueFor("armor"),
    evasion = self.ability:GetSpecialValueFor("special_evasion")
  })

  if self.ability:GetSpecialValueFor("special_break") == 1 then
    self.parent:AddModifier(self.ability, "_modifier_break", {})
  end

  if self.ability:GetSpecialValueFor("special_silence") == 1 then
    self.parent:AddModifier(self.ability, "_modifier_silence", {})
  end

  local bleed_damage = self.ability:GetSpecialValueFor("special_bleed_dmg")

  if bleed_damage > 0 then
    self.parent:AddModifier(self.ability, "orb_bleed_debuff", {bleed_damage = bleed_damage})
  end

  self.damageTable = {
    victim = self.parent, attacker = self.caster, damage = 0,
    damage_type = self.ability:GetAbilityDamageType(),
    ability = self.ability
  }
end

function fleaman_4_modifier_strip:OnRefresh(kv)
end

function fleaman_4_modifier_strip:OnRemoved()
  if not IsServer() then return end
  
  self.parent:RemoveSubStats(self.ability, {"armor", "evasion"})
  self.parent:RemoveAllModifiersByNameAndAbility("_modifier_break", self.ability)
  self.parent:RemoveAllModifiersByNameAndAbility("_modifier_silence", self.ability)
  self.parent:RemoveAllModifiersByNameAndAbility("orb_bleed_debuff", self.ability)

  if self.damageTable.damage > 0 then
    self:PlayEfxEnd()
    ApplyDamage(self.damageTable)
  end
end

-- API FUNCTIONS -----------------------------------------------------------

function fleaman_4_modifier_strip:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}

	return funcs
end

function fleaman_4_modifier_strip:OnTakeDamage(keys)
  if not IsServer() then return end

  if keys.unit ~= self.parent then return end
  
  local damage_percent = self.ability:GetSpecialValueFor("special_damage")
  self.damageTable.damage = self.damageTable.damage + (keys.damage * damage_percent * 0.01)
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function fleaman_4_modifier_strip:GetEffectName()
	return "particles/items3_fx/star_emblem.vpcf"
end

function fleaman_4_modifier_strip:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function fleaman_4_modifier_strip:PlayEfxStart()
	local string_1 = "particles/items_fx/abyssal_blink_end.vpcf"
	local particle_1 = ParticleManager:CreateParticle(string_1, PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(particle_1, 0, self.parent:GetOrigin())
	ParticleManager:ReleaseParticleIndex(particle_1)

	self.parent:EmitSound("DOTA_Item.AbyssalBlade.Activate")
end

function fleaman_4_modifier_strip:PlayEfxEnd()
	local string_1 = "particles/items_fx/abyssal_blink_start.vpcf"
	local particle_1 = ParticleManager:CreateParticle(string_1, PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(particle_1, 0, self.parent:GetOrigin())
	ParticleManager:ReleaseParticleIndex(particle_1)

	self.parent:EmitSound("DOTA_Item.Bloodthorn.Activate")
end