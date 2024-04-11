item_epic_mystical_veil_mod_passive = class({})

function item_epic_mystical_veil_mod_passive:IsHidden() return false end
function item_epic_mystical_veil_mod_passive:IsPurgable() return false end
function item_epic_mystical_veil_mod_passive:GetTexture() return "head/mystical_veil" end

-- CONSTRUCTORS -----------------------------------------------------------

function item_epic_mystical_veil_mod_passive:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  self.parent:AddAbilityStats(self.ability, {"max_mana", "cooldown_reduction"})
end

function item_epic_mystical_veil_mod_passive:OnRefresh(kv)
end

function item_epic_mystical_veil_mod_passive:OnRemoved()
  if not IsServer() then return end

  self.parent:RemoveSubStats(self.ability, {"max_mana", "cooldown_reduction"})
end

-- API FUNCTIONS -----------------------------------------------------------

function item_epic_mystical_veil_mod_passive:DeclareFunctions()
	local funcs = {
    MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
	}

	return funcs
end

function item_epic_mystical_veil_mod_passive:OnAbilityFullyCast(keys)
  if not IsServer() then return end
  
  if keys.unit ~= self.parent then return end

  if RandomFloat(0, 100) < self.ability:GetSpecialValueFor("reset_chance") then
    --Timers:CreateTimer((FrameTime()), function()
      keys.ability:EndCooldown()
    --end)
  end
end
-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------