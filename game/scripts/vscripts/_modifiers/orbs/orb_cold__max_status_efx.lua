orb_cold__max_status_efx = class({})

function orb_cold__max_status_efx:IsHidden() return true end
function orb_cold__max_status_efx:IsPurgable() return false end

-----------------------------------------------------------

function orb_cold__max_status_efx:OnCreated(kv)
end

function orb_cold__max_status_efx:OnRefresh(kv)
end

function orb_cold__max_status_efx:OnRemoved()
end

-----------------------------------------------------------

function orb_cold__max_status_efx:GetStatusEffectName()
    return "particles/econ/items/drow/drow_ti9_immortal/status_effect_drow_ti9_frost_arrow.vpcf"
end

function orb_cold__max_status_efx:StatusEffectPriority()
	return MODIFIER_PRIORITY_ULTRA
end