-- In this file you can set up all the properties and settings for your game mode.


ENABLE_HERO_RESPAWN = true              -- Should the heroes automatically respawn on a timer or stay dead until manually respawned
UNIVERSAL_SHOP_MODE = false             -- Should the main shop contain Secret Shop items as well as regular items
ALLOW_SAME_HERO_SELECTION = true        -- Should we let people select the same hero as each other

HERO_SELECTION_TIME = 9000.0              -- How long should we let people select their hero?
PRE_GAME_TIME = 150.0                    -- How long after people select their heroes should the horn blow and the game start?
POST_GAME_TIME = 60.0                   -- How long should we let people look at the scoreboard before closing the server automatically?
TREE_REGROW_TIME = 60.0                 -- How long should it take individual trees to respawn after being cut down/destroyed?

GOLD_PER_TICK = 100                     -- How much gold should players get per tick?
GOLD_TICK_TIME = 5                      -- How long should we wait in seconds between gold ticks?

RECOMMENDED_BUILDS_DISABLED = false     -- Should we disable the recommened builds for heroes
CAMERA_DISTANCE_OVERRIDE = -1           -- How far out should we allow the camera to go?  Use -1 for the default (1134) while still allowing for panorama camera distance changes

MINIMAP_ICON_SIZE = 1                   -- What icon size should we use for our heroes?
MINIMAP_CREEP_ICON_SIZE = 1             -- What icon size should we use for creeps?
MINIMAP_RUNE_ICON_SIZE = 1              -- What icon size should we use for runes?

RUNE_SPAWN_TIME = 120                   -- How long in seconds should we wait between rune spawns?
CUSTOM_BUYBACK_COST_ENABLED = true      -- Should we use a custom buyback cost setting?
CUSTOM_BUYBACK_COOLDOWN_ENABLED = true  -- Should we use a custom buyback time?
BUYBACK_ENABLED = false                 -- Should we allow people to buyback when they die?

DISABLE_FOG_OF_WAR_ENTIRELY = false     -- Should we disable fog of war entirely for both teams?
USE_UNSEEN_FOG_OF_WAR = false           -- Should we make unseen and fogged areas of the map completely black until uncovered by each team? 
                                            -- Note: DISABLE_FOG_OF_WAR_ENTIRELY must be false for USE_UNSEEN_FOG_OF_WAR to work
USE_STANDARD_DOTA_BOT_THINKING = false  -- Should we have bots act like they would in Dota? (This requires 3 lanes, normal items, etc)
USE_STANDARD_HERO_GOLD_BOUNTY = true    -- Should we give gold for hero kills the same as in Dota, or allow those values to be changed?

USE_CUSTOM_TOP_BAR_VALUES = true        -- Should we do customized top bar values or use the default kill count per team?
TOP_BAR_VISIBLE = true                  -- Should we display the top bar score/count at all?
SHOW_KILLS_ON_TOPBAR = false             -- Should we display kills only on the top bar? (No denies, suicides, kills by neutrals)  Requires USE_CUSTOM_TOP_BAR_VALUES

ENABLE_TOWER_BACKDOOR_PROTECTION = false-- Should we enable backdoor protection for our towers?
REMOVE_ILLUSIONS_ON_DEATH = false       -- Should we remove all illusions if the main hero dies?
DISABLE_GOLD_SOUNDS = false             -- Should we disable the gold sound when players get gold?

END_GAME_ON_KILLS = true                -- Should the game end after a certain number of kills?
KILLS_TO_END_GAME_FOR_TEAM = 50         -- How many kills for a team should signify an end of game?

USE_CUSTOM_HERO_LEVELS = true           -- Should we allow heroes to have custom levels?
MAX_LEVEL = 50                          -- What level should we let heroes get to?
USE_CUSTOM_XP_VALUES = true             -- Should we use custom XP values to level up heroes, or the default Dota numbers?

-- Fill this table up with the required XP per level if you want to change it
XP_PER_LEVEL_TABLE = {}
for i=1,MAX_LEVEL do
  XP_PER_LEVEL_TABLE[i] = (i-1) * 100
end

