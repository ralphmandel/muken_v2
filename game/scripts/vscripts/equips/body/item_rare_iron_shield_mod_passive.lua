item_rare_iron_shield_mod_passive = class({})

function item_rare_iron_shield_mod_passive:IsHidden() return false end
function item_rare_iron_shield_mod_passive:IsPurgable() return false end
function item_rare_iron_shield_mod_passive:GetTexture() return "shield/iron_shield" end

-- CONSTRUCTORS -----------------------------------------------------------

function item_rare_iron_shield_mod_passive:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  AddSubStats(self.parent, self.ability, {
    armor = self.ability:GetSpecialValueFor("armor")
  }, false)

  if IsServer() then self:StartIntervalThink(0.1) end
end

function item_rare_iron_shield_mod_passive:OnRefresh(kv)
end

function item_rare_iron_shield_mod_passive:OnRemoved()
  RemoveSubStats(self.parent, self.ability, {"armor"})
end

-- API FUNCTIONS -----------------------------------------------------------

function item_rare_iron_shield_mod_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK
	}

	return funcs
end

function item_rare_iron_shield_mod_passive:GetModifierPhysical_ConstantBlock(keys)
	if keys.damage_category ~= DOTA_DAMAGE_CATEGORY_ATTACK then return end
  if not keys.ranged_attack then return end

  if RandomFloat(0, 100) < self.ability:GetSpecialValueFor("block_chance") then
    self:StartGenericEfxBlock(keys.attacker)

    return keys.damage * self.ability:GetSpecialValueFor("block_percent") * 0.01
  end

  return 0
end
-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------