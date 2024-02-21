if (not _G.RankSystem) then
  _G.RankSystem = class({})
end

function RankSystem:Init()
  if (not IsServer()) then return end

  if RankSystem.initializated == nil then
    RankSystem.initializated = true
    RankSystem:InitPanaromaEvents()
  end
end

function RankSystem:InitPanaromaEvents()
  CustomGameEventManager:RegisterListener("stat_up_from_panorama", Dynamic_Wrap(RankSystem, 'OnStatUpgrade'))

  CustomGameEventManager:RegisterListener("request_bar_info_from_panorama", Dynamic_Wrap(RankSystem, 'OnProgressBarRequest'))
  CustomGameEventManager:RegisterListener("ranks_from_panorama", Dynamic_Wrap(RankSystem, 'OnRanksTableRequest'))
  CustomGameEventManager:RegisterListener("rank_up_from_panorama", Dynamic_Wrap(RankSystem, 'OnRankUpgrade'))
  CustomGameEventManager:RegisterListener("request_skill_name_from_panorama", Dynamic_Wrap(RankSystem, 'OnSkillNameRequest'))
  CustomGameEventManager:RegisterListener("request_buttons_state_from_panorama", Dynamic_Wrap(RankSystem, 'OnButtonsStateRequest'))

  CustomGameEventManager:RegisterListener("chosen_path_from_panorama", Dynamic_Wrap(RankSystem, 'OnPathUpgrade'))
end

function RankSystem:OnStatUpgrade(event)
  if (not event or not event.PlayerID) then return end

  local player = PlayerResource:GetPlayer(event.PlayerID)
  if (not player) then return end

  local hero = player:GetAssignedHero()
  if (not hero) then return end

  hero:GetBaseHeroAbility():UpgradeStat(event.stat)
end

function RankSystem:OnProgressBarRequest(event)
  if (not event or not event.PlayerID) then return end
  
  local player = PlayerResource:GetPlayer(event.PlayerID)
  if (not player) then return end

  local data = {
    entity = event.entity,
    points = 0,
    rank_level = "0",
    max_level = 0,
    style = "mana"
  }

  local unit = EntIndexToHScript(data.entity)

  if unit == nil then return end
  if IsValidEntity(unit) == false then return end

  if unit:HasModifier("ancient_u_modifier_passive") then
    data.style = "energy"
  end

  if unit then
    if unit:IsHero() then
      if unit:IsIllusion() then
        local players = PlayerResource:GetAllPlayers()
        for _, player in pairs(players) do
          local hero = player:GetAssignedHero()
          if unit:GetHeroName() == hero:GetHeroName() then
            data = hero:GetBaseHeroAbility():GetProgressBarInfo()
            data.entity = event.entity
            break
          end
        end
      else
        data = unit:GetBaseHeroAbility():GetProgressBarInfo()
      end
    end
  end

  CustomGameEventManager:Send_ServerToPlayer(player, "update_bar_from_lua", data)
end

function RankSystem:OnSkillNameRequest(event)
  if (not event or not event.PlayerID) then return end

  local player = PlayerResource:GetPlayer(event.PlayerID)
  if (not player) then return end

  CustomGameEventManager:Send_ServerToPlayer(player, "skill_name_from_lua", {id = event.id})
end

function RankSystem:OnRanksTableRequest(event)
  if (not event or not event.PlayerID) then return end
  
  local player = PlayerResource:GetPlayer(event.PlayerID)
  if (not player) then return end

  local entity = EntIndexToHScript(event.entity)
  if (not entity) then RankSystem:OnButtonsStateRequest(event) return end
  if entity:IsHero() == false then RankSystem:OnButtonsStateRequest(event) return end

  if entity:IsIllusion() then
    local players = PlayerResource:GetAllPlayers()
    for _, player in pairs(players) do
      local hero = player:GetAssignedHero()
      if entity:GetHeroName() == hero:GetHeroName() then
        hero:GetBaseHeroAbility():UpdatePanoramaRanksByName(player, event.skill_name)
      end
    end
  else
    entity:GetBaseHeroAbility():UpdatePanoramaRanksByName(player, event.skill_name)
  end
end

function RankSystem:OnButtonsStateRequest(event)
  if (not event or not event.PlayerID) then return end
  
  local player = PlayerResource:GetPlayer(event.PlayerID)
  if (not player) then return end

  local bEnable = false
  local entity = EntIndexToHScript(event.entity)
  if entity then
    if entity:IsHero() then
      bEnable = true
    end
  end

  CustomGameEventManager:Send_ServerToPlayer(player, "set_rank_buttons_from_lua", {bEnable = bEnable})
end

function RankSystem:OnRankUpgrade(event)
  if (not event or not event.PlayerID) then return end

  local entity = EntIndexToHScript(event.entity)
  if (not entity) then return end
  if entity:IsHero() == false then return end
  if entity:IsIllusion() then return end

  entity:GetBaseHeroAbility():UpgradeRank(event.skill_name, event.tier, event.path)
end

function RankSystem:OnPathUpgrade(event)
  if (not event or not event.PlayerID) then return end

  local player = PlayerResource:GetPlayer(event.PlayerID)
  if (not player) then return end

  local hero = player:GetAssignedHero()
  if (not hero) then return end

  hero:GetBaseHeroAbility():UpgradePath(event.path)
end

RankSystem:Init()