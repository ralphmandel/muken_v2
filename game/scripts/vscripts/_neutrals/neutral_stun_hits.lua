neutral_stun_hits = class({})
LinkLuaModifier("neutral_stun_hits_modifier_passive", "_neutrals/neutral_stun_hits_modifier_passive", LUA_MODIFIER_MOTION_NONE)

function neutral_stun_hits:Spawn()
  if not IsServer() then return end

  Timers:CreateTimer((0.2), function()
    if IsServer() then
      self:SetLevel(self:GetMaxLevel())
    end
  end)
end

function neutral_stun_hits:GetIntrinsicModifierName()
	return "neutral_stun_hits_modifier_passive"
end