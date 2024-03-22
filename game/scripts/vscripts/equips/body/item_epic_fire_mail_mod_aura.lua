item_epic_fire_mail_mod_aura = class({})

function item_epic_fire_mail_mod_aura:IsHidden() return false end
function item_epic_fire_mail_mod_aura:IsPurgable() return false end
function item_epic_fire_mail_mod_aura:GetTexture() return "armor/fire_mail" end

-- AURA -----------------------------------------------------------

function item_epic_fire_mail_mod_aura:IsAura() return true end
function item_epic_fire_mail_mod_aura:GetModifierAura() return "item_epic_fire_mail_mod_aura_effect" end
function item_epic_fire_mail_mod_aura:GetAuraDuration() return 0 end
function item_epic_fire_mail_mod_aura:GetAuraRadius() return self.aura_radius end
function item_epic_fire_mail_mod_aura:GetAuraSearchTeam() return self.aura_team end
function item_epic_fire_mail_mod_aura:GetAuraSearchType() return self.aura_type end
function item_epic_fire_mail_mod_aura:GetAuraSearchFlags() return self.aura_flag end
function item_epic_fire_mail_mod_aura:GetAuraEntityReject(hEntity)
  return self.caster:IsMuted() or self.ability:GetToggleState() == false
end

-- CONSTRUCTORS -----------------------------------------------------------

function item_epic_fire_mail_mod_aura:OnCreated(kv)
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

  if not IsServer() then return end

  self.aura_radius = self.ability:GetAOERadius()
  self.aura_team = self.ability:GetAbilityTargetTeam()
  self.aura_type = self.ability:GetAbilityTargetType()
  self.aura_flag = self.ability:GetAbilityTargetFlags()

  self.parent:AddAbilityStats(self.ability, {"vit"})
  self.parent:AddAbilityStats(self.ability, {"armor", "magic_resist"})
end

function item_epic_fire_mail_mod_aura:OnRefresh(kv)
end

function item_epic_fire_mail_mod_aura:OnRemoved()
  if not IsServer() then return end

  self:StopEfxStart()

  self.parent:RemoveMainStats(self.ability, {"vit"})
  self.parent:RemoveSubStats(self.ability, {"armor", "magic_resist"})
end

-- API FUNCTIONS -----------------------------------------------------------

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function item_epic_fire_mail_mod_aura:PlayEfxStart()
	local string = "particles/econ/events/fall_2022/radiance/radiance_owner_fall2022.vpcf"
  self.particle = ParticleManager:CreateParticle(string, PATTACH_ABSORIGIN_FOLLOW, self.parent)
  ParticleManager:SetParticleControl(self.particle, 0, self.parent:GetOrigin())

  self.parent:EmitSound("FireMail.Start")
end

function item_epic_fire_mail_mod_aura:StopEfxStart()
	if self.particle then
    ParticleManager:DestroyParticle(self.particle, false)
    self.particle = nil
  end
end