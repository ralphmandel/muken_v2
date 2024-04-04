item_epic_nature_boots_mod_passive = class({})

function item_epic_nature_boots_mod_passive:IsHidden() return false end
function item_epic_nature_boots_mod_passive:IsPurgable() return false end
function item_epic_nature_boots_mod_passive:GetTexture() return "boots/nature_boots" end

-- AURA -----------------------------------------------------------

function item_epic_nature_boots_mod_passive:IsAura() return true end
function item_epic_nature_boots_mod_passive:GetModifierAura() return "item_epic_nature_boots_mod_aura_effect" end
function item_epic_nature_boots_mod_passive:GetAuraDuration() return 0 end
function item_epic_nature_boots_mod_passive:GetAuraRadius() return FIND_UNITS_EVERYWHERE end
function item_epic_nature_boots_mod_passive:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function item_epic_nature_boots_mod_passive:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO end
function item_epic_nature_boots_mod_passive:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function item_epic_nature_boots_mod_passive:GetAuraEntityReject(hEntity)
  if hEntity ~= self.parent then return true end
  if IsServer() then
    local trees = GridNav:GetAllTreesAroundPoint(hEntity:GetOrigin(), 50, true)
    if trees then
      for _,tree in pairs(trees) do
        return false
      end
    end
    return true
  end
  return true
end

-- CONSTRUCTORS -----------------------------------------------------------

function item_epic_nature_boots_mod_passive:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  self.parent:AddAbilityStats(self.ability, {"speed", "incoming_heal"})
end

function item_epic_nature_boots_mod_passive:OnRefresh(kv)
end

function item_epic_nature_boots_mod_passive:OnRemoved()
  if not IsServer() then return end

  self.parent:RemoveSubStats(self.ability, {"speed", "incoming_heal"})
end

-- API FUNCTIONS -----------------------------------------------------------

function item_epic_nature_boots_mod_passive:CheckState()
	local state = {
    [MODIFIER_STATE_ALLOW_PATHING_THROUGH_TREES] = true,
	}

	return state
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------