--OTHERS

  function DebugPrint(...)
    local spew = Convars:GetInt('barebones_spew') or -1
    if spew == -1 and BAREBONES_DEBUG_SPEW then
      spew = 1
    end

    --if spew == 1 then
      --print(...)
    --end
  end

  function DebugPrintTable(...)
    local spew = Convars:GetInt('barebones_spew') or -1
    if spew == -1 and BAREBONES_DEBUG_SPEW then
      spew = 1
    end

    --if spew == 1 then
      PrintTable(...)
    --end
  end

  function PrintTable(t, indent, done)
    ----print ( string.format ('PrintTable type %s', type(keys)) )
    if type(t) ~= "table" then return end

    done = done or {}
    done[t] = true
    indent = indent or 0

    local l = {}
    for k, v in pairs(t) do
      table.insert(l, k)
    end

    table.sort(l)
    for k, v in ipairs(l) do
      -- Ignore FDesc
      if v ~= 'FDesc' then
        local value = t[v]

        if type(value) == "table" and not done[value] then
          done [value] = true
          --print(string.rep ("\t", indent)..tostring(v)..":")
          PrintTable (value, indent + 2, done)
        elseif type(value) == "userdata" and not done[value] then
          done [value] = true
          --print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
          PrintTable ((getmetatable(value) and getmetatable(value).__index) or getmetatable(value), indent + 2, done)
        else
          if t.FDesc and t.FDesc[v] then
            --print(string.rep ("\t", indent)..tostring(t.FDesc[v]))
          else
            --print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
          end
        end
      end
    end
  end

  -- Colors
  COLOR_NONE = '\x06'
  COLOR_GRAY = '\x06'
  COLOR_GREY = '\x06'
  COLOR_GREEN = '\x0C'
  COLOR_DPURPLE = '\x0D'
  COLOR_SPINK = '\x0E'
  COLOR_DYELLOW = '\x10'
  COLOR_PINK = '\x11'
  COLOR_RED = '\x12'
  COLOR_LGREEN = '\x15'
  COLOR_BLUE = '\x16'
  COLOR_DGREEN = '\x18'
  COLOR_SBLUE = '\x19'
  COLOR_PURPLE = '\x1A'
  COLOR_ORANGE = '\x1B'
  COLOR_LRED = '\x1C'
  COLOR_GOLD = '\x1D'

  function DebugAllCalls()
      if not GameRules.DebugCalls then
          --print("Starting DebugCalls")
          GameRules.DebugCalls = true

          debug.sethook(function(...)
              local info = debug.getinfo(2)
              local src = tostring(info.short_src)
              local name = tostring(info.name)
              if name ~= "__index" then
                  --print("Call: ".. src .. " -- " .. name .. " -- " .. info.currentline)
              end
          end, "c")
      else
          --print("Stopped DebugCalls")
          GameRules.DebugCalls = false
          debug.sethook(nil, "c")
      end
  end

  --[[Author: Noya
    Date: 09.08.2015.
    Hides all dem hats
  ]]
  function HideWearables( unit )
    unit.hiddenWearables = {} -- Keep every wearable handle in a table to show them later
      local model = unit:FirstMoveChild()
      while model ~= nil do
          if model:GetClassname() == "dota_item_wearable" then
              model:AddEffects(EF_NODRAW) -- Set model hidden
              table.insert(unit.hiddenWearables, model)
          end
          model = model:NextMovePeer()
      end
  end

  function ShowWearables( unit )

    for i,v in pairs(unit.hiddenWearables) do
      v:RemoveEffects(EF_NODRAW)
    end
  end

