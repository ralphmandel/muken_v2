item_epic_spectral_armor_mod_buff = class({})

function item_epic_spectral_armor_mod_buff:IsHidden() return false end
function item_epic_spectral_armor_mod_buff:IsPurgable() return false end
function item_epic_spectral_armor_mod_buff:GetTexture() return "armor/spectral_armor" end

-- CONSTRUCTORS -----------------------------------------------------------

function item_epic_spectral_armor_mod_buff:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  self.phase = kv.phase or 0

  if not IsServer() then return end

  local speed_percent = kv.speed_percent or 0
  self.invi_delay = kv.invi_delay or -1

  self.parent:AddAbilityStats(self.ability, {"perfect_dodge", "attack_time"})
  self.parent:AddSubStats(self.ability, {speed_percent = speed_percent})

  self:PlayEfxStart()
  self:StartIntervalThink(self.invi_delay)
end

function item_epic_spectral_armor_mod_buff:OnRefresh(kv)
end

function item_epic_spectral_armor_mod_buff:OnRemoved()
  if not IsServer() then return end

  self.parent:RemoveSubStats(self.ability, {"perfect_dodge", "attack_time"})
  self.parent:RemoveSubStats(self.ability, {"speed_percent"})
  self.parent:RemoveAllModifiersByNameAndAbility("_modifier_invisible", self.ability)

  self:StopEfxStart()
end

-- API FUNCTIONS -----------------------------------------------------------

function item_epic_spectral_armor_mod_buff:CheckState()
	local state = {
    [MODIFIER_STATE_NO_UNIT_COLLISION] = self.phase == 1,
	}

	return state
end

function item_epic_spectral_armor_mod_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
    MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end

function item_epic_spectral_armor_mod_buff:GetAbsoluteNoDamagePhysical(keys)
  return 1
end

function item_epic_spectral_armor_mod_buff:GetModifierTotalDamageOutgoing_Percentage(keys)
  if keys.damage_type == DAMAGE_TYPE_PHYSICAL then return -9999 else return 0 end
end

function item_epic_spectral_armor_mod_buff:OnAttackLanded(keys)
  if not IsServer() then return end

  if keys.attacker ~= self.parent then return end

  self:StartIntervalThink(self.invi_delay)
end

function item_epic_spectral_armor_mod_buff:OnIntervalThink()
  if not IsServer() then return end

  if self.invi then return end

  self.invi = self.parent:AddModifier(self.ability, "_modifier_invisible", {attack_break = 100, spell_break = 0})

  self.invi:SetEndCallback(function(interrupted)
    if self then
      if self:IsNull() == false then
        self.parent:SetModifierOnAllCosmetics(self.ability, "_modifier_invi_level", {level = 1}, true)
        self.invi = nil
      end
    end
  end)

  self:StartIntervalThink(-1)
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function item_epic_spectral_armor_mod_buff:PlayEfxStart()
  local string = "particles/shadowmancer/shadowmancer_arcana_ambient.vpcf"
	local particle = ParticleManager:CreateParticle(string, PATTACH_POINT_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(particle, 0, self.parent:GetOrigin())
	ParticleManager:SetParticleControlEnt(particle, 0, self.parent, PATTACH_POINT_FOLLOW, "", Vector(0,0,0), true)
	self:AddParticle(particle, false, false, -1, false, false)

  self.parent:SetModifierOnAllCosmetics(self.ability, "_modifier_invi_level", {level = 1}, true)
  self.parent:EmitSound("Hero_VoidSpirit.AetherRemnant.Cast")
  self.parent:EmitSound("Hero_VoidSpirit.AetherRemnant.Spawn_lp")
end

function item_epic_spectral_armor_mod_buff:StopEfxStart()
  self.parent:SetModifierOnAllCosmetics(self.ability, "_modifier_invi_level", nil, false)
  self.parent:StopSound("Hero_VoidSpirit.AetherRemnant.Spawn_lp")
end