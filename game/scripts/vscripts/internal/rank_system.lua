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
  CustomGameEventManager:RegisterListener("ranks_from_panorama", Dynamic_Wrap(RankSystem, 'OnRanksTableRequest'))
  CustomGameEventManager:RegisterListener("rank_up_from_panorama", Dynamic_Wrap(RankSystem, 'OnRankUpgrade'))
  CustomGameEventManager:RegisterListener("request_skill_name_from_panorama", Dynamic_Wrap(RankSystem, 'OnSkillNameRequest'))
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

  local hero = player:GetAssignedHero()
  if (not hero) then return end

  if BaseHero(hero) == nil then return end

  BaseHero(hero):UpdatePanoramaRanksByName(event.skill_name)
end

function RankSystem:OnRankUpgrade(event)
  if (not event or not event.PlayerID) then return end
  
  local player = PlayerResource:GetPlayer(event.PlayerID)
  if (not player) then return end

  local hero = player:GetAssignedHero()
  if (not hero) then return end

  if BaseHero(hero) == nil then return end

  BaseHero(hero):UpgradeRank(event.skill_name, event.tier, event.path)
end

RankSystem:Init()