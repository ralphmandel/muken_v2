orb_cold_debuff_efx = class({})

function orb_cold_debuff_efx:IsHidden() return true end
function orb_cold_debuff_efx:IsPurgable() return false end

-----------------------------------------------------------

function orb_cold_debuff_efx:OnCreated(kv)
end

function orb_cold_debuff_efx:OnRefresh(kv)
end

function orb_cold_debuff_efx:OnRemoved()
end

-----------------------------------------------------------

function orb_cold_debuff_efx:GetStatusEffectName()
  return "particles/econ/items/drow/drow_ti9_immortal/status_effect_drow_ti9_frost_arrow.vpcf"
end

function orb_cold_debuff_efx:StatusEffectPriority()
	return MODIFIER_PRIORITY_HIGH
end