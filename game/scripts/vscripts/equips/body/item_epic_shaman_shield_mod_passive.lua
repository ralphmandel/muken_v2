item_epic_shaman_shield_mod_passive = class({})

function item_epic_shaman_shield_mod_passive:IsHidden() return false end
function item_epic_shaman_shield_mod_passive:IsPurgable() return false end
function item_epic_shaman_shield_mod_passive:GetTexture() return "shield/shaman_shield" end

-- CONSTRUCTORS -----------------------------------------------------------

function item_epic_shaman_shield_mod_passive:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  self.parent:AddAbilityStats(self.ability, {"physical_block", "status_resist_stack"})
end

function item_epic_shaman_shield_mod_passive:OnRefresh(kv)
end

function item_epic_shaman_shield_mod_passive:OnRemoved()
  if not IsServer() then return end

  self.parent:RemoveSubStats(self.ability, {"physical_block", "status_resist_stack"})
end

-- API FUNCTIONS -----------------------------------------------------------

function item_epic_shaman_shield_mod_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK
	}

	return funcs
end

function item_epic_shaman_shield_mod_passive:GetModifierPhysical_ConstantBlock(keys)
  if not IsServer() then return 0 end

  if self.parent:IsMuted() then return 0 end
  if self.parent:IsBlockDisabled() then return 0 end

  local heal = self.ability:GetSpecialValueFor("physical_block")
  if heal > keys.damage then heal = keys.damage end

  self.parent:ApplyHeal(heal, self.ability, false)

  return 0
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------