neutral_doom_modifier_debuff_status_efx = class({})

function neutral_doom_modifier_debuff_status_efx:IsHidden()
	return true
end

function neutral_doom_modifier_debuff_status_efx:IsPurgable()
	return false
end

-----------------------------------------------------------

function neutral_doom_modifier_debuff_status_efx:OnCreated(kv)
end

function neutral_doom_modifier_debuff_status_efx:OnRefresh(kv)
end

function neutral_doom_modifier_debuff_status_efx:OnRemoved()
end

-----------------------------------------------------------

function neutral_doom_modifier_debuff_status_efx:GetStatusEffectName()
    return "particles/status_fx/status_effect_doom.vpcf"
end

function neutral_doom_modifier_debuff_status_efx:StatusEffectPriority()
	return MODIFIER_PRIORITY_ULTRA
end