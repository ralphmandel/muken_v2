death_slash__precache = class ({})
LinkLuaModifier("death_slash_special_values", "heroes/death/death_slash/death_slash-special_values", LUA_MODIFIER_MOTION_NONE)

function death_slash__precache:GetIntrinsicModifierName()
  return "death_slash_special_values"
end

function death_slash__precache:Spawn()
  if IsServer() then
    if self:IsTrained() == false then
      self:UpgradeAbility(true)
    end
  end
end

function death_slash__precache:Precache(context)
end