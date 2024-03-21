item_epic_fire_mail_mod_passive = class({})

function item_epic_fire_mail_mod_passive:IsHidden() return false end
function item_epic_fire_mail_mod_passive:IsPurgable() return false end
function item_epic_fire_mail_mod_passive:GetTexture() return "armor/fire_mail" end

-- CONSTRUCTORS -----------------------------------------------------------

function item_epic_fire_mail_mod_passive:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  self.parent:AddAbilityStats(self.ability, {"vit"})
  self.parent:AddAbilityStats(self.ability, {"armor", "magic_resist"})
end

function item_epic_fire_mail_mod_passive:OnRefresh(kv)
end

function item_epic_fire_mail_mod_passive:OnRemoved()
  if not IsServer() then return end

  self.parent:RemoveMainStats(self.ability, {"vit"})
  self.parent:RemoveSubStats(self.ability, {"armor", "magic_resist"})
end

-- API FUNCTIONS -----------------------------------------------------------

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------