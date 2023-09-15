bloodstained__modifier_extra_hp = class({})

function bloodstained__modifier_extra_hp:IsHidden() return false end
function bloodstained__modifier_extra_hp:IsPurgable() return false end
function bloodstained__modifier_extra_hp:RemoveOnDeath() return false end
function bloodstained__modifier_extra_hp:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

-- CONSTRUCTORS -----------------------------------------------------------

function bloodstained__modifier_extra_hp:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.cap = kv.cap * 0.01
	self.tick = 0.2

	if IsServer() then
		self:SetStackCount(kv.extra_life)
		self:StartIntervalThink(1)
	end
end

function bloodstained__modifier_extra_hp:OnRefresh(kv)
end

function bloodstained__modifier_extra_hp:OnRemoved()
	if self.target_mod then self.target_mod:Destroy() end
end

-- API FUNCTIONS -----------------------------------------------------------

function bloodstained__modifier_extra_hp:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS
	}

	return funcs
end

function bloodstained__modifier_extra_hp:GetModifierExtraHealthBonus()
	if IsServer() then return self:GetStackCount() end
end

function bloodstained__modifier_extra_hp:OnIntervalThink()
	if IsServer() then
		self:DecrementStackCount()
		self:StartIntervalThink(self.tick)
	end
end

function bloodstained__modifier_extra_hp:OnStackCountChanged(old)
	local cap = self.parent:GetBaseMaxHealth() * self.cap
	if self:GetStackCount() > cap then self:SetStackCount(cap) end
	if self:GetStackCount() <= 0 then self:Destroy() return end

	if old < self:GetStackCount() then self:StartIntervalThink(1) end

	if self.target_mod then self.target_mod:SetStackCount(self:GetStackCount()) end

	local void = self:GetCaster():FindAbilityByName("_void")
	if void then void:SetLevel(1) end
end

-- UTILS -----------------------------------------------------------

function bloodstained__modifier_extra_hp:ApplyTargetDebuff(target)
	if target == nil then return end

	self.target_mod = target:AddNewModifier(self.caster, self.ability, "bloodstained__modifier_target_hp", {
		hp = self:GetStackCount()
	})
end

-- EFFECTS -----------------------------------------------------------