ENABLE_FIRST_BLOOD = true               -- Should we enable first blood for the first kill in this game?
HIDE_KILL_BANNERS = false               -- Should we hide the kill banners that show when a player is killed?
LOSE_GOLD_ON_DEATH = true               -- Should we have players lose the normal amount of dota gold on death?
SHOW_ONLY_PLAYER_INVENTORY = false      -- Should we only allow players to see their own inventory even when selecting other units?
DISABLE_STASH_PURCHASING = false        -- Should we prevent players from being able to buy items into their stash when not at a shop?
DISABLE_ANNOUNCER = false               -- Should we disable the announcer from working in the game?
FORCE_PICKED_HERO = nil                 -- What hero should we force all players to spawn as? (e.g. "npc_dota_hero_axe").  Use nil to allow players to pick their own hero.

FIXED_RESPAWN_TIME = -1                 -- What time should we use for a fixed respawn timer?  Use -1 to keep the default dota behavior.
FOUNTAIN_CONSTANT_MANA_REGEN = -1       -- What should we use for the constant fountain mana regen?  Use -1 to keep the default dota behavior.
FOUNTAIN_PERCENTAGE_MANA_REGEN = -1     -- What should we use for the percentage fountain mana regen?  Use -1 to keep the default dota behavior.
FOUNTAIN_PERCENTAGE_HEALTH_REGEN = -1   -- What should we use for the percentage fountain health regen?  Use -1 to keep the default dota behavior.
MAXIMUM_ATTACK_SPEED = 600              -- What should we use for the maximum attack speed?
MINIMUM_ATTACK_SPEED = 20               -- What should we use for the minimum attack speed?

GAME_END_DELAY = -1                     -- How long should we wait after the game winner is set to display the victory banner and End Screen?  Use -1 to keep the default (about 10 seconds)
VICTORY_MESSAGE_DURATION = 3            -- How long should we wait after the victory message displays to show the End Screen?  Use 
STARTING_GOLD = 500                     -- How much starting gold should we give to each player?
DISABLE_DAY_NIGHT_CYCLE = false         -- Should we disable the day night cycle from naturally occurring? (Manual adjustment still possible)
DISABLE_KILLING_SPREE_ANNOUNCER = false -- Shuold we disable the killing spree announcer?
DISABLE_STICKY_ITEM = false             -- Should we disable the sticky item button in the quick buy area?
SKIP_TEAM_SETUP = false                 -- Should we skip the team setup entirely?
ENABLE_AUTO_LAUNCH = true               -- Should we automatically have the game complete team setup after AUTO_LAUNCH_DELAY seconds?
AUTO_LAUNCH_DELAY = 30                  -- How long should the default team selection launch timer be?  The default for custom games is 30.  Setting to 0 will skip team selection.
LOCK_TEAM_SETUP = false                 -- Should we lock the teams initially?  Note that the host can still unlock the teams 


-- NOTE: You always need at least 2 non-bounty type runes to be able to spawn or your game will crash!
ENABLED_RUNES = {}                      -- Which runes should be enabled to spawn in our game mode?
ENABLED_RUNES[DOTA_RUNE_DOUBLEDAMAGE] = true
ENABLED_RUNES[DOTA_RUNE_HASTE] = true
ENABLED_RUNES[DOTA_RUNE_ILLUSION] = true
ENABLED_RUNES[DOTA_RUNE_INVISIBILITY] = true
ENABLED_RUNES[DOTA_RUNE_REGENERATION] = true
ENABLED_RUNES[DOTA_RUNE_BOUNTY] = true
ENABLED_RUNES[DOTA_RUNE_ARCANE] = true

MAX_NUMBER_OF_TEAMS = 4                -- How many potential teams can be in this game mode?
USE_CUSTOM_TEAM_COLORS = true           -- Should we use custom team colors?
USE_CUSTOM_TEAM_COLORS_FOR_PLAYERS = true          -- Should we use custom team colors to color the players/minimap?

