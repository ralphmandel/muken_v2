item_rare_iron_shield_mod_passive = class({})

function item_rare_iron_shield_mod_passive:IsHidden() return false end
function item_rare_iron_shield_mod_passive:IsPurgable() return false end
function item_rare_iron_shield_mod_passive:GetTexture() return "shield/iron_shield" end

-- CONSTRUCTORS -----------------------------------------------------------

function item_rare_iron_shield_mod_passive:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  self.parent:AddAbilityStats(self.ability, {"armor"})
end

function item_rare_iron_shield_mod_passive:OnRefresh(kv)
end

function item_rare_iron_shield_mod_passive:OnRemoved()
  if not IsServer() then return end

  self.parent:RemoveSubStats(self.ability, {"armor"})
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
  if self.parent:IsMuted() then return end
  if self.ability:IsCooldownReady() == false then return end

  if RandomFloat(0, 100) < self.ability:GetSpecialValueFor("block_chance") then
    if IsServer() and self.parent:IsBlockDisabled() == false then
      self.ability:StartCooldown(self.ability:GetEffectiveCooldown(self.ability:GetLevel()))
      self:StartGenericEfxBlock(keys)
    end

    return self.ability:GetSpecialValueFor("block")
  end

  return 0
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------