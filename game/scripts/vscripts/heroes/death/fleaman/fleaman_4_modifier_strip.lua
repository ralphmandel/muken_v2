fleaman_4_modifier_strip = class({})

function fleaman_4_modifier_strip:IsHidden() return false end
function fleaman_4_modifier_strip:IsPurgable() return true end

-- CONSTRUCTORS -----------------------------------------------------------

function fleaman_4_modifier_strip:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  AddSubStats(self.parent, self.ability, {
    armor = self.ability:GetSpecialValueFor("armor"),
    evasion = self.ability:GetSpecialValueFor("special_evasion")
  }, false)

  if self.ability:GetSpecialValueFor("special_break") == 1 then
    AddModifier(self.parent, self.ability, "_modifier_break", {}, false)
  end

  if self.ability:GetSpecialValueFor("special_bleeding") == 1 then
    AddModifier(self.parent, self.ability, "_modifier_bleeding", {}, false)
  end

  if self.ability:GetSpecialValueFor("special_silence") == 1 then
    AddModifier(self.parent, self.ability, "_modifier_silence", {}, false)
  end

  self.damageTable = {
    victim = self.parent, attacker = self.caster, damage = 0,
    damage_type = self.ability:GetAbilityDamageType(),
    ability = self.ability
  }

	if IsServer() then self:PlayEfxStart() end
end

function fleaman_4_modifier_strip:OnRefresh(kv)
end

function fleaman_4_modifier_strip:OnRemoved()
  RemoveSubStats(self.parent, self.ability, {"armor", "evasion"})
  RemoveAllModifiersByNameAndAbility(self.parent, "_modifier_break", self.ability)
  RemoveAllModifiersByNameAndAbility(self.parent, "_modifier_bleeding", self.ability)
  RemoveAllModifiersByNameAndAbility(self.parent, "_modifier_silence", self.ability)

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

	if IsServer() then self.parent:EmitSound("DOTA_Item.AbyssalBlade.Activate") end
end

function fleaman_4_modifier_strip:PlayEfxEnd()
	local string_1 = "particles/items_fx/abyssal_blink_start.vpcf"
	local particle_1 = ParticleManager:CreateParticle(string_1, PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(particle_1, 0, self.parent:GetOrigin())
	ParticleManager:ReleaseParticleIndex(particle_1)

	if IsServer() then self.parent:EmitSound("DOTA_Item.Bloodthorn.Activate") end
end