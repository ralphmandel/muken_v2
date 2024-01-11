strider_2_modifier_passive = class({})

function strider_2_modifier_passive:IsHidden() return true end
function strider_2_modifier_passive:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function strider_2_modifier_passive:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()
end

function strider_2_modifier_passive:OnRefresh(kv)
end

function strider_2_modifier_passive:OnRemoved()
end

-- API FUNCTIONS -----------------------------------------------------------

function strider_2_modifier_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end

function strider_2_modifier_passive:OnAttackLanded(keys)
  if keys.attacker ~= self.parent then return end
  if self.parent:PassivesDisabled() then return end
  if self.parent:HasModifier("strider_2_modifier_spin") then return end

  local mods = self.parent:FindAllModifiersByName("trickster_u_modifier_autocast")
  for _,mod in pairs(mods) do
    if mod.stolen_ability:GetAbilityName() == self.ability:GetAbilityName() then
      if mod.enabled == false then return end
    end
  end

  if RandomFloat(0, 100) < CalcLuck(self.parent, self.ability:GetSpecialValueFor("special_bleed_chance")) then
    RemoveAllModifiersByNameAndAbility(keys.target, "_modifier_bleeding", self.ability)
    
    AddModifier(keys.target, self.ability, "_modifier_bleeding", {
      duration = self.ability:GetSpecialValueFor("bleeding_duration")
    }, true)
  end
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------