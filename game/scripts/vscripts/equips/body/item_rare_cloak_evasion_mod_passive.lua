item_rare_cloak_evasion_mod_passive = class({})

function item_rare_cloak_evasion_mod_passive:IsHidden() return false end
function item_rare_cloak_evasion_mod_passive:IsPurgable() return false end
function item_rare_cloak_evasion_mod_passive:GetTexture() return "armor/cloak_evasion" end

-- CONSTRUCTORS -----------------------------------------------------------

function item_rare_cloak_evasion_mod_passive:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  self.parent:AddAbilityStats(self.ability, {"evasion"})
end

function item_rare_cloak_evasion_mod_passive:OnRefresh(kv)
end

function item_rare_cloak_evasion_mod_passive:OnRemoved()
  if not IsServer() then return end

  self.parent:RemoveSubStats(self.ability, {"evasion"})
end

-- API FUNCTIONS -----------------------------------------------------------

function item_rare_cloak_evasion_mod_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_FAIL,
    MODIFIER_EVENT_ON_PROJECTILE_DODGE
	}

	return funcs
end

function item_rare_cloak_evasion_mod_passive:OnAttackFail(keys)
  self:ApplyInvisibility(keys)
end

function item_rare_cloak_evasion_mod_passive:OnProjectileDodge(keys)
  self:ApplyInvisibility(keys)
end

-- UTILS -----------------------------------------------------------

function item_rare_cloak_evasion_mod_passive:ApplyInvisibility(keys)
  if not IsServer() then return end

  if keys.target ~= self.parent then return end
  if self.parent:HasModifier("_modifier_invisible") then return end
  if self.parent:IsMuted() then return end
  if self.ability:IsCooldownReady() == false then return end

  if RandomFloat(0, 100) < self.ability:GetSpecialValueFor("invi_chance") then
    self.ability:StartCooldown(self.ability:GetEffectiveCooldown(self.ability:GetLevel()))

    self.parent:EmitSound("Hunter.Invi")

    self.parent:AddModifier(self.ability, "_modifier_invisible", {
      duration = self.ability:GetSpecialValueFor("invi_duration"),
      delay = self.ability:GetSpecialValueFor("invi_delay"),
      attack_break = 0, spell_break = 0
    })
  end
end

-- EFFECTS -----------------------------------------------------------