TEAM_COLORS = {}                        -- If USE_CUSTOM_TEAM_COLORS is set, use these colors.
TEAM_COLORS[DOTA_TEAM_NEUTRALS] = { 204, 204, 204 }  --   
TEAM_COLORS[DOTA_TEAM_CUSTOM_1] = { 172, 0, 32 }  --    
TEAM_COLORS[DOTA_TEAM_CUSTOM_2] = { 61, 210, 150 }   --    
TEAM_COLORS[DOTA_TEAM_CUSTOM_3] = { 140, 42, 244 }   --   
TEAM_COLORS[DOTA_TEAM_CUSTOM_4] = { 199, 228, 13 }  --   
TEAM_COLORS[DOTA_TEAM_CUSTOM_5] = { 66, 133, 244 }  --   
TEAM_COLORS[DOTA_TEAM_CUSTOM_6] = { 189, 66, 251 }  --   
TEAM_COLORS[DOTA_TEAM_CUSTOM_7] = { 251, 204, 66 }  --   
-- TEAM_COLORS[DOTA_TEAM_CUSTOM_1] = { 61, 210, 150 }  --    Teal
-- TEAM_COLORS[DOTA_TEAM_CUSTOM_2] = { 243, 201, 9 }   --    Yellow
-- TEAM_COLORS[DOTA_TEAM_CUSTOM_3] = { 197, 77, 168 }  --    Pink
-- TEAM_COLORS[DOTA_TEAM_CUSTOM_4] = { 255, 108, 0 }   --    Orange
-- TEAM_COLORS[DOTA_TEAM_CUSTOM_5] = { 199, 228, 13 }   --   Olive
-- TEAM_COLORS[DOTA_TEAM_CUSTOM_6] = { 140, 42, 244 }  --    Purple
-- TEAM_COLORS[DOTA_TEAM_CUSTOM_7] = { 129, 83, 54 }   --    Brown
-- TEAM_COLORS[DOTA_TEAM_CUSTOM_8] = { 27, 192, 216 }  --    Cyan
--TEAM_COLORS[DOTA_TEAM_CUSTOM_9] = { 199, 228, 13 }  --    Olive
--TEAM_COLORS[DOTA_TEAM_CUSTOM_10] = { 140, 42, 244 }  --    Purple


USE_AUTOMATIC_PLAYERS_PER_TEAM = false   -- Should we set the number of players to 10 / MAX_NUMBER_OF_TEAMS?

CUSTOM_TEAM_PLAYER_COUNT = {}           -- If we're not automatically setting the number of players per team, use this table
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_1] = 4
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_2] = 4
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_3] = 4
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_4] = 4
-- CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_5] = 1
-- CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_5] = 4
-- CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_6] = 4
-- CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_7] = 4
-- CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_8] = 4

INITIAL_XP = 1 -- LVL 30(MAX): 55300

SCORE_LIMIT = 50
SCORE_KILL = 2
SCORE_DEATH = -1
XP_BOUNTY_MIN = 20
XP_BOUNTY_MAX = 30

BOTS_ENABLED = true
BOTS_ENABLED_TOOLS = false
BOTS_LOADED = false

BOTS = {}

BOT_LIST = {
  "fleaman", "lawbreaker", "bloodstained", "bocuse",
  "genuine", "icebreaker",
  "dasdingo", "hunter",
  "paladin", "templar", "baldur", "ancient"
}

RANDOM_NAMES = {
  [1] = "Jairo, o Jakiro",
  [2] = "Zubumafu",
  [3] = "Gasp.Z",
  [4] = "Martin Gore",
  [5] = "Serluc",
  [6] = "Shirayama",
  [7] = "InStereo4",
  [8] = "UK",
  [9] = "kubo",
  [10] = "Edomic Wolf",
  [11] = "Kazunari",
  [12] = "Do Jun"
}

TEMP_DEL = 0
BOT_STATE_REST = 0
BOT_STATE_AGGRESSIVE = 1
BOT_STATE_FLEE = 2
BOT_STATE_FARMING = 3
BOT_STATE_AGGRESSIVE_FIND_TARGET = 10

RARITY_COMMON = 0
RARITY_RARE = 1
RARITY_EPIC = 2
RARITY_LEGENDARY = 3

TIER_TEAMS = {
  [RARITY_COMMON] = DOTA_TEAM_NEUTRALS,
  [RARITY_RARE] = DOTA_TEAM_CUSTOM_5,
  [RARITY_EPIC] = DOTA_TEAM_CUSTOM_6,
  [RARITY_LEGENDARY] = DOTA_TEAM_CUSTOM_7,
}

MAX_MOB_COUNT_TOTAL = 10
MAX_MOB_COUNT_PER_AREA = 3
MAX_BOSS_COUNT = 1

