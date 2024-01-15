neutral_rage = class({})
LinkLuaModifier("neutral_rage_modifier_passive", "_neutrals/neutral_rage_modifier_passive", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("neutral_rage_modifier_buff", "_neutrals/neutral_rage_modifier_buff", LUA_MODIFIER_MOTION_NONE)

function neutral_rage:Spawn()
  if not IsServer() then return end

  Timers:CreateTimer((0.2), function()
    if IsServer() then
      self:SetLevel(self:GetMaxLevel())
    end
  end)
end

function neutral_rage:GetIntrinsicModifierName()
	return "neutral_rage_modifier_passive"
end