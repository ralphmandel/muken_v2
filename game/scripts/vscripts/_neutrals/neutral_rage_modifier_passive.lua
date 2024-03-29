neutral_rage_modifier_passive = class({})

function neutral_rage_modifier_passive:IsHidden() return true end
function neutral_rage_modifier_passive:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function neutral_rage_modifier_passive:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()
end

function neutral_rage_modifier_passive:OnRefresh(kv)
end

function neutral_rage_modifier_passive:OnRemoved()
end

-- API FUNCTIONS -----------------------------------------------------------

function neutral_rage_modifier_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end

function neutral_rage_modifier_passive:OnAttackLanded(keys)
  if not IsServer() then return end

  if keys.attacker ~= self.parent then return end
  if self.parent:PassivesDisabled() then return end
  if self.parent:HasModifier("neutral_rage_modifier_buff") == true then return end

  if RandomFloat(0, 100) < self.parent:GetLuck(self.ability:GetSpecialValueFor("chance")) then
    self.parent:AddModifier(self.ability, "neutral_rage_modifier_buff", {
      duration = self.ability:GetSpecialValueFor("duration"), bResist = 1
    })
  end
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------