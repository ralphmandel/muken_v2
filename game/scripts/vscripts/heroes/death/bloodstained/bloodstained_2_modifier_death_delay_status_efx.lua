bloodstained_2_modifier_death_delay_status_efx = class({})

function bloodstained_2_modifier_death_delay_status_efx:IsHidden() return true end
function bloodstained_2_modifier_death_delay_status_efx:IsPurgable() return false end

-----------------------------------------------------------

function bloodstained_2_modifier_death_delay_status_efx:OnCreated(kv)
end

function bloodstained_2_modifier_death_delay_status_efx:OnRefresh(kv)
end

function bloodstained_2_modifier_death_delay_status_efx:OnRemoved()
end

-----------------------------------------------------------

function bloodstained_2_modifier_death_delay_status_efx:GetStatusEffectName()
  return "particles/status_fx/status_effect_wraithking_ghosts.vpcf"
end

function bloodstained_2_modifier_death_delay_status_efx:StatusEffectPriority()
	return 99999999
end