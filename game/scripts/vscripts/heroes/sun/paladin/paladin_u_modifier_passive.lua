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

  AddSubStats(self.parent, self.ability, {
    max_health = self.ability:GetSpecialValueFor("max_health"),
    magic_resist = self.ability:GetSpecialValueFor("special_magic_resist")
  }, false)
end

function paladin_u_modifier_passive:OnRefresh(kv)
  RemoveSubStats(self.parent, self.ability, {"max_health", "magic_resist"})
  AddSubStats(self.parent, self.ability, {
    max_health = self.ability:GetSpecialValueFor("max_health"),
    magic_resist = self.ability:GetSpecialValueFor("special_magic_resist")
  }, false)
end

function paladin_u_modifier_passive:OnRemoved()
  RemoveSubStats(self.parent, self.ability, {"max_health", "magic_resist"})
end

-- API FUNCTIONS -----------------------------------------------------------

function paladin_u_modifier_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}

	return funcs
end

function paladin_u_modifier_passive:OnTakeDamage(keys)
  if keys.unit ~= self.parent then return end
  if self.parent:PassivesDisabled() then return end
  if self.parent:IsAlive() == false then return end
  if self.ability:IsCooldownReady() == false then return end

  if self.parent:GetHealthPercent() < self.ability:GetSpecialValueFor("special_hp_cap") then
    IncreaseMana(self.parent, self.parent:GetMaxHealth() * self.ability:GetSpecialValueFor("special_mana") * 0.01)
    self.ability:StartCooldown(self.ability:GetEffectiveCooldown(self.ability:GetLevel()))
    self:PlayEfxRestore()
  end
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function paladin_u_modifier_passive:PlayEfxRestore()
  local string = "particles/econ/events/fall_2022/mekanism/mekanism_fall2022.vpcf"
  local effect = ParticleManager:CreateParticle(string, PATTACH_ABSORIGIN_FOLLOW, self.parent)
  ParticleManager:SetParticleControl(effect, 0, self.parent:GetOrigin())
  ParticleManager:ReleaseParticleIndex(effect)

  if IsServer() then self.parent:EmitSound("DOTA_Item.Mekansm.Activate") end
end