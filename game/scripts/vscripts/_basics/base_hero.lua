base_hero = class ({})
require("examples/worldpanelsExample")
LinkLuaModifier("base_hero_mod", "_basics/base_hero_mod", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_general_script", "_bot_scripts/_general_script", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_fountain_refresh_hp", "_modifiers/generics/_fountain_refresh_hp", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_fountain_refresh_mp", "_modifiers/generics/_fountain_refresh_mp", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_ban", "_modifiers/generics/_modifier_ban", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_bkb", "_modifiers/generics/_modifier_bkb", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_bleeding", "_modifiers/generics/_modifier_bleeding", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_blind", "_modifiers/generics/_modifier_blind", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_blind_stack", "_modifiers/generics/_modifier_blind_stack", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_break", "_modifiers/generics/_modifier_break", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_disarm", "_modifiers/generics/_modifier_disarm", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_ethereal", "_modifiers/generics/_modifier_ethereal", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_ethereal_status_efx", "_modifiers/generics/_modifier_ethereal_status_efx", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_fear", "_modifiers/generics/_modifier_fear", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_fear_status_efx", "_modifiers/generics/_modifier_fear_status_efx", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_generic_arc", "_modifiers/generics/_modifier_generic_arc", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("_modifier_generic_custom_indicator", "_modifiers/generics/_modifier_generic_custom_indicator", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_generic_knockback_lua", "_modifiers/generics/_modifier_generic_knockback_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_hex", "_modifiers/generics/_modifier_hex", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_hide", "_modifiers/generics/_modifier_hide", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_immunity", "_modifiers/generics/_modifier_immunity", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_invi_level", "_modifiers/generics/_modifier_invi_level", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_invisible", "_modifiers/generics/_modifier_invisible", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_invulnerable", "_modifiers/generics/_modifier_invulnerable", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_lighting", "_modifiers/generics/_modifier_lighting", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_no_bar", "_modifiers/generics/_modifier_no_bar", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_no_block", "_modifiers/generics/_modifier_no_block", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_no_vision_attacker", "_modifiers/generics/_modifier_no_vision_attacker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_path", "_modifiers/generics/_modifier_path", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_petrified", "_modifiers/generics/_modifier_petrified", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_petrified_status_efx", "_modifiers/generics/_modifier_petrified_status_efx", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_phase", "_modifiers/generics/_modifier_phase", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_pull", "_modifiers/generics/_modifier_pull", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_restrict", "_modifiers/generics/_modifier_restrict", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_root", "_modifiers/generics/_modifier_root", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_silence", "_modifiers/generics/_modifier_silence", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_stun", "_modifiers/generics/_modifier_stun", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_tracking", "_modifiers/generics/_modifier_tracking", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_truesight", "_modifiers/generics/_modifier_truesight", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_turn_disabled", "_modifiers/generics/_modifier_turn_disabled", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_unslowable", "_modifiers/generics/_modifier_unslowable", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_untargetable", "_modifiers/generics/_modifier_untargetable", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("orb_bleed__modifier", "_modifiers/orbs/orb_bleed__modifier", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("orb_bleed__status", "_modifiers/orbs/orb_bleed__status", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("orb_bleed_debuff", "_modifiers/orbs/orb_bleed_debuff", LUA_MODIFIER_MOTION_NONE)

require("internal/muken_events")
require("internal/rank_system")

-- INIT
	function base_hero:Spawn()
    if IsServer() then
      if self:IsTrained() == false then
        self:UpgradeAbility(true)
      end
    end
	end

  function base_hero:GetIntrinsicModifierName()
		return "base_hero_mod"
	end

  function base_hero:OnUpgrade()
		local caster = self:GetCaster()
		if caster:IsIllusion() then return end

		if self:GetLevel() == 1 then
      self.ability_points = GetHeroInitPts(GetHeroName(self:GetCaster()))

      self:ResetData()

      for team = DOTA_TEAM_CUSTOM_MIN, DOTA_TEAM_CUSTOM_MIN + 3 do
        if caster:GetTeamNumber() == team then
          Timers:CreateTimer(team, function()
            caster:RemoveAbilityByHandle(caster:FindAbilityByName("ability_capture"))
            caster:RemoveAbilityByHandle(caster:FindAbilityByName("abyssal_underlord_portal_warp"))
            if INITIAL_XP > 0 then caster:AddExperience(INITIAL_XP, 0, false, false) end
          end)
        end
      end
		end
	end

  function base_hero:ResetData()
    local caster = self:GetCaster()

    self.stat_points = 0
    self.bonus_level = {str = 0, agi = 0, int = 0, vit = 0}
    self:LoadBaseStats()

    self.abilities_name = GetAbilitiesList(self:GetCaster():GetUnitName())
    self.ranks_name = GetRanksList(self.abilities_name)
    self.ranks_exception = self:GetRanksException()
    self.rank_points = 0
    self.max_level = 15

    self.chosen_path = {Path_1 = false, Path_2 = false, Path_3 = false}
    self.path_points = 0
  end

-- STAT SYSTEM

  function base_hero:LoadBaseStats()
    local caster = self:GetCaster()
    local stats_data = LoadKeyValues("scripts/kv/heroes_stats.kv")

    for hero_name, stats in pairs(stats_data) do
      if hero_name == GetHeroName(caster) then
        for stat, types_table in pairs(stats) do
          for type, value in pairs(types_table) do
            if type == "base" then
              local ability_stat = caster:FindAbilityByName("_ability_"..string.lower(stat))
              if ability_stat then ability_stat:SetLevel(value) end
            else
              self.bonus_level[string.lower(stat)] = value
            end
          end
        end
      end
    end
  end

  function base_hero:GetRanksException()
    local caster = self:GetCaster()
    local name = GetHeroName(caster)
    local team = GetHeroTeam(caster)
    local data = LoadKeyValues("scripts/vscripts/heroes/"..team.."/"..name.."/"..name..".txt")
    local result = {}

    for ability_name, ability_data in pairs(data) do
      if ability_name ~= "Version" then
        local exception = true

        for k, v in pairs(ability_data) do
          if k == "AbilityTextureName" then
            exception = false
          end
        end
  
        result[ability_name] = exception        
      end
    end

    return result
  end

  function base_hero:ApplyStatBonusLevel()
    local caster = self:GetCaster()
		local level = caster:GetLevel()

    for stat, value in pairs(self.bonus_level) do
      local up = math.floor(value)
      local old = math.fmod(value, 1) * (level - 1)
      local new = math.fmod(value, 1) * level
      if math.floor(new + 0.01) - math.floor(old + 0.01) > 0 then up = up + 1 end

      local ability_stat = caster:FindAbilityByName("_ability_"..stat)
      if ability_stat then ability_stat:SetLevel(ability_stat:GetLevel() + up) end
    end
  end

  function base_hero:UpgradeStat(stat)
    local caster = self:GetCaster()

    local ability_stat = caster:FindAbilityByName("_ability_"..string.lower(stat))
    if ability_stat then
      ability_stat:UpgradeAbility(true)
      self:UpdateStatPoints(-1, stat)
    end
  end

  function base_hero:UpdatePanoramaPoints(upgraded_stat)
    local caster = self:GetCaster()
    if caster:IsHero() == false then return end
    if caster:IsIllusion() then return end

    local player = caster:GetPlayerOwner()
    if (not player) then return end

    local stats = {STR = false, AGI = false, INT = false, VIT = false}

    for stat, bool in pairs(stats) do
      local ability_stat = caster:FindAbilityByName("_ability_"..string.lower(stat))
      if ability_stat then
        stats[stat] = ability_stat:GetLevel() < 30 + (caster:GetLevel() * 4) and self.stat_points > 0
      end
    end

    CustomGameEventManager:Send_ServerToPlayer(player, "update_stats_point_from_lua", {
      total_points = self.stat_points, stats = stats, upgraded_stat = upgraded_stat
    })
  end

-- RANK SYSTEM

  function base_hero:UpgradeRank(skill_name, tier, path)
    local caster = self:GetCaster()
    local special_kv_modifier = caster:FindModifierByName(GetHeroName(caster).."_special_values")
    if special_kv_modifier == nil then return end

    local skill_id = self:GetSkillID(skill_name)
    tier = tonumber(tier)
    path = tonumber(path)

    special_kv_modifier:LearnRank(skill_id, tier, path)

    local ability = caster:FindAbilityByName(self.abilities_name[skill_id])
    ability:SetLevel(ability:GetLevel() + tier)
    self:UpdateRankPoints(-tier)

    SendOverheadEventMessage(nil, OVERHEAD_ALERT_SHARD, caster, tier, caster)
  end

  function base_hero:UpdatePanoramaRanksByName(player, skill_name)
    local caster = self:GetCaster()
		if (not player) then return end

    local skill_id = self:GetSkillID(skill_name)
    if skill_id == nil then return end

    local list = {}

    for tier = 1, 3, 1 do
      list[tier] = {}
      for path = 1, 2, 1 do
        list[tier][path] = {}
        list[tier][path]["rank_name"] = self.ranks_name[skill_id][tier][path]
        list[tier][path]["rank_state"] = self:GetRankState(skill_id, tier, path)
      end
    end

    local skill_level = 0
    if caster:FindAbilityByName(skill_name):IsTrained() then
      skill_level = caster:FindAbilityByName(skill_name):GetLevel() + 5
      if skill_id == 6 then skill_level = skill_level + 3 end
    end

		CustomGameEventManager:Send_ServerToPlayer(player, "ranks_from_lua", {
      skill_name = skill_name, skill_level = skill_level, table = list
    })
	end

  function base_hero:GetSkillID(skill_name)
    for id, name in pairs(self.abilities_name) do
      if name == skill_name then
        return id
      end
    end
  end

  function base_hero:GetRankState(skill_id, tier, path)
    local caster = self:GetCaster()
    local rank_name = self.ranks_name[skill_id][tier][path]
    if caster:HasRank(skill_id, tier, path) then return "StateUpgraded" end
    if self.ranks_exception[rank_name] == true then return "StateDisabled" end
    if self:IsRankAvailable(skill_id, tier, path) then return "StateAvailable" end
    return "StateDisabled"
  end

  function base_hero:IsRankAvailable(skill_id, tier, path)
    local caster = self:GetCaster()
    if self.rank_points < tier then return false end
    if caster:FindAbilityByName(self.abilities_name[skill_id]):IsTrained() == false then return false end
    
    for i_path, rank_name in pairs(self.ranks_name[skill_id][tier]) do
      if path ~= i_path and caster:HasRank(skill_id, tier, i_path) then
        return false
      end
    end

    return true
  end

  function base_hero:GetProgressBarInfo()
    local caster = self:GetCaster()
    local level = 0
    local style = "mana"

    for skill_id = 1, 6, 1 do
      for tier = 1, 3, 1 do
        for path = 1, 2, 1 do
          if caster:HasRank(skill_id, tier, path) then
            level = level + tier
          end
        end
      end
    end

    if caster:HasModifier("ancient_u_modifier_passive") then
      style = "energy"
    end

    return {
      entity = caster:entindex(),
      points = self.rank_points,
      rank_level = level,
      max_level = self.max_level,
      style = style
    }
  end

-- HERO LEVEL UP

  function base_hero:AddManaExtra(ability)
    local caster = self:GetCaster()
    if caster:IsHero() == false then return end

    local hero_name = GetHeroName(caster)
    local hero_team = GetHeroTeam(caster)
    local abilities_data = LoadKeyValues("scripts/vscripts/heroes/"..hero_team.."/"..hero_name.."/"..hero_name..".txt")
    if abilities_data == nil then return end

    for ability_name, data in pairs(abilities_data) do
      if ability:GetAbilityName() == ability_name then
        for key, value in pairs(data) do
          if key == "ActiveSpell" then
            if tonumber(value) == 1 then
              self:UpgradeAbility(true)
            end
          end
        end          
      end
    end
  end

	function base_hero:OnHeroLevelUp()
		local caster = self:GetCaster()
		local level = caster:GetLevel()
		if caster:IsIllusion() then return end

    caster:SetAbilityPoints(self.ability_points)

    if level == 2 or level == 4 then
      self:UpdateAbilityPoints(1)
    end

		if level == 8 then
			local ultimate = caster:FindAbilityByName(self.abilities_name[6])
			if ultimate then
				if ultimate:IsTrained() == false then
					ultimate:UpgradeAbility(true)
          self:AddManaExtra(ultimate)
				end
			end
		end

    if level % 1 == 0 then
      self:ApplyStatBonusLevel()
      self:UpdateStatPoints(3, "nil")
    end

    if (level + 1) % 2 == 0 then
      self:UpdateRankPoints(1)
    end

    if level % 15 == 0 then
      self:UpdatePathPoints(1)
    end


    local bot_script = caster:FindModifierByName("_general_script")
    if bot_script then bot_script:ConsumeAllPoints() end
	end

	function base_hero:OnAbilityUpgrade(ability)
		if ability:GetCaster() == self:GetCaster() then
      self:UpdateAbilityPoints(-1)
      self:AddManaExtra(ability)
    end
	end

	function base_hero:UpdateAbilityPoints(points)
		local caster = self:GetCaster()

		self.ability_points = self.ability_points + points
		caster:SetAbilityPoints(self.ability_points)

		for i = 1, 5, 1 do
			local skill = caster:FindAbilityByName(self.abilities_name[i])
			if skill then
				if skill:IsTrained() == false then
					--skill:SetHidden(self.ability_points < 1)
				end
			end
		end

    self:UpdatePanoramaRankWindow()
	end

  function base_hero:UpdateStatPoints(points, stat)
		self.stat_points = self.stat_points + points
    self:UpdatePanoramaPoints(stat)
	end

  function base_hero:UpdateRankPoints(points)
		self.rank_points = self.rank_points + points
    self:UpdatePanoramaRankWindow()
    self:UpdatePanoramaProgressBar()
	end

  function base_hero:UpdatePathPoints(points)
		self.path_points = self.path_points + points
    self:UpdatePanoramaPathWindow()
	end

  function base_hero:UpdatePanoramaRankWindow()
    local caster = self:GetCaster()
    CustomGameEventManager:Send_ServerToAllClients("update_rank_window_from_lua", {entity = caster:entindex()})    
	end

  function base_hero:UpdatePanoramaProgressBar()
    local caster = self:GetCaster()
    CustomGameEventManager:Send_ServerToAllClients("update_bar_from_lua", self:GetProgressBarInfo())
	end

  function base_hero:UpdatePanoramaPathWindow()
    local caster = self:GetCaster()
    if caster:IsHero() == false then return end
    if caster:IsIllusion() then return end

    local player = caster:GetPlayerOwner()
    if (not player) then return end

    CustomGameEventManager:Send_ServerToPlayer(player, "update_path_window_from_lua", {
      path_states = self.chosen_path, path_points = self.path_points
    })
	end

-- PATH SYSTEM
  function base_hero:UpgradePath(path)
    local caster = self:GetCaster()
    self.chosen_path[path] = true

    if path == "Path_1" then
      self:UpdateAbilityPoints(1)
    end

    if path == "Path_2" then
      self.max_level = self.max_level + 6
      self:UpdateRankPoints(6)
    end

    if path == "Path_3" then
      self:UpdateStatPoints(30, "nil")
    end

    self:UpdatePathPoints(-1)
  end