SPAWNER_MOBS = {
  -- {["rarity"] = RARITY_COMMON, ["tier"] = 1, ["units"] = {
  --   "neutral_legendary_great_lamp"
  -- }},
  -- TIER 1 | 96
    {["rarity"] = RARITY_COMMON, ["tier"] = 1, ["units"] = {
      "neutral_common_chameleon_a", "neutral_common_chameleon_b"
    }}, -- 96 | 43 + 53
    {["rarity"] = RARITY_COMMON, ["tier"] = 1, ["units"] = {
      "neutral_common_crocodilian_a"
    }}, -- 96 | 96
    {["rarity"] = RARITY_COMMON, ["tier"] = 1, ["units"] = {
      "neutral_common_crocodilian_b"
    }}, -- 114 | 114
    {["rarity"] = RARITY_COMMON, ["tier"] = 1, ["units"] = {
      "neutral_common_great_gargoyle"
    }}, -- 79 | 79

  -- TIER 2 | 210
    {["rarity"] = RARITY_COMMON, ["tier"] = 2, ["units"] = {
      "neutral_common_chameleon_a", "neutral_common_chameleon_b",
      "neutral_common_chameleon_a", "neutral_common_chameleon_b"
    }}, -- 192 | 43 + 43 + 53 + 53
    {["rarity"] = RARITY_COMMON, ["tier"] = 2, ["units"] = {
      "neutral_common_crocodilian_a", "neutral_common_crocodilian_b"
    }}, -- 210 | 96 + 114
    {["rarity"] = RARITY_COMMON, ["tier"] = 2, ["units"] = {
      "neutral_common_gargoyle", "neutral_common_gargoyle",
      "neutral_common_great_gargoyle"
    }}, -- 209 | 65 + 65 + 79
    {["rarity"] = RARITY_RARE, ["tier"] = 2, ["units"] = { -- [x1.25]
      "neutral_rare_frostbitten"
    }}, -- 210 | 210 [262 | 262]

  -- TIER 3 | 376
    {["rarity"] = RARITY_COMMON, ["tier"] = 3, ["units"] = {
      "neutral_common_drake"
    }}, -- 376 | 376
    {["rarity"] = RARITY_COMMON, ["tier"] = 3, ["units"] = {
      "neutral_common_crocodilian_b", "neutral_common_crocodilian_b",
      "neutral_common_chameleon_a", "neutral_common_chameleon_b", "neutral_common_chameleon_b"
    }}, -- 377 | 114 + 114 + 43 + 53 + 53
    {["rarity"] = RARITY_RARE, ["tier"] = 3, ["units"] = { -- [x1.25]
      "neutral_rare_crocodile"
    }}, -- 376 | 376 [470 | 470]
    {["rarity"] = RARITY_EPIC, ["tier"] = 3, ["units"] = { -- [x1.5]
      "neutral_epic_igneo", "neutral_epic_igneo"
    }}, -- 366 | 183 + 183 [549 | 274 + 274]

  -- TIER 4 | 595
    {["rarity"] = RARITY_COMMON, ["tier"] = 4, ["units"] = {
      "neutral_common_gargoyle", "neutral_common_great_gargoyle", "neutral_common_great_gargoyle",
      "neutral_common_drake"
    }}, -- 599 | 65 + 79 + 79 + 376
    {["rarity"] = RARITY_RARE, ["tier"] = 4, ["units"] = { -- [x1.25]
      "neutral_rare_skydragon", "neutral_rare_dragon"
    }}, -- 586 | 376 + 210 [ 732 | 470 + 262]
    {["rarity"] = RARITY_EPIC, ["tier"] = 4, ["units"] = { -- [x1.5]
      "neutral_epic_lamp"
    }}, -- 595 | 595 [ 892 | 892]
    {["rarity"] = RARITY_LEGENDARY, ["tier"] = 4, ["units"] = { -- [x1.75]
      "neutral_legendary_great_lamp"
    }}, -- 595 | 595 [ 1,041 | 1,041]

  -- TIER 5 | 866
    {["rarity"] = RARITY_COMMON, ["tier"] = 5, ["units"] = {
      "neutral_common_skeleton"
    }}, -- 866 | 866
    {["rarity"] = RARITY_RARE, ["tier"] = 5, ["units"] = { -- [x1.25]
      "neutral_rare_frostbitten", "neutral_rare_frostbitten",
      "neutral_rare_mage"
    }}, -- 877 | 210 + 210 + 457 [1,095 | 262 + 262 + 571]
    {["rarity"] = RARITY_EPIC, ["tier"] = 5, ["units"] = { -- [x1.5]
      "neutral_epic_great_igneo"
    }}, -- 866 | 866 [1,299 | 1,299]
    {["rarity"] = RARITY_LEGENDARY, ["tier"] = 5, ["units"] = { -- [x1.75]
      "neutral_legendary_spider"
    }}, -- 866 | 866 [1,515 | 1,515]

  -- TIER 6 | 1190
    {["rarity"] = RARITY_COMMON, ["tier"] = 6, ["units"] = {
      "neutral_common_skeleton", "neutral_common_drake", "neutral_common_drake"
    }}, -- 1,242 | 866 + 376
    {["rarity"] = RARITY_RARE, ["tier"] = 6, ["units"] = { -- [x1.25]
      "neutral_rare_crocodile", "neutral_rare_crocodile", "neutral_rare_frostbitten", "neutral_rare_frostbitten"
    }}, -- 1,172 | 376 + 376 + 210 + 210 [1,465 | 470 + 470 + 262 + 262]
    {["rarity"] = RARITY_EPIC, ["tier"] = 6, ["units"] = { -- [x1.5]
      "neutral_epic_lamp", "neutral_epic_lamp"
    }}, -- 1190 | 595 + 595 [ 2,082 | 1,041 + 1,041]
    {["rarity"] = RARITY_LEGENDARY, ["tier"] = 6, ["units"] = { -- [x1.75]
      "neutral_legendary_iron_golem"
    }}, -- 1190 | 1190 [ 2,082 | 2,082]
  }

