base_hero = class ({})
LinkLuaModifier("base_hero_mod", "_basics/base_hero_mod", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_general_script", "_bot_scripts/_general_script", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_fountain_refresh_hp", "_modifiers/_fountain_refresh_hp", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_fountain_refresh_mp", "_modifiers/_fountain_refresh_mp", LUA_MODIFIER_MOTION_NONE)
require("internal/talent_tree")
require("internal/rank_system")

-- INIT
	function base_hero:Spawn()
    if self:IsTrained() == false then self:UpgradeAbility(true) end
	end

  function base_hero:GetIntrinsicModifierName()
		return "base_hero_mod"
	end

  function base_hero:OnUpgrade()
		local caster = self:GetCaster()
		if caster:IsIllusion() then return end

		if self:GetLevel() == 1 then
      self.hero_name = GetHeroName(self:GetCaster():GetUnitName())
      self.hero_team = GetHeroTeam(self:GetCaster():GetUnitName())
      self.ability_points = GetHeroInitPts(self.hero_name)

      self:ResetData()

      for team = DOTA_TEAM_CUSTOM_MIN, DOTA_TEAM_CUSTOM_MIN + 3 do
        if caster:GetTeamNumber() == team then
          Timers:CreateTimer(team, function()
            caster:RemoveAbilityByHandle(caster:FindAbilityByName("ability_capture"))
            caster:RemoveAbilityByHandle(caster:FindAbilityByName("abyssal_underlord_portal_warp"))
            caster:AddExperience(INITIAL_XP, 0, false, false)
          end)
        end
      end
		end
	end

  function base_hero:ResetData()
    local caster = self:GetCaster()

    self.stat_points = 0
    self.stat_bonus = {str = 0, agi = 0, int = 0, vit = 0}
    self:LoadBaseStats()

    self.abilities_name = GetAbilitiesList(self:GetCaster():GetUnitName())
    self.ranks_name = GetRanksList(self.abilities_name)
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
      if hero_name == GetHeroName(caster:GetUnitName()) then
        for stat, types_table in pairs(stats) do
          for type, value in pairs(types_table) do
            if type == "base" then
              local ability_stat = caster:FindAbilityByName("_ability_"..string.lower(stat))
              if ability_stat then ability_stat:SetLevel(value) end
            else
              self.stat_bonus[string.lower(stat)] = value
            end
          end
        end
      end
    end
  end

  function base_hero:ApplyStatBonusLevel()
    local caster = self:GetCaster()
		local level = caster:GetLevel()

    for stat, value in pairs(self.stat_bonus) do
      local up = 0
      if value % 1 ~= 0 and level % 2 == 0 then up = up + 1 end
      if value >= 1 then up = up + math.floor(value) end
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
        stats[stat] = ability_stat:GetLevel() < 90 + (caster:GetLevel() * 3) and self.stat_points > 0
      end
    end

    CustomGameEventManager:Send_ServerToPlayer(player, "update_stats_point_from_lua", {
      total_points = self.stat_points, stats = stats, upgraded_stat = upgraded_stat
    })
  end

-- RANK SYSTEM

  function base_hero:UpgradeRank(skill_name, tier, path)
    local caster = self:GetCaster()
    local skill_id = self:GetSkillID(skill_name)
    tier = tonumber(tier)
    path = tonumber(path)

    local rank = caster:AddAbility(self.ranks_name[skill_id][tier][path])
    local ability = caster:FindAbilityByName(self.abilities_name[skill_id])

    rank:UpgradeAbility(true)
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
    if caster:HasAbility(rank_name) then return "StateUpgraded" end
    if self:IsRankAvailable(skill_id, tier, path) then return "StateAvailable" end
    return "StateDisabled"
  end

  function base_hero:IsRankAvailable(skill_id, tier, path)
    local caster = self:GetCaster()
    if self.rank_points < tier then return false end
    if caster:FindAbilityByName(self.abilities_name[skill_id]):IsTrained() == false then return false end
    
    for i_path, rank_name in pairs(self.ranks_name[skill_id][tier]) do
      if path ~= i_path and caster:HasAbility(rank_name) then
        return false
      end
    end

    return true
  end

  function base_hero:GetProgressBarInfo()
    local caster = self:GetCaster()
    local level = 0

    for skill = 1, 6, 1 do
      for tier = 1, 3, 1 do
        for path = 1, 2, 1 do
          if caster:HasAbility(self.ranks_name[skill][tier][path]) then
            level = level + tier
          end
        end
      end
    end

    return {
      entity = caster:entindex(),
      points = self.rank_points,
      rank_level = level,
      max_level = self.max_level
    }
  end

-- HERO LEVEL UP

  function base_hero:AddManaExtra(ability)
    local caster = self:GetCaster()
    if caster:IsHero() == false then return end

    local hero_name = GetHeroName(caster:GetUnitName())
    local hero_team = GetHeroTeam(caster:GetUnitName())
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
      self:UpdateStatPoints(6, "nil")
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
					skill:SetHidden(self.ability_points < 1)
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
    CustomGameEventManager:Send_ServerToAllClients("update_path_window_from_lua", {
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