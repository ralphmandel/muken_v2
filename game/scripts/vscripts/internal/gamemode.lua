-- This function initializes the game mode and is called before anyone loads into the game
-- It can be used to pre-initialize any values/tables that will be needed later
function GameMode:_InitGameMode()
  -- if GameMode._reentrantCheck then
  --   return
  -- end

  -- Setup rules
  --GameRules:SetHeroRespawnEnabled( ENABLE_HERO_RESPAWN )
  --GameRules:SetUseUniversalShopMode( UNIVERSAL_SHOP_MODE )
  GameRules:SetCustomGameAllowHeroPickMusic(false)
  GameRules:SetCustomGameAllowMusicAtGameStart(false)
  GameRules:SetCustomGameAllowBattleMusic(false)

  GameRules:SetSameHeroSelectionEnabled(false)
  GameRules:SetSafeToLeave(true)
  GameRules:SetTimeOfDay(0.25)
  GameRules:SetStrategyTime(0)
  GameRules:SetShowcaseTime(0)
  GameRules:SetHeroSelectionTime(HERO_SELECTION_TIME)
  GameRules:SetPreGameTime(PRE_GAME_TIME)
  GameRules:SetPostGameTime(60)
  GameRules:SetTreeRegrowTime(150)
  --GameRules:SetUseCustomHeroXPValues ( USE_CUSTOM_XP_VALUES )
  GameRules:SetGoldPerTick(0)
  GameRules:SetGoldTickTime(0)
  --GameRules:SetRuneSpawnTime(RUNE_SPAWN_TIME)
  --GameRules:SetUseBaseGoldBountyOnHeroes(USE_STANDARD_HERO_GOLD_BOUNTY)
  --GameRules:SetHeroMinimapIconScale( MINIMAP_ICON_SIZE )
  GameRules:SetCreepMinimapIconScale(0)
  --GameRules:SetRuneMinimapIconScale( MINIMAP_RUNE_ICON_SIZE )

  GameRules:SetFirstBloodActive(true)
  --GameRules:SetHideKillMessageHeaders( HIDE_KILL_BANNERS )

  --GameRules:SetCustomGameEndDelay( GAME_END_DELAY )
  GameRules:SetCustomVictoryMessageDuration(30)
  GameRules:SetStartingGold(0)

  -- if SKIP_TEAM_SETUP then
  --   GameRules:SetCustomGameSetupAutoLaunchDelay( 0 )
  --   GameRules:LockCustomGameSetupTeamAssignment( true )
  --   GameRules:EnableCustomGameSetupAutoLaunch( true )
  -- else
  --   GameRules:SetCustomGameSetupAutoLaunchDelay( AUTO_LAUNCH_DELAY )
  --   GameRules:LockCustomGameSetupTeamAssignment( LOCK_TEAM_SETUP )
  --   GameRules:EnableCustomGameSetupAutoLaunch( ENABLE_AUTO_LAUNCH )
  -- end


  -- This is multiteam configuration stuff
  GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS, 0)
  GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_BADGUYS, 0)

  if USE_AUTOMATIC_PLAYERS_PER_TEAM then
    local num = math.floor(10 / MAX_NUMBER_OF_TEAMS)
    local count = 0
    for team,number in pairs(TEAM_COLORS) do
      if count >= MAX_NUMBER_OF_TEAMS then
        GameRules:SetCustomGameTeamMaxPlayers(team, 0)
      else
        GameRules:SetCustomGameTeamMaxPlayers(team, num)
      end
      count = count + 1
    end
  else
    local count = 0
    for team,number in pairs(CUSTOM_TEAM_PLAYER_COUNT) do
      if count >= MAX_NUMBER_OF_TEAMS then
        GameRules:SetCustomGameTeamMaxPlayers(team, 0)
      else
        GameRules:SetCustomGameTeamMaxPlayers(team, number)
      end
      count = count + 1
    end
  end

  GameRules:SetCustomGameTeamMaxPlayers(1, 2)

  if USE_CUSTOM_TEAM_COLORS then
    for team,color in pairs(TEAM_COLORS) do
      SetTeamCustomHealthbarColor(team, color[1], color[2], color[3])
    end
  end
  DebugPrint('[BAREBONES] GameRules set')

  --InitLogFile( "log/barebones.txt","")

  -- Event Hooks
  -- All of these events can potentially be fired by the game, though only the uncommented ones have had
  -- Functions supplied for them.  If you are interested in the other events, you can uncomment the
  -- ListenToGameEvent line and add a function to handle the event
  ListenToGameEvent('dota_player_gained_level', Dynamic_Wrap(GameMode, 'OnPlayerLevelUp'), self)
  ListenToGameEvent('dota_ability_channel_finished', Dynamic_Wrap(GameMode, 'OnAbilityChannelFinished'), self)
  ListenToGameEvent('dota_player_learned_ability', Dynamic_Wrap(GameMode, 'OnPlayerLearnedAbility'), self)
  ListenToGameEvent('entity_killed', Dynamic_Wrap(GameMode, '_OnEntityKilled'), self)
  ListenToGameEvent('player_connect_full', Dynamic_Wrap(GameMode, '_OnConnectFull'), self)
  ListenToGameEvent('player_disconnect', Dynamic_Wrap(GameMode, 'OnDisconnect'), self)
  ListenToGameEvent('dota_item_purchased', Dynamic_Wrap(GameMode, 'OnItemPurchased'), self)
  ListenToGameEvent('dota_item_picked_up', Dynamic_Wrap(GameMode, 'OnItemPickedUp'), self)
  ListenToGameEvent('last_hit', Dynamic_Wrap(GameMode, 'OnLastHit'), self)
  ListenToGameEvent('dota_non_player_used_ability', Dynamic_Wrap(GameMode, 'OnNonPlayerUsedAbility'), self)
  ListenToGameEvent('player_changename', Dynamic_Wrap(GameMode, 'OnPlayerChangedName'), self)
  ListenToGameEvent('dota_rune_activated_server', Dynamic_Wrap(GameMode, 'OnRuneActivated'), self)
  ListenToGameEvent('dota_player_take_tower_damage', Dynamic_Wrap(GameMode, 'OnPlayerTakeTowerDamage'), self)
  ListenToGameEvent('tree_cut', Dynamic_Wrap(GameMode, 'OnTreeCut'), self)
  ListenToGameEvent('entity_hurt', Dynamic_Wrap(GameMode, 'OnEntityHurt'), self)
  ListenToGameEvent('player_connect', Dynamic_Wrap(GameMode, 'PlayerConnect'), self)
  ListenToGameEvent('dota_player_used_ability', Dynamic_Wrap(GameMode, 'OnAbilityUsed'), self)
  ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(GameMode, '_OnGameRulesStateChange'), self)
  ListenToGameEvent('npc_spawned', Dynamic_Wrap(GameMode, '_OnNPCSpawned'), self)
  ListenToGameEvent('dota_player_pick_hero', Dynamic_Wrap(GameMode, 'OnPlayerPickHero'), self)
  ListenToGameEvent('dota_team_kill_credit', Dynamic_Wrap(GameMode, 'OnTeamKillCredit'), self)
  ListenToGameEvent("player_reconnected", Dynamic_Wrap(GameMode, 'OnPlayerReconnect'), self)

  ListenToGameEvent("dota_illusions_created", Dynamic_Wrap(GameMode, 'OnIllusionsCreated'), self)
  ListenToGameEvent("dota_item_combined", Dynamic_Wrap(GameMode, 'OnItemCombined'), self)
  ListenToGameEvent("dota_player_begin_cast", Dynamic_Wrap(GameMode, 'OnAbilityCastBegins'), self)
  ListenToGameEvent("dota_tower_kill", Dynamic_Wrap(GameMode, 'OnTowerKill'), self)
  ListenToGameEvent("dota_player_selected_custom_team", Dynamic_Wrap(GameMode, 'OnPlayerSelectedCustomTeam'), self)
  ListenToGameEvent("dota_npc_goal_reached", Dynamic_Wrap(GameMode, 'OnNPCGoalReached'), self)

  ListenToGameEvent("player_chat", Dynamic_Wrap(GameMode, 'OnPlayerChat'), self)

  --ListenToGameEvent("dota_tutorial_shop_toggled", Dynamic_Wrap(GameMode, 'OnShopToggled'), self)

  --ListenToGameEvent('player_spawn', Dynamic_Wrap(GameMode, 'OnPlayerSpawn'), self)
  --ListenToGameEvent('dota_unit_event', Dynamic_Wrap(GameMode, 'OnDotaUnitEvent'), self)
  --ListenToGameEvent('nommed_tree', Dynamic_Wrap(GameMode, 'OnPlayerAteTree'), self)
  --ListenToGameEvent('player_completed_game', Dynamic_Wrap(GameMode, 'OnPlayerCompletedGame'), self)
  --ListenToGameEvent('dota_match_done', Dynamic_Wrap(GameMode, 'OnDotaMatchDone'), self)
  --ListenToGameEvent('dota_combatlog', Dynamic_Wrap(GameMode, 'OnCombatLogEvent'), self)
  --ListenToGameEvent('dota_player_killed', Dynamic_Wrap(GameMode, 'OnPlayerKilled'), self)
  --ListenToGameEvent('player_team', Dynamic_Wrap(GameMode, 'OnPlayerTeam'), self)

  --[[This block is only used for testing events handling in the event that Valve adds more in the future
  Convars:RegisterCommand('events_test', function()
      GameMode:StartEventTest()
    end, "events test", 0)]]

  local spew = 0
  if BAREBONES_DEBUG_SPEW then
    spew = 1
  end
  print("BAREBONES_DEBUG_SPEW", spew)
  Convars:RegisterConvar('barebones_spew', tostring(spew), 'Set to 1 to start spewing barebones debug info.  Set to 0 to disable.', 0)

  -- Change random seed
  local timeTxt = string.gsub(string.gsub(GetSystemTime(), ':', ''), '^0+','')
  math.randomseed(tonumber(timeTxt))

  -- Initialized tables for tracking state
  self.bSeenWaitForPlayers = false
  self.vUserIds = {}

  DebugPrint('[BAREBONES] Done loading Barebones gamemode!\n\n')
  GameMode._reentrantCheck = true
  GameMode:InitGameMode()
  GameMode._reentrantCheck = false
