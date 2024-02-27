_modifier_fear = class ({})

function _modifier_fear:IsHidden() return false end
function _modifier_fear:IsPurgable() return true end
function _modifier_fear:GetTexture() return "_modifier_fear" end
function _modifier_fear:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

-- CONSTRUCTORS -----------------------------------------------------------

function _modifier_fear:OnCreated(kv)
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

  if not IsServer() then return end

	self.target = self.parent:GetAggroTarget()
  self.special = kv.special or 0
  if kv.x and kv.y and kv.z then self.vec = Vector(kv.x, kv.y, kv.z) end
  local slow = kv.slow or 50

  self.parent:AddSubStats(self.ability, {slow_percent = slow})
  self.parent:AddStatusEfx(self.caster, self.ability, "_modifier_fear_status_efx")

  if self.special == 1 then
    self:PlayEfxStart("particles/econ/items/dark_willow/dark_willow_immortal_2021/dw_2021_willow_wisp_spell_debuff.vpcf", PATTACH_OVERHEAD_FOLLOW)
    self:PlayEfxStart("particles/genuine/genuine_fear.vpcf", PATTACH_ABSORIGIN_FOLLOW)
    self.parent:EmitSound("Hero_DarkWillow.Fear.Target")
    self.parent:StopSound("Genuine.Fear.Loop")
    self.parent:EmitSound("Genuine.Fear.Loop")
  elseif self.special == 2 then
    self:PlayEfxStart("particles/econ/items/dark_willow/dark_willow_immortal_2021/dw_2021_willow_wisp_spell_debuff.vpcf", PATTACH_OVERHEAD_FOLLOW)
    self:PlayEfxStart("particles/genuine/genuine_fear.vpcf", PATTACH_ABSORIGIN_FOLLOW)
    self.parent:EmitSound("Hero_DarkWillow.Fear.Target")      
  else
    self:PlayEfxStart("particles/units/heroes/hero_lone_druid/lone_druid_savage_roar_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW)
  end

  self:OnIntervalThink()
end

function _modifier_fear:OnRefresh(kv)
end

function _modifier_fear:OnRemoved(kv)
  if not IsServer() then return end

	if self.target then
		self.parent:MoveToTargetToAttack(self.target)
	else
		self.parent:Stop()
	end

  self.parent:RemoveSubStats(self.ability, {"slow_percent"})
  self.parent:RemoveStatusEfx(self.caster, self.ability, "_modifier_fear_status_efx")

  if self.special == 1 then self.parent:StopSound("Genuine.Fear.Loop") end

  if self.endCallback then
		self.endCallback(self.interrupted)
	end
end

function _modifier_fear:SetEndCallback(func)
	self.endCallback = func
end

-- API FUNCTIONS -----------------------------------------------------------

function _modifier_fear:CheckState()
	local state = {
    [MODIFIER_STATE_FEARED] = true,
    [MODIFIER_STATE_COMMAND_RESTRICTED] = true
  }

	return state
end

-- UTILS -----------------------------------------------------------

function _modifier_fear:OnIntervalThink()
  if not IsServer() then return end

  local vec = self.vec or self.caster:GetAbsOrigin()
	local direction = vec - self.parent:GetAbsOrigin()

  if direction:Length2D() < 10 then
    vec = vec + RandomVector(15)
    direction = vec - self.parent:GetAbsOrigin()
  end

	local pos = self.parent:GetOrigin() + direction:Normalized() * -250
	self.parent:MoveToPosition(pos)

	self:StartIntervalThink(0.1)
end

-- EFFECTS -----------------------------------------------------------

function _modifier_fear:GetStatusEffectName()
  return "particles/status_fx/status_effect_lone_druid_savage_roar.vpcf"
end

function _modifier_fear:StatusEffectPriority()
  return MODIFIER_PRIORITY_HIGH
end

function _modifier_fear:PlayEfxStart(string, attach)
	local pfx = ParticleManager:CreateParticle(string, attach, self.parent)	
	self:AddParticle(pfx, false, false, -1, false, false)
end