lifesteal = class({})
LinkLuaModifier( "lifesteal_modifier", "_neutrals/lifesteal_modifier", LUA_MODIFIER_MOTION_NONE )

function lifesteal:GetIntrinsicModifierName()
	return "lifesteal_modifier"
end