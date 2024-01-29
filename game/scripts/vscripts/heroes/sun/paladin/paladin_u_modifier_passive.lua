paladin_u_modifier_passive = class({})

function paladin_u_modifier_passive:IsHidden() return true end
function paladin_u_modifier_passive:IsPurgable() return false end

-- AURA -----------------------------------------------------------

function paladin_u_modifier_passive:IsAura() return self:GetCaster():PassivesDisabled() == false end
function paladin_u_modifier_passive:GetModifierAura() return "paladin_u_modifier_aura_effect" end
function paladin_u_modifier_passive:GetAuraRadius() return self:GetAbility():GetAOERadius() end
function paladin_u_modifier_passive:GetAuraSearchTeam() return self:GetAbility():GetAbilityTargetTeam() end
function paladin_u_modifier_passive:GetAuraSearchType() return self:GetAbility():GetAbilityTargetType() end
function paladin_u_modifier_passive:GetAuraSearchFlags() return self:GetAbility():GetAbilityTargetFlags() end
function paladin_u_modifier_passive:GetAuraEntityReject(hEntity)
  return self:GetCaster() ~= hEntity and self:GetAbility():GetAOERadius() == 0
end

-- CONSTRUCTORS -----------------------------------------------------------

function paladin_u_modifier_passive:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  self.parent:AddSubStats(self.ability, {
    max_health = self.ability:GetSpecialValueFor("max_health"),
    max_mana = self.ability:GetSpecialValueFor("special_max_mana"),
    magic_resist = self.ability:GetSpecialValueFor("special_magic_resist"),
    stone_resist = self.ability:GetSpecialValueFor("special_stone_resist"),
    cold_resist = self.ability:GetSpecialValueFor("special_stone_resist"),
    poison_resist = self.ability:GetSpecialValueFor("special_stone_resist"),
    thunder_resist = self.ability:GetSpecialValueFor("special_stone_resist"),
    bleed_resist = self.ability:GetSpecialValueFor("special_stone_resist"),
    sleep_resist = self.ability:GetSpecialValueFor("special_stone_resist")
  })
end

function paladin_u_modifier_passive:OnRefresh(kv)
  if not IsServer() then return end

  self.parent:RemoveSubStats(self.ability, {
    "max_health", "max_mana", "magic_resist",
    "stone_resist", "cold_resist", "poison_resist",
    "thunder_resist", "bleed_resist", "sleep_resist"
  })

  self.parent:AddSubStats(self.ability, {
    max_health = self.ability:GetSpecialValueFor("max_health"),
    max_mana = self.ability:GetSpecialValueFor("special_max_mana"),
    magic_resist = self.ability:GetSpecialValueFor("special_magic_resist"),
    stone_resist = self.ability:GetSpecialValueFor("special_stone_resist"),
    cold_resist = self.ability:GetSpecialValueFor("special_stone_resist"),
    poison_resist = self.ability:GetSpecialValueFor("special_stone_resist"),
    thunder_resist = self.ability:GetSpecialValueFor("special_stone_resist"),
    bleed_resist = self.ability:GetSpecialValueFor("special_stone_resist"),
    sleep_resist = self.ability:GetSpecialValueFor("special_stone_resist")
  })
end

function paladin_u_modifier_passive:OnRemoved()
  if not IsServer() then return end

  self.parent:RemoveSubStats(self.ability, {
    "max_health", "max_mana", "magic_resist",
    "stone_resist", "cold_resist", "poison_resist",
    "thunder_resist", "bleed_resist", "sleep_resist"
  })
end

-- API FUNCTIONS -----------------------------------------------------------

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function paladin_u_modifier_passive:PlayEfxRestore()
  local string = "particles/econ/events/fall_2022/mekanism/mekanism_fall2022.vpcf"
  local effect = ParticleManager:CreateParticle(string, PATTACH_ABSORIGIN_FOLLOW, self.parent)
  ParticleManager:SetParticleControl(effect, 0, self.parent:GetOrigin())
  ParticleManager:ReleaseParticleIndex(effect)

  self.parent:EmitSound("DOTA_Item.Mekansm.Activate")
end