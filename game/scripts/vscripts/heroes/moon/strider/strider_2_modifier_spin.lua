strider_2_modifier_spin = class({})
LinkLuaModifier("strider_2_modifier_bleeding", "heroes/moon/strider/strider_2_modifier_bleeding", LUA_MODIFIER_MOTION_NONE)

function strider_2_modifier_spin:IsHidden() return false end
function strider_2_modifier_spin:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function strider_2_modifier_spin:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if IsServer() then self:PlayEffects() end

	self.caster:StartGestureWithFadeAndPlaybackRate(ACT_DOTA_OVERRIDE_ABILITY_1, 0, 0.48, 2)

	Timers:CreateTimer((0.12), self:SpinDamage())
	
	self.damageTable = {
		--victim = caster,
		attacker = caster,
		damage = self.caster:GetAttackDamage(),
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
	}
end

function strider_2_modifier_spin:OnRefresh(kv)
  if IsServer() then
    self:PlayEffects()
  end
end

function strider_2_modifier_spin:OnRemoved()
	if self.particle_silence then ParticleManager:DestroyParticle(self.particle_silence, true) end
end

function strider_2_modifier_spin:OnDestroy()
  if IsServer() then

	end
end

-- API FUNCTIONS -----------------------------------------------------------
function strider_1_modifier_silence:CheckState()
	local state = {
		[MODIFIER_STATE_CANNOT_MISS] = true,
		[MODIFIER_STATE_IGNORING_MOVE_ORDERS] = true
	}
	return state
end

function strider_2_modifier_spin:SpinDamage()

	
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	
		self:GetParent():GetOrigin(),	
		nil,	-- handle, cacheUnit. (not known)
		self.ability:GetSpecialValueFor("radius"),	
		DOTA_UNIT_TARGET_TEAM_ENEMY,	
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- damage enemies
	for _,enemy in pairs(enemies) do
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
		AddModifier(enemy,self.ability,"strider_2_modifier_bleeding", true)
		-- Play effects
		self:PlayEffects2( enemy )
	end


end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function strider_2__spin:PlayEffects()
	-- Get Resources
local particle_cast = "particles/units/heroes/hero_juggernaut/juggernaut_blade_fury.vpcf"
local sound_cast = "Hero_Juggernaut.BladeFuryStart"

-- Create Particle
local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl( effect_cast, 5, Vector( self.radius, 0, 0 ) )

-- buff particle
self:AddParticle(
	effect_cast,
	false,
	false,
	-1,
	false,
	false
)

-- Emit sound
EmitSoundOn( sound_cast, self:GetParent() )
end

function strider_2_modifier_spin:PlayEffects2( target )
	local particle_cast = "particles/units/heroes/hero_juggernaut/juggernaut_blade_fury_tgt.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end