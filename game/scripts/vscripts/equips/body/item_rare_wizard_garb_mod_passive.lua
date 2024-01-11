item_rare_wizard_garb_mod_passive = class({})

function item_rare_wizard_garb_mod_passive:IsHidden() return false end
function item_rare_wizard_garb_mod_passive:IsPurgable() return false end
function item_rare_wizard_garb_mod_passive:GetTexture() return "armor/wizard_garb" end

-- CONSTRUCTORS -----------------------------------------------------------

function item_rare_wizard_garb_mod_passive:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  AddSubStats(self.parent, self.ability, {
    armor = self.ability:GetSpecialValueFor("magic_resist")
  }, false)
end

function item_rare_wizard_garb_mod_passive:OnRefresh(kv)
end

function item_rare_wizard_garb_mod_passive:OnRemoved()
  RemoveSubStats(self.parent, self.ability, {"magic_resist"})
end

-- API FUNCTIONS -----------------------------------------------------------

function item_rare_wizard_garb_mod_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}

	return funcs
end

function item_rare_wizard_garb_mod_passive:OnTakeDamage(keys)
  if keys.attacker == nil then return end
  if keys.attacker:IsBaseNPC() == false then return end
  if keys.unit ~= self.parent then return end
  if keys.damage_type ~= self.ability:GetAbilityDamageType() then return end
  if self.parent:IsMuted() then return end

  IncreaseMana(self.parent, keys.attacker:GetLastOriginalDamage(self.ability:GetSpecialValueFor("damage_percent")))
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------