striker_3_modifier_buff = class({})

function striker_3_modifier_buff:IsHidden() return false end
function striker_3_modifier_buff:IsPurgable() return true end

-- CONSTRUCTORS -----------------------------------------------------------

function striker_3_modifier_buff:OnCreated(kv)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

	self.ticks = self.ability:GetSpecialValueFor("max_ticks")
	self.amount = self.ability:GetSpecialValueFor("init_amount")
	self.amount_reduction = self.ability:GetSpecialValueFor("amount_reduction")
	self.tick_interval = self.ability:GetSpecialValueFor("tick_interval")

	if IsServer() then
		self:ApplyTick()
		self:PlayEfxStart()
	end
end

function striker_3_modifier_buff:OnRefresh(kv)
	if IsServer() then
		self:ModifyStack(0, true)
		self:PlayEfxStart()
	end
end

function striker_3_modifier_buff:OnRemoved()
	if self.particle then ParticleManager:DestroyParticle(self.particle, false) end
  RemoveAllModifiersByNameAndAbility(self.parent, "_modifier_movespeed_buff", self.ability)
end

-- API FUNCTIONS -----------------------------------------------------------

function striker_3_modifier_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}

	return funcs
end

function striker_3_modifier_buff:OnTakeDamage(keys)
	if keys.unit ~= self.parent then return end
	if keys.damage_category ~= DOTA_DAMAGE_CATEGORY_ATTACK then return end
	if keys.damage > 0 then self:ModifyStack(self.ability:GetSpecialValueFor("tick_decrease"), false) end
end

function striker_3_modifier_buff:OnIntervalThink()
	if IsServer() then self:ApplyTick() end
end

function striker_3_modifier_buff:OnStackCountChanged(old)
	if self:GetStackCount() < 1 then self:Destroy() end
end

-- UTILS -----------------------------------------------------------

function striker_3_modifier_buff:ApplyTick()
	if RandomFloat(0, 100) < self.ability:GetSpecialValueFor("special_purge_chance") then
		self.parent:Purge(false, true, false, true, false)
		self:PlayEfxPurge()
	end

	local heal = self.amount * BaseStats(self.caster):GetHealPower()
  if heal > 0 then self.parent:Heal(heal, self.ability) end

	self:ModifyStack(1, true)

	if self.particle then ParticleManager:SetParticleControl(self.particle, 1, self.parent:GetAbsOrigin()) end
	if IsServer() then self:StartIntervalThink(self.tick_interval) end
end

function striker_3_modifier_buff:ModifyStack(value, bModifyAmount)
	if value == 0 and bModifyAmount then
		self.ticks = self.ability:GetSpecialValueFor("max_ticks")
		self.amount = self.amount + self.ability:GetSpecialValueFor("init_amount")
	end

  RemoveAllModifiersByNameAndAbility(self.parent, "_modifier_movespeed_buff", self.ability)

	local ms = self.ability:GetSpecialValueFor("special_movespeed") * self.ticks
	if ms > 0 then
		self.parent:AddNewModifier(self.caster, self.ability, "_modifier_movespeed_buff", {percent = ms})
	end

	self.ticks = self.ticks - value

	if bModifyAmount then
		self.amount = self.amount * (100 - self.amount_reduction) * 0.01
	end

	if IsServer() then self:SetStackCount(self.ticks) end
end

-- EFFECTS -----------------------------------------------------------

function striker_3_modifier_buff:PlayEfxStart()
	if self.particle then ParticleManager:DestroyParticle(self.particle, false) end

	local string = "particles/econ/events/fall_2021/blink_dagger_fall_2021_end.vpcf"
    local particle = ParticleManager:CreateParticle(string, PATTACH_WORLDORIGIN, self.parent)
	ParticleManager:SetParticleControl(particle, 0, self.parent:GetOrigin())

	local string_2 = "particles/econ/events/fall_2021/radiance_fall_2021.vpcf"
	self.particle = ParticleManager:CreateParticle(string_2, PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(self.particle, 0, self.parent:GetAbsOrigin())
	ParticleManager:SetParticleControl(self.particle, 1, self.parent:GetAbsOrigin())
	self:AddParticle(self.particle, false, false, -1, false, false)

	if IsServer() then self.parent:EmitSound("Hero_Striker.Portal.Buff") end
end

function striker_3_modifier_buff:PlayEfxPurge()
	local string = "particles/striker/portal_purge/striker_portal_purge_hit.vpcf"
	local particle = ParticleManager:CreateParticle(string, PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControlEnt(particle, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(particle)

	if IsServer() then self.parent:EmitSound("Hero_Leshrac.Diabolic_Edict") end
end