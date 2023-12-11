trickster_1__double_rank_11 = class ({})
trickster_1__double_rank_12 = class ({})
trickster_1__double_rank_21 = class ({})
trickster_1__double_rank_22 = class ({})
trickster_1__double_rank_31 = class ({})
trickster_1__double_rank_32 = class ({})

trickster_2__dodge_rank_11 = class ({})
trickster_2__dodge_rank_12 = class ({})
trickster_2__dodge_rank_21 = class ({})
trickster_2__dodge_rank_22 = class ({})
trickster_2__dodge_rank_31 = class ({})
trickster_2__dodge_rank_32 = class ({})

trickster_3__hide_rank_11 = class ({})
trickster_3__hide_rank_12 = class ({})
trickster_3__hide_rank_21 = class ({})
trickster_3__hide_rank_22 = class ({})
trickster_3__hide_rank_31 = class ({})
trickster_3__hide_rank_32 = class ({})

trickster_4__heart_rank_11 = class ({})
trickster_4__heart_rank_12 = class ({})
trickster_4__heart_rank_21 = class ({})
trickster_4__heart_rank_22 = class ({})
trickster_4__heart_rank_31 = class ({})
trickster_4__heart_rank_32 = class ({})

trickster_5__teleport_rank_11 = class ({})
trickster_5__teleport_rank_12 = class ({})
trickster_5__teleport_rank_21 = class ({})
trickster_5__teleport_rank_22 = class ({})
trickster_5__teleport_rank_31 = class ({})
trickster_5__teleport_rank_32 = class ({})

trickster_u__autocast_rank_11 = class ({})
trickster_u__autocast_rank_12 = class ({})
trickster_u__autocast_rank_21 = class ({})
trickster_u__autocast_rank_22 = class ({})
trickster_u__autocast_rank_31 = class ({})
trickster_u__autocast_rank_32 = class ({})

trickster__precache = class ({})
LinkLuaModifier("trickster_special_values", "heroes/moon/trickster/trickster-special_values", LUA_MODIFIER_MOTION_NONE)

function trickster__precache:GetIntrinsicModifierName()
  return "trickster_special_values"
end

function trickster__precache:Spawn()
	if self:IsTrained() == false then self:UpgradeAbility(true) end
end

function trickster__precache:Precache(context)
  PrecacheResource("model", "models/items/pangolier/masked_swordsman_armor/masked_swordsman_armor.vmdl", context)
  PrecacheResource("model", "models/items/pangolier/masked_swordsman_head/masked_swordsman_head.vmdl", context)
  PrecacheResource("model", "models/items/pangolier/masked_swordsman_off_hand/masked_swordsman_off_hand.vmdl", context)
  PrecacheResource("model", "models/items/pangolier/masked_swordsman_weapon/masked_swordsman_weapon.vmdl", context)

  PrecacheResource("particle", "particles/units/heroes/hero_pangolier/pangolier_weapon_ambient.vpcf", context)
  PrecacheResource("particle", "particles/units/heroes/hero_riki/riki_backstab.vpcf", context)
  PrecacheResource("particle", "particles/units/heroes/hero_antimage/antimage_spellshield_reflect.vpcf", context)
  PrecacheResource("particle", "particles/shadowmancer/blur/shadowmancer_blur_ambient.vpcf", context)
  PrecacheResource("particle", "particles/shadowmancer/blur/shadowmancer_blur_start.vpcf", context)
  PrecacheResource("particle", "particles/trickster/bloodloss/trickster_bloodloss.vpcf", context)
  PrecacheResource("particle", "particles/econ/events/spring_2021/blink_dagger_spring_2021_end_godray_godray.vpcf", context)
  PrecacheResource("particle", "particles/econ/events/spring_2021/blink_dagger_spring_2021_end_lvl2.vpcf", context)
  PrecacheResource("particle", "particles/econ/events/spring_2021/blink_dagger_spring_2021_start_lvl2.vpcf", context)
  PrecacheResource("particle", "particles/econ/items/tinker/boots_of_travel/teleport_end_bots.vpcf", context)
  PrecacheResource("particle", "particles/trickster/spell_steal/trickster_spell_steal.vpcf", context)
end