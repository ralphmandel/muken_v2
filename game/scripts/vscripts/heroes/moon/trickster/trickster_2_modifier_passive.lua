trickster_2_modifier_passive = class({})

function trickster_2_modifier_passive:IsHidden() return true end
function trickster_2_modifier_passive:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function trickster_2_modifier_passive:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  self.records = {}
  self.passives_disabled = self.parent:PassivesDisabled()

  AddSubStats(self.parent, self.ability, {evasion = self.ability:GetSpecialValueFor("evasion")}, false)
end

function trickster_2_modifier_passive:OnRefresh(kv)
  RemoveSubStats(self.parent, self.ability, {"evasion"})
  AddSubStats(self.parent, self.ability, {evasion = self.ability:GetSpecialValueFor("evasion")}, false)
end

function trickster_2_modifier_passive:OnRemoved()
  RemoveSubStats(self.parent, self.ability, {"evasion"})
end

-- API FUNCTIONS -----------------------------------------------------------

function trickster_2_modifier_passive:DeclareFunctions()
	local funcs = {
    MODIFIER_EVENT_ON_STATE_CHANGED,
		MODIFIER_EVENT_ON_ATTACK_RECORD,
		MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
    MODIFIER_PROPERTY_ABSORB_SPELL
	}

	return funcs
end

function trickster_2_modifier_passive:OnStateChanged(keys)
  if keys.unit ~= self.parent then return end
  
  if self.passives_disabled == false and self.parent:PassivesDisabled() then
    RemoveSubStats(self.parent, self.ability, {"evasion"})
    self.passives_disabled = true
  end

  if self.passives_disabled == true and self.parent:PassivesDisabled() == false then
    RemoveSubStats(self.parent, self.ability, {"evasion"})
    AddSubStats(self.parent, self.ability, {evasion = self.ability:GetSpecialValueFor("evasion")}, false)
    self.passives_disabled = false
  end
end

function trickster_2_modifier_passive:OnAttackRecord(keys)
  if keys.target ~= self.parent then return end

  self.records[keys.record] = keys.attacker

  AddModifier(keys.attacker, self.ability, "trickster_2_modifier_debuff", {}, false)
end


function trickster_2_modifier_passive:OnAttackRecordDestroy(keys)
  if keys.target ~= self.parent then return end

  local attacker = self.records[keys.record]
  self.records[keys.record] = nil

  for record, target in pairs(self.records) do
    if attacker == target then return end
  end

  attacker:RemoveModifierByNameAndCaster("trickster_2_modifier_debuff", self.caster)
end

function trickster_2_modifier_passive:OnAttackLanded(keys)
  if keys.target ~= self.parent then return end

  if RandomFloat(0, 100) < self.ability:GetSpecialValueFor("special_disarm_chance") then
    AddModifier(keys.attacker, self.ability, "_modifier_disarm", {
      duration = self.ability:GetSpecialValueFor("special_disarm_duration")
    }, true)
  end

  RemoveSubStats(self.parent, self.ability, {"evasion"})

  if IsServer() then self:StartIntervalThink(self.ability:GetSpecialValueFor("last_hit_delay")) end
end

function trickster_2_modifier_passive:GetAbsorbSpell(keys)
  if RandomFloat(0, 100) < self.ability:GetSpecialValueFor("special_linkens_chance") then
    if IsServer() then self:PlayEfxSpellBlock() end
    return 1
  end

  return 0
end

function trickster_2_modifier_passive:OnIntervalThink()
  AddSubStats(self.parent, self.ability, {health_regen = self.ability:GetSpecialValueFor("special_health_regen")}, false)

  if IsServer() then self:StartIntervalThink(-1) end
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function trickster_2_modifier_passive:PlayEfxSpellBlock()
	local particle_cast = "particles/units/heroes/hero_antimage/antimage_spellshield_reflect.vpcf"
	local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_POINT_FOLLOW, self.parent)
	ParticleManager:SetParticleControlEnt(effect_cast, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
	ParticleManager:ReleaseParticleIndex(effect_cast)

	if IsServer() then self.parent:EmitSound("DOTA_Item.LinkensSphere.Activate") end
end