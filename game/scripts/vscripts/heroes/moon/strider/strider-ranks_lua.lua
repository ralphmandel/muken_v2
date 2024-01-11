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

strider_3__smoke_rank_11 = class ({})
strider_3__smoke_rank_12 = class ({})
strider_3__smoke_rank_21 = class ({})
strider_3__smoke_rank_22 = class ({})
strider_3__smoke_rank_31 = class ({})
strider_3__smoke_rank_32 = class ({})

strider_4__shuriken_rank_11 = class ({})
strider_4__shuriken_rank_12 = class ({})
strider_4__shuriken_rank_21 = class ({})
strider_4__shuriken_rank_22 = class ({})
strider_4__shuriken_rank_31 = class ({})
strider_4__shuriken_rank_32 = class ({})

strider_5__aspd_rank_11 = class ({})
strider_5__aspd_rank_12 = class ({})
strider_5__aspd_rank_21 = class ({})
strider_5__aspd_rank_22 = class ({})
strider_5__aspd_rank_31 = class ({})
strider_5__aspd_rank_32 = class ({})

strider_u__shadow_rank_11 = class ({})
strider_u__shadow_rank_12 = class ({})
strider_u__shadow_rank_21 = class ({})
strider_u__shadow_rank_22 = class ({})
strider_u__shadow_rank_31 = class ({})
strider_u__shadow_rank_32 = class ({})

strider__precache = class ({})
LinkLuaModifier("strider_special_values", "heroes/moon/strider/strider-special_values", LUA_MODIFIER_MOTION_NONE)

function strider__precache:GetIntrinsicModifierName()
  return "strider_special_values"
end

function strider__precache:Spawn()
  if IsServer() then
    if self:IsTrained() == false then
      self:UpgradeAbility(true)
    end
  end
end

function strider__precache:Precache(context)
end