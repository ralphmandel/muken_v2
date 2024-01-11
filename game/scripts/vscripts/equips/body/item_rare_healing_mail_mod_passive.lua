item_rare_healing_mail_mod_passive = class({})

function item_rare_healing_mail_mod_passive:IsHidden() return false end
function item_rare_healing_mail_mod_passive:IsPurgable() return false end
function item_rare_healing_mail_mod_passive:GetTexture() return "armor/healing_mail" end

-- CONSTRUCTORS -----------------------------------------------------------

function item_rare_healing_mail_mod_passive:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  AddSubStats(self.parent, self.ability, {
    health_regen = self.ability:GetSpecialValueFor("health_regen")
  }, false)
end

function item_rare_healing_mail_mod_passive:OnRefresh(kv)
end

function item_rare_healing_mail_mod_passive:OnRemoved()
  RemoveSubStats(self.parent, self.ability, {"health_regen"})
end

-- API FUNCTIONS -----------------------------------------------------------

function item_rare_healing_mail_mod_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}

	return funcs
end

function item_rare_healing_mail_mod_passive:OnTakeDamage(keys)
  if keys.unit ~= self.parent then return end
  if self.ability:IsCooldownReady() == false then return end
  if self.parent:IsMuted() then return end

  self.parent:Heal(CalcHeal(self.caster, self.ability:GetSpecialValueFor("heal")), self.ability)
  self.ability:StartCooldown(self.ability:GetEffectiveCooldown(self.ability:GetLevel()))
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------