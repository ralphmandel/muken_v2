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
			self:StartIntervalThink(0.05)
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
		local point = Vector(kv.x, kv.y, kv.z)
		self.direction = point-self:GetCaster():GetOrigin()
		self.direction.z = self.direction.z + 90
		self.direction = self.direction:Normalized()
		self.current_amount = 0
		self.angle = 50
end

function strider_4_modifier_shuriken_slow:OnRefresh(kv)
  if IsServer() then
  end
end

function strider_4_modifier_shuriken_slow:OnRemoved(kv)
  if IsServer() then
		self.caster:FadeGesture((ACT_DOTA_GENERIC_CHANNEL_1)
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
	end

end


function strider_4_modifier_shuriken_slow:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
end

function strider_4_modifier_shuriken_slow:OnTakeDamage(keys)
	if IsServer() then

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

-- function strider_4_modifier_shuriken_slow:GetEffectName()
-- 	return "particles/items2_fx/orchid.vpcf"
-- end

-- function strider_4_modifier_shuriken_slow:GetEffectAttachType()
-- 	return PATTACH_OVERHEAD_FOLLOW
-- end

function strider_4_modifier_shuriken_slow:PlayEfxStart()
  if IsServer() then self.parent:EmitSound("Hero_PhantomAssassin.Dagger.Target") end

end

function strider_4_modifier_shuriken_slow:GetEffectName()
	return "particles/econ/items/phantom_assassin/pa_ti8_immortal_head/pa_ti8_immortal_dagger_debuff.vpcf"
end

function strider_4_modifier_shuriken_slow:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


-- function strider_4_modifier_shuriken_slow:PlayEfxEnemy()
--   local particle_cast = "particles/econ/items/phantom_assassin/pa_ti8_immortal_head/pa_ti8_immortal_dagger_debuff.vpcf"
--   local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent)
--   ParticleManager:SetParticleControl(effect_cast, 2, Vector(radius, radius, radius))
-- end



