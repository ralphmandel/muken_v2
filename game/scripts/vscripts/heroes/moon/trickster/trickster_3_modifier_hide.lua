trickster_3_modifier_hide = class({})

function trickster_3_modifier_hide:IsHidden() return false end
function trickster_3_modifier_hide:IsPurgable() return true end

-- CONSTRUCTORS -----------------------------------------------------------

function trickster_3_modifier_hide:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  AddModifier(self.parent, self.ability, "_modifier_invisible", {attack_break = 0, spell_break = 0}, false)

  self.ability:SetActivated(false)
  self.ability:EndCooldown()

  if IsServer() then
    self:PlayEfxStart()
    self:StartIntervalThink(0.5)
  end
end

function trickster_3_modifier_hide:OnRefresh(kv)
end

function trickster_3_modifier_hide:OnRemoved()
  RemoveAllModifiersByNameAndAbility(self.parent, "_modifier_invisible", self.ability)

  self.ability:SetActivated(false)
  self.ability:StartCooldown(self.ability:GetEffectiveCooldown(self.ability:GetLevel()))
end

-- API FUNCTIONS -----------------------------------------------------------

function trickster_3_modifier_hide:OnIntervalThink()

  if IsServer() then self:StartIntervalThink(-1) end
end

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