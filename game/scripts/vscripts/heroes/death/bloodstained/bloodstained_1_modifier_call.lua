bloodstained_1_modifier_call = class({})

function bloodstained_1_modifier_call:IsHidden() return false end
function bloodstained_1_modifier_call:IsPurgable() return true end

-- CONSTRUCTORS -----------------------------------------------------------

function bloodstained_1_modifier_call:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  self.parent:AddModifier(self.ability, "_modifier_force_attack", {target = self.caster:GetEntityIndex()})
  self.parent:AddStatusEfx(self.caster, self.ability, "bloodstained_1_modifier_call_status_efx")
end

function bloodstained_1_modifier_call:OnRefresh(kv)
end

function bloodstained_1_modifier_call:OnRemoved()
  if not IsServer() then return end

	self.parent:RemoveAllModifiersByNameAndAbility("_modifier_force_attack", self.ability)
  self.parent:RemoveStatusEfx(self.caster, self.ability, "bloodstained_1_modifier_call_status_efx")
end

-- API FUNCTIONS -----------------------------------------------------------

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function bloodstained_1_modifier_call:GetStatusEffectName()
	return "particles/status_fx/status_effect_beserkers_call.vpcf"
end

function bloodstained_1_modifier_call:StatusEffectPriority()
	return MODIFIER_PRIORITY_HIGH
end