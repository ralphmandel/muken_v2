templar_4_modifier_passive = class({})

function templar_4_modifier_passive:IsHidden() return true end
function templar_4_modifier_passive:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function templar_4_modifier_passive:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()
end

function templar_4_modifier_passive:OnRefresh(kv)
end

function templar_4_modifier_passive:OnRemoved()
end

-- API FUNCTIONS -----------------------------------------------------------

function templar_4_modifier_passive:DeclareFunctions()
	local funcs = {
    MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end

function templar_4_modifier_passive:OnAttackLanded(keys)
  if not IsServer() then return end

  if keys.attacker ~= self.parent then return end
  if self.parent:PassivesDisabled() then return end

  if RandomFloat(0, 100) < self.ability:GetSpecialValueFor("special_autocast_chance") then
    keys.target:AddModifier(self.ability, "templar_4_modifier_revenge", {duration = 5})
  end
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------