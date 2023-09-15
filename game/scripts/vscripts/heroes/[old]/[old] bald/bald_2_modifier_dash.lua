bald_2_modifier_dash = class ({})

function bald_2_modifier_dash:IsHidden() return true end
function bald_2_modifier_dash:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function bald_2_modifier_dash:OnCreated(kv)
    self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.ability:SetActivated(false)

	self.trigger = false

	local vector = (self.ability.target:GetAbsOrigin() - self.parent:GetAbsOrigin()):Normalized()
	self.parent:SetForwardVector(vector)
	self.angle = self.parent:GetForwardVector():Normalized()

	local distance = self.ability:GetCastRange(self.parent:GetOrigin(), self.ability.target) + 200
	local time = self:GetDuration() / FrameTime()
	self.distance = distance / time

	if IsServer() then
		self:StartIntervalThink(FrameTime())
		self:PlayEfxStart()
	end
end

function bald_2_modifier_dash:OnRefresh(kv)
end

function bald_2_modifier_dash:OnRemoved()
end

function bald_2_modifier_dash:OnDestroy()
	if not IsServer() then return end
	
	ResolveNPCPositions(self.parent:GetAbsOrigin(), 128)

	if self.trigger == false then
		self.parent:MoveToPosition(self.parent:GetOrigin())
		self.ability:SetActivated(true)
	end
end

-- API FUNCTIONS -----------------------------------------------------------

function bald_2_modifier_dash:CheckState()
	local state = {
		[MODIFIER_STATE_SILENCED] = true
	}
	return state
end

function bald_2_modifier_dash:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DISABLE_TURNING
	}

	return funcs
end

function bald_2_modifier_dash:GetModifierDisableTurning()
	return 1
end

function bald_2_modifier_dash:OnIntervalThink()
	self:HorizontalMotion(self.parent, FrameTime())
end

function bald_2_modifier_dash:HorizontalMotion(unit, time)
	if not IsServer() then return end

	local pos = unit:GetAbsOrigin()
	GridNav:DestroyTreesAroundPoint(pos, 80, false)
	local pos_p = self.angle * self.distance
	local next_pos = GetGroundPosition(pos + pos_p,unit)
	unit:SetAbsOrigin(next_pos)

	if self.ability.target then
		if IsValidEntity(self.ability.target) then
			if self.ability:GetSpecialValueFor("special_bash_aoe") > 0 then
				local enemies = FindUnitsInRadius(
					self.parent:GetTeamNumber(), self.parent:GetOrigin(), nil, self.ability:GetSpecialValueFor("special_bash_aoe"),
					DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
					DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false
				)
			
				for _,enemy in pairs(enemies) do
					if self.ability.target ~= enemy then
						self.ability:ApplyImpact(enemy)
					end
				end
			end

			local distance = CalcDistanceBetweenEntityOBB(self.parent, self.ability.target)
			if distance <= 100 then
				self.parent:AddNewModifier(self.caster, self.ability, "bald_2_modifier_impact", {duration = 0.3})
				self.parent:MoveToTargetToAttack(self.ability.target)
				self.trigger = true
				self:Destroy()
			end			
		end
	end
end

-- EFFECTS -----------------------------------------------------------

function bald_2_modifier_dash:GetEffectName()
	return "particles/bald/bald_dash/bald_dash.vpcf"
end

function bald_2_modifier_dash:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function bald_2_modifier_dash:PlayEfxStart()
	if IsServer() then self.parent:EmitSound("Bald.Dash") end
end