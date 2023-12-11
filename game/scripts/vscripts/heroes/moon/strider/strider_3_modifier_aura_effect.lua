strider_3_modifier_aura_effect = class({})

function strider_3_modifier_aura_effect:IsHidden() return true end
function strider_3_modifier_aura_effect:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function strider_3_modifier_aura_effect:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()
  
  AddModifierOnAllCosmetics(self.parent, self.ability, "_modifier_invi_level", {level = 1})
  AddSubStats(self.parent, self.ability, {evasion = self.ability:GetSpecialValueFor("flee_bonus")}, false)

  if IsServer() then self:StartIntervalThink(self.ability:GetSpecialValueFor("fade_inv")) end
end

function strider_3_modifier_aura_effect:OnRefresh(kv)
end

function strider_3_modifier_aura_effect:OnRemoved()
  RemoveAllModifiersByNameAndAbility(self.parent, "_modifier_invisible", self.ability)
  RemoveModifierOnAllCosmetics(self:GetParent(), self:GetAbility(), "_modifier_invi_level")
  RemoveSubStats(self.parent, self.ability, {"evasion"})
end

-- API FUNCTIONS -----------------------------------------------------------

function strider_3_modifier_aura_effect:OnIntervalThink()
  local inv = AddModifier(self.parent, self.ability, "_modifier_invisible", {attack_break = 1, spell_break = 1}, false)

  inv:SetEndCallback(function(interrupted)
    if IsServer() and interrupted == true then
      AddModifierOnAllCosmetics(self.parent, self.ability, "_modifier_invi_level", {level = 1})
      self:StartIntervalThink(self.ability:GetSpecialValueFor("fade_inv"))
    end
  end)

	if IsServer() then self:StartIntervalThink(-1) end
end

function strider_3_modifier_aura_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK
	}

	return funcs
end

function strider_3_modifier_aura_effect:OnAttack(keys)
	if keys.attacker ~= self.parent then return end
  
  if IsServer() then self:StartIntervalThink(self.ability:GetSpecialValueFor("fade_inv")) end
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------
