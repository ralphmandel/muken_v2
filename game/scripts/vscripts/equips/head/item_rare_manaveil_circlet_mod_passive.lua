item_rare_manaveil_circlet_mod_passive = class({})

function item_rare_manaveil_circlet_mod_passive:IsHidden() return false end
function item_rare_manaveil_circlet_mod_passive:IsPurgable() return false end
function item_rare_manaveil_circlet_mod_passive:GetTexture() return "head/manaveil_circlet" end

-- AURA -----------------------------------------------------------

function item_rare_manaveil_circlet_mod_passive:IsAura() return true end
function item_rare_manaveil_circlet_mod_passive:GetModifierAura() return "item_rare_manaveil_circlet_mod_aura_effect" end
function item_rare_manaveil_circlet_mod_passive:GetAuraDuration() return 0 end
function item_rare_manaveil_circlet_mod_passive:GetAuraRadius() return self.ability:GetAOERadius() end
function item_rare_manaveil_circlet_mod_passive:GetAuraSearchTeam() return self.ability:GetAbilityTargetTeam() end
function item_rare_manaveil_circlet_mod_passive:GetAuraSearchType() return self.ability:GetAbilityTargetType() end
function item_rare_manaveil_circlet_mod_passive:GetAuraSearchFlags() return self.ability:GetAbilityTargetFlags() end
function item_rare_manaveil_circlet_mod_passive:GetAuraEntityReject(hEntity) return self.parent:IsMuted() end

-- CONSTRUCTORS -----------------------------------------------------------

function item_rare_manaveil_circlet_mod_passive:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()
end

function item_rare_manaveil_circlet_mod_passive:OnRefresh(kv)
end

function item_rare_manaveil_circlet_mod_passive:OnRemoved()
end

-- API FUNCTIONS -----------------------------------------------------------

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------