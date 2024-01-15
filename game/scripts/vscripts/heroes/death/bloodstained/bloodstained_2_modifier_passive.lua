bloodstained_2_modifier_passive = class({})

function bloodstained_2_modifier_passive:IsHidden() return true end
function bloodstained_2_modifier_passive:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function bloodstained_2_modifier_passive:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()
end

function bloodstained_2_modifier_passive:OnRefresh(kv)
end

function bloodstained_2_modifier_passive:OnRemoved()
end

-- API FUNCTIONS -----------------------------------------------------------

function bloodstained_2_modifier_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end

function bloodstained_2_modifier_passive:OnAttackLanded(keys)
	if keys.attacker ~= self.parent then return end
	if self.parent:PassivesDisabled() then return end
	if self.parent:HasModifier("bloodstained_2_modifier_frenzy") then return end

  local purge = self.ability:GetSpecialValueFor("special_purge")
  local bleeding_duration = self.ability:GetSpecialValueFor("special_bleeding_duration")

	if RandomFloat(0, 100) <  self.ability:GetSpecialValueFor("chance") then
		self.ability.target = keys.target

    if purge == 1 then
      self.parent:Purge(false, true, false, false, false)
    end

    if bleeding_duration > 0 then
      AddModifier(keys.target, self.ability, "_modifier_bleeding", {duration = bleeding_duration}, true)
    end

    AddModifier(self.parent, self.ability, "bloodstained_2_modifier_frenzy", {
      duration = self.ability:GetSpecialValueFor("duration")
    }, false)
	end
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------