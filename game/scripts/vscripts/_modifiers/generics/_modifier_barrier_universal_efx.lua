_modifier_barrier_universal_efx = class({})

function _modifier_barrier_universal_efx:IsHidden() return true end
function _modifier_barrier_universal_efx:IsPurgable() return false end

-----------------------------------------------------------

function _modifier_barrier_universal_efx:OnCreated(kv)
end

function _modifier_barrier_universal_efx:OnRefresh(kv)
end

function _modifier_barrier_universal_efx:OnRemoved()
end

-----------------------------------------------------------

function _modifier_barrier_universal_efx:GetStatusEffectName()
  return "particles/status_fx/status_effect_shield_rune.vpcf"
end

function _modifier_barrier_universal_efx:StatusEffectPriority()
	return MODIFIER_PRIORITY_ULTRA
end