-- STATS/MODIFIERS

  function CalcStatus(duration, caster, target)
    if caster == nil or target == nil then return duration end
    if IsValidEntity(caster) == false or IsValidEntity(target) == false then return duration end

    -- if caster:GetTeamNumber() == target:GetTeamNumber() then
    --   duration = CalcBuffAmp(duration, target)
    -- else
    --   duration = CalcDebuffAmp(duration, caster)
    --   duration = CalcStatusResistance(duration, target)
    -- end

    if caster:GetTeamNumber() ~= target:GetTeamNumber() then
      duration = CalcStatusResistance(duration, target)
    end

    return duration
  end

  function CalcDebuffAmp(duration, caster)
    if caster:GetMainStat("INT") == nil then return duration end
    return duration * (1 + caster:GetMainStat("INT"):GetDebuffAmp())
  end

  function CalcStatusResistance(duration, target)
    if target:GetMainStat("VIT") == nil then return duration end
    return duration * (1 - target:GetMainStat("VIT"):GetStatusResist(true))
  end

  function CalcBuffAmp(duration, target)
    if target:GetMainStat("VIT") == nil then return duration end
    return duration * (1 + target:GetMainStat("VIT"):GetIncomingBuff())
  end

  function AddSubStats(target, ability, table, bCalcStatus)
    return AddModifier(target, ability, "sub_stat_modifier", table, bCalcStatus)
  end

  function RemoveSubStats(target, ability, list)
    if target == nil then return end
    if IsValidEntity(target) == false then return end

    local mod = target:FindAllModifiersByName("sub_stat_modifier")
    for _,modifier in pairs(mod) do
      local bPass = true

      for _, sub_stat in pairs(list) do
        if modifier.kv[sub_stat] == nil then
          bPass = false
        end
      end

      if bPass == true and (modifier:GetAbility() == ability or ability == nil) then
        modifier:Destroy()
      end
    end
  end

  function AddBonus(ability, string, target, bonus, base, time)
    if bonus == 0 and base == 0 then return end
    local stringFormat = "_1_"
    if string ~= "STR" and string ~= "INT" and string ~= "AGI" and string ~= "CON" then stringFormat = "_2_" end
    stringFormat = stringFormat..string

    if BaseStats(target) then return BaseStats(target):AddBonusStat(ability:GetCaster(), ability, bonus, base, time, stringFormat) end
  end

  function RemoveBonus(ability, string, target)
    local stringFormat = "_1_"
    if string ~= "STR" and string ~= "INT" and string ~= "AGI" and string ~= "CON" then stringFormat = "_2_" end
    stringFormat = stringFormat..string.."_modifier_stack"

    RemoveAllModifiersByNameAndAbility(target, stringFormat, ability)
  end

  function RemoveAllModifiersByNameAndAbility(target, name, ability)
    local mod = target:FindAllModifiersByName(name)
    for _,modifier in pairs(mod) do
      if modifier:GetAbility() == ability or ability == nil then
        modifier:Destroy()
      end
    end
  end

  function TargetHasModifierByAbility(target, name, ability)
    local mod = target:FindAllModifiersByName(name)
    for _,modifier in pairs(mod) do
      if modifier:GetAbility() == ability or ability == nil then
        return true
      end
    end

    return false
  end

