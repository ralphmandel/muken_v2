trickster_u_modifier_passive = class({})

function trickster_u_modifier_passive:IsHidden() return true end
function trickster_u_modifier_passive:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function trickster_u_modifier_passive:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()
end

function trickster_u_modifier_passive:OnRefresh(kv)
end

function trickster_u_modifier_passive:OnRemoved()
end

-- API FUNCTIONS -----------------------------------------------------------

function trickster_u_modifier_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
	}

	return funcs
end

function trickster_u_modifier_passive:OnAbilityFullyCast(keys)
  if keys.unit:GetTeamNumber() == self.parent:GetTeamNumber() then return end

  if self:IsListed(keys.ability) then
    AddModifier(keys.unit, self.ability, "trickster_u_modifier_last", {
      ability_index = keys.ability:entindex()
    }, false)
  end
end

-- UTILS -----------------------------------------------------------

function trickster_u_modifier_passive:IsListed(ability)
  local ability_name = ability:GetAbilityName()

  local list = {
    "fleaman_1__precision",
    "fleaman_3__jump",
    "fleaman_5__smoke",
    "bloodstained_1__rage",
    "bloodstained_u__seal",
    "templar_3__hammer",
    "templar_4__revenge",
    "templar_u__praise",
    "ancient_2__roar",
    "ancient_5__walk",
    "ancient_u__fissure",
  }

  for _, name in pairs(list) do
    if name == ability_name then
      return true
    end
  end
end

-- EFFECTS -----------------------------------------------------------