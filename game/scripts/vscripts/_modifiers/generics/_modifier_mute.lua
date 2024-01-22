_modifier_mute = class({})

--------------------------------------------------------------------------------
function _modifier_mute:IsPurgable()
	return true
end

function _modifier_mute:IsHidden()
	return false
end

function _modifier_mute:GetTexture()
	return "_modifier_mute"
end

function _modifier_mute:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------

function _modifier_mute:OnCreated( kv )
end

--------------------------------------------------------------------------------

function _modifier_mute:CheckState()
	local state = {
		[MODIFIER_STATE_MUTED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
