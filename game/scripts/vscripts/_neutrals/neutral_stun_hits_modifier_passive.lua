neutral_stun_hits_modifier_passive = class({})

function neutral_stun_hits_modifier_passive:IsHidden() return true end
function neutral_stun_hits_modifier_passive:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function neutral_stun_hits_modifier_passive:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if IsServer() then self:SetStackCount(self.ability:GetSpecialValueFor("hits")) end
end

function neutral_stun_hits_modifier_passive:OnRefresh(kv)
end

function neutral_stun_hits_modifier_passive:OnRemoved()
end

-- API FUNCTIONS -----------------------------------------------------------

function neutral_stun_hits_modifier_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end

function neutral_stun_hits_modifier_passive:OnAttackLanded(keys)
  if not IsServer() then return end

  if keys.attacker ~= self.parent then return end
  if self.parent:PassivesDisabled() then return end

  if self:GetStackCount() == 1 then
    RemoveAllModifiersByNameAndAbility(keys.target, "_modifier_stun", self.ability)
    AddModifier(keys.target, self.ability, "_modifier_stun", {
      duration = self.ability:GetSpecialValueFor("stun_duration")
    }, true)
  end

  self:DecrementStackCount()
end

function neutral_stun_hits_modifier_passive:OnStackCountChanged(old)
  if not IsServer() then return end

  if self:GetStackCount() == 0 and self:GetStackCount() ~= old then
    self:SetStackCount(self.ability:GetSpecialValueFor("hits"))
  end    
end


-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------