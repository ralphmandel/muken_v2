lawbreaker_1__dual_rank_11 = class ({})
lawbreaker_1__dual_rank_12 = class ({})
lawbreaker_1__dual_rank_21 = class ({})
lawbreaker_1__dual_rank_22 = class ({})
lawbreaker_1__dual_rank_31 = class ({})
lawbreaker_1__dual_rank_32 = class ({})

lawbreaker_2__combo_rank_11 = class ({})
lawbreaker_2__combo_rank_12 = class ({})
lawbreaker_2__combo_rank_21 = class ({})
lawbreaker_2__combo_rank_22 = class ({})
lawbreaker_2__combo_rank_31 = class ({})
lawbreaker_2__combo_rank_32 = class ({})

lawbreaker_3__grenade_rank_11 = class ({})
lawbreaker_3__grenade_rank_12 = class ({})
lawbreaker_3__grenade_rank_21 = class ({})
lawbreaker_3__grenade_rank_22 = class ({})
lawbreaker_3__grenade_rank_31 = class ({})
lawbreaker_3__grenade_rank_32 = class ({})

lawbreaker_4__rain_rank_11 = class ({})
lawbreaker_4__rain_rank_12 = class ({})
lawbreaker_4__rain_rank_21 = class ({})
lawbreaker_4__rain_rank_22 = class ({})
lawbreaker_4__rain_rank_31 = class ({})
lawbreaker_4__rain_rank_32 = class ({})

lawbreaker_5__blink_rank_11 = class ({})
lawbreaker_5__blink_rank_12 = class ({})
lawbreaker_5__blink_rank_21 = class ({})
lawbreaker_5__blink_rank_22 = class ({})
lawbreaker_5__blink_rank_31 = class ({})
lawbreaker_5__blink_rank_32 = class ({})

lawbreaker_u__form_rank_11 = class ({})
lawbreaker_u__form_rank_12 = class ({})
lawbreaker_u__form_rank_21 = class ({})
lawbreaker_u__form_rank_22 = class ({})
lawbreaker_u__form_rank_31 = class ({})
lawbreaker_u__form_rank_32 = class ({})

lawbreaker__precache = class ({})
LinkLuaModifier("lawbreaker_special_values", "heroes/death/lawbreaker/lawbreaker-special_values", LUA_MODIFIER_MOTION_NONE)

function lawbreaker__precache:GetIntrinsicModifierName()
  return "lawbreaker_special_values"
end

function lawbreaker__precache:Spawn()
	if self:IsTrained() == false then self:UpgradeAbility(true) end
end

function lawbreaker__precache:Precache(context)
  PrecacheResource("model", "models/heroes/muerta/muerta_armor.vmdl", context)
  PrecacheResource("model", "models/heroes/muerta/muerta_back.vmdl", context)
  PrecacheResource("model", "models/heroes/muerta/muerta_head.vmdl", context)
  PrecacheResource("model", "models/heroes/muerta/muerta_weapons.vmdl", context)

  PrecacheResource( "particle", "particles/units/heroes/hero_muerta/muerta_weapon_primary_ambient.vpcf", context )
  PrecacheResource( "particle", "particles/lawbreaker/lawbreaker_skill2_bullets.vpcf", context )
  PrecacheResource( "particle", "particles/lawbreaker/shots_count/lawbreaker_shots_overhead.vpcf", context )
  PrecacheResource( "particle", "particles/econ/items/windrunner/windranger_arcana/windranger_arcana_ambient.vpcf", context )
  PrecacheResource( "particle", "particles/lawbreaker/grenade/lawbreaker_grenade_model.vpcf", context )
  PrecacheResource( "particle", "particles/lawbreaker/grenade/lawbreaker_grenade_slow.vpcf", context )
  PrecacheResource( "particle", "particles/lawbreaker/rain_launch/lawbreaker_rain_launch.vpcf", context )
  PrecacheResource( "particle", "particles/lawbreaker/rain/lawbreaker_rain.vpcf", context )
  PrecacheResource( "particle", "particles/lawbreaker/blink/lawbreaker_blink_start.vpcf", context )
  PrecacheResource( "particle", "particles/lawbreaker/blink/lawbreaker_blink_end.vpcf", context )
  PrecacheResource( "particle", "particles/units/heroes/hero_muerta/muerta_ultimate_projectile.vpcf", context )
  PrecacheResource( "particle", "particles/units/heroes/hero_muerta/muerta_ultimate_form_ethereal.vpcf", context )
  PrecacheResource( "particle", "particles/units/heroes/hero_muerta/muerta_ultimate_form_screen_effect.vpcf", context )
  PrecacheResource( "particle", "particles/units/heroes/hero_muerta/muerta_ultimate_form_finish.vpcf", context )
  PrecacheResource( "particle", "particles/units/heroes/hero_muerta/muerta_gunslinger.vpcf", context )
end