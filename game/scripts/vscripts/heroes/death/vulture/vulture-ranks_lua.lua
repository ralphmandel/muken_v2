vulture_1__tree_rank_11 = class ({})
vulture_1__tree_rank_12 = class ({})
vulture_1__tree_rank_21 = class ({})
vulture_1__tree_rank_22 = class ({})
vulture_1__tree_rank_31 = class ({})
vulture_1__tree_rank_32 = class ({})

vulture_2__sk2_rank_11 = class ({})
vulture_2__sk2_rank_12 = class ({})
vulture_2__sk2_rank_21 = class ({})
vulture_2__sk2_rank_22 = class ({})
vulture_2__sk2_rank_31 = class ({})
vulture_2__sk2_rank_32 = class ({})

vulture_3__sk3_rank_11 = class ({})
vulture_3__sk3_rank_12 = class ({})
vulture_3__sk3_rank_21 = class ({})
vulture_3__sk3_rank_22 = class ({})
vulture_3__sk3_rank_31 = class ({})
vulture_3__sk3_rank_32 = class ({})

vulture_4__sk4_rank_11 = class ({})
vulture_4__sk4_rank_12 = class ({})
vulture_4__sk4_rank_21 = class ({})
vulture_4__sk4_rank_22 = class ({})
vulture_4__sk4_rank_31 = class ({})
vulture_4__sk4_rank_32 = class ({})

vulture_5__sk5_rank_11 = class ({})
vulture_5__sk5_rank_12 = class ({})
vulture_5__sk5_rank_21 = class ({})
vulture_5__sk5_rank_22 = class ({})
vulture_5__sk5_rank_31 = class ({})
vulture_5__sk5_rank_32 = class ({})

vulture_u__sk6_rank_11 = class ({})
vulture_u__sk6_rank_12 = class ({})
vulture_u__sk6_rank_21 = class ({})
vulture_u__sk6_rank_22 = class ({})
vulture_u__sk6_rank_31 = class ({})
vulture_u__sk6_rank_32 = class ({})

vulture__precache = class ({})
LinkLuaModifier("vulture_special_values", "heroes/death/vulture/vulture-special_values", LUA_MODIFIER_MOTION_NONE)

function vulture__precache:GetIntrinsicModifierName()
  return "vulture_special_values"
end

function vulture__precache:Spawn()
	if self:IsTrained() == false then self:UpgradeAbility(true) end
end

function vulture__precache:Precache(context)
end