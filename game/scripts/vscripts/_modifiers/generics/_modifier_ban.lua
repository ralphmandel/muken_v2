_modifier_ban = class({})

--------------------------------------------------------------------------------
-- Classifications
function _modifier_ban:IsHidden()
	return false
end

function _modifier_ban:IsPurgable()
    return false
end

function _modifier_ban:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function _modifier_ban:OnCreated( kv )
  local parent = self:GetParent()

  if not IsServer() then return end

  parent:AddNoDraw()

  local cosmetics = parent:FindAbilityByName("cosmetics")
	if cosmetics then cosmetics:HideCosmetic(nil, true) end
end

function _modifier_ban:OnRemoved()
  local parent = self:GetParent()

  if not IsServer() then return end

  parent:RemoveNoDraw()

  local cosmetics = parent:FindAbilityByName("cosmetics")
	if cosmetics then cosmetics:HideCosmetic(nil, false) end
end

---------------------------------------------------------------------------------

function _modifier_ban:CheckState()
	local state = {
		[MODIFIER_STATE_OUT_OF_GAME] = true,
    [MODIFIER_STATE_STUNNED] = true,
    [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
    [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
	}

	return state
end

function _modifier_ban:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
    MODIFIER_PROPERTY_BONUS_DAY_VISION
	}
	
	return funcs
end

function _modifier_ban:GetBonusNightVision()
  if self:IsDebuff() then return -9999 else return 0 end
end

function _modifier_ban:GetBonusDayVision()
  if self:IsDebuff() then return -9999 else return 0 end
end