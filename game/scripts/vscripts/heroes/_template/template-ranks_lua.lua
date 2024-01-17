template__precache = class ({})
LinkLuaModifier("template_special_values", "heroes/id_team/template/template-special_values", LUA_MODIFIER_MOTION_NONE)

function template__precache:GetIntrinsicModifierName()
  return "template_special_values"
end

function template__precache:Spawn()
  if IsServer() then
    if self:IsTrained() == false then
      self:UpgradeAbility(true)
    end
  end
end

function template__precache:Precache(context)
end