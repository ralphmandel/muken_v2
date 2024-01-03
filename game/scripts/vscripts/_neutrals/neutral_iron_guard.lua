neutral_iron_guard = class({})
LinkLuaModifier("neutral_iron_guard_modifier_passive", "_neutrals/neutral_iron_guard_modifier_passive", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("neutral_iron_guard_modifier_resistance", "_neutrals/neutral_iron_guard_modifier_resistance", LUA_MODIFIER_MOTION_NONE)

function neutral_iron_guard:Spawn()
  Timers:CreateTimer((0.2), function()
    if IsServer() then
      self:SetLevel(self:GetMaxLevel())
    end
  end)
end

function neutral_iron_guard:GetIntrinsicModifierName()
	return "neutral_iron_guard_modifier_passive"
end