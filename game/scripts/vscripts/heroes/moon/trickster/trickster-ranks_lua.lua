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
end