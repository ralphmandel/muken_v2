fleaman_1__precision_rank_11 = class ({})
fleaman_1__precision_rank_12 = class ({})
fleaman_1__precision_rank_21 = class ({})
fleaman_1__precision_rank_22 = class ({})
fleaman_1__precision_rank_31 = class ({})
fleaman_1__precision_rank_32 = class ({})

fleaman_2__speed_rank_11 = class ({})
fleaman_2__speed_rank_12 = class ({})
fleaman_2__speed_rank_21 = class ({})
fleaman_2__speed_rank_22 = class ({})
fleaman_2__speed_rank_31 = class ({})
fleaman_2__speed_rank_32 = class ({})

fleaman_3__jump_rank_11 = class ({})
fleaman_3__jump_rank_12 = class ({})
fleaman_3__jump_rank_21 = class ({})
fleaman_3__jump_rank_22 = class ({})
fleaman_3__jump_rank_31 = class ({})
fleaman_3__jump_rank_32 = class ({})

fleaman_4__strip_rank_11 = class ({})
fleaman_4__strip_rank_12 = class ({})
fleaman_4__strip_rank_21 = class ({})
fleaman_4__strip_rank_22 = class ({})
fleaman_4__strip_rank_31 = class ({})
fleaman_4__strip_rank_32 = class ({})

fleaman_5__smoke_rank_11 = class ({})
fleaman_5__smoke_rank_12 = class ({})
fleaman_5__smoke_rank_21 = class ({})
fleaman_5__smoke_rank_22 = class ({})
fleaman_5__smoke_rank_31 = class ({})
fleaman_5__smoke_rank_32 = class ({})

fleaman_u__steal_rank_11 = class ({})
fleaman_u__steal_rank_12 = class ({})
fleaman_u__steal_rank_21 = class ({})
fleaman_u__steal_rank_22 = class ({})
fleaman_u__steal_rank_31 = class ({})
fleaman_u__steal_rank_32 = class ({})

fleaman__precache = class ({})
LinkLuaModifier("fleaman_special_values", "heroes/death/fleaman/fleaman-special_values", LUA_MODIFIER_MOTION_NONE)

function fleaman__precache:GetIntrinsicModifierName()
  return "fleaman_special_values"
end

function fleaman__precache:Spawn()
	if self:IsTrained() == false then self:UpgradeAbility(true) end
end

function fleaman__precache:Precache(context)
  PrecacheResource( "model", "models/items/slark/hydrakan_latch/mesh/hydrkan_latch_model.vmdl", context )
  PrecacheResource( "model", "models/items/slark/slark_head_immortal/slark_head_immortal.vmdl", context )
  PrecacheResource( "model", "models/items/slark/dplus_shadow_of_the_dark_reef_shoulder/dplus_shadow_of_the_dark_reef_shoulder.vmdl", context )
  PrecacheResource( "model", "models/items/slark/dplus_shadow_of_the_dark_reef_back/dplus_shadow_of_the_dark_reef_back.vmdl", context )
  PrecacheResource( "model", "models/items/slark/dplus_shadow_of_the_dark_reef_arms/dplus_shadow_of_the_dark_reef_arms.vmdl", context )

  PrecacheResource( "particle", "particles/fleaman/fleaman_precision.vpcf", context )
  PrecacheResource( "particle", "particles/status_fx/status_effect_slark_shadow_dance.vpcf", context )
  PrecacheResource( "particle", "particles/econ/items/slark/slark_ti6_blade/slark_ti6_pounce_ground.vpcf", context )
  PrecacheResource( "particle", "particles/econ/items/slark/slark_ti6_blade/slark_ti6_pounce_trail.vpcf", context )
  PrecacheResource( "particle", "particles/econ/items/slark/slark_ti6_blade/slark_ti6_pounce_start.vpcf", context )
  PrecacheResource( "particle", "particles/units/heroes/hero_riki/riki_backstab.vpcf", context )
  PrecacheResource( "particle", "particles/items3_fx/star_emblem.vpcf", context )
  PrecacheResource( "particle", "particles/items_fx/abyssal_blink_end.vpcf", context )
  PrecacheResource( "particle", "particles/items_fx/abyssal_blink_start.vpcf", context )
  PrecacheResource( "particle", "particles/econ/items/slark/slark_ti6_blade/slark_ti6_blade_essence_shift.vpcf", context )
  PrecacheResource( "particle", "particles/units/heroes/hero_slark/slark_shadow_dance.vpcf", context )
  PrecacheResource( "particle", "particles/units/heroes/hero_slark/slark_shadow_dance_dummy.vpcf", context )
  PrecacheResource( "particle", "particles/fleaman/smoke/fleaman_smoke.vpcf", context )
  PrecacheResource( "particle", "particles/units/heroes/hero_zuus/zuus_arc_lightning_.vpcf", context )
  PrecacheResource( "particle", "particles/econ/items/slark/slark_ti6_blade/slark_ti6_blade_ambient.vpcf", context )
  PrecacheResource( "particle", "particles/econ/items/slark/slark_head_immortal/slark_head_immortal_ambient.vpcf", context )
  PrecacheResource( "particle", "particles/econ/items/slark/slark_head_immortal/slark_immortal_dark_pact_pulses.vpcf", context )
end