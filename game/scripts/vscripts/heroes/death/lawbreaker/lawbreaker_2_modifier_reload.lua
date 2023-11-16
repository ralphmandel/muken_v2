lawbreaker_2_modifier_reload = class({})

function lawbreaker_2_modifier_reload:IsHidden() return true end
function lawbreaker_2_modifier_reload:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function lawbreaker_2_modifier_reload:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()
  self.ability.reloading = true
  self.efx = false

  if self.parent:HasModifier("lawbreaker_u_modifier_form") then
    self.parent:StartGesture(ACT_DOTA_GENERIC_CHANNEL_1)
  end
  
  if IsServer() then self:OnIntervalThink() end
end

function lawbreaker_2_modifier_reload:OnRefresh(kv)
end

function lawbreaker_2_modifier_reload:OnRemoved()
  self.parent:FadeGesture(ACT_DOTA_GENERIC_CHANNEL_1)
  self.parent:ClearActivityModifiers()
  self.ability.reloading = false
  self.ability:DisableGesture()
end

-- API FUNCTIONS -----------------------------------------------------------

function lawbreaker_2_modifier_reload:DeclareFunctions()
	local funcs = {
    MODIFIER_EVENT_ON_STATE_CHANGED,
    MODIFIER_EVENT_ON_UNIT_MOVED,
		MODIFIER_EVENT_ON_ATTACK_START
	}

	return funcs
end

function lawbreaker_2_modifier_reload:OnStateChanged(keys)
	if keys.unit ~= self.parent then return end
	if self.parent:IsStunned() or self.parent:IsHexed() or self.parent:IsFrozen() then
		self:Destroy()
	end
end

function lawbreaker_2_modifier_reload:OnUnitMoved(keys)
  if keys.unit == self.parent then self:Destroy() end
end 

function lawbreaker_2_modifier_reload:OnAttackStart(keys)
  if keys.attacker == self.parent then self:Destroy() end
end

-- UTILS -----------------------------------------------------------

function lawbreaker_2_modifier_reload:OnIntervalThink()
  if self.efx == false then
    self:PlayEfxStart()
    self.efx = true
  end

  local fast_reload = self.ability:GetSpecialValueFor("fast_reload")

  self.ability:IncrementBullets(fast_reload)

  if IsServer() then self:StartIntervalThink(fast_reload) end
end

-- EFFECTS -----------------------------------------------------------

function lawbreaker_2_modifier_reload:PlayEfxStart()
	local string = "particles/econ/items/windrunner/windranger_arcana/windranger_arcana_ambient.vpcf"
	local particle = ParticleManager:CreateParticle(string, PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(particle, 0, self.parent:GetOrigin())
	self:AddParticle(particle, false, false, -1, false, false)
end