templar_1__shield_rank_11 = class ({})
templar_1__shield_rank_12 = class ({})
templar_1__shield_rank_21 = class ({})
templar_1__shield_rank_22 = class ({})
templar_1__shield_rank_31 = class ({})
templar_1__shield_rank_32 = class ({})
templar_1__shield_rank_41 = class ({})
templar_1__shield_rank_42 = class ({})

templar_2__barrier_rank_11 = class ({})
templar_2__barrier_rank_12 = class ({})
templar_2__barrier_rank_21 = class ({})
templar_2__barrier_rank_22 = class ({})
templar_2__barrier_rank_31 = class ({})
templar_2__barrier_rank_32 = class ({})
templar_2__barrier_rank_41 = class ({})
templar_2__barrier_rank_42 = class ({})

templar_3__circle_rank_11 = class ({})
templar_3__circle_rank_12 = class ({})
templar_3__circle_rank_21 = class ({})
templar_3__circle_rank_22 = class ({})
templar_3__circle_rank_31 = class ({})
templar_3__circle_rank_32 = class ({})
templar_3__circle_rank_41 = class ({})
templar_3__circle_rank_42 = class ({})

templar_4__hammer_rank_11 = class ({})
templar_4__hammer_rank_12 = class ({})
templar_4__hammer_rank_21 = class ({})
templar_4__hammer_rank_22 = class ({})
templar_4__hammer_rank_31 = class ({})
templar_4__hammer_rank_32 = class ({})
templar_4__hammer_rank_41 = class ({})
templar_4__hammer_rank_42 = class ({})

templar_5__reborn_rank_11 = class ({})
templar_5__reborn_rank_12 = class ({})
templar_5__reborn_rank_21 = class ({})
templar_5__reborn_rank_22 = class ({})
templar_5__reborn_rank_31 = class ({})
templar_5__reborn_rank_32 = class ({})
templar_5__reborn_rank_41 = class ({})
templar_5__reborn_rank_42 = class ({})

templar_u__praise_rank_11 = class ({})
templar_u__praise_rank_12 = class ({})
templar_u__praise_rank_21 = class ({})
templar_u__praise_rank_22 = class ({})
templar_u__praise_rank_31 = class ({})
templar_u__praise_rank_32 = class ({})
templar_u__praise_rank_41 = class ({})
templar_u__praise_rank_42 = class ({})

templar__precache = class ({})
LinkLuaModifier("templar_special_values", "heroes/sun/templar/templar-special_values", LUA_MODIFIER_MOTION_NONE)

function templar__precache:GetIntrinsicModifierName()
  return "templar_special_values"
end

function templar__precache:Spawn()
	if self:IsTrained() == false then self:UpgradeAbility(true) end
end

function templar__precache:Precache(context)
  PrecacheResource("model", "models/items/omniknight/light_hammer/mesh/light_hammer_model.vmdl", context)
  PrecacheResource("model", "models/heroes/omniknight/head.vmdl", context)
  PrecacheResource("model", "models/items/omniknight/light_helmet/light_helmet.vmdl", context)
  PrecacheResource("model", "models/items/omniknight/the_unbroken_knight_back/the_unbroken_knight_back.vmdl", context)
  PrecacheResource("model", "models/items/omniknight/omni_fall20_immortal_shoulders/omni_fall20_immortal_shoulders.vmdl", context)
  PrecacheResource("model", "models/items/omniknight/omni_2021_immortal_arms/omni_2021_immortal_arms.vmdl", context)

  PrecacheResource("particle", "particles/econ/items/omniknight/hammer_ti6_immortal/omniknight_hammer_ambient.vpcf", context)
  PrecacheResource("particle", "particles/econ/items/omniknight/omni_ti8_head/omni_ti8_head_ambient.vpcf", context)
  PrecacheResource("particle", "particles/econ/items/omniknight/omniknight_fall20_immortal/omniknight_fall20_immortal_shoulder_ambient.vpcf", context)
  PrecacheResource("particle", "particles/econ/items/omniknight/omni_2021_immortal/omni_2021_immortal_arms_ambient.vpcf", context)
  PrecacheResource("particle", "particles/dasdingo/dasdingo_aura.vpcf", context)
  PrecacheResource("particle", "particles/units/heroes/hero_omniknight/omniknight_guardian_angel_halo_buff.vpcf", context)
  PrecacheResource("particle", "particles/econ/items/omniknight/omni_2021_immortal/omni_2021_immortal.vpcf", context)
  PrecacheResource("particle", "particles/templar/circle/templar_circle_pit_pre.vpcf", context)
  PrecacheResource("particle", "particles/templar/circle/templar_circle_pit.vpcf", context)
  PrecacheResource("particle", "particles/econ/items/omniknight/omniknight_fall20_immortal/omniknight_fall20_immortal_degen_aura_debuff.vpcf", context)
  PrecacheResource("particle", "particles/econ/items/omniknight/omni_crimson_witness_2021/omniknight_crimson_witness_2021_degen_aura_debuff.vpcf", context)
  PrecacheResource("particle", "particles/units/heroes/hero_omniknight/omniknight_hammer_of_purity_projectile.vpcf", context)
  PrecacheResource("particle", "particles/units/heroes/hero_omniknight/omniknight_shard_hammer_of_purity_overhead_debuff.vpcf", context)
  PrecacheResource("particle", "particles/units/heroes/hero_omniknight/omniknight_shard_hammer_of_purity_target.vpcf", context)
  PrecacheResource("particle", "particles/items_fx/aegis_respawn_timer.vpcf", context)
  PrecacheResource("particle", "particles/econ/events/ti10/aegis_lvl_1000_ambient_ti10.vpcf", context)
  PrecacheResource("particle", "particles/status_fx/status_effect_shield_rune.vpcf", context)
  PrecacheResource("particle", "particles/econ/items/luna/luna_lucent_ti5_gold/luna_eclipse_cast_moonfall_gold.vpcf", context)
  PrecacheResource("particle", "particles/bioshadow/bioshadow_poison_hit_shake.vpcf", context)
  PrecacheResource("particle", "particles/econ/items/luna/luna_lucent_ti5_gold/luna_eclipse_impact_notarget_moonfall_gold.vpcf", context)
  PrecacheResource("particle", "particles/units/heroes/hero_dawnbreaker/dawnbreaker_solar_guardian_beam_shaft.vpcf", context)
end