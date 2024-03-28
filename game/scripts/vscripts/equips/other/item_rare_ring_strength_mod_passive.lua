item_rare_ring_strength_mod_passive = class({})

function item_rare_ring_strength_mod_passive:IsHidden() return false end
function item_rare_ring_strength_mod_passive:IsPurgable() return false end
function item_rare_ring_strength_mod_passive:GetTexture() return "misc/ring_strength" end

-- CONSTRUCTORS -----------------------------------------------------------

function item_rare_ring_strength_mod_passive:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  self.parent:AddAbilityStats(self.ability, {"physical_damage"})
end

function item_rare_ring_strength_mod_passive:OnRefresh(kv)
end

function item_rare_ring_strength_mod_passive:OnRemoved()
  if not IsServer() then return end

  self.parent:RemoveSubStats(self.ability, {"physical_damage"})
  self.parent:RemoveMainStats(self.ability, {"str"})
end

-- API FUNCTIONS -----------------------------------------------------------

function item_rare_ring_strength_mod_passive:DeclareFunctions()
	local funcs = {
    MODIFIER_EVENT_ON_TAKEDAMAGE
	}

	return funcs
end

function item_rare_ring_strength_mod_passive:OnTakeDamage(keys)
  if not IsServer() then return end

  if keys.unit ~= self.parent then return end
  if self.parent:IsMuted() then return end
  
  if self.modifier then
    if self.modifier:IsNull() == false then
      return
    end
  end

  if self.parent:GetHealthPercent() < self.ability:GetSpecialValueFor("hp_cap") then
    self.modifier = self.parent:AddAbilityStats(self.ability, {"str"})
    self:StartIntervalThink(0.5)
  end
end

function item_rare_ring_strength_mod_passive:OnIntervalThink(keys)
  if not IsServer() then return end

  if self.modifier == nil then self:StartIntervalThink(-1) return end
  if self.modifier:IsNull() then self:StartIntervalThink(-1) return end

  if self.parent:GetHealthPercent() > self.ability:GetSpecialValueFor("hp_cap") then
    self.modifier:Destroy()
    self.modifier = nil
    self:StartIntervalThink(-1)
    return
  end

  self:StartIntervalThink(0.5)
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------