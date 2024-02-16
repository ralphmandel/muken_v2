strider_3_modifier_aura_effect = class({})

function strider_3_modifier_aura_effect:IsHidden() return true end
function strider_3_modifier_aura_effect:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function strider_3_modifier_aura_effect:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  if self.parent:GetTeamNumber() == self.caster:GetTeamNumber() then
    self.parent:SetModifierOnAllCosmetics(self.ability, "_modifier_invi_level", {level = 1}, true)
    self.parent:AddSubStats(self.ability, {evasion = self.ability:GetSpecialValueFor("evasion")})
    self:StartIntervalThink(self.ability:GetSpecialValueFor("fade_inv"))
  else
    if self.ability:GetSpecialValueFor("special_mute") == 1 then
      self.parent:AddModifier(self.ability, "_modifier_mute", {})
    end
  end
end

function strider_3_modifier_aura_effect:OnRefresh(kv)
end

function strider_3_modifier_aura_effect:OnRemoved()
  if not IsServer() then return end

  self.parent:RemoveAllModifiersByNameAndAbility("_modifier_mute", self.ability)
  self.parent:RemoveAllModifiersByNameAndAbility("_modifier_invisible", self.ability)
  self.parent:SetModifierOnAllCosmetics(self.ability, "_modifier_invi_level", nil, false)
  self.parent:RemoveSubStats(self.ability, {"evasion"})
end

-- API FUNCTIONS -----------------------------------------------------------

function strider_3_modifier_aura_effect:OnIntervalThink()
  if not IsServer() then return end

  local inv = self.parent:AddModifier(self.ability, "_modifier_invisible", {
    attack_break = self.ability:GetSpecialValueFor("attack_break"),
    spell_break = self.ability:GetSpecialValueFor("spell_break")
  })

  inv:SetEndCallback(function(interrupted)
    if interrupted == true then
      self.parent:SetModifierOnAllCosmetics(self.ability, "_modifier_invi_level", {level = 1}, true)
      self:StartIntervalThink(self.ability:GetSpecialValueFor("fade_inv"))
    end
  end)

	self:StartIntervalThink(-1)
end

-- function strider_3_modifier_aura_effect:DeclareFunctions()
-- 	local funcs = {
-- 		MODIFIER_EVENT_ON_ATTACK
-- 	}

-- 	return funcs
-- end

-- function strider_3_modifier_aura_effect:OnAttack(keys)
--   if not IsServer() then return end

-- 	if keys.attacker ~= self.parent then return end
--   if self.parent:GetTeamNumber() ~= self.caster:GetTeamNumber() then return end
  
--   self:StartIntervalThink(self.ability:GetSpecialValueFor("fade_inv"))
-- end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------
