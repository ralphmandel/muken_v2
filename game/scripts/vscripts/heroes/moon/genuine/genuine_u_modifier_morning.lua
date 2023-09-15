genuine_u_modifier_morning = class({})

function genuine_u_modifier_morning:IsHidden() return false end
function genuine_u_modifier_morning:IsPurgable() return false end
function genuine_u_modifier_morning:RemoveOnDeath() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function genuine_u_modifier_morning:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()
  self.int_allies = self.ability.kills

	self.ability:SetActivated(false)

  AddBonus(self.ability, "AGI", self.parent, self.ability:GetSpecialValueFor("agi"), 0, nil)
  AddBonus(self.ability, "REC", self.parent, self.ability:GetSpecialValueFor("rec"), 0, nil)

  GameRules:BeginTemporaryNight(self:GetDuration())

	if IsServer() then self.parent:EmitSound("Genuine.Morning") end
end

function genuine_u_modifier_morning:OnRefresh(kv)
end

function genuine_u_modifier_morning:OnRemoved()
  self.parent:FindModifierByName(self.ability:GetIntrinsicModifierName()):StopEfxBuff()
	self.ability:SetActivated(true)

	RemoveBonus(self.ability, "AGI", self.parent)
	RemoveBonus(self.ability, "REC", self.parent)
end

-- API FUNCTIONS -----------------------------------------------------------

function genuine_u_modifier_morning:CheckState()
	local state = {
		[MODIFIER_STATE_FORCED_FLYING_VISION] = true
	}

	return state
end

-- function genuine_u_modifier_morning:DeclareFunctions()
-- 	local funcs = {
-- 		MODIFIER_EVENT_ON_MODIFIER_ADDED
-- 	}
	
-- 	return funcs
-- end

-- function genuine_u_modifier_morning:OnModifierAdded(keys)
-- 	if keys.unit:GetTeamNumber() == self.parent:GetTeamNumber() then return end
-- 	if keys.added_buff:IsDebuff() == false then return end
--   if CalcDistanceBetweenEntityOBB(keys.unit, self.parent) > self.ability:GetAOERadius() then return end

--   local exceptions = {
-- 		"_1_AGI_modifier_stack", "_1_CON_modifier_stack",
-- 		"_1_INT_modifier_stack", "_1_STR_modifier_stack",
-- 		"_2_DEF_modifier_stack", "_2_DEX_modifier_stack",
-- 		"_2_LCK_modifier_stack", "_2_MND_modifier_stack",
-- 		"_2_REC_modifier_stack", "_2_RES_modifier_stack",
-- 		"_modifier_blind", "_modifier_movespeed_debuff",
--     "_modifier_percent_movespeed_debuff"
-- 	}

-- 	for _,mod_name in pairs(exceptions) do
-- 		if mod_name == keys.added_buff:GetName() then return end
-- 	end

-- 	local damage = ApplyDamage({
-- 		damage = self.ability:GetSpecialValueFor("special_strike_damage"),
-- 		attacker = self.caster, victim = keys.unit, ability = self.ability,
-- 		damage_type = self.ability:GetAbilityDamageType()
-- 	})

-- 	if keys.unit then
-- 		if IsValidEntity(keys.unit) then
-- 			self:PlayEfxDamage(keys.unit, damage)			
-- 		end
-- 	end
-- end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

-- function genuine_u_modifier_morning:PlayEfxDamage(target, damage)
-- 	if damage == 0 then return end

-- 	local particle = "particles/genuine/genuine_zap/genuine_zap_attack_heavy_ti_5.vpcf"
-- 	local zap_pfx = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN, target)
-- 	ParticleManager:SetParticleControlEnt(zap_pfx, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
-- 	ParticleManager:SetParticleControlEnt(zap_pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
-- 	ParticleManager:ReleaseParticleIndex(zap_pfx)

-- 	if IsServer() then
-- 		self.parent:EmitSound("Hero_Pugna.NetherWard.Attack")
-- 		target:EmitSound("Hero_Pugna.NetherWard.Target")
-- 	end
-- end