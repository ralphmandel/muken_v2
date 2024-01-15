_modifier_turn_disabled = class({})

--------------------------------------------------------------------------------
function _modifier_turn_disabled:IsHidden()
	return false
end

function _modifier_turn_disabled:IsPurgable()
	return false
end

function _modifier_turn_disabled:GetTexture()
	return "_modifier_turn_disabled"
end

function _modifier_turn_disabled:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------

function _modifier_turn_disabled:OnCreated( kv )
end

--------------------------------------------------------------------------------

function _modifier_turn_disabled:DeclareFunctions()
	local funcs = {
    MODIFIER_PROPERTY_DISABLE_TURNING,
		MODIFIER_EVENT_ON_ABILITY_START,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_HERO_KILLED
	}

	return funcs
end

function _modifier_turn_disabled:GetModifierDisableTurning()
	return 1
end