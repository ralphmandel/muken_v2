fleaman_2_modifier_charge = class({})

function fleaman_2_modifier_charge:IsHidden() return false end
function fleaman_2_modifier_charge:IsPurgable() return true end

-- CONSTRUCTORS -----------------------------------------------------------

function fleaman_2_modifier_charge:OnCreated(kv)
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

  self.stack = kv.distance * 0.05

	if IsServer() then self:SetStackCount(math.floor(self.stack)) end
end

function fleaman_2_modifier_charge:OnRefresh(kv)
  self.stack = self.stack + (kv.distance * 0.05)

	if IsServer() then self:SetStackCount(math.floor(self.stack)) end
end

function fleaman_2_modifier_charge:OnRemoved()
end

-- API FUNCTIONS -----------------------------------------------------------

function fleaman_2_modifier_charge:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end

function fleaman_2_modifier_charge:OnAttackLanded(keys)
	if keys.attacker ~= self.parent then return end
  
  if self:GetStackCount() == 100 then
    AddModifier(keys.target, self.ability, "_modifier_stun", {
      duration = self.ability:GetSpecialValueFor("special_stun_duration")
    }, true)

    self:Destroy()
  end
end

function fleaman_2_modifier_charge:OnStackCountChanged(old)
  if IsServer() then
    if self:GetStackCount() > 100 then self:SetStackCount(100) end
  end
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------