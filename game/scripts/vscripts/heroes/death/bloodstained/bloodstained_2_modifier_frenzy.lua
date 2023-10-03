bloodstained_2_modifier_frenzy = class({})

function bloodstained_2_modifier_frenzy:IsHidden() return false end
function bloodstained_2_modifier_frenzy:IsPurgable() return true end

-- CONSTRUCTORS -----------------------------------------------------------

function bloodstained_2_modifier_frenzy:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

	self.parent:SetForceAttackTarget(self.ability.target)
	
  AddModifier(self.parent, self.ability, "sub_stat_modifier", {
    status_resist_stack = self.ability:GetSpecialValueFor("status_res"),
    attack_speed = self.ability:GetSpecialValueFor("attack_speed")
  }, false)

  AddModifier(self.parent, self.ability, "sub_stat_movespeed_increase", {
    value = self.ability:GetSpecialValueFor("ms")
  }, false)

	if IsServer() then
		self:PlayEfxStart()
		self:OnIntervalThink()
	end
end

function bloodstained_2_modifier_frenzy:OnRefresh(kv)
end

function bloodstained_2_modifier_frenzy:OnRemoved()
	self.parent:SetForceAttackTarget(nil)

  RemoveSubStats(self.parent, self.ability, {"attack_speed", "status_resist_stack"})
  RemoveAllModifiersByNameAndAbility(self.parent, "sub_stat_movespeed_increase", self.ability)
end

-- API FUNCTIONS -----------------------------------------------------------

function bloodstained_2_modifier_frenzy:CheckState()
	local state = {
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true
	}

	return state
end

function bloodstained_2_modifier_frenzy:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MIN_HEALTH,
    MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end

function bloodstained_2_modifier_frenzy:GetMinHealth()
  return 1
end

function bloodstained_2_modifier_frenzy:OnAttackLanded(keys)
  if keys.attacker ~= self.parent then return end

  local cleave = self.ability:GetSpecialValueFor("special_cleave") * 0.01
	local string = "particles/bloodstained/cleave/bloodstained_cleave.vpcf"
	if cleave > 0 then DoCleaveAttack(self.parent, keys.target, self.ability, keys.damage * cleave, 100, 400, 500, string) end
end

function bloodstained_2_modifier_frenzy:OnIntervalThink()
	if IsServer() then		
		local enemies = FindUnitsInRadius(
			self.caster:GetTeamNumber(), self.parent:GetOrigin(), nil, 500,
			DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false
		)
	
		for _,enemy in pairs(enemies) do
			self.ability.target = enemy
			self.parent:SetForceAttackTarget(self.ability.target)
			self:StartIntervalThink(FrameTime())
			return
		end
    
		self:Destroy()
	end
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function bloodstained_2_modifier_frenzy:GetEffectName()
	return "particles/bloodstained/frenzy/bloodstained_hands_v2.vpcf"
end

function bloodstained_2_modifier_frenzy:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function bloodstained_2_modifier_frenzy:PlayEfxStart()
	local loc = self.parent:GetOrigin()
	local particle_cast = "particles/bloodstained/frenzy/bloodstained_frenzy.vpcf"
	local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControlEnt(effect_cast, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_attack1", loc, true)
	ParticleManager:SetParticleControlEnt(effect_cast, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_attack2", loc, true)
	ParticleManager:SetParticleControlEnt(effect_cast, 2, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", loc, true)
	self:AddParticle(effect_cast, false, false, -1, false, true)

	local particle_cast_2 = "particles/osiris/poison_alt/osiris_poison_splash_shake.vpcf"
	local effect = ParticleManager:CreateParticle(particle_cast_2, PATTACH_ABSORIGIN, self.parent)
	ParticleManager:SetParticleControl(effect, 0, loc)
	ParticleManager:SetParticleControl(effect, 1, Vector(500, 0, 0))

	if IsServer() then self.parent:EmitSound("Hero_ShadowDemon.DemonicPurge.Damage") end
end