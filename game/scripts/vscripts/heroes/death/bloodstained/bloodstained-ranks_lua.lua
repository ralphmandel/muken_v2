bloodstained__precache = class ({})
LinkLuaModifier("bloodstained_special_values", "heroes/death/bloodstained/bloodstained-special_values", LUA_MODIFIER_MOTION_NONE)

function bloodstained__precache:GetIntrinsicModifierName()
  return "bloodstained_special_values"
end

function bloodstained__precache:Spawn()
  if IsServer() then
    if self:IsTrained() == false then
      self:UpgradeAbility(true)
    end
  end
end

function bloodstained__precache:Precache(context)
  PrecacheResource( "model", "models/items/shadow_demon/mantle_of_the_shadow_demon_belt/mantle_of_the_shadow_demon_belt.vmdl", context )
  PrecacheResource( "model", "models/items/shadow_demon/sd_crown_of_the_nightworld_tail/sd_crown_of_the_nightworld_tail.vmdl", context )
  PrecacheResource( "model", "models/items/shadow_demon/ti7_immortal_back/sd_ti7_immortal_back.vmdl", context )
  PrecacheResource( "model", "models/items/shadow_demon/sd_crown_of_the_nightworld_armor/sd_crown_of_the_nightworld_armor.vmdl", context )
  PrecacheResource( "particle", "particles/econ/items/shadow_demon/sd_ti7_shadow_poison/sd_ti7_immortal_ambient.vpcf", context )
  PrecacheResource( "particle", "particles/econ/items/shadow_demon/sd_crown_nightworld/sd_crown_nightworld_armor.vpcf", context )

  PrecacheResource( "particle", "particles/bloodstained/status_efx/status_effect_bloodstained.vpcf", context )
  PrecacheResource( "particle", "particles/econ/items/lifestealer/lifestealer_immortal_backbone/status_effect_life_stealer_immortal_rage.vpcf", context )
  PrecacheResource( "particle", "particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_ignite_debuff.vpcf", context )
  PrecacheResource( "particle", "particles/econ/items/lifestealer/lifestealer_immortal_backbone/status_effect_life_stealer_immortal_rage.vpcf", context )
  PrecacheResource( "particle", "particles/bioshadow/bioshadow_drain.vpcf", context )
  PrecacheResource( "particle", "particles/units/heroes/hero_bloodseeker/bloodseeker_rupture_nuke.vpcf", context )
  PrecacheResource( "particle", "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodbath.vpcf", context )
  PrecacheResource( "particle", "particles/units/heroes/hero_queenofpain/queen_shadow_strike_body.vpcf", context )
  PrecacheResource( "particle", "particles/econ/items/grimstroke/gs_fall20_immortal/gs_fall20_immortal_soulbind.vpcf", context )
  PrecacheResource( "particle", "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodrage.vpcf", context )
  PrecacheResource( "particle", "particles/bloodstained/frenzy/bloodstained_hands_v2.vpcf", context )
  PrecacheResource( "particle", "particles/bloodstained/frenzy/bloodstained_frenzy.vpcf", context )
  PrecacheResource( "particle", "particles/bloodstained/tear/bloodstained_tear_initial.vpcf", context )
  PrecacheResource( "particle", "particles/bloodstained/mist/blood_mist_aoe.vpcf", context )
  PrecacheResource( "particle", "particles/bloodstained/bloodstained_x2_blood.vpcf", context )
  PrecacheResource( "particle", "particles/units/heroes/hero_undying/undying_soul_rip_damage.vpcf", context )
  PrecacheResource( "particle", "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodbath.vpcf", context )
  PrecacheResource( "particle", "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", context )
  PrecacheResource( "particle", "particles/bloodstained/seal_finder_aoe.vpcf", context )
  PrecacheResource( "particle", "particles/bloodstained/bloodstained_thirst_owner_smoke_dark.vpcf", context )
  PrecacheResource( "particle", "particles/bloodstained/bloodstained_u_illusion_status.vpcf", context )
  PrecacheResource( "particle", "particles/units/heroes/hero_bloodseeker/bloodseeker_rupture.vpcf", context )
  PrecacheResource( "particle", "particles/bloodstained/bloodstained_u_track1.vpcf", context )
  PrecacheResource( "particle", "particles/bloodstained/bloodstained_u_bubbles.vpcf", context )
  PrecacheResource( "particle", "particles/bloodstained/bloodstained_field_replica.vpcf", context )
  PrecacheResource( "particle", "particles/bloodstained/bloodstained_seal_impact.vpcf", context )
  PrecacheResource( "particle", "particles/bloodstained/bloodstained_seal_war.vpcf", context )
  PrecacheResource( "particle", "particles/bloodstained/cleave/bloodstained_cleave.vpcf", context )
  PrecacheResource( "particle", "particles/econ/events/ti6/blink_dagger_start_ti6_lvl2.vpcf", context )
  PrecacheResource( "particle", "particles/econ/events/ti6/blink_dagger_end_ti6_lvl2.vpcf", context )
end