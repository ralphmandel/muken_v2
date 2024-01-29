templar_1_modifier_aura_effect = class({})

function templar_1_modifier_aura_effect:IsHidden() return false end
function templar_1_modifier_aura_effect:IsPurgable() return false end

-- AURA -----------------------------------------------------------

function templar_1_modifier_aura_effect:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  self.parent:EmitSound("Hero_Pangolier.TailThump.Cast")

  self:SetStackCount(0)
  self.ability:UpdateCount()
end

function templar_1_modifier_aura_effect:OnRefresh(kv)
end

function templar_1_modifier_aura_effect:OnRemoved(kv)
  if not IsServer() then return end

  self.parent:RemoveSubStats(self.ability, {"status_resist_stack", "armor"})
  self.parent:EmitSound("Hero_Medusa.ManaShield.Off")

  self.ability:UpdateCount()
end

-- API FUNCTIONS -----------------------------------------------------------

function templar_1_modifier_aura_effect:DeclareFunctions()
	local funcs = {
    MODIFIER_PROPERTY_ABSORB_SPELL,
    MODIFIER_EVENT_ON_TAKEDAMAGE
	}

	return funcs
end

function templar_1_modifier_aura_effect:GetBonusNightVision()
	return self:GetAbility():GetSpecialValueFor("special_day_vision")
end

function templar_1_modifier_aura_effect:GetAbsorbSpell(keys)
  if RandomFloat(0, 100) < self.ability:GetSpecialValueFor("special_spellblock_chance") then
    if IsServer() then self:PlayEfxSpellBlock() end
    return 1
  end

  return 0
end

function templar_1_modifier_aura_effect:OnTakeDamage(keys)
  if not IsServer() then return end

	if keys.unit ~= self.parent then return end
	if keys.attacker == nil then return end
	if keys.attacker:IsBaseNPC() == false then return end

	local return_damage = keys.damage * self.ability:GetSpecialValueFor("special_return") * 0.01

	if keys.damage_flags ~= 31 and keys.damage_flags ~= 1040 then    
		ApplyDamage({
			damage = return_damage, damage_type = keys.damage_type,
			attacker = self.caster, victim = keys.attacker, ability = self.ability,
			damage_flags = 31
		})
	end
end

function templar_1_modifier_aura_effect:OnStackCountChanged(old)
  if not IsServer() then return end

  self.parent:RemoveSubStats(self.ability, {"status_resist_stack", "armor"})

  self.parent:AddSubStats(self.ability, {
    status_resist_stack = self.ability:GetSpecialValueFor("res_stack") * self:GetStackCount(),
    armor = self.ability:GetSpecialValueFor("special_armor") * self:GetStackCount()
  })

  self:PlayEfxStart()
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function templar_1_modifier_aura_effect:PlayEfxStart()
	local special = 50
	local string = "particles/dasdingo/dasdingo_aura.vpcf"
  local size = 0
  local shield_count = self:GetStackCount()

  if self.effect_cast then ParticleManager:DestroyParticle(self.effect_cast, true) end

	self.effect_cast = ParticleManager:CreateParticle(string, PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControlEnt(self.effect_cast, 1, self.parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
	ParticleManager:SetParticleControl(self.effect_cast, 3, Vector(special, 0, 0))
  ParticleManager:SetParticleControl(self.effect_cast, 10, Vector(shield_count, math.floor(100 / shield_count), 0))
	ParticleManager:SetParticleControl(self.effect_cast, 11, Vector(0, 0, HEROES_DATA[self.parent:GetHeroName()].shield_fx_height))

	self:AddParticle(self.effect_cast, false, false, -1, false, false)
end

function templar_1_modifier_aura_effect:PlayEfxSpellBlock()
	local particle_cast = "particles/units/heroes/hero_antimage/antimage_spellshield_reflect.vpcf"
	local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_POINT_FOLLOW, self.parent)
	ParticleManager:SetParticleControlEnt(effect_cast, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
	ParticleManager:ReleaseParticleIndex(effect_cast)

	self.parent:EmitSound("DOTA_Item.LinkensSphere.Activate")
end