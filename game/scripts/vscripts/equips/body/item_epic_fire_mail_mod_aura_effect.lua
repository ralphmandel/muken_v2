item_epic_fire_mail_mod_aura_effect = class({})

function item_epic_fire_mail_mod_aura_effect:IsHidden() return true end
function item_epic_fire_mail_mod_aura_effect:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function item_epic_fire_mail_mod_aura_effect:OnCreated(kv)
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

  if not IsServer() then return end

  self.interval = self.ability:GetSpecialValueFor("interval")
  
  self.parent:EmitSound("FireMail.Loop")

  self:PlayEfxStart()
  self:StartIntervalThink(self.interval)
end

function item_epic_fire_mail_mod_aura_effect:OnRefresh(kv)
end

function item_epic_fire_mail_mod_aura_effect:OnRemoved()
  if not IsServer() then return end

  self.parent:StopSound("FireMail.Loop")
end

-- API FUNCTIONS -----------------------------------------------------------

function item_epic_fire_mail_mod_aura_effect:OnIntervalThink()
  if not IsServer() then return end

	ApplyDamage({
		victim = self.parent, attacker = self.caster, ability = self.ability,
		damage = self.ability:GetSpecialValueFor("damage") * self.interval,
    damage_type = self.ability:GetAbilityDamageType()
	})

  self:UpdateEfx()
  self:StartIntervalThink(self.interval)
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function item_epic_fire_mail_mod_aura_effect:PlayEfxStart()
	local string = "particles/econ/events/fall_2022/radiance_target_fall2022.vpcf"
	self.particle = ParticleManager:CreateParticle(string, PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(self.particle, 0, self.parent:GetOrigin())
	ParticleManager:SetParticleControl(self.particle, 1, self.caster:GetOrigin())
	self:AddParticle(self.particle, false, false, -1, false, false)
end

function item_epic_fire_mail_mod_aura_effect:UpdateEfx()
  if self.particle then ParticleManager:SetParticleControl(self.particle, 1, self.caster:GetOrigin()) end
end