item_epic_spectral_mask_mod_passive = class({})

function item_epic_spectral_mask_mod_passive:IsHidden() return false end
function item_epic_spectral_mask_mod_passive:IsPurgable() return false end
function item_epic_spectral_mask_mod_passive:GetTexture() return "head/spectral_mask" end

-- CONSTRUCTORS -----------------------------------------------------------

function item_epic_spectral_mask_mod_passive:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  self.parent:AddAbilityStats(self.ability, {"curse_resist"})

end

function item_epic_spectral_mask_mod_passive:OnRefresh(kv)
end

function item_epic_spectral_mask_mod_passive:OnRemoved()
  if not IsServer() then return end

  self.parent:RemoveSubStats(self.ability, {"curse_resist"})
end

-- API FUNCTIONS -----------------------------------------------------------

function item_epic_spectral_mask_mod_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
    MODIFIER_PROPERTY_BONUS_DAY_VISION
	}
	
	return funcs
end

function item_epic_spectral_mask_mod_passive:GetBonusNightVision()
  return self.ability:GetSpecialValueFor("night_vision")
end

function item_epic_spectral_mask_mod_passive:GetBonusDayVision()
  return self.ability:GetSpecialValueFor("day_vision")
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------