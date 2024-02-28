require('libraries/notifications')

if (not _G.MukenEvents) then
  _G.MukenEvents = class({})
end

function MukenEvents:Init()
  if (not IsServer()) then return end

  if MukenEvents.initializated == nil then
    MukenEvents.initializated = true
    MukenEvents:InitPanaromaEvents()
  end
end

function MukenEvents:InitPanaromaEvents()  
  CustomGameEventManager:RegisterListener("role_bar_update", Dynamic_Wrap(MukenEvents, 'OnRoleBarRequest'))
  CustomGameEventManager:RegisterListener("scoreboard_update", Dynamic_Wrap(MukenEvents, 'OnScoreRequest'))
  CustomGameEventManager:RegisterListener("request_unit_info_from_panorama", Dynamic_Wrap(MukenEvents, 'OnPortraitUpdate'))
  CustomGameEventManager:RegisterListener("game_points_from_server", Dynamic_Wrap(MukenEvents, 'GamePointsUpdate'))
  CustomGameEventManager:RegisterListener("dota_time_from_panorama", Dynamic_Wrap(MukenEvents, 'Notifications'))
  CustomGameEventManager:RegisterListener("equip_item_from_panorama", Dynamic_Wrap(MukenEvents, 'OnItemEquipped'))
  CustomGameEventManager:RegisterListener("unequip_item_from_panorama", Dynamic_Wrap(MukenEvents, 'OnItemUnequipped'))
  CustomGameEventManager:RegisterListener("drop_item_from_panorama", Dynamic_Wrap(MukenEvents, 'OnDropItem'))
  CustomGameEventManager:RegisterListener("forge_tower_from_panorama", Dynamic_Wrap(MukenEvents, 'OnForgeTower'))
end

function MukenEvents:Notifications(params)
  Notifications:TopToAll({text="THE FIRST TEAM TO REACH #score POINTS WINS", duration=10.0})
end

function MukenEvents:GamePointsUpdate(params)
  SCORE_LIMIT = params.match_points
end

function MukenEvents:OnForgeTower(event)
  if (not event or not event.PlayerID) then return end
  
  local player = PlayerResource:GetPlayer(event.PlayerID)
  if (not player) then return end

  player:ToggleForgeTower(event.ent_index)
end

function MukenEvents:OnItemEquipped(event)
  if (not event or not event.PlayerID) then return end
  
  local player = PlayerResource:GetPlayer(event.PlayerID)
  if (not player) then return end

  local unit = EntIndexToHScript(event.unit)
  local item = CreateItem(event.itemname, player, nil)
  unit:AddItem(item)

  local item_slot = item:GetItemSlot()
  local new_slot = GetSlotByType(event.type)

  if item_slot ~= new_slot then
    unit:SwapItems(item_slot, new_slot)
  end
end

function MukenEvents:OnItemUnequipped(event)
  if (not event or not event.PlayerID) then return end
  
  local player = PlayerResource:GetPlayer(event.PlayerID)
  if (not player) then return end
  
  local unit = EntIndexToHScript(event.unit)
  local item = unit:FindItemInInventory(event.itemname)
  unit:RemoveItem(item)
end

function MukenEvents:OnDropItem(event)
  if (not event or not event.PlayerID) then return end
  
  local player = PlayerResource:GetPlayer(event.PlayerID)
  if (not player) then return end
  
  local unit = EntIndexToHScript(event.unit)
  local item = CreateItem(event.itemname, player, nil)
  local drop = CreateItemOnPositionSync(unit:GetOrigin(), item)
  item:LaunchLootInitialHeight(false, 200, 200, 0.5, unit:GetOrigin())
end

function MukenEvents:OnRoleBarRequest(event)
  if (not event or not event.PlayerID) then return end
  
  local player = PlayerResource:GetPlayer(event.PlayerID)
  if (not player) then return end

  local event_hero_name = ""

  local players = PlayerResource:GetAllPlayers()
  for _, player in pairs(players) do
    local hero = player:GetAssignedHero()
    if "npc_dota_hero_"..event.id_name == hero:GetUnitName() then
      event_hero_name = hero:GetHeroName()
      break
    end
  end

  local heroes_stats_data = LoadKeyValues("scripts/kv/heroes_roles_level.kv")
  for hero_name, data in pairs(heroes_stats_data) do
    if hero_name == event_hero_name then
      CustomGameEventManager:Send_ServerToPlayer(player, "role_bar_state_from_server", data)
    end
  end
