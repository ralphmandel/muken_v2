neutral_spike_armor = class({})
LinkLuaModifier("neutral_spike_armor_modifier_passive", "_neutrals/neutral_spike_armor_modifier_passive", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("neutral_spike_armor_modifier_buff", "_neutrals/neutral_spike_armor_modifier_buff", LUA_MODIFIER_MOTION_NONE)

function neutral_spike_armor:Spawn()
  if not IsServer() then return end

  Timers:CreateTimer((0.2), function()
    if IsServer() then
      self:SetLevel(self:GetMaxLevel())
    end
  end)
end

function neutral_spike_armor:GetIntrinsicModifierName()
	return "neutral_spike_armor_modifier_passive"
end

function neutral_spike_armor:OnSpellStart()
  if not IsServer() then return end

  local caster = self:GetCaster()
  caster:AddModifier(self, "neutral_spike_armor_modifier_buff", {
    duration = self:GetSpecialValueFor("duration"), bResist = 1
  })
end