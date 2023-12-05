strider_2_modifier_spin = class({})

function strider_2_modifier_spin:IsHidden() return false end
function strider_2_modifier_spin:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function strider_2_modifier_spin:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

	self.caster:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_1)
	self:PlayEffects()
	
	if IsServer() then
   self:StartIntervalThink(0.1)
  end

end

function strider_2_modifier_spin:OnRefresh(kv)
  if IsServer() then
   
  end
end

function strider_2_modifier_spin:OnRemoved()
	--if self.particle_silence then ParticleManager:DestroyParticle(self.particle_silence, true) end
	self.caster:FadeGesture(ACT_DOTA_OVERRIDE_ABILITY_1)
end

function strider_2_modifier_spin:OnDestroy()
  if IsServer() then

	end
end

-- API FUNCTIONS -----------------------------------------------------------
function strider_2_modifier_spin:CheckState()
	local state = {
		[MODIFIER_STATE_CANNOT_MISS] = true,
		[MODIFIER_STATE_IGNORING_MOVE_ORDERS] = true
	}
	return state
end

function strider_2_modifier_spin:OnIntervalThink()

	if IsServer() then
		local enemies = FindUnitsInRadius(
			self.caster:GetTeamNumber(),	
			self.parent:GetOrigin(),	
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
			self.parent:PerformAttack(enemy, false, true, true, true, false, false, false)
			AddModifier(enemy,self.ability,"_modifier_bleeding", {duration = self.ability:GetSpecialValueFor("bleeding_duration")},true)
			-- Play effects
			self:PlayEffects2(enemy)
		end
		self:StartIntervalThink(-1)
	end
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------
function strider_2_modifier_spin:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/strider/spin/strider_bloodchaser.vpcf"
	local sound_cast = "DOTA_Item.AbyssalBlade.Activate"
	
	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	
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
	if IsServer() then
		EmitSoundOn( sound_cast, self:GetParent() )
	end
end


function strider_2_modifier_spin:PlayEffects2(target)
	print("HAJIME999999999999999999999")
	local particle_cast = "particles/units/heroes/hero_juggernaut/juggernaut_blade_fury_tgt.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end
