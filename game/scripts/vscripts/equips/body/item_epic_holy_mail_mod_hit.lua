item_epic_holy_mail_mod_hit = class({})

function item_epic_holy_mail_mod_hit:IsHidden() return true end
function item_epic_holy_mail_mod_hit:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function item_epic_holy_mail_mod_hit:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end
end

function item_epic_holy_mail_mod_hit:OnRefresh(kv)
end

function item_epic_holy_mail_mod_hit:OnRemoved()
end

-- API FUNCTIONS -----------------------------------------------------------

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------