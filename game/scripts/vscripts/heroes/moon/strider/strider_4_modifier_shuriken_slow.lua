strider_4_modifier_shuriken_slow = class({})

function strider_4_modifier_shuriken_slow:IsHidden() return false end
function strider_4_modifier_shuriken_slow:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function strider_4_modifier_shuriken_slow:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()
	self.amount = self.ability:GetSpecialValueFor("shuriken_amount")
	self.distance = self.ability:GetSpecialValueFor("shuriken_distance")
	self.speed = self.ability:GetSpecialValueFor("shuriken_speed")
	
  if IsServer() then
		Timers:CreateTimer(0.26, function()
			self:StartIntervalThink(0.02)
			EmitSoundOn( "Hero_Terrorblade.PreAttack", self.parent )
		end)
		
  end

	self.caster:StartGestureWithPlaybackRate(ACT_DOTA_GENERIC_CHANNEL_1, 2)

	self.projectile_name = "particles/strider/shuriken/strider_shuriken_base.vpcf"

	self.info = {
		Source = self.caster,
		Ability = self.ability,
		vSpawnOrigin = self.caster:GetAttachmentOrigin( self.caster:ScriptLookupAttachment( "attach_attack1" ) ),
		bDeleteOnHit = true,
		iUnitTargetTeam = self.ability:GetAbilityTargetTeam(),
		iUnitTargetType = self.ability:GetAbilityTargetType(),
		iUnitTargetFlags = self.ability:GetAbilityTargetFlags(),
		EffectName = self.projectile_name,
		fDistance = self.distance,
		fStartRadius = 50,
		fEndRadius = 50,
		-- vVelocity = projectile_direction * self.speed,
		bProvidesVision = false
	}
		-- get projectile main direction
		local point_init = Vector(kv.init_x, kv.init_y, kv.init_z)
		local point_end = Vector(kv.end_x, kv.end_y, kv.end_z)
		
		self.direction = point_end - point_init
		self.direction.z = self.direction.z + 90
		self.direction = self.direction:Normalized()
		self.current_amount = 0
		self.angle = 19
end

function strider_4_modifier_shuriken_slow:OnRefresh(kv)
  if IsServer() then
  end
end

function strider_4_modifier_shuriken_slow:OnRemoved(kv)
  if IsServer() then
		self.caster:FadeGesture(ACT_DOTA_GENERIC_CHANNEL_1)
  end
end

-- API FUNCTIONS -----------------------------------------------------------

function strider_4_modifier_shuriken_slow:OnIntervalThink()
	if self.current_amount <= self.amount then
	
		local angle_random = math.random(-self.angle, self.angle)
		--   -self.angle/2 + self.current_arrows*step
		
	
		-- calculate actual direction
		local projectile_direction = RotatePosition( Vector(0,0,0), QAngle( 0, angle_random, 0 ), self.direction )
	
		-- launch projectile
		self.info.vVelocity = projectile_direction * self.speed
	
		ProjectileManager:CreateLinearProjectile(self.info)
		self.amount = self.amount + 1
	else
		if IsServer() then
			self:StartIntervalThink(-1)
		end
	end


end

function strider_4_modifier_shuriken_slow:CheckState()
	local state = {
		[MODIFIER_STATE_IGNORING_MOVE_ORDERS] = true
	}
	return state
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------