strider_u_modifier_shadow = class({})

function strider_u_modifier_shadow:IsHidden()
	return false
end

function strider_u_modifier_shadow:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function strider_u_modifier_shadow:OnCreated( kv )
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	self.target = nil

	if IsServer() then 
		self:StartIntervalThink(0.1)
		self:PlayEffects()
		self:PlayEffects2()
	 end


end

function strider_u_modifier_shadow:OnRefresh( kv )
end

function strider_u_modifier_shadow:OnRemoved()
	if self.particle then ParticleManager:DestroyParticle(self.particle, false) end
	if self.parent:IsAlive() then self.parent:ForceKill(false) end
end

--------------------------------------------------------------------------------

function strider_u_modifier_shadow:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
	}

	return funcs
end

function strider_u_modifier_shadow:OnDeath(keys)
	if keys.unit == self.caster then self:Destroy() end
end

function strider_u_modifier_shadow:OnAttackLanded(keys)
	if keys.attacker ~= self.unit then return end
	if IsServer() then self.unit:EmitSound("Hero_Broodmother.Attack") end
end

function strider_u_modifier_shadow:GetAttackSound(keys)
    return ""
end

function strider_u_modifier_shadow:OnIntervalThink()
	if self.target then
		if IsValidEntity(self.target) then
			if self.target:IsAlive() then
				if IsServer() then self:StartIntervalThink(0.1) end
				return
			end
		end
	end

	self:ChangeTarget()
	if IsServer() then self:StartIntervalThink(0.1) end
end

function strider_u_modifier_shadow:ChangeTarget()
	local enemies = FindUnitsInRadius(
		self.parent:GetTeamNumber(), self.parent:GetOrigin(), nil, 250,
		DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		0, 0, false
	)

	for _,enemy in pairs(enemies) do
		self.target = enemy
		self.parent:SetForceAttackTarget(self.target)
		return
	end
end


function strider_u_modifier_shadow:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_UNTARGETABLE_ENEMY] = true,
	}
	return state
end

-- EFFECTS -----------------------------------------------------------
function strider_u_modifier_shadow:PlayEffects()
	-- MOD PARTICLE
	local string = "particles/strider/ult/strider_shadow_blur.vpcf"
	local particle = ParticleManager:CreateParticle(string, PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(particle, 0, self.parent:GetOrigin())
	self:AddParticle(particle, false, false, -1, false, false)
	ParticleManager:ReleaseParticleIndex( particle )
	print('EFEITO BLUR')

end

function strider_u_modifier_shadow:GetStatusEffectName()
	return "particles/strider/ult/strider_shadow_status_effect.vpcf"
end

function strider_u_modifier_shadow:StatusEffectPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end

function strider_u_modifier_shadow:PlayEffects2()
	local string = "particles/strider/ult/strider_shadow_ground.vpcf"
	self.particle = ParticleManager:CreateParticle(string, PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(self.particle, 0, self.parent:GetOrigin())
	self.parent:EmitSound("Hero_Invoker.ForgeSpirit")
end