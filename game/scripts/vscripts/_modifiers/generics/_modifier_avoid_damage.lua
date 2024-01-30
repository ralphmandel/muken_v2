_modifier_avoid_damage = class({})

--------------------------------------------------------------------------------
function _modifier_avoid_damage:IsHidden()
	return false
end

function _modifier_avoid_damage:IsPurgable()
	return true
end

function _modifier_avoid_damage:GetTexture()
	return "_modifier_avoid_damage"
end

function _modifier_avoid_damage:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------

function _modifier_avoid_damage:OnCreated( kv )
end

--------------------------------------------------------------------------------

function _modifier_avoid_damage:DeclareFunctions()

  local funcs = {
    MODIFIER_PROPERTY_AVOID_DAMAGE,
  }

  return funcs
end

function _modifier_avoid_damage:GetModifierAvoidDamage()
  return 1
end

--------------------------------------------------------------------------------