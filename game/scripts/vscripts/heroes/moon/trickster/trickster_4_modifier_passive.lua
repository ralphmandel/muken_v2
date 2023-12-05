trickster_4_modifier_passive = class({})

function trickster_4_modifier_passive:IsHidden() return true end
function trickster_4_modifier_passive:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function trickster_4_modifier_passive:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()
end

function trickster_4_modifier_passive:OnRefresh(kv)
end

function trickster_4_modifier_passive:OnRemoved()
end

-- API FUNCTIONS -----------------------------------------------------------

function trickster_4_modifier_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end

function trickster_4_modifier_passive:OnAttackLanded(keys)
  if keys.attacker ~= self.parent then return end
  if self.parent:PassivesDisabled() then return end

  local stack = 1
  local modifier = keys.target:FindModifierByName("trickster_4_modifier_heart")
  local max_stack = self.ability:GetSpecialValueFor("max_stack")
  
  if modifier then stack = modifier:GetStackCount() + stack end
  if stack > max_stack then stack = max_stack end

  AddModifier(keys.target, self.ability, "trickster_4_modifier_heart", {
    duration = self.ability:GetSpecialValueFor("duration") + (self.ability:GetSpecialValueFor("duration_stack") * stack)
  }, true)
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------