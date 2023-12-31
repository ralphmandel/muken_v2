templar_1_modifier_aura_effect = class({})

function templar_1_modifier_aura_effect:IsHidden() return false end
function templar_1_modifier_aura_effect:IsPurgable() return false end

-- AURA -----------------------------------------------------------

function templar_1_modifier_aura_effect:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()
  --self.day_time = self.ability:GetCurrentAbilityCharges() == CYCLE_DAY

  if IsServer() then
    self:SetStackCount(0)
    self.ability:UpdateCount()
    self.parent:EmitSound("Hero_Pangolier.TailThump.Cast")
  end
end

function templar_1_modifier_aura_effect:OnRefresh(kv)
end

function templar_1_modifier_aura_effect:OnRemoved(kv)
  if IsServer() then self.parent:EmitSound("Hero_Medusa.ManaShield.Off") end

	RemoveSubStats(self.parent, self.ability, {"status_resist_stack", "armor"})

  self.ability:UpdateCount()
end

-- API FUNCTIONS -----------------------------------------------------------

function templar_1_modifier_aura_effect:OnStackCountChanged(old)
	RemoveSubStats(self.parent, self.ability, {"status_resist_stack"})

  AddSubStats(self.parent, self.ability, {
    status_resist_stack = self.ability:GetSpecialValueFor("res_stack") * self:GetStackCount(),
    armor = self.ability:GetSpecialValueFor("special_armor") * self:GetStackCount()
  }, false)

  if IsServer() then self:PlayEfxStart() end
end

function templar_1_modifier_aura_effect:DeclareFunctions()
	local funcs = {
    MODIFIER_EVENT_ON_TAKEDAMAGE
	}

	return funcs
end

function templar_1_modifier_aura_effect:OnTakeDamage(keys)
	if keys.unit ~= self.parent then return end
	if keys.attacker == nil then return end
	if keys.attacker:IsBaseNPC() == false then return end

	local return_damage = keys.damage * self.ability:GetSpecialValueFor("special_return") * 0.01

	if keys.damage_flags ~= 31 and keys.damage_flags ~= 1040 then
		--if IsServer() then keys.attacker:EmitSound("DOTA_Item.BladeMail.Damage") end
    
		ApplyDamage({
			damage = return_damage, damage_type = keys.damage_type,
			attacker = self.caster, victim = keys.attacker, ability = self.ability,
			damage_flags = 31 --DOTA_DAMAGE_FLAG_REFLECTION
		})
	end
end

-- function templar_1_modifier_aura_effect:OnIntervalThink()
--   if self.day_time == true then
--     if self.ability:GetCurrentAbilityCharges() == CYCLE_NIGHT then
--       RemoveAllModifiersByNameAndAbility(self.parent, "_modifier_heal_amp", self.ability)
--       self.day_time = false
--     end
--   else
--     if self.ability:GetCurrentAbilityCharges() == CYCLE_DAY then
--       RemoveAllModifiersByNameAndAbility(self.parent, "_modifier_heal_amp", self.ability)
--       AddModifier(self.parent, self.ability, "_modifier_heal_amp", {
--         amount = self.ability:GetSpecialValueFor("heal_amp")
--       }, false)
--       self.day_time = true
--     end
--   end
--   if IsServer() then self:StartIntervalThink(0.1) end
-- end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function templar_1_modifier_aura_effect:PlayEfxStart()
	local special = 50
	local string = "particles/dasdingo/dasdingo_aura.vpcf"
  local size = 0
  local shield_count = self:GetStackCount()

  if GetHeroName(self.parent) == "lawbreaker" then size = 185 end
  if GetHeroName(self.parent) == "bloodstained" then size = 210 end
  if GetHeroName(self.parent) == "bocuse" then size = 210 end
  if GetHeroName(self.parent) == "fleaman" then size = 155 end
  if GetHeroName(self.parent) == "vulture" then size = 250 end

  if GetHeroName(self.parent) == "dasdingo" then size = 175 end
  if GetHeroName(self.parent) == "druid" then size = 185 end
  if GetHeroName(self.parent) == "hunter" then size = 165 end

  if GetHeroName(self.parent) == "genuine" then size = 185 end
  if GetHeroName(self.parent) == "icebreaker" then size = 155 end

  if GetHeroName(self.parent) == "ancient" then size = 250 end
  if GetHeroName(self.parent) == "paladin" then size = 215 end
  if GetHeroName(self.parent) == "templar" then size = 235 end
  if GetHeroName(self.parent) == "baldur" then size = 175 end

  if self.effect_cast then ParticleManager:DestroyParticle(self.effect_cast, true) end

	self.effect_cast = ParticleManager:CreateParticle(string, PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControlEnt(self.effect_cast, 1, self.parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
	ParticleManager:SetParticleControl(self.effect_cast, 3, Vector(special, 0, 0))
  ParticleManager:SetParticleControl(self.effect_cast, 10, Vector(shield_count, math.floor(100 / shield_count), 0))
	ParticleManager:SetParticleControl(self.effect_cast, 11, Vector(0, 0, size))

	self:AddParticle(self.effect_cast, false, false, -1, false, false)
end