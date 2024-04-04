item_epic_secret_boots_mod_passive = class({})

function item_epic_secret_boots_mod_passive:IsHidden() return false end
function item_epic_secret_boots_mod_passive:IsPurgable() return false end
function item_epic_secret_boots_mod_passive:GetTexture() return "boots/secret_boots" end

-- CONSTRUCTORS -----------------------------------------------------------

function item_epic_secret_boots_mod_passive:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  self.size_percent = self.ability:GetSpecialValueFor("size_percent")
  self.parent:AddModelSizePercent(self.size_percent)
  self.parent:AddAbilityStats(self.ability, {"speed"})
end

function item_epic_secret_boots_mod_passive:OnRefresh(kv)
end

function item_epic_secret_boots_mod_passive:OnRemoved()
  if not IsServer() then return end

  self.parent:AddModelSizePercent(-self.size_percent)
  self.parent:RemoveSubStats(self.ability, {"speed"})
end

-- API FUNCTIONS -----------------------------------------------------------

function item_epic_secret_boots_mod_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
    MODIFIER_PROPERTY_BONUS_DAY_VISION,
    MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
	}
	
	return funcs
end

function item_epic_secret_boots_mod_passive:GetBonusNightVision()
  return self.ability:GetSpecialValueFor("bonus_vision")
end

function item_epic_secret_boots_mod_passive:GetBonusDayVision()
  return self.ability:GetSpecialValueFor("bonus_vision")
end

function item_epic_secret_boots_mod_passive:GetModifierAttackRangeBonus()
  return self.ability:GetSpecialValueFor("attack_range")
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------