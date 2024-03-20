item_rare_healing_mail_mod_passive = class({})

function item_rare_healing_mail_mod_passive:IsHidden() return false end
function item_rare_healing_mail_mod_passive:IsPurgable() return false end
function item_rare_healing_mail_mod_passive:GetTexture() return "armor/healing_mail" end

-- CONSTRUCTORS -----------------------------------------------------------

function item_rare_healing_mail_mod_passive:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  self.parent:AddAbilityStats(self.ability, {"health_regen"})
  self:StartIntervalThink(self.ability:GetEffectiveCooldown(self.ability:GetLevel()))
end

function item_rare_healing_mail_mod_passive:OnRefresh(kv)
end

function item_rare_healing_mail_mod_passive:OnRemoved()
  if not IsServer() then return end

  self.parent:RemoveSubStats(self.ability, {"health_regen"})
end

-- API FUNCTIONS -----------------------------------------------------------

function item_rare_healing_mail_mod_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}

	return funcs
end

function item_rare_healing_mail_mod_passive:OnTakeDamage(keys)
  if not IsServer() then return end

  if keys.unit ~= self.parent then return end
  
  self.ability:StartCooldown(self.ability:GetEffectiveCooldown(self.ability:GetLevel()))
  self:StartIntervalThink(self.ability:GetEffectiveCooldown(self.ability:GetLevel()))
end

function item_rare_healing_mail_mod_passive:OnIntervalThink()
  if not IsServer() then return end

  if self.parent:IsMuted() then return end

  local interval = self.ability:GetSpecialValueFor("interval")

  self.parent:ApplyHeal(self.ability:GetSpecialValueFor("heal") * interval, self.ability, false)
  self:StartIntervalThink(interval)
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------