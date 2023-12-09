ancient_2_modifier_pre = class({})

function ancient_2_modifier_pre:IsHidden() return true end
function ancient_2_modifier_pre:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function ancient_2_modifier_pre:OnCreated(kv)
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
  self.roar = true

  AddModifier(self.parent, self.ability, "ancient_2_modifier_gesture", {
    duration = self:GetDuration() + 0.2
  }, false)

	self.charge = self.ability:GetSpecialValueFor("max_charge_time")
	self.interval = 0.03
	self:StartIntervalThink(0.12)

	if not IsServer() then return end

	self.projectile_range = self.ability:GetSpecialValueFor("cast_range")
	self.projectile_width = self.ability:GetSpecialValueFor("width")

	self:SetDirection(Vector(kv.x, kv.y, 0))
	self.current_dir = self.target_dir
	self.face_target = true
	self.parent:SetForwardVector(self.current_dir)
	self.turn_speed = self.interval * self.ability:GetSpecialValueFor("turn_rate")

	self:PlayEfxStart()
end

function ancient_2_modifier_pre:OnRefresh(kv)
end

function ancient_2_modifier_pre:OnRemoved()
  if self.roar == true then
    local damage = self.ability:GetSpecialValueFor("damage")
    local loc_start = self.parent:GetOrigin()
    local direction = self.parent:GetForwardVector()
    local loc_end = loc_start + direction * self.projectile_range
    local strike = false
    
    if IsServer() then self:PlayEfxRoar(loc_start, loc_end) end
  
    local enemies = FindUnitsInLine(
      self.parent:GetTeamNumber(), loc_start, loc_end, nil, self.projectile_width,
      self.ability:GetAbilityTargetTeam(), self.ability:GetAbilityTargetType(),
      self.ability:GetAbilityTargetFlags()
    )
  
    for _, enemy in pairs(enemies) do
      if IsServer() then enemy:EmitSound("Hero_PrimalBeast.Uproar.Projectile.Split") end
      strike = true
  
      local knockback_mult = 2500
      local distance_percent = 1 - ((self.parent:GetOrigin() - enemy:GetOrigin()):Length2D() / self.projectile_range)
      if distance_percent < 0.2 then distance_percent = 0.2 end
      if distance_percent > 1 then distance_percent = 1 end
  
      local damage_result = ApplyDamage({
        victim = enemy, attacker = self.parent,
        ability = self.ability, damage = damage,
        damage_type = self.ability:GetAbilityDamageType()
      })
    
      if enemy then
        if IsValidEntity(enemy) then
          local disarm = self.ability:GetSpecialValueFor("special_disarm")
          local armor = self.ability:GetSpecialValueFor("special_armor")

          if disarm == 1 then
            AddModifier(enemy, self.ability, "_modifier_disarm", {
              duration = self.ability:GetSpecialValueFor("special_debuff_duration")
            }, true)
          end

          if armor < 0 then
            local modifier = AddSubStats(enemy, self.ability, {
              duration = self.ability:GetSpecialValueFor("special_debuff_duration"),
              armor = armor
            }, true)

            if modifier then
              modifier:AddParticle(
                ParticleManager:CreateParticle("particles/items3_fx/star_emblem.vpcf", PATTACH_OVERHEAD_FOLLOW, enemy),
                false, false, -1, false, false
              )
            end
          end

          AddModifier(enemy, self.ability, "modifier_knockback", {
            center_x = self.parent:GetAbsOrigin().x + 1,
            center_y = self.parent:GetAbsOrigin().y + 1,
            center_z = self.parent:GetAbsOrigin().z,
            knockback_height = 0,
            duration = (damage_result * distance_percent) / knockback_mult,
            knockback_duration = (damage_result * distance_percent) / knockback_mult,
            knockback_distance = (damage_result * distance_percent * self.projectile_range) / (knockback_mult * 0.8)
          }, true)
        end
      end
    end
  
    if strike == true then PlayEfxAncientStun(self.parent, damage, true) end
  else
    self.parent:RemoveModifierByName("ancient_2_modifier_gesture")
  end
end

-- API FUNCTIONS -----------------------------------------------------------

function ancient_2_modifier_pre:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = true
	}

	return state
end

function ancient_2_modifier_pre:DeclareFunctions()
	local funcs = {
    MODIFIER_EVENT_ON_STATE_CHANGED,
		MODIFIER_EVENT_ON_ORDER,		
		MODIFIER_PROPERTY_DISABLE_TURNING,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT
	}

	return funcs
end

function ancient_2_modifier_pre:OnStateChanged(keys)
  if keys.unit ~= self.parent then return end
  if self.parent:IsStunned() or self.parent:IsFrozen() or self.parent:IsHexed() then
    self.roar = false
    self:Destroy()
  end
end

function ancient_2_modifier_pre:OnOrder(keys)
	if keys.unit ~= self.parent then return end

	if keys.order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION
	or keys.order_type == DOTA_UNIT_ORDER_MOVE_TO_DIRECTION then
		self:SetDirection(keys.new_pos)

	elseif keys.order_type == DOTA_UNIT_ORDER_MOVE_TO_TARGET
	or keys.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET then
		self:SetDirection(keys.target:GetOrigin())
	end
end

function ancient_2_modifier_pre:GetModifierDisableTurning()
	return 1