SPAWNER_SPOTS = {
  ["death"] = {
    [1] = { ["mob"] = {}, ["origin"] = Vector(1043.112671, -2866.549316, 0.000000), ["respawn"] = -90 },
    [2] = { ["mob"] = {}, ["origin"] = Vector(84.746513, -3119.543457, 0.000000), ["respawn"] = -90 },
    [3] = { ["mob"] = {}, ["origin"] = Vector(-1436.207153, -2662.348633, 0.000000), ["respawn"] = -90 },
    [4] = { ["mob"] = {}, ["origin"] = Vector(-806.645142, -1629.660645, 0.000000), ["respawn"] = -90 },
    [5] = { ["mob"] = {}, ["origin"] = Vector(471.747162, -1815.814453, 0.000000), ["respawn"] = -90 },
  },
  ["nature"] = {
    [1] = { ["mob"] = {}, ["origin"] = Vector(-458.524475, 2276.512207, 0.000000), ["respawn"] = -90 },
    [2] = { ["mob"] = {}, ["origin"] = Vector(45.256325, 3225.523682, 0.000000), ["respawn"] = -90 },
    [3] = { ["mob"] = {}, ["origin"] = Vector(291.189697, 864.622437, 0.000000), ["respawn"] = -90 },
    [4] = { ["mob"] = {}, ["origin"] = Vector(1476.522583, 2448.850098, 0.000000), ["respawn"] = -90 },
    [5] = { ["mob"] = {}, ["origin"] = Vector(2758.485596, 1504.205933, 0.000000), ["respawn"] = -90 },
  },
  ["moon"] = {
    [1] = { ["mob"] = {}, ["origin"] = Vector(-3139.694092, 569.087036, 128.000000), ["respawn"] = -90 },
    [2] = { ["mob"] = {}, ["origin"] = Vector(-2075.637939, 1354.958740, 128.000000), ["respawn"] = -90 },
    [3] = { ["mob"] = {}, ["origin"] = Vector(-1075.118896, 180.366470, 128.000000), ["respawn"] = -90 },
    [4] = { ["mob"] = {}, ["origin"] = Vector(-2835.726318, -404.650146, 128.000000), ["respawn"] = -90 },
    [5] = { ["mob"] = {}, ["origin"] = Vector(-1515.097168, -685.532654, 128.000000), ["respawn"] = -90 },
  },
  ["sun"] = {
    [1] = { ["mob"] = {}, ["origin"] = Vector(2889.883301, 605.660278, 128.000000), ["respawn"] = -90 },
    [2] = { ["mob"] = {}, ["origin"] = Vector(1549.846191, 243.432129, 128.000000), ["respawn"] = -90 },
    [3] = { ["mob"] = {}, ["origin"] = Vector(3222.945312, -636.734619, 128.000000), ["respawn"] = -90 },
    [4] = { ["mob"] = {}, ["origin"] = Vector(1954.839600, -894.835815, 128.000000), ["respawn"] = -90 },
    [5] = { ["mob"] = {}, ["origin"] = Vector(2242.126953, -1821.577393, 128.000000), ["respawn"] = -90 },
  }
}

