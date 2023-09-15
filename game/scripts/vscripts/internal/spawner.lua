if Spawner == nil then
  DebugPrint( '[BAREBONES] creating spawner' )
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
      for i = 1, #TEAMS, 1 do
        local loc = GetGroundPosition(TEAMS[i]["fountain_origin"], nil)
        local fountain = CreateUnitByName("fountain_building", loc, true, nil, nil, TEAMS[i][1])
        fountain:SetOrigin(loc)
        FindClearSpaceForUnit(fountain, loc, true)
      end
    end
  end

  self.start = true
end

function Spawner:SpawnNeutrals(spawn_area)
  local current_mobs = 0

  while current_mobs < MAX_MOB_COUNT do
    local free_spots = {}
    local free_spot_index = 1
    current_mobs = 0

    for i = 1, #spawn_area, 1 do
      local spot_blocked = self:IsSpotAlive(spawn_area, i)
      if not spot_blocked then spot_blocked = self:IsSpotCooldown(spawn_area, i, 5) end
      if spot_blocked then
        current_mobs = current_mobs + 1
      else
        free_spots[free_spot_index] = i
        free_spot_index = free_spot_index + 1
      end
    end

    if current_mobs < MAX_MOB_COUNT then
      local spot = free_spots[RandomInt(1, #free_spots)]
      local tier = self:RandomizeTier()
      local mob = self:RandomizeMob(tier)
      self:CreateMob(spawn_area, spot, tier, mob, "_modifier__ai")
    end
  end
end

function Spawner:SpawnBosses()
end

function Spawner:SpawnBosses()
  local current_mobs = 0

  while current_mobs < MAX_BOSS_COUNT do
    local free_spots = {}
    local free_spot_index = 1
    current_mobs = 0

    for i = 1, #SPAWNER_BOSS_SPOTS, 1 do
      local spot_blocked = self:IsSpotAlive(SPAWNER_BOSS_SPOTS, i)
      if not spot_blocked then spot_blocked = self:IsSpotCooldown(SPAWNER_BOSS_SPOTS, i, 300) end
      if spot_blocked then
        current_mobs = current_mobs + 1
      else
        free_spots[free_spot_index] = i
        free_spot_index = free_spot_index + 1
      end
    end

    if current_mobs < MAX_BOSS_COUNT then
      local spot = free_spots[RandomInt(1, #free_spots)]
      self:CreateMob(SPAWNER_BOSS_SPOTS, spot, 8, self:RandomizeMob(8), "")
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

function Spawner:RandomizeTier()
  local hero_count = 0
  local hero_lvl_total = 0

  for _, hero in pairs(HeroList:GetAllHeroes()) do
    hero_count = hero_count + 1
    hero_lvl_total = hero_lvl_total + hero:GetLevel()
  end

  local current_tier = math.ceil((hero_lvl_total / hero_count) / 6)

  for i = current_tier, 1, -1 do
    if RandomFloat(0, 100) < 40 then
      return i
    end
  end

  return 1
end

function Spawner:RandomizeMob(tier)
  local rand_mobs = {}
  local index = 0
  for _,mob in pairs(SPAWNER_MOBS) do
    if mob["tier"] == tier then
      index = index + 1
      rand_mobs[index] = mob["units"]
    end
  end

  return rand_mobs[RandomInt(1, index)]
end

function Spawner:CreateMob(spawner, spot, tier, mob, modifier)
  local spawned_units = {}

  for _,unit in pairs(mob) do
    local spawned_unit = CreateUnitByName(unit, spawner[spot]["origin"], true, nil, nil, DOTA_TEAM_NEUTRALS)
    table.insert(spawned_units, spawned_unit)
    local ai = spawned_unit:FindModifierByName(modifier)
    if ai then ai.spot_origin = spawner[spot]["origin"] end
  end

  spawner[spot]["respawn"] = nil
  spawner[spot]["mob"] = {["tier"] = tier, ["units"] = spawned_units}
end

function Spawner:RandomizePlayerSpawn(unit)
  local loc = Vector(0, 0, 0)

  if GetMapName() == "muken_arena_pvp" then
    loc = TEAM_ORIGIN[unit:GetTeamNumber()]
  else
    for i = 1, #TEAMS, 1 do
      if TEAMS[i][1] == unit:GetTeamNumber() then
        loc = TEAMS[i]["team_origin"]
      end
    end
  end

  unit:SetOrigin(loc)
  FindClearSpaceForUnit(unit, loc, true)
end