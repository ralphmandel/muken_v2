strider_1__silence_rank_11 = class ({})
strider_1__silence_rank_12 = class ({})
strider_1__silence_rank_21 = class ({})
strider_1__silence_rank_22 = class ({})
strider_1__silence_rank_31 = class ({})
strider_1__silence_rank_32 = class ({})

strider_2__spin_rank_11 = class ({})
strider_2__spin_rank_12 = class ({})
strider_2__spin_rank_21 = class ({})
strider_2__spin_rank_22 = class ({})
strider_2__spin_rank_31 = class ({})
strider_2__spin_rank_32 = class ({})

strider_3__sk3_rank_11 = class ({})
strider_3__sk3_rank_12 = class ({})
strider_3__sk3_rank_21 = class ({})
strider_3__sk3_rank_22 = class ({})
strider_3__sk3_rank_31 = class ({})
strider_3__sk3_rank_32 = class ({})

strider_4__sk4_rank_11 = class ({})
strider_4__sk4_rank_12 = class ({})
strider_4__sk4_rank_21 = class ({})
strider_4__sk4_rank_22 = class ({})
strider_4__sk4_rank_31 = class ({})
strider_4__sk4_rank_32 = class ({})

strider_5__sk5_rank_11 = class ({})
strider_5__sk5_rank_12 = class ({})
strider_5__sk5_rank_21 = class ({})
strider_5__sk5_rank_22 = class ({})
strider_5__sk5_rank_31 = class ({})
strider_5__sk5_rank_32 = class ({})

strider_u__sk6_rank_11 = class ({})
strider_u__sk6_rank_12 = class ({})
strider_u__sk6_rank_21 = class ({})
strider_u__sk6_rank_22 = class ({})
strider_u__sk6_rank_31 = class ({})
strider_u__sk6_rank_32 = class ({})

strider__precache = class ({})
LinkLuaModifier("strider_special_values", "heroes/moon/strider/strider-special_values", LUA_MODIFIER_MOTION_NONE)

function strider__precache:GetIntrinsicModifierName()
  return "strider_special_values"
end

function strider__precache:Spawn()
	if self:IsTrained() == false then self:UpgradeAbility(true) end
end

function strider__precache:Precache(context)
end