SPAWNER_BOSS_SPOTS = {
  [1] = { ["mob"] = {}, ["origin"] = Vector(-6500, 0, 0), ["respawn"] = -300},
  [2] = { ["mob"] = {}, ["origin"] = Vector(6500, 0, 0), ["respawn"] = -300},
}

PLAYERS = {}
TEAMS = { -- [1] Team, [2] Score, [3] Team Name, [4] number of players, [5] team colour bar  
  [1] = {[1] = DOTA_TEAM_CUSTOM_1, [2] = 0, [3] = "Death Team",  [4] = 0, [5] = "<font color='#ac0020'>", ["fountain_origin"] = Vector(-2550, 3850, 0), ["team_origin"] = Vector(-3215, 3965, 0)},
  [2] = {[1] = DOTA_TEAM_CUSTOM_2, [2] = 0, [3] = "Nature Team",   [4] = 0, [5] = "<font color='#3dd296'>", ["fountain_origin"] = Vector(2550, -3850, 0), ["team_origin"] = Vector(3215, -3965, 0)},
  [3] = {[1] = DOTA_TEAM_CUSTOM_3, [2] = 0, [3] = "Moon Team", [4] = 0, [5] = "<font color='#8c2af4'>", ["fountain_origin"] = Vector(-3850, -2550, 0), ["team_origin"] = Vector(-3965, -3215, 0)},
  [4] = {[1] = DOTA_TEAM_CUSTOM_4, [2] = 0, [3] = "Sun Team", [4] = 0, [5] = "<font color='#c7e40d'>", ["fountain_origin"] = Vector(3850, 2550, 0), ["team_origin"] = Vector(3965, 3215, 0)},
}

TEAM_ORIGIN = {
  [DOTA_TEAM_CUSTOM_1] = Vector(-2730, -2730, 0),
  [DOTA_TEAM_CUSTOM_2] = Vector(2730, 2730, 0),
  [DOTA_TEAM_CUSTOM_3] = Vector(-2730, 2730, 0),
  [DOTA_TEAM_CUSTOM_4] = Vector(2730, -2730, 0),
}

OUTPOST_ORIGIN = {
  [1] = Vector(2145.98, -427.15, 48.1793),
  [2] = Vector(545.975, 2452.85, 48.1793),
  [3] = Vector(-2526.03, 596.85, 57.7422),
  [4] = Vector(-542.025, -2283.15, 16),
}

STATUS_LIST = {
  "status_bar_bleed",
  "status_bar_cold",
  "status_bar_curse"
}

STATUS_OFFSET_HERO = -25
STATUS_OFFSET_CREEP = -10
STATUS_OFFSET_SPACING = -25

HEROES_DATA = {
  ["bloodstained"] = {
    shield_fx_height = 210
  },
  ["fleaman"] = {
    shield_fx_height = 155
  },
  ["strider"] = {
    shield_fx_height = 185
  },
  ["genuine"] = {
    shield_fx_height = 185
  },
  ["paladin"] = {
    shield_fx_height = 215
  },
  ["templar"] = {
    shield_fx_height = 235
  },
}

CYCLE_NIGHT = 0
CYCLE_DAY = 1

BALDUR_CHARGING = 0
BALDUR_READY = 1
BALDUR_READY_NO_MANACOST = 2

GENUINE_TRAVEL_DEFAULT = 2
GENUINE_TRAVEL_ON_ORB = 3
GENUINE_TRAVEL_SUPER_CAST = 5
GENUINE_TRAVEL_POINT_CAST = 7

-- if GetHeroName(self.parent) == "lawbreaker" then size = 185 end
-- if GetHeroName(self.parent) == "bocuse" then size = 210 end
-- if GetHeroName(self.parent) == "vulture" then size = 250 end

-- if GetHeroName(self.parent) == "dasdingo" then size = 175 end
-- if GetHeroName(self.parent) == "druid" then size = 185 end
-- if GetHeroName(self.parent) == "hunter" then size = 165 end

-- if GetHeroName(self.parent) == "icebreaker" then size = 155 end

-- if GetHeroName(self.parent) == "ancient" then size = 250 end
-- if GetHeroName(self.parent) == "baldur" then size = 175 end