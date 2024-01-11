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

  if IsServer() then
    self:SetStackCount(self.ability:GetSpecialValueFor("hits"))
    self:PlayEfxStart()
  end
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

function trickster_3_modifier_hide:DeclareFunctions()
	local funcs = {
    MODIFIER_EVENT_ON_ATTACK_FAIL,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
    MODIFIER_EVENT_ON_ATTACKED
	}

	return funcs
end

function trickster_3_modifier_hide:OnAttackFail(keys)
  if keys.attacker ~= self.parent then return end

  --if IsServer() then self:DecrementStackCount() end
end

function trickster_3_modifier_hide:OnAttackLanded(keys)
  if keys.attacker ~= self.parent then return end

  if IsServer() then self:DecrementStackCount() end
end

function trickster_3_modifier_hide:OnAttacked(keys)
  if keys.attacker ~= self.parent then return end

  self.parent:Heal(keys.original_damage * self.ability:GetSpecialValueFor("special_lifesteal") * 0.01, self.ability)
end

function trickster_3_modifier_hide:OnStackCountChanged(old)
	if self:GetStackCount() ~= old and self:GetStackCount() == 0 then self:Destroy() return end
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

function trickster_3_modifier_hide:PlayEfxLifesteal()
	local particle = "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf"
	local effect = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(effect, 1, self.parent:GetOrigin())
	ParticleManager:ReleaseParticleIndex(effect)
end