-- HEROES UTIL

  function HasTreeNearby(point, radius)
    local trees = GridNav:GetAllTreesAroundPoint(point, radius, false)
    
    if trees then
      for k, v in pairs(trees) do
        return true
      end
    end

    return false
  end

  function IsMetamorphosis(ability_name, target)
    local ability = target:FindAbilityByName(ability_name)
    if ability then
      if ability:IsTrained() then
        return ability:GetCurrentAbilityCharges()
      end
    end
    return 0
  end

  function ApplyBash(target, ability, stun_duration, damage, bGreater)
    local caster = ability:GetCaster()
    local stun_mult = 1
    local sound_cast = "Hero_Spirit_Breaker.GreaterBash.Creep"

    if bGreater == false then
      stun_mult = 0.25
      sound_cast = "Hero_Spirit_Breaker.GreaterBash"
    end

    AddModifier(target, ability, "_modifier_stun", {duration = stun_duration * stun_mult}, true)
    AddModifier(target, ability, "modifier_knockback", {
      duration = 0.25,
      knockback_duration = 0.25,
      knockback_distance = CalcStatus(stun_duration * 50, caster, target),
      center_x = caster:GetAbsOrigin().x + 1,
      center_y = caster:GetAbsOrigin().y + 1,
      center_z = caster:GetAbsOrigin().z,
      knockback_height = stun_duration * 20,
    }, false)
  
    local particle_cast = "particles/econ/items/spirit_breaker/spirit_breaker_weapon_ti8/spirit_breaker_bash_ti8.vpcf"
    local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_POINT_FOLLOW, target)
    ParticleManager:SetParticleControlEnt(effect_cast, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
    ParticleManager:ReleaseParticleIndex(effect_cast)
    if IsServer() then target:EmitSound(sound_cast) end

    if damage > 0 then
      ApplyDamage({
        attacker = caster, victim = target,
        damage = damage, ability = ability,
        damage_type = ability:GetAbilityDamageType()
      })
    end
  end

  function PlayEfxAncientStun(target, damage, isCrit)
    local particle_shake = "particles/osiris/poison_alt/osiris_poison_splash_shake.vpcf"
    local effect = ParticleManager:CreateParticle(particle_shake, PATTACH_ABSORIGIN, target)
    ParticleManager:SetParticleControl(effect, 0, target:GetOrigin())
    ParticleManager:SetParticleControl(effect, 1, Vector(damage * 2, 0, 0))
  
    if isCrit == true then
      if target:GetPlayerOwner() then
        local particle_screen = "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_aftershock_screen.vpcf"
        local effect_screen = ParticleManager:CreateParticleForPlayer(particle_screen, PATTACH_WORLDORIGIN, nil, target:GetPlayerOwner())      
      end
  
      if IsServer() then target:EmitSound("Ancient.Stun.Crit") end
    end
  end

  function UpdateForcedTime()
    local thinkers = Entities:FindAllByClassname("npc_dota_thinker")
  
    for _,thinker in pairs(thinkers) do
      if thinker:HasModifier("_modifier_forced_night") then
      end
    end
  end

-- LUCK / HEAL / MANA

  function CalcHeal(caster, amount)
    return amount * (1 + caster:GetMainStat("INT"):GetHealPower())
  end

  function IncreaseMana(target, amount)
    local mana_deficit = target:GetMaxMana() - target:GetMana()
    if amount > mana_deficit then amount = mana_deficit end
    if amount <= 0 then return 0 end
    
    target:GiveMana(amount)

    SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, target, amount, nil)
    return amount
  end

  function ReduceMana(target, ability, amount, bMessage)
    if target:GetMana() < amount then amount = target:GetMana() end
    if amount <= 0 then return 0 end

    target:Script_ReduceMana(amount, ability)
    if bMessage then SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_LOSS, target, amount, nil) end
    return amount
  end

  function StealMana(target, inflictor, ability, amount)
    if amount > target:GetMana() then amount = target:GetMana() end

    ReduceMana(target, ability, amount, true)
    return IncreaseMana(inflictor, amount)
  end

