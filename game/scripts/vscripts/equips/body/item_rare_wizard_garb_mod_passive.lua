item_rare_wizard_garb_mod_passive = class({})

function item_rare_wizard_garb_mod_passive:IsHidden() return false end
function item_rare_wizard_garb_mod_passive:IsPurgable() return false end
function item_rare_wizard_garb_mod_passive:GetTexture() return "armor/wizard_garb" end

-- CONSTRUCTORS -----------------------------------------------------------

function item_rare_wizard_garb_mod_passive:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  self.parent:AddAbilityStats(self.ability, {"magic_resist"})
end

function item_rare_wizard_garb_mod_passive:OnRefresh(kv)
end

function item_rare_wizard_garb_mod_passive:OnRemoved()
  if not IsServer() then return end

  self.parent:RemoveSubStats(self.ability, {"magic_resist"})
end

-- API FUNCTIONS -----------------------------------------------------------

function item_rare_wizard_garb_mod_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}

	return funcs
end

function item_rare_wizard_garb_mod_passive:OnTakeDamage(keys)
  if not IsServer() then return end

  if keys.attacker == nil then return end
  if keys.attacker:IsBaseNPC() == false then return end
  if keys.unit ~= self.parent then return end
  if keys.damage_type ~= self.ability:GetAbilityDamageType() then return end
  if self.parent:IsMuted() then return end
  if self.ability:IsCooldownReady() == false then return end
  
  self.parent:ApplyMana(self.ability:GetSpecialValueFor("mana_gain"), self.ability, false, nil, true)
  self.ability:StartCooldown(self.ability:GetEffectiveCooldown(self.ability:GetLevel()))
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------