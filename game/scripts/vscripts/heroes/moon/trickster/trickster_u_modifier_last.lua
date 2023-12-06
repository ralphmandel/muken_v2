trickster_u_modifier_last = class({})

function trickster_u_modifier_last:IsHidden() return true end
function trickster_u_modifier_last:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function trickster_u_modifier_last:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if IsServer() then
    self.ability_index = kv.ability_index
    self:CheckAbility()
  end
end

function trickster_u_modifier_last:OnRefresh(kv)
  if IsServer() then
    self.ability_index = kv.ability_index
    self:CheckAbility()
  end
end

function trickster_u_modifier_last:OnRemoved()
  self.parent:RemoveModifierByName("trickster_u_modifier_used")
end

-- API FUNCTIONS -----------------------------------------------------------

-- UTILS -----------------------------------------------------------

function trickster_u_modifier_last:CheckAbility()
  -- if self.caster:HasAbility(EntIndexToHScript(self.ability_index):GetAbilityName()) then
  --   AddModifier(self.parent, self.ability, "trickster_u_modifier_used", {}, false)
  -- else
  --   self.parent:RemoveModifierByName("trickster_u_modifier_used")
  -- end
end

-- EFFECTS -----------------------------------------------------------