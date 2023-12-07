strider_4_modifier_turn = class({})

function strider_4_modifier_turn:IsHidden() return false end
function strider_4_modifier_turn:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function strider_4_modifier_turn:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()
end

function strider_4_modifier_turn:OnRefresh(kv)
end

function strider_4_modifier_turn:OnRemoved()

end

-- API FUNCTIONS -----------------------------------------------------------

function strider_4_modifier_turn:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DISABLE_TURNING,
		MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
		MODIFIER_EVENT_ON_ORDER
	}

	return funcs
end

function strider_4_modifier_turn:GetModifierDisableTurning()
	return self.ability.disable
end

function strider_4_modifier_turn:GetModifierIgnoreCastAngle()
	return self.ability.disable
end

function strider_4_modifier_turn:OnOrder(keys)
	if keys.unit ~= self.parent then return end
	if keys.order_type == DOTA_UNIT_ORDER_CAST_POSITION then
		if keys.ability == self.ability then 
			self.ability.disable = 1
		end
	end
end


-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------