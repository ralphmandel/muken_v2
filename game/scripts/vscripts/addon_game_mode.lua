-- This is the entry-point to your game mode and should be used primarily to precache models/particles/sounds/etc

require('internal/util')
require('gamemode')

function Precache( context )
  --[[
  This function is used to precache resources/units/items/abilities that will be needed
  for sure in your game and that will not be precached by hero selection.  When a hero
  is selected from the hero selection screen, the game will precache that hero's assets,
  any equipped cosmetics, and perform the data-driven precaching defined in that hero's
  precache{} block, as well as the precache{} block for any equipped abilities.

  See GameMode:PostLoadPrecache() in gamemode.lua for more information
  ]]

  DebugPrint("[BAREBONES] Performing pre-load precache")

  -- Particles can be precached individually or by folder
    -- It it likely that precaching a single particle system will precache all of its children, but this may not be guaranteed
    --PrecacheResource("particle_folder", "particles/test_particle", context)
    PrecacheResource( "particle", "particles/econ/items/silencer/silencer_ti6/silencer_last_word_ti6_silence.vpcf", context)
    PrecacheResource( "particle", "particles/items_fx/black_king_bar_avatar.vpcf", context)
    PrecacheResource( "particle", "particles/status_fx/status_effect_medusa_stone_gaze.vpcf", context)
    PrecacheResource( "particle", "particles/units/heroes/hero_medusa/medusa_stone_gaze_debuff_stoned.vpcf", context)
    PrecacheResource( "particle", "particles/osiris/poison_alt/osiris_poison_splash_shake.vpcf", context)
    PrecacheResource( "particle", "particles/units/heroes/hero_snapfire/hero_snapfire_disarm.vpcf", context)
    PrecacheResource( "particle", "particles/econ/items/techies/techies_arcana/techies_suicide_kills_arcana.vpcf", context )
    PrecacheResource( "particle", "particles/items_fx/blademail.vpcf", context )
    PrecacheResource( "particle", "particles/bocuse/bocuse_msg.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodritual_impact.vpcf", context )
    PrecacheResource( "particle", "particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodbath_eztzhok.vpcf", context )
    PrecacheResource( "particle", "particles/econ/items/bloodseeker/bloodseeker_ti7/bloodseeker_ti7_thirst_owner.vpcf", context )
    PrecacheResource( "particle", "particles/econ/wards/ti8_ward/ti8_ward_true_sight_ambient.vpcf", context )
    PrecacheResource( "particle", "particles/basics/silence.vpcf", context )
    PrecacheResource( "particle", "particles/basics/silence__red.vpcf", context )
    PrecacheResource( "particle", "particles/basics/restrict.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_pudge/pudge_fleshheap_count.vpcf", context )
    PrecacheResource( "particle", "particles/items2_fx/teleport_start.vpcf", context )
    PrecacheResource( "particle", "particles/items2_fx/teleport_end.vpcf", context )
    PrecacheResource( "particle", "particles/msg_fx/msg_heal.vpcf", context )
    PrecacheResource( "particle", "particles/msg_fx/msg_gold.vpcf", context )
    PrecacheResource( "particle", "particles/msg_fx/msg_crit.vpcf", context )
    PrecacheResource( "particle", "particles/msg_fx/msg_blocked.vpcf", context )
    PrecacheResource( "particle", "particles/generic/give_mana.vpcf", context )
    PrecacheResource( "particle", "particles/generic_gameplay/generic_stunned.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_alchemist/alchemist_acid_spray_debuff.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_alchemist/alchemist_acid_spray.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_mars/mars_spear_impact_debuff.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_phantom_assassin/phantom_assassin_blur.vpcf", context )
    PrecacheResource( "particle", "particles/econ/items/omniknight/omni_ti8_head/omniknight_repel_buff_ti8.vpcf", context )
    PrecacheResource( "particle", "particles/econ/items/gyrocopter/gyro_ti10_immortal_missile/gyro_ti10_immortal_missile_explosion.vpcf", context )
    PrecacheResource( "particle", "particles/econ/items/sven/sven_warcry_ti5/sven_warcry_cast_arc_lightning_impact.vpcf", context )
    PrecacheResource( "particle", "particles/status_fx/status_effect_combo_breaker.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_centaur/centaur_double_edge.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_treant/treant_bramble_root.vpcf", context )
    PrecacheResource( "particle", "particles/econ/items/dark_willow/dark_willow_chakram_immortal/dark_willow_chakram_immortal_bramble_root.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/heroes_underlord/abyssal_underlord_pitofmalice_stun.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_treant/treant_overgrowth_vines_small.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_treant/treant_overgrowth_vines.vpcf", context )
    PrecacheResource( "particle", "particles/econ/items/lone_druid/lone_druid_cauldron_retro/lone_druid_bear_entangle_retro_cauldron.vpcf", context )
    PrecacheResource( "particle", "particles/econ/items/alchemist/alchemist_aurelian_weapon/alchemist_chemical_rage_aurelian.vpcf", context )
    PrecacheResource( "particle", "particles/status_fx/status_effect_life_stealer_rage.vpcf", context )
    PrecacheResource( "particle", "particles/druid/druid_ult_projectile.vpcf", context )
    PrecacheResource( "particle", "particles/econ/items/centaur/centaur_ti6/centaur_ti6_warstomp.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_dragon_knight/dragon_knight_dragon_tail_dragonform_proj.vpcf", context )
    PrecacheResource( "particle", "particles/econ/events/ti7/fountain_regen_ti7_lvl3.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_alchemist/alchemist_acid_spray_debuff.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_alchemist/alchemist_acid_spray.vpcf", context )
    PrecacheResource( "particle", "particles/econ/items/warlock/warlock_hellsworn_construct/golem_hellsworn_ambient.vpcf", context )
    PrecacheResource( "particle", "particles/items_fx/abyssal_blink_start.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_doom_bringer/doom_bringer_doom.vpcf", context )
    PrecacheResource( "particle", "particles/status_fx/status_effect_doom.vpcf", context )
    PrecacheResource( "particle", "particles/items3_fx/octarine_core_lifesteal.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_oracle/oracle_fortune_purge.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_ancient_apparition/ancient_apparition_chilling_touch_projectile.vpcf", context )
    PrecacheResource( "particle", "particles/econ/items/lifestealer/lifestealer_immortal_backbone/status_effect_life_stealer_immortal_rage.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_ursa/ursa_enrage_buff.vpcf", context )
    PrecacheResource( "particle", "particles/neutral_fx/ogre_bruiser_smash.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_windrunner/windrunner_windrun.vpc", context )
    PrecacheResource( "particle", "particles/econ/items/visage/immortal_familiar/visage_immortal_ti5/visage_familiar_base_attack_ti5.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_crystalmaiden/maiden_base_attack.vpcf", context )

  -- Models can also be precached by folder or individually
    -- PrecacheModel should generally used over PrecacheResource for individual models
    --PrecacheResource("model_folder", "particles/heroes/antimage", context)
    --PrecacheModel("models/props_gameplay/treasure_chest001.vmdl", context)
    --PrecacheModel("models/props_debris/merchant_debris_chest001.vmdl", context)
    --PrecacheModel("models/props_debris/merchant_debris_chest002.vmdl", context)
    PrecacheResource( "model", "models/items/warlock/golem/hellsworn_golem/hellsworn_golem.vmdl", context )
    PrecacheResource( "model", "models/creeps/lane_creeps/creep_radiant_ranged/radiant_ranged_crystal.vmdl", context )
    PrecacheResource( "model", "models/creeps/ice_biome/frostbitten/n_creep_frostbitten_swollen01.vmdl", context )
    PrecacheResource( "model", "models/creeps/lane_creeps/ti9_crocodilian_dire/ti9_crocodilian_dire_ranged_mega.vmdl", context )
    PrecacheResource( "model", "models/creeps/neutral_creeps/n_creep_eimermole/n_creep_eimermole.vmdl", context )
    PrecacheResource( "model", "models/creeps/neutral_creeps/n_creep_eimermole/n_creep_eimermole_lamp.vmdl", context )
    PrecacheResource( "model", "models/items/broodmother/spiderling/elder_blood_heir_of_elder_blood/elder_blood_heir_of_elder_blood.vmdl", context )
    PrecacheResource( "model", "models/items/broodmother/spiderling/dplus_malevolent_mother_malevoling/dplus_malevolent_mother_malevoling.vmdl", context )
    PrecacheResource( "model", "models/creeps/neutral_creeps/n_creep_dragonspawn_a/n_creep_dragonspawn_a.vmdl", context )
    PrecacheResource( "model", "models/creeps/neutral_creeps/n_creep_dragonspawn_b/n_creep_dragonspawn_b.vmdl", context )
    PrecacheResource( "model", "models/creeps/lane_creeps/ti9_chameleon_radiant/ti9_chameleon_radiant_melee_mega.vmdl", context )
    PrecacheResource( "model", "models/creeps/lane_creeps/ti9_chameleon_radiant/ti9_chameleon_radiant_melee.vmdl", context )
    PrecacheResource( "model", "models/creeps/lane_creeps/ti9_crocodilian_dire/ti9_crocodilian_dire_melee_mega.vmdl", context )
    PrecacheResource( "model", "models/creeps/lane_creeps/ti9_crocodilian_dire/ti9_crocodilian_dire_melee.vmdl", context )
    PrecacheResource( "model", "models/creeps/neutral_creeps/n_creep_black_dragon/n_creep_black_dragon.vmdl", context )
    PrecacheResource( "model", "models/creeps/neutral_creeps/n_creep_black_drake/n_creep_black_drake.vmdl", context )
    PrecacheResource( "model", "models/heroes/dragon_knight/dragon_knight_dragon.vmdl", context )
    PrecacheResource( "model", "models/items/wraith_king/frostivus_wraith_king/frostivus_wraith_king_skeleton.vmdl", context )
    PrecacheResource( "model", "models/items/lone_druid/bear/tarzan_and_kingkong_spirit/tarzan_and_kingkong_spirit.vmdl", context )
    PrecacheResource( "model", "models/props_structures/good_fountain001.vmdl", context )
    PrecacheResource( "model", "models/props_gameplay/rune_goldxp.vmdl", context )

  -- Sounds can precached here like anything else
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_axe.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_broodmother.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_lone_druid.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_meepo.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_shadowshaman.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_shadow_demon.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_ogre_magi.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_skywrath_mage.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_alchemist.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_snapfire.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_clinkz.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_pudge.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_viper.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_sniper.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_brewmaster.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_marci.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_crystalmaiden.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_queenofpain.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_phantom_assassin.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_doombringer.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_drowranger.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_lina.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_death_prophet.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_terrorblade.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_centaur.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_ursa.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_undying.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_leshrac.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_legion_commander.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_dawnbreaker.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_abaddon.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_lycan.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_lone_druid.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_dazzle.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_mirana.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_life_stealer.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_dark_willow.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_medusa.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_chen.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_luna.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_invoker.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_lich.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_sven.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_antimage.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_puck.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_tiny.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_pangolier.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_spirit_breaker.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_void_spirit.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_necrolyte.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_nevermore.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_slardar.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_slark.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_techies.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_grimstroke.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_batrider.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_dark_seer.vsndevts", context ) 
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_bane.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_warlock.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_winter_wyvern.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_wisp.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_rubick.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_lion.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_enigma.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_huskar.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_monkey_king.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_leshrac.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_abyssal_underlord.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_earthshaker.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_earth_spirit.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_ancient_apparition.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_bounty_hunter.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_zuus.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_templar_assassin.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_stormspirit.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_nightstalker.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_venomancer.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_magnataur.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_visage.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_bloodseeker.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_ember_spirit.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_bristleback.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/voscripts/game_sounds_vo_night_stalker.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_skeletonking.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_juggernaut.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_enchantress.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_faceless_void.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_phoenix.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_chaos_knight.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_elder_titan.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_spectre.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_riki.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_shredder.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_oracle.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_rattletrap.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_windrunner.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_pugna.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_furion.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_omniknight.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_keeper_of_the_light.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_mars.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_treant.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_witchdoctor.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_sandking.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_muerta.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_arc_warden.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_dragon_knight.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_beastmaster.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_primal_beast.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/voscripts/game_sounds_vo_announcer_killing_spree.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/soundevent_vo.vsndevts", context)
    PrecacheResource( "soundfile", "soundevents/soundevent_muken_items.vsndevts", context)
    PrecacheResource( "soundfile", "soundevents/soundevent_muken_config.vsndevts", context)
    PrecacheResource( "soundfile", "soundevents/soundevent_muken_generics.vsndevts", context)
    PrecacheResource( "soundfile", "soundevents/soundevent_bloodstained.vsndevts", context)
    PrecacheResource( "soundfile", "soundevents/soundevent_bocuse.vsndevts", context)
    PrecacheResource( "soundfile", "soundevents/soundevent_fleaman.vsndevts", context)
    PrecacheResource( "soundfile", "soundevents/soundevent_genuine.vsndevts", context)
    PrecacheResource( "soundfile", "soundevents/soundevent_icebreaker.vsndevts", context)
    PrecacheResource( "soundfile", "soundevents/soundevent_dasdingo.vsndevts", context)
    PrecacheResource( "soundfile", "soundevents/soundevent_druid.vsndevts", context)
    PrecacheResource( "soundfile", "soundevents/soundevent_ancient.vsndevts", context)
    PrecacheResource( "soundfile", "soundevents/soundevent_hunter.vsndevts", context)
    PrecacheResource( "soundfile", "soundevents/soundevent_paladin.vsndevts", context)
    PrecacheResource( "soundfile", "soundevents/soundevent_templar.vsndevts", context)
    PrecacheResource( "soundfile", "soundevents/soundevent_baldur.vsndevts", context)
    PrecacheResource( "soundfile", "soundevents/soundevent_trickster.vsndevts", context)
    PrecacheResource( "soundfile", "soundevents/soundevent_strider.vsndevts", context)
    PrecacheResource( "soundfile", "soundevents/game_sounds_items.vsndevts", context)

  -- Entire items can be precached by name
    -- Abilities can also be precached in this way despite the name
    PrecacheItemByNameSync("example_ability", context)
    PrecacheItemByNameSync("item_example_item", context)

  -- Entire heroes (sound effects/voice/models/particles) can be precached with PrecacheUnitByNameSync
    -- Custom units from npc_units_custom.txt can also have all of their abilities and precache{} blocks precached in this way
    PrecacheUnitByNameSync("npc_dota_hero_ancient_apparition", context)
    PrecacheUnitByNameSync("npc_dota_hero_enigma", context)
end

-- Create the game mode when we activate
function Activate()
  GameRules.GameMode = GameMode()
  GameRules.GameMode:_InitGameMode()
end