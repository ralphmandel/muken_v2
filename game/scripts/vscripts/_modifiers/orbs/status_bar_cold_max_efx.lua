status_bar_cold_max_efx = class({})

function status_bar_cold_max_efx:IsHidden() return true end
function status_bar_cold_max_efx:IsPurgable() return false end

-----------------------------------------------------------

function status_bar_cold_max_efx:OnCreated(kv)
end

function status_bar_cold_max_efx:OnRefresh(kv)
end

function status_bar_cold_max_efx:OnRemoved()
end

-----------------------------------------------------------

function status_bar_cold_max_efx:GetStatusEffectName()
  return "particles/econ/items/drow/drow_ti9_immortal/status_effect_drow_ti9_frost_arrow.vpcf"
end

function status_bar_cold_max_efx:StatusEffectPriority()
	return MODIFIER_PRIORITY_ULTRA
end