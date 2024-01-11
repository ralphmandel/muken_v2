item_epic_shaman_shield_mod_passive = class({})

function item_epic_shaman_shield_mod_passive:IsHidden() return false end
function item_epic_shaman_shield_mod_passive:IsPurgable() return false end
function item_epic_shaman_shield_mod_passive:GetTexture() return "shield/shaman_shield" end

-- CONSTRUCTORS -----------------------------------------------------------

function item_epic_shaman_shield_mod_passive:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  AddSubStats(self.parent, self.ability, {
    physical_block = self.ability:GetSpecialValueFor("physical_block"),
    status_resist_stack = self.ability:GetSpecialValueFor("status_resist")
  }, false)
end

function item_epic_shaman_shield_mod_passive:OnRefresh(kv)
end

function item_epic_shaman_shield_mod_passive:OnRemoved()
  RemoveSubStats(self.parent, self.ability, {"physical_block", "status_resist_stack"})
end

-- API FUNCTIONS -----------------------------------------------------------

function item_epic_shaman_shield_mod_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK
	}

	return funcs
end

function item_epic_shaman_shield_mod_passive:GetModifierPhysical_ConstantBlock(keys)
  if self.parent:IsMuted() then return 0 end
  if self.parent:IsBlockDisabled() then return 0 end
  if keys.damage_type ~= DAMAGE_TYPE_PHYSICAL then return 0 end

  self.parent:Heal(CalcHeal(self.caster, self.ability:GetSpecialValueFor("heal")), self.ability)

  return 0
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------