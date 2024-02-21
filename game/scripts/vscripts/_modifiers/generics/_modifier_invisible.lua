_modifier_invisible = class({})

function _modifier_invisible:IsHidden() return false end
function _modifier_invisible:IsPurgable() return true end
function _modifier_invisible:GetTexture() return "_modifier_invisible" end
function _modifier_invisible:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

--------------------------------------------------------------------------------

function _modifier_invisible:OnCreated( kv )
	local delay = kv.delay or 0
	self.spell_break = kv.spell_break or 0
	self.attack_break = kv.attack_break or 100
	self.delay = false
  self.hidden = false
  self.interrupted = false

	if not IsServer() then return end

  if delay == 0 then
    self.hidden = true
  else
    self:StartIntervalThink(delay)
  end

  AddModifierOnAllCosmetics(self:GetParent(), self:GetAbility(), "_modifier_invi_level", {level = 1})

  if self.attack_break > 0 and self:GetParent():GetAttackTarget() then
    self:GetParent():MoveToTargetToAttack(self:GetParent():GetAttackTarget())
  end
end

function _modifier_invisible:OnRefresh( kv )
end

function _modifier_invisible:OnDestroy( kv )
  if not IsServer() then return end

	RemoveModifierOnAllCosmetics(self:GetParent(), self:GetAbility(), "_modifier_invi_level")

  if self.endCallback then
		self.endCallback(self.interrupted)
	end
end

function _modifier_invisible:SetEndCallback(func)
	self.endCallback = func
end

-------------------------------------------------------------

function _modifier_invisible:CheckState()
	local state = {
		[MODIFIER_STATE_INVISIBLE] = self.hidden,
	}

	return state
end

function _modifier_invisible:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_EVENT_ON_ABILITY_START
	}

	return funcs
end

function _modifier_invisible:OnAttackStart(keys)
  if not IsServer() then return end

  if keys.attacker == self:GetParent()
  and RandomFloat(0, 100) < self.attack_break then
    self.interrupted = true
    self:Destroy()
  end
end

function _modifier_invisible:OnAbilityStart(keys)
  if not IsServer() then return end

	if keys.unit == self:GetParent()
  and RandomFloat(0, 100) < self.spell_break then
    self.interrupted = true
    self:Destroy()
  end
end

function _modifier_invisible:OnIntervalThink()
  if not IsServer() then return end

	if self.delay == false then
		self.delay = true
		self:PlayEffects()
		self:StartIntervalThink(0.2)
	else
		self.hidden = true
		self:StartIntervalThink(-1)
	end
end

--------------------------------------------------------------------------------

-- function _modifier_invisible:GetEffectName()
-- 	return "particles/units/heroes/hero_phantom_assassin/phantom_assassin_blur.vpcf"
-- end

-- function _modifier_invisible:GetEffectAttachType()
-- 	return PATTACH_ABSORIGIN_FOLLOW
-- end

function _modifier_invisible:PlayEffects()
	local particle_cast = "particles/econ/items/gyrocopter/gyro_ti10_immortal_missile/gyro_ti10_immortal_missile_explosion.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	self:AddParticle(effect_cast, false, false, -1, false, false)
end