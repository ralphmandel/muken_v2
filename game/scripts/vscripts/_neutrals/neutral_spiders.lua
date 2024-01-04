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

  if IsServer() then target:EmitSound("Hero_Broodmother.SpawnSpiderlingsCast") end

  Timers:CreateTimer((0.1), function()
    for i = 1, self:GetSpecialValueFor("units"), 1 do
      local spider = CreateUnitByName("summon_spider", target:GetOrigin(), true, nil, nil, caster:GetTeamNumber())
      self:SetStats(spider)

      AddModifier(spider, self, "neutral_spiders_modifier_summon", {
        duration = self:GetSpecialValueFor("duration"),
        target = target:entindex()
      }, false)
    end
  end)
end

function neutral_spiders:SetStats(unit)
  Timers:CreateTimer((0.2), function()
    if IsServer() then
      local neutral_list = LoadKeyValues("scripts/vscripts/_neutrals/_neutral_units.txt")
      local abilities_stats = {
        ["str"] = unit:FindAbilityByName("_ability_str"),
        ["agi"] = unit:FindAbilityByName("_ability_agi"),
        ["int"] = unit:FindAbilityByName("_ability_int"),
        ["vit"] = unit:FindAbilityByName("_ability_vit")
      }
    
      for name, table in pairs(neutral_list) do
        if name == unit:GetUnitName() then
          for info, stats in pairs(table) do
            if info == "Stats" then
              for stat, value in pairs(stats) do
                abilities_stats[stat]:SetLevel(value * unit:GetLevel())
              end
              return
            end
          end
        end
      end      
    end
  end)
end