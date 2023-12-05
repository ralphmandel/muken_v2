trickster_3_modifier_hide = class({})

function trickster_3_modifier_hide:IsHidden() return false end
function trickster_3_modifier_hide:IsPurgable() return true end

-- CONSTRUCTORS -----------------------------------------------------------

function trickster_3_modifier_hide:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  AddModifier(self.parent, self.ability, "_modifier_invisible", {delay = 0.5, attack_break = 0, spell_break = 0}, false)
  AddModifier(self.parent, self.ability, "sub_stat_movespeed_increase", {value = self.ability:GetSpecialValueFor("ms")}, false)

  self.ability:SetActivated(false)
  self.ability:EndCooldown()

  if IsServer() then self:PlayEfxStart() end
end

function trickster_3_modifier_hide:OnRefresh(kv)
end

function trickster_3_modifier_hide:OnRemoved()
  RemoveAllModifiersByNameAndAbility(self.parent, "_modifier_invisible", self.ability)
  RemoveAllModifiersByNameAndAbility(self.parent, "sub_stat_movespeed_increase", self.ability)

  self.ability:SetActivated(true)
  self.ability:StartCooldown(self.ability:GetEffectiveCooldown(self.ability:GetLevel()))
end

-- API FUNCTIONS -----------------------------------------------------------

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function trickster_3_modifier_hide:GetEffectName()
	return "particles/shadowmancer/blur/shadowmancer_blur_ambient.vpcf"
end

function trickster_3_modifier_hide:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function trickster_3_modifier_hide:PlayEfxStart(target)
	local particle = "particles/shadowmancer/blur/shadowmancer_blur_start.vpcf"
	local effect = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN, self.parent)
	ParticleManager:SetParticleControl(effect, 0, self.parent:GetOrigin())
	ParticleManager:ReleaseParticleIndex(effect)

	if IsServer() then self.parent:EmitSound("Hero_PhantomAssassin.Blur") end
end