-- COSMETICS

  function Cosmetics(baseNPC)
    return baseNPC:FindAbilityByName("cosmetics")
  end

  function AddStatusEfx(ability, string, caster, target)
    if Cosmetics(target) then Cosmetics(target):SetStatusEffect(caster, ability, string, true) end
  end

  function RemoveStatusEfx(ability, string, caster, target)
    if Cosmetics(target) then Cosmetics(target):SetStatusEffect(caster, ability, string, false) end
  end

  function GestureCosmetic(baseNPC, model_name, gesture, bEnabled)
    if Cosmetics(baseNPC) == nil then return end
    if Cosmetics(baseNPC).cosmetic == nil then return end

    if bEnabled then
      Cosmetics(baseNPC):StartCosmeticGesture(model_name, gesture)
    else
      Cosmetics(baseNPC):FadeCosmeticsGesture(model_name, gesture)
    end
  end

  function FindCosmeticByModel(baseNPC, model_name)
    if Cosmetics(baseNPC) then return Cosmetics(baseNPC):FindCosmeticByModel(model_name) end
  end

  function ChangeCosmeticsActivity(baseNPC)
    if Cosmetics(baseNPC) then Cosmetics(baseNPC):ChangeCosmeticsActivity(true) end
  end

  function ApplyParticleOnCosmetic(baseNPC, model_name, particle_name, attach)
    if Cosmetics(baseNPC) == nil then return end
    local off_hand_mod = Cosmetics(baseNPC):FindModifierByModel(model_name)
    if off_hand_mod then off_hand_mod:PlayEfxAmbient(particle_name, attach) end
  end

  function DestroyParticleOnCosmetic(baseNPC, model_name, particle_name, bDestroyImmediately)
    if Cosmetics(baseNPC) then Cosmetics(baseNPC):DestroyAmbient(model_name, particle_name, bDestroyImmediately) end
  end

  function AddModifierOnAllCosmetics(BaseNPC, ability, modifier_name, table)
    BaseNPC:AddNewModifier(BaseNPC, ability, modifier_name, table)

    if Cosmetics(BaseNPC) == nil then return end

    for i = 1, #Cosmetics(BaseNPC).cosmetic, 1 do
      Cosmetics(BaseNPC).cosmetic[i]:AddNewModifier(BaseNPC, ability, modifier_name, table)
    end
  end

  function RemoveModifierOnAllCosmetics(BaseNPC, ability, modifier_name)
    RemoveAllModifiersByNameAndAbility(BaseNPC, modifier_name, ability)

    if Cosmetics(BaseNPC) == nil then return end

    for i = 1, #Cosmetics(BaseNPC).cosmetic, 1 do
      RemoveAllModifiersByNameAndAbility(Cosmetics(BaseNPC).cosmetic[i], modifier_name, ability)
    end
  end

-- BASES

  function BaseHero(baseNPC)
    return baseNPC:FindAbilityByName("base_hero")
  end

  function BaseHeroMod(baseNPC)
    return baseNPC:FindModifierByName("base_hero_mod")
  end

  function ChangeActivity(baseNPC, activity)
    if BaseHeroMod(baseNPC) then BaseHeroMod(baseNPC):ChangeActivity(activity) end
  end

-- GETTERS

  function GetAbilitiesList(BaseNPC)
    local list = {}

		local skills_data = LoadKeyValues("scripts/vscripts/heroes/".. BaseNPC:GetHeroTeam().."/"..BaseNPC:GetHeroName().."/"..BaseNPC:GetHeroName().."-skills.txt")
		if skills_data ~= nil then
			for skill, skill_name in pairs(skills_data) do
				list[tonumber(skill)] = skill_name
			end
		end

    return list
	end

  function GetShrineTarget(hero)
    local bot_script = hero:FindModifierByName("_general_script")
    if bot_script then return bot_script:GetShrineTarget() end
  end
  
  function GetKillingSpreeAnnouncer(kills)
    local rand = RandomInt(1,2)
  
    if kills == 4 then
      if rand == 1 then return "announcer_killing_spree_announcer_kill_dominate_01" end
      if rand == 2 then return "announcer_killing_spree_announcer_kill_mega_01" end
    end
    if kills == 5 then
      if rand == 1 then return "announcer_killing_spree_announcer_kill_unstop_01" end
      if rand == 2 then return "announcer_killing_spree_announcer_kill_wicked_01" end
    end
    if kills == 6 then
      if rand == 1 then return "announcer_killing_spree_announcer_kill_godlike_01" end
      if rand == 2 then return "announcer_killing_spree_announcer_ownage_01" end
    end
    if kills >= 7 then
      if rand == 1 then return "announcer_killing_spree_announcer_kill_holy_01" end
      if rand == 2 then return "announcer_killing_spree_announcer_kill_monster_01" end
    end
  
    return "announcer_killing_spree_announcer_kill_spree_01"
  end

  function GetPipHitDamage(attacker)
    local hit = 1

    if attacker:IsHero() then
      if attacker:GetAttackCapability() == DOTA_UNIT_CAP_MELEE_ATTACK then hit = 4 else hit = 2 end
      if attacker:HasModifier("ancient_3_modifier_passive") then hit = 6 end
    end

    return hit
  end

