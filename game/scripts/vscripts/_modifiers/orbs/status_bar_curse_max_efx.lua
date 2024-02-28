status_bar_curse_max_efx = class({})

function status_bar_curse_max_efx:IsHidden() return true end
function status_bar_curse_max_efx:IsPurgable() return false end

-----------------------------------------------------------

function status_bar_curse_max_efx:OnCreated(kv)
end

function status_bar_curse_max_efx:OnRefresh(kv)
end

function status_bar_curse_max_efx:OnRemoved()
end

-----------------------------------------------------------

function status_bar_curse_max_efx:GetStatusEffectName()
  return "particles/econ/items/effigies/status_fx_effigies/status_effect_aghs_standard_statue.vpcf"
end

function status_bar_curse_max_efx:StatusEffectPriority()
	return MODIFIER_PRIORITY_ULTRA
end