end

function ancient_2_modifier_pre:GetModifierMoveSpeed_Limit()
	return 0.1
end

function ancient_2_modifier_pre:OnIntervalThink()
	if not IsServer() then
		self:UpdateStack()
		return
	end

	self:TurnLogic()

	local startpos = self.parent:GetOrigin()
	local visions = self.projectile_range / self.projectile_width
	local delta = self.parent:GetForwardVector() * self.projectile_width

	for i = 1, visions do
		AddFOWViewer(self.parent:GetTeamNumber(), startpos, self.projectile_width, 0.1, false)
		startpos = startpos + delta
	end

	local remaining = self:GetRemainingTime()
	local seconds = math.ceil(remaining)
	local isHalf = (seconds-remaining) > 0.5
	if isHalf then seconds = seconds - 1 end

	if self.half ~= isHalf then
		self.half = isHalf
		self:PlayEfxTimer(seconds, isHalf)
	end

	self:UpdateEffect()
  self:StartIntervalThink(self.interval)
end


-- UTILS -----------------------------------------------------------

function ancient_2_modifier_pre:SetDirection(vec)
	self.target_dir = ((vec - self.parent:GetOrigin()) * Vector(1,1,0)):Normalized()
	self.face_target = false
end

function ancient_2_modifier_pre:TurnLogic()
	-- only rotate when target changed
	if self.face_target then return end

	local current_angle = VectorToAngles( self.current_dir ).y
	local target_angle = VectorToAngles( self.target_dir ).y
	local angle_diff = AngleDiff( current_angle, target_angle )

	local sign = -1
	if angle_diff<0 then sign = 1 end

	if math.abs( angle_diff )<1.1*self.turn_speed then
		-- end rotating
		self.current_dir = self.target_dir
		self.face_target = true
	else
		-- rotate
		self.current_dir = RotatePosition( Vector(0,0,0), QAngle(0, sign*self.turn_speed, 0), self.current_dir )
	end

	-- set facing when not motion controlled
	local a = self.parent:IsCurrentlyHorizontalMotionControlled()
	local b = self.parent:IsCurrentlyVerticalMotionControlled()
	if not (a or b) then
		self.parent:SetForwardVector( self.current_dir )
	end
end

function ancient_2_modifier_pre:UpdateStack()
	-- only update stack percentage on client to reduce traffic
	local pct = math.min( self:GetElapsedTime(), self.charge )/self.charge
	pct = math.floor( pct*100 )
	self:SetStackCount( pct )
end

function ancient_2_modifier_pre:OrderFilter(data)
	if #data.units > 1 then return true end

	local unit
	for _,id in pairs(data.units) do
		unit = EntIndexToHScript(id)
	end
	if unit ~= self.parent then return true end

	if data.order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION then
		data.order_type = DOTA_UNIT_ORDER_MOVE_TO_DIRECTION

	elseif data.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET or data.order_type == DOTA_UNIT_ORDER_MOVE_TO_TARGET then
		local pos = EntIndexToHScript(data.entindex_target):GetOrigin()

		data.order_type = DOTA_UNIT_ORDER_MOVE_TO_DIRECTION
		data.position_x = pos.x
		data.position_y = pos.y
		data.position_z = pos.z
	end

	return true
end

-- EFFECTS -----------------------------------------------------------

function ancient_2_modifier_pre:PlayEfxStart()
	local startpos = self.parent:GetAbsOrigin()
	local endpos = startpos + self.parent:GetForwardVector() * self.projectile_range

	local particle_cast = "particles/units/heroes/hero_primal_beast/primal_beast_onslaught_range_finder.vpcf"
	local effect_cast = ParticleManager:CreateParticleForPlayer(particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent, self.parent:GetPlayerOwner())
	ParticleManager:SetParticleControl(effect_cast, 0, startpos)
	ParticleManager:SetParticleControl(effect_cast, 1, endpos)
	self:AddParticle(effect_cast, false, false, -1, false, false)
	self.effect_cast = effect_cast
end

function ancient_2_modifier_pre:PlayEfxRoar(loc_start, loc_end)
  local particle_cast = "particles/units/heroes/hero_beastmaster/beastmaster_primal_roar.vpcf"
  local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent)
  ParticleManager:SetParticleControlEnt(effect_cast, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
  ParticleManager:SetParticleControl(effect_cast, 1, loc_end)
  ParticleManager:ReleaseParticleIndex(effect_cast)

  if IsServer() then self.parent:EmitSound("Hero_PrimalBeast.Uproar.Scepter") end
end

function ancient_2_modifier_pre:PlayEfxTimer(seconds, half)
	local mid = 1
	if half then mid = 8 end

	local len = 2
	if seconds<1 then
		len = 1
		if not half then return end
	end

  local particle_cast = "particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter_timer.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(effect_cast, 1, Vector(1, seconds, mid))
	ParticleManager:SetParticleControl(effect_cast, 2, Vector(len, 0, 0))
end

function ancient_2_modifier_pre:UpdateEffect()
	local startpos = self.parent:GetAbsOrigin()
	local endpos = startpos + self.current_dir * self.projectile_range

	ParticleManager:SetParticleControl(self.effect_cast, 0, startpos)
	ParticleManager:SetParticleControl(self.effect_cast, 1, endpos)
end