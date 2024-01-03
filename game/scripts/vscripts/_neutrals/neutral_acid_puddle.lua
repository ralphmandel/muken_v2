neutral_acid_puddle = class({})
LinkLuaModifier("neutral_acid_puddle_modifier_passive", "_neutrals/neutral_acid_puddle_modifier_passive", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("neutral_acid_puddle_modifier_aura", "_neutrals/neutral_acid_puddle_modifier_aura", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("neutral_acid_puddle_modifier_aura_effect", "_neutrals/neutral_acid_puddle_modifier_aura_effect", LUA_MODIFIER_MOTION_NONE)

function neutral_acid_puddle:Spawn()
  Timers:CreateTimer((0.2), function()
    if IsServer() then
      self:SetLevel(self:GetMaxLevel())
    end
  end)
end

function neutral_acid_puddle:GetIntrinsicModifierName()
	return "neutral_acid_puddle_modifier_passive"
end

function neutral_acid_puddle:GetAOERadius()
  return self:GetSpecialValueFor("radius")
end

function neutral_acid_puddle:OnSpellStart()
  local caster = self:GetCaster()

  CreateModifierThinker(caster, self, "neutral_acid_puddle_modifier_aura", {
    duration = self:GetSpecialValueFor("duration")
  }, self:GetCursorPosition(), caster:GetTeamNumber(), false)
end