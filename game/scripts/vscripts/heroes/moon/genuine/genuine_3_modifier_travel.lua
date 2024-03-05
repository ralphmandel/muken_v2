genuine_3_modifier_travel = class({})

function genuine_3_modifier_travel:IsHidden() return true end
function genuine_3_modifier_travel:IsPurgable() return false end
function genuine_3_modifier_travel:GetPriority() return MODIFIER_PRIORITY_SUPER_ULTRA end

-- CONSTRUCTORS -----------------------------------------------------------

function genuine_3_modifier_travel:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  self.ability.casting = nil
  self.ability.aggro_target = self.parent:GetAggroTarget()

  self.ban = self.parent:AddModifier(self.ability, "_modifier_ban", {})
	self:PlayEfxStart()
end

function genuine_3_modifier_travel:OnRefresh(kv)
end

function genuine_3_modifier_travel:OnRemoved()
  if not IsServer() then return end

  if self.ban:IsNull() == false then self.ban:Destroy() end

  self:PlayEfxEnd()
end

-- API FUNCTIONS -----------------------------------------------------------

function genuine_3_modifier_travel:CheckState()
	local state = {
    [MODIFIER_STATE_STUNNED] = false,
    [MODIFIER_STATE_COMMAND_RESTRICTED] = false,
    [MODIFIER_STATE_DISARMED] = true,
    [MODIFIER_STATE_SILENCED] = true,
  }

  if self.ability:GetSpecialValueFor("special_no_disarm") == 1 then
    state = {
      [MODIFIER_STATE_STUNNED] = false,
      [MODIFIER_STATE_COMMAND_RESTRICTED] = false,
    }
  end

	return state
end

function genuine_3_modifier_travel:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ORDER
	}

	return funcs
end

function genuine_3_modifier_travel:OnOrder(keys)
  if not IsServer() then return end

	if keys.unit ~= self.parent then return end
  if self.parent:HasModifier("genuine_3_modifier_travel") == false then return end

  if keys.order_type > 4 and keys.order_type < 10 then
    self.ability.casting = true
    self:StartIntervalThink(keys.ability:GetCastPoint() + 0.2)
  end

  if keys.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET then
    self.ability.aggro_target = keys.target
  end

  if keys.order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION and self.ability.projectileData
  and self.ability:GetSpecialValueFor("change_direction") == 1 and self.ability:IsCooldownReady() then
    local new_pos = keys.new_pos
    local direction = self.ability.projectileData.direction
    local max_distance = self.ability.projectileData.max_distance

    local angle_1 = VectorToAngles(direction)
    local angle_2 = VectorToAngles(new_pos - self.parent:GetOrigin())
    local angle_diff = AngleDiff(angle_1.y, angle_2.y)

    if angle_diff > -45 and angle_diff < 45 then return end

    if angle_diff >= 135 or angle_diff <= -135 then
      new_pos = self.parent:GetOrigin() - (direction:Normalized() * max_distance)
    else
      if angle_diff >= 45 then angle_diff = 90 end
      if angle_diff <= -45 then angle_diff = -90 end

      local pos_mult = max_distance * (math.sin(math.rad(angle_diff)))
      new_pos = self.parent:GetOrigin() + (CrossVectors(direction, Vector(0, 0, 1)):Normalized() * pos_mult)
    end

    local travelled_distance = (self.ability.projectileData.origin - self.ability.projectileData.location):Length2D()

    Timers:CreateTimer(FrameTime(), function()
      if self:IsNull() == false then
        self.parent:Stop()
        self.ability:SetDirection()
      end
    end)

    self.ability:DestroyOrb(false)
    self.ability:CreateOrb(new_pos, travelled_distance, false)
  end
end

function genuine_3_modifier_travel:OnIntervalThink()
  if not IsServer() then return end

  self.ability.casting = nil
  self:StartIntervalThink(-1)
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function genuine_3_modifier_travel:PlayEfxStart()
  local particle_cast = "particles/units/heroes/hero_puck/puck_illusory_orb_blink_out.vpcf"
  local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN, self.parent)
  ParticleManager:SetParticleControl(effect_cast, 0, self.parent:GetOrigin())
  ParticleManager:ReleaseParticleIndex(effect_cast)
end

function genuine_3_modifier_travel:PlayEfxEnd()
  local radius = self.ability:GetSpecialValueFor("silence_radius")
  local particle_cast = "particles/genuine/genuine_travel_silence/genuine_silence_aproset.vpcf"
  local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_WORLDORIGIN, self.parent)
  ParticleManager:SetParticleControl(effect_cast, 0, self.parent:GetOrigin())
  ParticleManager:SetParticleControl(effect_cast, 1, Vector(radius, radius, radius))
  ParticleManager:ReleaseParticleIndex(effect_cast)

  self.parent:EmitSound("Hero_Puck.Waning_Rift")
end