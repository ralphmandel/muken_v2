paladin_5_modifier_sonicblow = class({})

function paladin_5_modifier_sonicblow:IsHidden() return true end
function paladin_5_modifier_sonicblow:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function paladin_5_modifier_sonicblow:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  self.ban = true

  -- MAX ASPD: 800
  self.parent:AddSubStats(self.ability, {attack_speed = 9999, attack_time = 0.6})
  self.parent:AddModifier(self.ability, "_modifier_ban", {})
  self.parent:Stop()

  ProjectileManager:ProjectileDodge(self.parent)

  self.target = EntIndexToHScript(kv.target)
  self:SetStackCount(self.ability:GetSpecialValueFor("special_hits"))
  self:PlayEfxBlinkStart()
  self:StartIntervalThink(0.3)
end

function paladin_5_modifier_sonicblow:OnRefresh(kv)
end

function paladin_5_modifier_sonicblow:OnRemoved()
  if not IsServer() then return end

  self.parent:RemoveSubStats(self.ability, {"attack_speed", "attack_time"})
  self.parent:RemoveAllModifiersByNameAndAbility("_modifier_ban", self.ability)
end

-- API FUNCTIONS -----------------------------------------------------------

function paladin_5_modifier_sonicblow:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK,
    MODIFIER_EVENT_ON_STATE_CHANGED,
    MODIFIER_EVENT_ON_UNIT_MOVED,
    MODIFIER_EVENT_ON_ORDER
	}

	return funcs
end

function paladin_5_modifier_sonicblow:OnStateChanged(keys)
  if not IsServer() then return end

	if keys.unit ~= self.parent then return end
  if self.ban == true then return end

	if self.parent:IsStunned()
	or self.parent:IsHexed()
	or self.parent:IsFrozen()
	or self.parent:IsDisarmed() then
		self:Destroy()
	end
end

function paladin_5_modifier_sonicblow:OnUnitMoved(keys)
  if not IsServer() then return end

	if keys.unit == self.parent then self:Destroy() end
end

function paladin_5_modifier_sonicblow:OnOrder(keys)
  if not IsServer() then return end

	if keys.unit ~= self.parent then return end
	if keys.order_type > 10 then return end
	if keys.order_type == 4 then
		if keys.target then
			if keys.target == self.target then
				return
			end
		end
	end

	self:Destroy()
end

function paladin_5_modifier_sonicblow:OnAttack(keys)
  if not IsServer() then return end

	if keys.attacker ~= self.parent then return end

  if keys.target == self.target then
    self:DecrementStackCount()
  else
    self:SetStackCount(0)
  end
end

function paladin_5_modifier_sonicblow:OnIntervalThink()
  if not IsServer() then return end

  self.parent:RemoveAllModifiersByNameAndAbility("_modifier_ban", self.ability)

  if self.target then
    if IsValidEntity(self.target) then
      self.ban = false
      local point = self.target:GetAbsOrigin() + RandomVector(250)

      local blink_point = (point - self.target:GetOrigin()):Normalized() * 50
      blink_point = self.target:GetOrigin() + blink_point
      GridNav:DestroyTreesAroundPoint(blink_point, 150, false)

      self.parent:SetAbsOrigin(blink_point)
      self.parent:SetForwardVector((self.target:GetAbsOrigin() - blink_point):Normalized())
      FindClearSpaceForUnit(self.parent, blink_point, true)

      self.parent:MoveToTargetToAttack(self.target)
      self:PlayEfxBlinkEnd(point)

      if self.target:IsMagicImmune() == false then
        self.target:AddModifier(self.ability, "modifier_knockback", {
          center_x = self.parent:GetAbsOrigin().x + 1,
          center_y = self.parent:GetAbsOrigin().y + 1,
          center_z = self.parent:GetAbsOrigin().z,
          knockback_height = 12,
          duration = 0.3,
          knockback_duration = 0.3,
          knockback_distance = 75
        })   
      end
    
      self.target:EmitSound("Hero_Spirit_Breaker.Charge.Impact")
      self:StartIntervalThink(-1)
      return
    end
  end

  self:Destroy()
end

function paladin_5_modifier_sonicblow:OnStackCountChanged(old)
	if self:GetStackCount() == 0 and self:GetStackCount() ~= old then self:Destroy() end
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function paladin_5_modifier_sonicblow:PlayEfxBlinkStart()
	local particle_cast = "particles/econ/events/ti10/blink_dagger_start_ti10_splash.vpcf"
  local direction = self.target:GetOrigin() - self.parent:GetOrigin()

  local blink_start_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_WORLDORIGIN, nil)
  ParticleManager:SetParticleControl(blink_start_fx, 0, self.parent:GetOrigin())
  ParticleManager:SetParticleControlForward(blink_start_fx, 0, direction:Normalized())
	ParticleManager:SetParticleControl(blink_start_fx, 1, self.target:GetOrigin() + direction)
  ParticleManager:ReleaseParticleIndex(blink_start_fx)

	self.parent:EmitSound("Hero_Antimage.Blink_out")
end

function paladin_5_modifier_sonicblow:PlayEfxBlinkEnd(point)
	local particle_cast_a = "particles/econ/items/phantom_assassin/pa_fall20_immortal_shoulders/pa_fall20_blur_start.vpcf"
	local particle_cast_b = "particles/econ/events/ti10/blink_dagger_end_ti10_lvl2.vpcf"
  local direction = self.target:GetAbsOrigin() - point
	
	local effect_cast_a = ParticleManager:CreateParticle(particle_cast_a, PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(effect_cast_a, 0, point)
	ParticleManager:SetParticleControlForward(effect_cast_a, 0, direction:Normalized())
	ParticleManager:SetParticleControl(effect_cast_a, 1, point + direction)
	ParticleManager:ReleaseParticleIndex(effect_cast_a)

  local blink_end_fx = ParticleManager:CreateParticle(particle_cast_b, PATTACH_ABSORIGIN, self.parent)
  ParticleManager:SetParticleControl(blink_end_fx, 0, self.parent:GetOrigin())
  ParticleManager:SetParticleControlForward( blink_end_fx, 0, direction:Normalized())
  ParticleManager:ReleaseParticleIndex(blink_end_fx)

	self.parent:EmitSound("Hero_Antimage.Blink_in.Persona")
end