end

mode = nil

-- This function is called as the first player loads and sets up the GameMode parameters
function GameMode:_CaptureGameMode()
  if mode == nil then
    -- Set GameMode parameters
    mode = GameRules:GetGameModeEntity()        
    mode:SetTPScrollSlotItemOverride("item_tp")
    mode:SetGiveFreeTPOnDeath(false)
    mode:SetDaynightCycleAdvanceRate(2)
    mode:SetModifyGoldFilter(Dynamic_Wrap(self, "FilterModifyGold"), self)
    mode:SetModifyExperienceFilter(Dynamic_Wrap(self, "FilterModifyExperience"), self)
    mode:SetCustomScanCooldown(30)
    mode:SetNeutralStashEnabled(false)
    mode:SetInnateMeleeDamageBlockAmount(0)
    mode:SetSelectionGoldPenaltyEnabled(false)

    --mode:SetRecommendedItemsDisabled( RECOMMENDED_BUILDS_DISABLED )
    mode:SetCameraDistanceOverride(1350)
    --mode:SetCustomBuybackCostEnabled( CUSTOM_BUYBACK_COST_ENABLED )
    --mode:SetCustomBuybackCooldownEnabled( CUSTOM_BUYBACK_COOLDOWN_ENABLED )
    mode:SetBuybackEnabled(false)
    mode:SetTopBarTeamValuesOverride(USE_CUSTOM_TOP_BAR_VALUES)
    mode:SetTopBarTeamValuesVisible(false)
    mode:SetUseCustomHeroLevels(true)
    --mode:SetCustomHeroMaxLevel ( MAX_LEVEL )

    mode:SetCustomXPRequiredToReachNextLevel({
      200, 420, 670, 960, 1300, 1700, 2170, 2720, 3360, 4100,
      4950, 5920, 7020, 8260, 9650, 11200, 12920, 14820, 16910, 19200,
      21700, 24420, 27370, 30560, 34000, 37700, 41670, 45920, 50460, 55300
    })

    --mode:SetBotThinkingEnabled( USE_STANDARD_DOTA_BOT_THINKING )
    --mode:SetTowerBackdoorProtectionEnabled( ENABLE_TOWER_BACKDOOR_PROTECTION )

    --mode:SetFogOfWarDisabled(DISABLE_FOG_OF_WAR_ENTIRELY)
    mode:SetGoldSoundDisabled(false)
    mode:SetRemoveIllusionsOnDeath(true)

    mode:SetAlwaysShowPlayerInventory(false)
    mode:SetAnnouncerDisabled(true)
    if FORCE_PICKED_HERO ~= nil then
      mode:SetCustomGameForceHero( FORCE_PICKED_HERO )
    end
    mode:SetFixedRespawnTime(30)
    --mode:SetFountainConstantManaRegen( FOUNTAIN_CONSTANT_MANA_REGEN )
    --mode:SetFountainPercentageHealthRegen( FOUNTAIN_PERCENTAGE_HEALTH_REGEN )
    --mode:SetFountainPercentageManaRegen( FOUNTAIN_PERCENTAGE_MANA_REGEN )
    mode:SetLoseGoldOnDeath(false)
    mode:SetMaximumAttackSpeed(900)
    --mode:SetMinimumAttackSpeed( MINIMUM_ATTACK_SPEED )
    mode:SetStashPurchasingDisabled(true)

    for rune, spawn in pairs(ENABLED_RUNES) do
      mode:SetRuneEnabled(rune, false)
    end

    mode:SetUnseenFogOfWarEnabled(USE_UNSEEN_FOG_OF_WAR)

    mode:SetDaynightCycleDisabled(false)
    mode:SetKillingSpreeAnnouncerDisabled(true)
    --mode:SetStickyItemDisabled( DISABLE_STICKY_ITEM )

		mode:SetModifyExperienceFilter(
			function(ctx, event)
				return false
			end
		, self)

		mode:SetModifyGoldFilter(
			function(ctx, event)
				if event.reason_const == 18 then
					return true
				end
				return false
			end
		, self)

		mode:SetItemAddedToInventoryFilter(
			function(ctx, event)
				local unit = EntIndexToHScript(event.inventory_parent_entindex_const)
				local item = EntIndexToHScript(event.item_entindex_const)

				if item:GetName() == "item_branch_green" then item:SetCombineLocked(true) end
				if item:GetName() == "item_branch_red" then item:SetCombineLocked(true) end
				if item:GetName() == "item_branch_blue" then item:SetCombineLocked(true) end
				if item:GetName() == "item_branch_yellow" then item:SetCombineLocked(true) end

				return true
			end
		, self)

    mode:SetTrackingProjectileFilter(
      function(ctx, event)
				local source = EntIndexToHScript(event.entindex_source_const)
				local target = EntIndexToHScript(event.entindex_target_const)
				local ability = EntIndexToHScript(event.entindex_ability_const)

        if source ~= nil then
          local lawbreaker_form = source:FindModifierByName("lawbreaker_u_modifier_form")
          local gunslinger = source:FindAbilityByName("muerta_gunslinger")
          if lawbreaker_form and gunslinger then
            if gunslinger:GetCurrentAbilityCharges() == 1 then
              gunslinger:SetCurrentAbilityCharges(0)
              gunslinger:SetLevel(1)

              ProjectileManager:CreateTrackingProjectile({
                Target = target,
                Source = source,
                Ability = lawbreaker_form:GetAbility(),
                EffectName = lawbreaker_form:GetModifierProjectileName(),
                iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2,
                iMoveSpeed = source:GetProjectileSpeed(),
                bReplaceExisting = false,
                bProvidesVision = false,
                iVisionRadius = 75,
                iVisionTeamNumber = source:GetTeamNumber(),
                bDodgeable = false
              })

              return false
            end
          end
        end

				return true
			end
    , self)


    self:OnFirstPlayerLoaded()
  end 
end