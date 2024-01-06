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
end

function MukenEvents:Notifications(params)
  Notifications:TopToAll({text="THE FIRST TEAM TO REACH #score POINTS WINS", duration=10.0})
end

function MukenEvents:GamePointsUpdate(params)
  SCORE_LIMIT = params.match_points
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

  local heroes_stats_data = LoadKeyValues("scripts/kv/heroes_roles_level.kv")
  for hero, data in pairs(heroes_stats_data) do
    if hero == GetHeroName("npc_dota_hero_" .. event.id_name) then
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
  if MainStats(entity, "STR") == nil then return end
  if MainStats(entity, "AGI") == nil then return end
  if MainStats(entity, "INT") == nil then return end
  if MainStats(entity, "VIT") == nil then return end

  local info = {
    unit_name = entity:GetUnitName(),

    physical_damage = MainStats(entity, "STR"):GetPhysicalDamageAmp(),
    attack_speed = entity:GetDisplayAttackSpeed(),
    armor = entity:GetPhysicalArmorValue(false),
    evasion = MainStats(entity, "AGI"):GetEvasion(false),
    evasion_percent = MainStats(entity, "AGI"):GetEvasion(true),
    crit_chance = MainStats(entity, "STR"):GetCriticalChance(false),
    crit_chance_percent = MainStats(entity, "STR"):GetCriticalChance(true),

    attack_damage = entity:GetAverageTrueAttackDamage(nil),
    movespeed = entity:GetIdealSpeed(),
    hp_regen = entity:GetHealthRegen(),
    miss_chance = MainStats(entity, "STR"):GetMissChance(),
    crit_damage = MainStats(entity, "STR"):GetCriticalDamage(),

    magical_damage = MainStats(entity, "INT"):GetMagicalDamageAmp(),
    current_vision = entity:GetCurrentVisionRange(),
    magical_resist = MainStats(entity, "INT"):GetMagicalResist(),
    magical_resist_percent = entity:Script_GetMagicalArmorValue(false, MainStats(entity, "INT")) * 100,
    mp_regen = entity:GetManaRegen(),
    debuff_amp = MainStats(entity, "INT"):GetDebuffAmp() * 100,

    heal_power = 100 + (MainStats(entity, "INT"):GetHealPower() * 100),
    heal_amp = MainStats(entity, "VIT"):GetIncomingHeal(),
    status_resist = MainStats(entity, "VIT"):GetStatusResist(true) * 100,
    cd_reduction = MainStats(entity, "AGI"):GetCooldownReduction(),
    cd_reduction_percent = entity:GetCooldownReduction() * 100,
    buff_amp = MainStats(entity, "VIT"):GetIncomingBuff() * 100

    -- physical_damage = BaseStats(entity):GetTotalPhysicalDamagePercent(),
    -- attack_speed = entity:GetDisplayAttackSpeed(),
    -- armor = entity:GetPhysicalArmorValue(false),
    -- evasion = BaseStats(entity):GetDodgePercent(),
    -- crit_chance = BaseStats(entity):GetCriticalChance(true),

    -- attack_damage = entity:GetAverageTrueAttackDamage(nil),
    -- movespeed = entity:GetIdealSpeed(),
    -- block = BaseStats(entity):GetBlockAtkDamage(),
    -- hp_regen = entity:GetHealthRegen(),
    -- crit_damage = 100 + BaseStats(entity):GetTotalCriticalDamage(),

    -- magical_damage = BaseStats(entity):GetTotalMagicalDamagePercent(),
    -- current_vision = entity:GetCurrentVisionRange(),
    -- magical_resist = entity:Script_GetMagicalArmorValue(false, BaseStats(entity)) * 100,
    -- mp_regen = entity:GetManaRegen(),
    -- debuff_amp = BaseStats(entity):GetTotalDebuffAmpPercent(),

    -- heal_power = BaseStats(entity):GetTotalHealPowerPercent(),
    -- heal_amp = 100 + BaseStats(entity):GetHealAmp(),
    -- status_resist = BaseStats(entity):GetStatusResistPercent(),
    -- cd_reduction = entity:GetCooldownReduction() * 100,
    -- buff_amp = BaseStats(entity):GetTotalBuffAmpPercent()
  }

  CustomGameEventManager:Send_ServerToPlayer(player, "unit_info_from_lua", info)
end

function MukenEvents:OnTalentTreeTalentsRequest(event)
  if (not event or not event.PlayerID) then return end
  
  local player = PlayerResource:GetPlayer(event.PlayerID)
  if (not player) then return end

  local hero = player:GetAssignedHero()
  if (not hero) then return end

  if BaseHero(hero) == nil then return end

  BaseHero(hero):UpdatePanoramaRanks()
end

function MukenEvents:OnTalentTreeLevelUpRequest(event)
  if (not IsServer()) then return end
  if (event == nil or not event.PlayerID) then return end

  local player = PlayerResource:GetPlayer(event.PlayerID)
  if (not player) then return end

  local hero = player:GetAssignedHero()
  if (not hero) then return end

  local talentId = tonumber(event.id)

  if BaseHero(hero) then BaseHero(hero):UpgradeRank(talentId) end
end

function MukenEvents:OnTalentTreeStateRequest(event)
  if (not IsServer()) then return end
  if (not event or not event.PlayerID) then return end

  local player = PlayerResource:GetPlayer(event.PlayerID)
  if (not player) then return end

  local hero = player:GetAssignedHero()
  if (hero == nil) then return end

  if BaseHero(hero) == nil then return end

  BaseHero(hero):UpdatePanoramaState()
end

function MukenEvents:OnTalentTreeResetRequest(event)
  if (not IsServer()) then return end
  if (event == nil or not event.PlayerID) then return end

  local player = PlayerResource:GetPlayer(event.PlayerID)
  if (not player) then return end

  local hero = player:GetAssignedHero()
  if (not hero) then return end

  if BaseHero(hero) == nil then return end

  local pointsToReturn = 0
  for i = 1, #base_hero.talentsData do
    pointsToReturn = pointsToReturn + base_hero:GetHeroTalentLevel(i)
    BaseHero(hero):SetHeroTalentLevel(i, 0)
  end

  BaseHero(hero):UpdateRankPoints(pointsToReturn)
end

MukenEvents:Init()