end

function MukenEvents:OnScoreRequest(event)
  if (not event or not event.PlayerID) then return end
  
  local player = PlayerResource:GetPlayer(event.PlayerID)
  if (not player) then return end

  local score_table = {
    [DOTA_TEAM_CUSTOM_1] = TEAMS[1][2],
    [DOTA_TEAM_CUSTOM_2] = TEAMS[2][2],
    [DOTA_TEAM_CUSTOM_3] = TEAMS[3][2],
    [DOTA_TEAM_CUSTOM_4] = TEAMS[4][2]
  }

  CustomGameEventManager:Send_ServerToPlayer(player, "score_state_from_server", score_table)
end

function MukenEvents:OnPortraitUpdate(event)
  if (not IsServer()) then return end
  if (not event or not event.PlayerID) then return end
  local player = PlayerResource:GetPlayer(event.PlayerID)
  if (not player) then return end
  local hero = player:GetAssignedHero()
  if (not hero) then return end
  local entity = EntIndexToHScript(event.entity)
  if entity == nil then return end
  if IsValidEntity(entity) == false then return end
  if hero:CanEntityBeSeenByMyTeam(entity) == false then return end
  if entity:GetMainStat("STR") == nil then return end
  if entity:GetMainStat("AGI") == nil then return end
  if entity:GetMainStat("INT") == nil then return end
  if entity:GetMainStat("VIT") == nil then return end

  local armor = entity:GetPhysicalArmorValue(false)

  if entity:IsIllusion() then
    local players = PlayerResource:GetAllPlayers()
    for _, player in pairs(players) do
      local hero = player:GetAssignedHero()
      if entity:GetHeroName() == hero:GetHeroName() then
        armor = hero:GetPhysicalArmorValue(false)
        break
      end
    end
  end

  local info = {
    unit_name = entity:GetUnitName(),

    physical_damage = entity:GetMainStat("STR"):GetPhysicalDamageAmp(),
    attack_speed = entity:GetDisplayAttackSpeed(),
    armor = armor,
    evasion = entity:GetMainStat("AGI"):GetEvasion(false),
    evasion_percent = entity:GetMainStat("AGI"):GetEvasion(true),
    crit_chance = entity:GetMainStat("STR"):GetCriticalChance(),

    attack_damage = entity:GetAverageTrueAttackDamage(nil),
    movespeed = entity:GetIdealSpeed(),
    luck = entity:GetMainStat("INT"):GetLuck() * 100,
    miss_chance = entity:GetMainStat("STR"):GetMissChance(),
    crit_damage = entity:GetMainStat("STR"):GetCriticalDamage(),

    magical_damage = entity:GetMainStat("INT"):GetMagicalDamageAmp(),
    current_vision = entity:GetCurrentVisionRange(),
    magical_resist = entity:GetMainStat("INT"):GetMagicalResist(),
    magical_resist_percent = entity:Script_GetMagicalArmorValue(false, entity:GetMainStat("INT")) * 100,
    summon_power = entity:GetMainStat("INT"):GetSummonPower(),
    debuff_amp = entity:GetMainStat("INT"):GetDebuffAmp() * 100,

    heal_power = 100 + (entity:GetMainStat("INT"):GetHealPower() * 100),
    heal_amp = entity:GetMainStat("VIT"):GetIncomingHeal(),
    status_resist = entity:GetMainStat("VIT"):GetStatusResist(true) * 100,
    cd_reduction = entity:GetMainStat("AGI"):GetCooldownReduction(),
    cd_reduction_percent = entity:GetCooldownReduction() * 100,
    buff_amp = entity:GetMainStat("VIT"):GetIncomingBuff() * 100
  }

  CustomGameEventManager:Send_ServerToPlayer(player, "unit_info_from_lua", info)
end

MukenEvents:Init()