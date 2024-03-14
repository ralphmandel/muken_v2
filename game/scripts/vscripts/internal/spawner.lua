if Spawner == nil then
  --DebugPrint( '[BAREBONES] creating spawner' )
  _G.Spawner = class({})
end

function Spawner:SpawnFountains()
  if self.start == nil then
    if GetMapName() == "muken_arena_pvp" then
      local shrines = Entities:FindAllByClassname("npc_dota_healer")
      for _, shrine in pairs(shrines) do
        local shrine_ability = shrine:AddAbility("shrine")
        shrine_ability:UpgradeAbility(true)
      end
    else
      -- for i = 1, 4, 1 do
      --   local loc = GetGroundPosition(fountain_origin, nil)
      --   local fountain = CreateUnitByName("fountain_building", loc, true, nil, nil, team_number)
      --   fountain:SetOrigin(loc)
      --   FindClearSpaceForUnit(fountain, loc, true)
      -- end
    end
  end

  self.start = true
end

function Spawner:SpawnNeutrals(spawn_area)
  local current_mobs = 0

  while current_mobs < MAX_MOB_COUNT_TOTAL do
    local free_spots = {}
    local free_spot_index = 1
    current_mobs = 0

    for area, spots in pairs(spawn_area) do
      local current_mobs_area = 0
      local free_spots_area = {}
      local index = 1

      for i = 1, #spots, 1 do
        local spot_blocked = self:IsSpotAlive(spots, i) or self:IsSpotCooldown(spots, i, 30)
  
        if spot_blocked then
          current_mobs_area = current_mobs_area + 1
          current_mobs = current_mobs + 1
        else
          free_spots_area[index] = i
          index = index + 1
        end
      end

      if current_mobs_area < MAX_MOB_COUNT_PER_AREA then
        for i = 1, #free_spots_area, 1 do
          free_spots[free_spot_index] = {["area"] = area, ["spot"] = free_spots_area[i]}
          free_spot_index = free_spot_index + 1
        end
      end
    end

    if current_mobs < MAX_MOB_COUNT_TOTAL then
      local map = free_spots[RandomInt(1, #free_spots)]
      local mob = self:RandomizeMob()
      self:CreateMob(spawn_area, map, mob, "_modifier__ai")
    end
  end
end

function Spawner:IsSpotAlive(spawner, spot)
  for category, data in pairs(spawner[spot]["mob"]) do
    if category == "units" then
      for _,unit in pairs(data) do
        if IsValidEntity(unit) then
          if unit:IsAlive() and unit:IsDominated() == false then
            return true
          end
        end
      end
    end
  end

  return false
end

function Spawner:IsSpotCooldown(spawner, spot, respawn_time)
  local current_time = GameRules:GetDOTATime(false, false)

  if spawner[spot]["respawn"] == nil then
    spawner[spot]["respawn"] = current_time
    return true
  end

  return (respawn_time > (current_time - spawner[spot]["respawn"]))
end

function Spawner:RandomizeMob()
  local rand_mobs = {}
  local index = 0
  local rarity = RARITY_COMMON

  local hero_count = 0
  local hero_lvl_total = 0

  for _, hero in pairs(HeroList:GetAllHeroes()) do
    hero_count = hero_count + 1
    hero_lvl_total = hero_lvl_total + hero:GetLevel() + 1
  end

  local average_level = hero_lvl_total / hero_count
  local current_tier = math.ceil(average_level / 5)
  if current_tier > 6 then current_tier = 6 end
  
  if RandomFloat(0, 100) < 15 then
    if current_tier > 3 then rarity = RARITY_LEGENDARY end
  elseif RandomFloat(0, 100) < 23.5 then
    if current_tier > 2 then rarity = RARITY_EPIC end
  elseif RandomFloat(0, 100) < 38.5 then
    if current_tier > 1 then rarity = RARITY_RARE end
  end

  local random_tier = RandomInt(rarity + 1, current_tier)

  for _,mob in pairs(SPAWNER_MOBS) do
    if mob["rarity"] == rarity and mob["tier"] == random_tier then
      index = index + 1
      rand_mobs[index] = mob
    end
  end

  return rand_mobs[RandomInt(1, index)]
end

function Spawner:CreateMob(spawner, map, mob, modifier)
  local spawned_units = {}
  local area = map["area"]
  local spot = map["spot"]
  local rarity = mob["rarity"]

  for _,unit in pairs(mob["units"]) do
    local spawned_unit = CreateUnitByName(unit, spawner[area][spot]["origin"], true, nil, nil, TIER_TEAMS[rarity])
    spawned_unit.xp_mult = 1 + (rarity * 0.25)
    table.insert(spawned_units, spawned_unit)
    local ai = spawned_unit:FindModifierByName(modifier)
    if ai then ai.spot_origin = spawner[area][spot]["origin"] end
  end

  spawner[area][spot]["respawn"] = nil
  spawner[area][spot]["mob"] = {["tier"] = mob["tier"], ["units"] = spawned_units}
end

function Spawner:RandomizePlayerSpawn(unit)
  local loc = TEAMS[unit:GetTeamNumber()].origin
  unit:SetOrigin(loc)
  FindClearSpaceForUnit(unit, loc, true)
end