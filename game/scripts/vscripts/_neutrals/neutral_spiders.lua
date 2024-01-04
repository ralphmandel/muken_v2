neutral_spiders = class({})
LinkLuaModifier("neutral_spiders_modifier_passive", "_neutrals/neutral_spiders_modifier_passive", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("neutral_spiders_modifier_summon", "_neutrals/neutral_spiders_modifier_summon", LUA_MODIFIER_MOTION_NONE)

function neutral_spiders:Spawn()
  Timers:CreateTimer((0.2), function()
    if IsServer() then
      self:SetLevel(self:GetMaxLevel())
    end
  end)
end

function neutral_spiders:GetIntrinsicModifierName()
	return "neutral_spiders_modifier_passive"
end

function neutral_spiders:OnSpellStart()
  local caster = self:GetCaster()
  local target = self:GetCursorTarget()

  for i = 1, self:GetSpecialValueFor("units"), 1 do
    local spider = CreateUnitByName("summoner_spider", target:GetOrigin(), true, nil, nil, caster:GetTeamNumber())
    AddModifier(spider, self, "neutral_spiders_modifier_summon", {
      duration = self:GetSpecialValueFor("duration"),
      target = target:entindex()
    }, false)
  end
end