-- ROLL FUNCTIONS

  function RollDrops(unit, killerEntity)
    local table = LoadKeyValues("scripts/kv/item_drops.kv")
    local DropInfo = table[unit:GetUnitName()]
    if DropInfo then
      local chance = 0
      local item_list = {}
      for table_name, table_chance in pairs(DropInfo) do
        if table_name == "chance" then
          chance = unit:GetLevel() * 2 --table_chance
        else
          for i = 1, table_chance, 1 do
            if #item_list then
              item_list[#item_list + 1] = table_name
            else
              item_list[1] = table_name
            end
          end
        end
      end

      if RandomFloat(0, 100) < chance then
        local item_name = item_list[RandomInt(1, #item_list)]
        local item = CreateItem(item_name, nil, nil)
        local pos = unit:GetAbsOrigin()
        local drop = CreateItemOnPositionSync(pos, item)
        local pos_launch = pos + RandomVector(RandomInt(150,200))
        item:LaunchLoot(false, 200, 0.75, pos_launch)

        local string = "particles/neutral_fx/neutral_item_drop_lvl4.vpcf"
        if unit:GetUnitName() == "boss_gorillaz" then string = "particles/neutral_fx/neutral_item_drop_lvl5.vpcf" end
        local particle = ParticleManager:CreateParticle(string, PATTACH_WORLDORIGIN, nil)
        ParticleManager:SetParticleControl(particle, 0, pos_launch)
        ParticleManager:ReleaseParticleIndex(particle)
      
        if IsServer() then
          if killerEntity then
            EmitSoundOnLocationForAllies(pos_launch, "NeutralLootDrop.Spawn", killerEntity)
          end
        end

        Timers:CreateTimer((15), function()
          if drop then
            if IsValidEntity(drop) then
              UTIL_Remove(drop)
            end
          end
        end)
      end
    end
  end

  function RandomForNoHeroSelected()
    for team_number, data in pairs(TEAMS) do
      for i = 1, CUSTOM_TEAM_PLAYER_COUNT[team_number] do
        local playerID = PlayerResource:GetNthPlayerIDOnTeam(team_number, i)
        if playerID ~= nil then
          if not PlayerResource:HasSelectedHero(playerID) then
            local hPlayer = PlayerResource:GetPlayer(playerID)
            if hPlayer ~= nil then
              hPlayer:MakeRandomHeroSelection()
            end
          end
        end
      end
    end
  end

  function GetSlotByType(type)
    if type == "armor" then return 0 end
    if type == "head" then return 1 end
    if type == "weapon" then return 2 end
    if type == "misc" then return 3 end
    return -1
  end

-- BOTS

  function LoadBots()
    if BOTS_ENABLED_TOOLS == false then
      local names = {
        [1] = "item_rare_nature_ring", [2] = "item_rare_nature_ring",
        [3] = "item_rare_nature_ring", [4] = "item_rare_nature_ring"
      }

      for i = 1, 5, 1 do
        local item = CreateItem(names[RandomInt(1, 4)], nil, nil)
        local pos = Vector(-1400, -1400, 0)
        local drop = CreateItemOnPositionSync(pos, item)
        local pos_launch = pos + RandomVector(RandomInt(100, 200))
        item:LaunchLoot(false, 200, 0.75, pos_launch, nil)        
      end
    end

    if IsInToolsMode() then
      if BOTS_ENABLED_TOOLS == false then return end
    else
      if BOTS_ENABLED == false then return end
    end

    BOTS_LOADED = true
    
    local bot_slots = {
      [DOTA_TEAM_CUSTOM_1] = 3,
      [DOTA_TEAM_CUSTOM_2] = 3,
      [DOTA_TEAM_CUSTOM_3] = 3,
      [DOTA_TEAM_CUSTOM_4] = 3,
    }

    local players_hero_list = {}
    local bot_list = {}
    local random_list = {}
    local hero_index = 1

    local players = PlayerResource:GetAllPlayers()
    for _, player in pairs(players) do
      local hero = player:GetAssignedHero()
      table.insert(players_hero_list, hero:GetHeroName())
    end

    for team_number, data in pairs(TEAMS) do
      for i = 1, CUSTOM_TEAM_PLAYER_COUNT[team_number] do
        local playerID = PlayerResource:GetNthPlayerIDOnTeam(team_number, i)
        if playerID then
          local unit_name = GetHeroName(PlayerResource:GetSelectedHeroName(playerID))
          if unit_name then
            for bot_team, number in pairs(bot_slots) do
              if bot_team == team_number then
                bot_slots[bot_team] = bot_slots[bot_team] - 1
              end
            end
          end
        end
      end
    end

    for _, bot_hero_name in pairs(BOT_LIST) do
      local bIncludeHero = true
      for _, player_hero_name in pairs(players_hero_list) do
        if player_hero_name == bot_hero_name then
          bIncludeHero = false
        end
      end
      if bIncludeHero == true then
        bot_list[hero_index] = bot_hero_name
        hero_index = hero_index + 1
      end
    end

    for i = 1, #bot_list, 1 do
      local rand = RandomInt(i, #bot_list)
      random_list[i] = bot_list[rand]
      bot_list[rand] = bot_list[i]
      bot_list[i] = random_list[i]
    end

    hero_index = 1

    for bot_team, number in pairs(bot_slots) do
      local i = number
      while i > 0 do
        local hero = GetIDName(random_list[hero_index])
        --if TEMP_DEL == 0 and bot_team == DOTA_TEAM_CUSTOM_1 then TEMP_DEL = 1 hero = "npc_dota_hero_sniper" end -- FORCE BOT PICK
        local new_bot = GameRules:AddBotPlayerWithEntityScript(hero, RANDOM_NAMES[hero_index], bot_team, "", false)

        PlayerResource:GetPlayer(new_bot:GetPlayerID()):SetAssignedHeroEntity(new_bot)
        new_bot:AddNewModifier(new_bot, nil, "_general_script", {})

        BOTS[hero_index] = new_bot
        hero_index = hero_index + 1
        i = i - 1

        if hero_index > #random_list then return end
      end
    end
  end

  function IsAbilityCastable(ability)
    if ability == nil then return false end
    if ability:IsTrained() == false then return false end
    if ability:IsChanneling() == true then return true end
    if ability:IsActivated() == false then return false end
    if ability:IsFullyCastable() == false then return false end
    if ability:GetCaster():IsCommandRestricted() then return false end
    if ability:GetCaster():IsSilenced() then return false end
    
    return true
  end

  function GetAllAttackers(target)
    local attackers = nil

    for _, hero in pairs(HeroList:GetAllHeroes()) do
      if hero:GetTeamNumber() ~= target:GetTeamNumber() then  
        if hero:IsAttackingEntity(target) then
          if attackers == nil then attackers = {} end
          table.insert(attackers, hero)
        end
      end
    end

    return attackers
  end

  function CallBloodLoss(damage, attacker, unit)
    local keys = {damage = damage, attacker = attacker, unit = unit}

    local entties = Entities:FindAllInSphere(Vector(0, 0, 0), 10000)

    for _,ent in pairs(entties) do
      if ent:IsBaseNPC() then
        local modifiers = ent:FindAllModifiers()

        for _,mod in pairs(modifiers) do
          if mod.OnBloodLoss then
            mod:OnBloodLoss(keys)
          end
        end
      end
    end
  end