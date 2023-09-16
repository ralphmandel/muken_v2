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

			self:ResetRanksData()

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

  function base_hero:ResetRanksData()
    local caster = self:GetCaster()

		self.abilities_name = GetAbilitiesList(self:GetCaster():GetUnitName())
    self.ranks_name = GetRanksList(self.abilities_name)
    self.ranks_upgraded = {}
    self.rank_points = 0
	end

-- UPDATE DATA

  function base_hero:UpdatePanoramaRanksByName(skill_name)
    local caster = self:GetCaster()
		local player = caster:GetPlayerOwner()
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

		CustomGameEventManager:Send_ServerToPlayer(player, "ranks_from_lua", {skill_name = skill_name, table = list})
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
    if caster:HasAbility(rank_name) then return "RankStateUpgraded" end
    if self:IsRankAvailable(skill_id, tier, path) then return "RankStateAvailable" end
    return "RankStateDisabled"
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

  function base_hero:UpgradeRank(rank_name, skill_name, tier)
    local caster = self:GetCaster()
    local ability = caster:AddAbility(rank_name)

    ability:UpgradeAbility(true)
    table.insert(self.ranks_upgraded, ability)

    SendOverheadEventMessage(nil, OVERHEAD_ALERT_SHARD, caster, tier, caster)
    self:UpdatePanoramaRanksByName(skill_name)
  end

-- HERO LEVEL UP

	function base_hero:OnHeroLevelUp()
		local caster = self:GetCaster()
		local level = caster:GetLevel()
		if caster:IsIllusion() then return end

		if level == 8 then
			local ultimate = caster:FindAbilityByName(self.abilities_name[6])
			if ultimate then
				if ultimate:IsTrained() == false then
					ultimate:UpgradeAbility(true)
          BaseStats(caster):AddManaExtra(ultimate)
				end
			end
		end

    if level == 15 then
      self:UpdateAbilityPoints(1)
    end

    if (level + 1) % 2 == 0 then
      self:UpdateRankPoints(1)
    end

    local bot_script = caster:FindModifierByName("_general_script")
    if bot_script then bot_script:ConsumeAllPoints() end
	end

	function base_hero:OnAbilityUpgrade(ability)
		if ability:GetCaster() == self:GetCaster() then
      self:UpdateAbilityPoints(-1)
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
	end

  function base_hero:UpdateRankPoints(points)
		self.rank_points = self.rank_points + points

		self:UpdatePanoramaState()
	end