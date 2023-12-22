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

  if RandomFloat(0, 100) < self.ability:GetSpecialValueFor("special_bleed_chance") then
    AddModifier(keys.target, self.ability, "_modifier_bleeding", {
      duration = self.ability:GetSpecialValueFor("bleeding_duration")
    }, true)
  end
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------