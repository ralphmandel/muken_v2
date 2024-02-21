strider_u_modifier_shadow_status_efx = class({})

function strider_u_modifier_shadow_status_efx:IsHidden() return true end
function strider_u_modifier_shadow_status_efx:IsPurgable() return false end

-----------------------------------------------------------

function strider_u_modifier_shadow_status_efx:OnCreated(kv)
end

function strider_u_modifier_shadow_status_efx:OnRefresh(kv)
end

function strider_u_modifier_shadow_status_efx:OnRemoved()
end

-----------------------------------------------------------

function strider_u_modifier_shadow_status_efx:GetStatusEffectName()
  return "particles/strider/ult/strider_shadow_status_effect.vpcf"
end

function strider_u_modifier_shadow_status_efx:StatusEffectPriority()
	return 99999999
end