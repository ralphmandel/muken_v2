neutral_burn_aura = class({})
LinkLuaModifier("neutral_burn_aura_modifier_passive", "_neutrals/neutral_burn_aura_modifier_passive", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("neutral_burn_aura_modifier_aura_effect", "_neutrals/neutral_burn_aura_modifier_aura_effect", LUA_MODIFIER_MOTION_NONE)

function neutral_burn_aura:Spawn()
  Timers:CreateTimer((0.2), function()
    if IsServer() then
      self:SetLevel(self:GetMaxLevel())
    end
  end)
end

function neutral_burn_aura:GetIntrinsicModifierName()
	return "neutral_burn_aura_modifier_passive"
end

function neutral_burn_aura:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end