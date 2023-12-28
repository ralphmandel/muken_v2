neutral_strike = class({})
LinkLuaModifier("neutral_strike_modifier_passive", "_neutrals/neutral_strike_modifier_passive", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("neutral_strike_modifier_wind", "_neutrals/neutral_strike_modifier_wind", LUA_MODIFIER_MOTION_NONE)

function neutral_strike:Spawn()
  if IsServer() then self:SetLevel(self:GetMaxLevel()) end
end

function neutral_strike:GetIntrinsicModifierName()
	return "neutral_strike_modifier_passive"
end